function [decision,DATAout] = play_valueIteration(board,pieceNum,DATA)
    cache_file="cache/play_valueIteration_cache.mat";
    use_cache=false;
    assert(all(isfield(DATA,["flatBoards","boards","moves","stateMap"])));
    addpath("./algorithms");
    if ~all(isfield(DATA,["J","mu","Q","params"]))
        params.n_pieces=length(DATA.moves);
        % Define game size
        params.ColCap=size(DATA.moves{1}{1},2);
        params.RowCap = DATA.rowCap; % height of gameOver
        
        params.stateMap=DATA.stateMap;
        params.flatBoards=DATA.flatBoards;
        params.boards=DATA.boards;
        params.moves=DATA.moves;
        
        params.n_states=length(params.stateMap)+1;
        params.max_n_actions=max(cellfun(@length,params.moves));
        params.TERMINAL_STATE=params.n_states;
        params.alpha=0.9;
        reload_flag=false;
        if exist(cache_file,"file") && use_cache
            load(cache_file,"J","mu","Q");
            if length(J)==params.n_states && length(mu)==params.n_states && isequal(size(Q),[params.n_states,params.max_n_actions])
                reload_flag=true;
                fprintf("successfully reloaded policy from cache file: %s\n",cache_file);
            else
                assert(false);
            end
        end
        if ~reload_flag
            [P,g]=getMatrices(params);
            [J,mu,Q]=sparseValueIteration(P,g,params.alpha,"max");
            save(cache_file,"J","mu","Q");
        end
        DATA.J=J;
        DATA.mu=mu;
        DATA.Q=Q;
        DATA.params=params;
    end
    s = getTetrisState(board,pieceNum,DATA.flatBoards,DATA.stateMap);
    a=DATA.mu(s);
    decision=DATA.moves{pieceNum}{a};
    DATAout=DATA;
end
function [P,g]=getMatrices(params)
    fprintf("getMatrices\n");
    n_states=params.n_states;
    n_actions=params.max_n_actions;
    P=cell(1,n_actions);
    for k=1:n_actions
        P{k}=sparse(n_states,n_states);
%         P{k}=zeros(n_states,n_states);
        P{k}(n_states,n_states)=1;
    end
    for k=1:n_actions
        g{k}=sparse(n_states,n_states);
%         g{k}=zeros(n_states,n_states);
    end
    for k=1:n_states-1
        [board,pending_piece] = getTetrisBoard(k,params.boards,params.stateMap);
        n_allowed_actions=length(params.moves{pending_piece});
        for a=1:n_allowed_actions
            move=params.moves{pending_piece}{a};
            [newBoard,score] = nextBoard(board,move);
            if isequal(size(newBoard),size(board)) % not game over
                for p=1:params.n_pieces
                    s = getTetrisState(newBoard,p,params.flatBoards,params.stateMap);
                    P{a}(k,s)=1/params.n_pieces;
                    g{a}(k,s)=score;
                end
            else % game over
                P{a}(k,params.TERMINAL_STATE)=1;
                g{a}(k,s)=score;
            end
        end
        % not allowed actions
        for a=(n_allowed_actions+1):n_actions
            P{a}(k,k)=1;
            g{a}(k,:)=0;
        end
    end
end

function [J,varargout]=sparseValueIteration(P,g,alpha,mode)
    eps=1e-5;
    n_actions=length(P);
    [n_states,~]=size(P{1});
    J0=zeros(n_states,1);
    eg=zeros(n_states,n_actions);
    for k=1:n_states
        for l=1:n_actions
            eg(k,l)=P{l}(k,:)*g{l}(k,:)';
        end
    end
    J_prev=ones(n_states,1)*inf;
    J=J0;
    iter=0;
    delta=norm(J-J_prev,'inf');
    while delta>=eps
        fprintf("iter: %d, delta: %.4f\n",iter,delta);
        Q=zeros(n_states,n_actions);
        for a=1:n_actions
            Q(:,a)=alpha*P{a}*J+eg(:,a);
        end 
        J_prev=J;
        if strcmp(mode,"min")
            [J,mu]=min(Q,[],2);
        elseif strcmp(mode,"max")
            [J,mu]=max(Q,[],2);
        end
        delta=norm(J-J_prev,'inf');
        iter=iter+1;
        varargout{1}=mu;
        varargout{2}=Q;
    end
    fprintf("iter: %d, delta: %.4f\n",iter,delta);
end

% function [J,mu,Q]=valueIteration(params)
%     eps=1e-5;
%     n_states=params.n_states;
%     n_actions=params.max_n_actions;
%     J0=zeros(n_states,1);
%     J_prev=ones(n_states,1)*(-inf);
%     J=J0;
%     iter=0;
%     delta=norm(J-J_prev,'inf');
%     while delta>=eps
%         fprintf("iter: %d, delta: %.5f\n",iter,delta);
%         Q=zeros(n_states,n_actions);
%         Q(params.TERMINAL_STATE,:)=0;
%         parfor s=1:(n_states-1)
%             [board,pending_piece] = getTetrisBoard(s,params.boards,params.stateMap);
%             n_allowed_actions=length(params.moves{pending_piece});
%             Q_temp=zeros(1,n_actions);
%             for a=1:n_allowed_actions
%                 move=params.moves{pending_piece}{a};
%                 [newBoard,score] = nextBoard(board,move);
%                 Q_temp(a)=Q_temp(a)+score;
%                 future_score=0;
%                 if isequal(size(newBoard),size(board)) % not game over
%                     for p=1:params.n_pieces
%                         t = getTetrisState(newBoard,p,params.flatBoards,params.stateMap);
%                         future_score=future_score+params.alpha/params.n_pieces*J(t);
%                     end
%                 else % game over
%                     future_score=0;
%                 end
%                 Q_temp(a)=Q_temp(a)+future_score;
%             end
%             
%             Q_temp((n_allowed_actions+1):n_actions)=-inf;
%             
%             Q(s,:)=Q_temp;
%             
%         end
%         J_prev=J;
%         [J,mu]=max(Q,[],2);
%         delta=norm(J-J_prev,'inf');
%         iter=iter+1;      
%     end
%     
%     fprintf("iter: %d, delta: %.5f\n",iter,delta);
% 
% end

