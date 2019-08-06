function [decision,DATAout] = myPlay(board,pieceNum,DATA)
    addpath("./play_strategies");
    %[decision,DATAout] = play_minMaxHeight(board,pieceNum,DATA);
    %[decision,DATAout] = play_generalValueIteration(board,pieceNum,DATA);
    %[decision,DATAout] = play_valueIteration(board,pieceNum,DATA);
    %[decision,DATAout] = play_randomChoice(board,pieceNum,DATA);
    %[decision,DATAout] = play_sarsaCompleteState(board,pieceNum,DATA);
    [decision,DATAout] = play_sarsaLinearFA(board,pieceNum,DATA);

end

