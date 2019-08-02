function [board,piece] = getTetrisBoard(s,boards,stateMap)
%
% [board,piece] = getTetrisBoard(s,flatBoards,stateMap)
%

board = boards{stateMap(s,1)};
piece = stateMap(s,2);
