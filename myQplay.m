function [decision,DATAout] = myQplay(board,pieceNum,DATA)
%
% Implements on-policy Q-learning using approximate Q
%

Qtest = [];
for u = 1:length(DATA.moves{pieceNum}),
    Qtest(u) = tetrisQeval(board,pieceNum,u,DATA.w,DATA.moves,DATA.rowCap);
end

uBest = randiP(softmax(Qtest/0.1));
decision = DATA.moves{pieceNum}{uBest};

[theNextBoard,score] = nextBoard(board,decision);

[Qnow,phi] = tetrisQeval(board,pieceNum,uBest,DATA.w,DATA.moves,DATA.rowCap);

target = score;
nPieces = length(DATA.moves);
for pNo = 1:nPieces
    Qtest = [];
    for v = 1:length(DATA.moves{pNo})
        Qtest(v) = tetrisQeval(theNextBoard,pNo,v,DATA.w,DATA.moves,DATA.rowCap);
    end
    target =  target + max(Qtest)/nPieces;
end
w = DATA.w;
w = w + 0.01*(target - Qnow)*phi;
DATA.w = w;

%DATA.w = [12.5278    1.0305   -0.9758   -1.7897]';

DATAout = DATA;
