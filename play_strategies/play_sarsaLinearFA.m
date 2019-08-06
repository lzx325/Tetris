function [decision,DATAout] = play_sarsaLinearFA(board,pieceNum,DATA)
    assert(all(isfield(DATA,["moves"])));
    addpath("algorithms");
    if ~all(isfield(DATA,["W","params","episode","step"])) % initialization
        params.n_pieces=length(DATA.moves);
        % Define game size
        params.ColCap=size(DATA.moves{1}{1},2);
        params.RowCap = DATA.rowCap; % height of gameOver
        
        params.moves=DATA.moves;
        
        params.discount_factor=0.9;
        params.learning_rate0=1e-2;
        params.learning_rate=params.learning_rate0;
        params.eps0=1;
        params.eps=params.eps0;
        params.n_features=5;
        DATA.W=zeros(params.n_features,1);
        DATA.params=params;
        DATA.episode=1;
        DATA.step=1;
    end
    
    n_allowed_actions=length(DATA.moves{pieceNum});
    state_action_features=zeros(n_allowed_actions,DATA.params.n_features);
    for a=1:n_allowed_actions
        phi=alg_tetrisFeatures(board,pieceNum,a,DATA.params);
        state_action_features(a,:)=phi';
    end
    action_valuations=(state_action_features*DATA.W)'; % estimated value of each action
    A_distribution=alg_epsGreedyPolicy(1,action_valuations,DATA.params.eps);
    
    A=find(mnrnd(1,A_distribution,1));
    decision=DATA.moves{pieceNum}{A};
    [newBoard,n_rows_cleared] = nextBoard(board,decision);
    R=n_rows_cleared;
    if ~isequal(size(newBoard),board)
        R=-1;
    end
    % sarsa update
    %==============================================================================
    if DATA.step>1
        board_prev=DATA.board_prev;
        pieceNum_prev=DATA.pieceNum_prev;
        R_prev=DATA.R_prev;
        A_prev=DATA.A_prev;
        
        
        feature_current=alg_tetrisFeatures(board,pieceNum,A,DATA.params);
        q_current=feature_current'*DATA.W;
        feature_prev=alg_tetrisFeatures(board_prev,pieceNum_prev,A_prev,DATA.params);
        q_prev=feature_prev'*DATA.W;
        delta_W=(R_prev+DATA.params.discount_factor*q_current-q_prev)*feature_prev;
        DATA.W=DATA.W+DATA.params.learning_rate*delta_W;   
%         if ~ max(abs(delta_W))==0 && R_prev>0
%             keyboard;
%         end
    end
    %==============================================================================
    % q_learning update
    %==============================================================================
%     if DATA.step>1
%         board_prev=DATA.board_prev;
%         pieceNum_prev=DATA.pieceNum_prev;
%         R_prev=DATA.R_prev;
%         A_prev=DATA.A_prev;
%         
%         q_all_actions=zeros(1,length(DATA.moves{pieceNum}));
%         for a=1:length(DATA.moves{pieceNum})
%             feature_tmp=alg_tetrisFeatures(board,pieceNum,a,DATA.params);
%             q_all_actions(a)=feature_tmp'*DATA.W;
%         end
%         q_max=max(q_all_actions);
%         feature_prev=alg_tetrisFeatures(board_prev,pieceNum_prev,A_prev,DATA.params);
%         q_prev=feature_prev'*DATA.W;
%         delta_W=(R_prev+DATA.params.discount_factor*q_max-q_prev)*feature_prev;
%         DATA.W=DATA.W+DATA.params.learning_rate*delta_W;
%         
%     end
    %==============================================================================
    % averaged Q_learning update
    %==============================================================================
%     feature_current=alg_tetrisFeatures(board,pieceNum,A,DATA.params);
%     Qnow=feature_current'*DATA.W;
%     target=R;
%     for pNo=1:DATA.params.n_pieces
%         Qtest=[];
%         for v=1:length(DATA.moves{pNo})
%             feature_tmp=alg_tetrisFeatures(newBoard,pNo,v,DATA.params);
%             Qtest(v)=feature_tmp'*DATA.W;
%         end
%         target=target+max(Qtest)/DATA.params.n_pieces;        
%     end
%     delta_W=(target-Qnow)*feature_current;
%     DATA.W=DATA.W+DATA.params.learning_rate*delta_W;
    %==============================================================================
    
    
    
    
    
    
    % game over, next episode
    if ~isequal(size(newBoard),size(board)) || DATA.step>=DATA.maxStages
        % terminal weight update
        feature_current=alg_tetrisFeatures(board,pieceNum,A,DATA.params);
        q_current=feature_current'*DATA.W;

        delta_W=(R_prev-q_current)*feature_prev;
        DATA.W=DATA.W+DATA.params.learning_rate*delta_W;   
        
        % prepare next episode
        DATA.episode=DATA.episode+1;
        DATA.step=1;
        DATA=rmfield(DATA,"board_prev");
        DATA=rmfield(DATA,"pieceNum_prev");
        DATA=rmfield(DATA,"R_prev");
        DATA=rmfield(DATA,"A_prev");
%         DATA.params.learning_rate=min(DATA.params.learning_rate0/DATA.episode,1);
        DATA.params.learning_rate=min(DATA.params.learning_rate0/DATA.episode,1);
        DATA.params.eps=min(DATA.params.eps0/DATA.episode,1);
        fprintf("game over, current step: %d, next episode: episode %d, eps: %.2e, lr: %.2e\n", DATA.step, DATA.episode, DATA.params.eps, DATA.params.learning_rate);
    else
        DATA.board_prev=board;
        DATA.pieceNum_prev=pieceNum;
        DATA.R_prev=R;
        DATA.A_prev=A;
        DATA.step=DATA.step+1;        
    end
    DATAout=DATA;
end