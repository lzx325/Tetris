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
        params.learning_rate0=1e-3;
        params.learning_rate=params.learning_rate0;
        params.eps0=1;
        params.eps=params.eps0;
        params.n_features=4;
        DATA.W=-ones(params.n_features,1);
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
    if DATA.step>1
        board_prev=DATA.board_prev;
        pieceNum_prev=DATA.pieceNum_prev;
        R_prev=DATA.R_prev;
        A_prev=DATA.A_prev;
        feature_plus=alg_tetrisFeatures(board,pieceNum,A,DATA.params);
        q_plus=feature_plus'*DATA.W;
        feature_prev=alg_tetrisFeatures(board_prev,pieceNum_prev,A_prev,DATA.params);
        q_prev=feature_prev'*DATA.W;
        delta_W=DATA.params.learning_rate*(R_prev+DATA.params.discount_factor*q_plus-q_prev)*feature_prev;
%         fprintf("%.2e, %.2e, %.2e\n",R_prev,q_plus,q_prev);
        DATA.W=DATA.W+delta_W;
%         if delta_W(4)>0
%             keyboard;
%         end
    end
    
    decision=DATA.moves{pieceNum}{A};
    [newBoard,R] = nextBoard(board,decision);
    % game over, next episode
    if ~isequal(size(newBoard),size(board)) || DATA.step>=DATA.maxStages
        DATA.episode=DATA.episode+1;
        DATA.step=1;
        DATA=rmfield(DATA,"board_prev");
        DATA=rmfield(DATA,"pieceNum_prev");
        DATA=rmfield(DATA,"R_prev");
        DATA=rmfield(DATA,"A_prev");
%         DATA.params.learning_rate=min(DATA.params.learning_rate0/DATA.episode,1);
        DATA.params.learning_rate=min(DATA.params.learning_rate0,1);
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