function [decision,DATAout] = myPlay(board,pieceNum,DATA)
% 
% Places the piece to minimize the maximum height
%
for u = 1:length(DATA.moves{pieceNum}),
    move = DATA.moves{pieceNum}{u};
    theNextBoard = nextBoard(board,move); % lizx: What the next board will be
    height(u) = max(boardHeight(theNextBoard));
end

[~,uBest] = min(height);

decision = DATA.moves{pieceNum}{uBest}; % lizx: allowed moves on this current piece, all translations and rotations
DATAout = DATA;
