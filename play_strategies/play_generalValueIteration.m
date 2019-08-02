function [decision,DATAout] = play_generalValueIteration(board,pieceNum,DATA)
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
        [P,g]=getMatrices(params);
        [J,mu,Q]=alg_generalValueIteration(P,g,params.alpha,"max");
        DATA.J=J;
        DATA.mu=mu;
        DATA.Q=Q;
        DATA.params=params;
    end
    s = getTetrisState(board,pieceNum,DATA.params.flatBoards,DATA.params.stateMap);
    a=DATA.mu(s);
    decision=DATA.moves{pieceNum}{a};
    DATAout=DATA;
end

function [P,g]=getMatrices(params)
    n_states=params.n_states;
    n_actions=params.max_n_actions;
    P=zeros(n_states,n_states,n_actions);
    g=zeros(n_states,n_actions,n_states);
    P(n_states,n_states,:)=1;
    for k=1:n_states-1
        [board,pending_piece] = getTetrisBoard(k,params.boards,params.stateMap);
        n_allowed_actions=length(params.moves{pending_piece});
        for a=1:n_allowed_actions
            move=params.moves{pending_piece}{a};
            [newBoard,score] = nextBoard(board,move);
            if isequal(size(newBoard),size(board)) % not game over
                for p=1:params.n_pieces
                    s = getTetrisState(newBoard,p,params.flatBoards,params.stateMap);
                    P(k,s,a)=1/params.n_pieces;
                    g(k,a,s)=score;
                end
            else % game over
                P(k,params.TERMINAL_STATE,a)=1;
                g(k,a,s)=score;
            end
        end
        % not allowed actions
        for a=(n_allowed_actions+1):n_actions
            P(k,k,a)=1;
            g(k,a,:)=-inf;
        end
    end
end