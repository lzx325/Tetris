function s = getTetrisState(board,piece,flatBoards,stateMap)
%
% s = getTetrisState(board,piece,flatBoards,stateMap)
%
[nr,nc] = size(board);
theFlatBoard = reshape(board,1,nr*nc);
nBoards = size(flatBoards,1);

iBoard = find(flatBoards(:,1) == theFlatBoard(1));
for col = 2:nr*nc,
    tmp = find(flatBoards(:,col) == theFlatBoard(col));
    iBoard = intersect(iBoard,tmp);
end

s = intersect(find(stateMap(:,1)==iBoard),find(stateMap(:,2)==piece));


