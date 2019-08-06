function [decision,DATAout] = play_sarsaCompleteState(board,pieceNum,DATA)
    assert(all(isfield(DATA,["flatBoards","boards","moves","stateMap"])));
    addpath("algorithms");
    if ~all(isfield(DATA,["Q","params","episode","step"])) % initialization
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
        params.discount_factor=0.9;
        params.learning_rate0=0.1;
        params.learning_rate=params.learning_rate0;
        params.eps0=1;
        params.eps=params.eps0;
        DATA.Q=zeros(params.n_states,params.max_n_actions);
        % set illegal actions to -inf
        for s=1:params.n_states-1
            [~,pc] = getTetrisBoard(s,params.boards,params.stateMap);
            DATA.Q(s,(length(params.moves{pc})+1):end)=-inf;
            [DATA.J,DATA.mu]=max(DATA.Q,[],2);
        end
        DATA.params=params;
        DATA.episode=1;
        DATA.step=1;
        DATA.S_prev=0;
        DATA.R_prev=0;
        DATA.A_prev=0;
    end
    S = getTetrisState(board,pieceNum,DATA.flatBoards,DATA.stateMap);
    A_distribution=alg_epsGreedyPolicy(S,DATA.Q,DATA.params.eps);
    A=find(mnrnd(1,A_distribution,1));
    if DATA.step>1
        S_prev=DATA.S_prev;
        A_prev=DATA.A_prev;
        R_prev=DATA.R_prev;
        DATA.Q(S_prev,A_prev)=DATA.Q(S_prev,A_prev)+DATA.params.learning_rate*...
            (R_prev+DATA.params.discount_factor*DATA.Q(S,A)-DATA.Q(S_prev,A_prev));
        [DATA.J,DATA.mu]=max(DATA.Q,[],2);
    end
    
    decision=DATA.moves{pieceNum}{A};
    [newBoard,R] = nextBoard(board,decision);
    % game over, next episode
    if ~isequal(size(newBoard),size(board)) || DATA.step>=DATA.maxStages
        DATA.episode=DATA.episode+1;
        DATA.step=1;
        DATA=rmfield(DATA,"S_prev");
        DATA=rmfield(DATA,"A_prev");
        DATA=rmfield(DATA,"R_prev");
        DATA.params.learning_rate=min(DATA.params.learning_rate0,1);
        DATA.params.eps=min(DATA.params.eps0/DATA.episode,1);
        fprintf("game over, current step: %d, next episode: episode %d, eps: %.2e\n", DATA.step, DATA.episode, DATA.params.eps);
    else
        DATA.S_prev=S;
        DATA.A_prev=A;
        DATA.R_prev=R;
        DATA.step=DATA.step+1;        
    end
    DATAout=DATA;
end