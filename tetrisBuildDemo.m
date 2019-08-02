%
% Tetris build demo
%
% lizx: this is for offline computation
% Define pieces

Pieces{1} = [0 1;1 1];
Pieces{2} = [1 1];
Pieces{3} = [1];
numRots = [3 1 0]; 

% Define game size

GameSize = [6,2]; % height x width
RowCap = 2; % height of gameOver

% Build boards & stateMap

[moves,flatBoards,boards,stateMap] = ...
    tetrisBuild(RowCap,GameSize(2),Pieces,numRots);

%
% Display output
%

disp('Pieces:')
Pieces{:}

disp('Boards:')
boards{:}

disp('Moves of 1st piece:')
moves{1}{:}

disp('Moves of 2nd piece:')
moves{2}{:}

disp('Moves of 3rd piece:')
moves{3}{:}

%
% Getting states
%

disp('Number of states:')
nStates = size(stateMap,1)

% Get the board/piece corresponding to a state
disp('Randomly selected state:')
s = randi(nStates)
[board,piece] = getTetrisBoard(s,boards,stateMap) % state number to board

% Get the state corresponding to a board/state
sTest = getTetrisState(board,piece,flatBoards,stateMap) % board to state number

%
% Nextboard function
%

% Example 1:
disp('Nextboard example 1:')
board1 = boards{16}
move1 = moves{1}{1}
[newBoard1,score1] = nextBoard(board1,move1)
% Example 2:
disp('Nextboard example 2:')
board2 = boards{1}
move2 = moves{3}{2}
[newBoard2,score2] = nextBoard(board2,move2)
