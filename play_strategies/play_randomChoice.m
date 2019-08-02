function [decision,DATAout] = play_randomChoice(board,pieceNum,DATA)
    n_allowed_actions=length(DATA.moves{pieceNum});
    decision=DATA.moves{pieceNum}{randi(n_allowed_actions)};
    DATAout=DATA;
end