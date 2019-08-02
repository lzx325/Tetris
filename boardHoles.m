function h = boardHoles(board)

%
% Compute the number of holes of each column
%

[nr,nc] = size(board);

for i = 1:nc,
    fboard = flip(board);
    tmp = max(find(fboard(:,i) == 1));
    if isempty(tmp),
        holes(i) = 0;
    else
        holes(i) = length(find(fboard(1:(tmp-1),i) == 0));
    end
end

h = holes;