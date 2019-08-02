% TetrisSim.m - Tetris Simulator
% J.Aho 10/16/11
% modified for Discrete Math course, Holly Borowski 10/28/13
% modified for KAUST, JSS 11/24/17

clearvars, close all
format compact
beep off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------Students: edit this section to test your code------%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% [decision,DATA] = myFun(boardLower,CurPnum,DATA)
%
myFun = 'myPlay';

N = 50; % max number of pieces per episode
nEpisodes = 5; % number of episodes

buildStates = 0; % flag to build state space
morePieces = 0; % add the s-shaped pieces

GameSize = [8,6]; % height x width
RowCap = 4; % height of gameOver

TimeDelay=.05; % Time delay of dropping piece (lower number=faster)

%
% DATA = structure structure to pass back and forth to myPlay
% Reserved fields: flatBoards, boards, moves, stateMap
%

DATA.example1 = [];
DATA.example2 = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------Students: edit this section to test your code------%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize and Setup Game

DATA.rowCap = RowCap;
% Define the game pieces
Pieces{1} = [0 1;1 1];
Pieces{2} = [0 1 0;1 1 1];
Pieces{3} = [1 1 1];
numRots = [3 3 1]; %number of times each piece can be rotated, the total set of configurations is the rotations plus the original one
if morePieces == 1,
    Pieces{4} = [1 1 0;0 1 1];
    Pieces{5} = [0 1 1;1 1 0];
    numRots = [3 3 1 1 1]; 
end

% Set piece colors
Pcolor=1:length(Pieces);

% Build tetris states & moves

if buildStates,
    display(datetime('now'))
    tic
    [moves,flatBoards,boards,stateMap] = ...
      tetrisBuild(RowCap,GameSize(2),Pieces,numRots);
    DATA.flatBoards = flatBoards;
    DATA.boards = boards;
    DATA.moves = moves;
    DATA.stateMap = stateMap;
    toc
else
    moves = tetrisBuild(RowCap,GameSize(2),Pieces,numRots);
    DATA.moves = moves;
end

% A few more parameters
S_Sounds=0; % Switch, 1=sounds on, 0=sounds off
S_Plot=1;  % Switch to Perform plotting, 1=yes

% Execute Game

startPiece = randi(length(Pieces));

for kc=1:nEpisodes,
    
    CurPnum = startPiece;
    board=zeros(GameSize);

    if S_Plot==1
        figure(1)
    end
    GameOver=0;
    Score=0;
    stoploop=0;
    
    for numPlays = 1:N+1,
        if GameOver ~= 1,
            
            CurPnum = randi(length(Pieces));

            % the game board that is under the red line
            boardLower = board(GameSize-RowCap+1:end,:); 
            boardLower = boardLower>0;
            
            %%%%%%%%%%%%%%
            %%%%%%%%%%%%%%
            % Call myFun %
            %%%%%%%%%%%%%%
            %%%%%%%%%%%%%%
            
            theString = strcat('[decision,DATA] =',myFun,...
                '(boardLower,CurPnum,DATA);');
            eval(theString);

            cols = find(sum(decision,1)>0);
            rows = find(sum(decision,2)>0);
            CurPlace = cols(1);
            CurPiece = decision(rows,cols);
            cp = Pieces{CurPnum};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            %%%%SEEMS UNNECESSARY%%%%
%            % check to see if your decision is valid
%             valid = 0;
%             for j = 0:numRots(CurPnum)
%                 testMatrix = rot90(cp,j);
%                 if (size(testMatrix)==size(CurPiece))
%                     test = sum(sum(testMatrix~=CurPiece));
%                     if ~test
%                         valid = 1;
%                         break;
%                     end
%                 end
%             end
%             if valid==0
%                  error('Invalid decision!')
%             end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            CurPiece = CurPiece*Pcolor(CurPnum);

            [CPr,CPc]=size(CurPiece);

            if CurPlace+CPc-1>GameSize(2)
                warning('WARNING: Your piece is off the gameboard!')
            end

            overlap=0;
            GameBoard1=board;
            count=0;
            while overlap==0
                count=count+1;

                if count+CPr-2==GameSize(1)
                    overlap=1;
                    board=GameBoard1;
                elseif max(max((board(count:count+CPr-1,CurPlace:CurPlace+CPc-1)>0)+(CurPiece>0)))>1
                    overlap=1;
                    board=GameBoard1;
                else
                    GameBoard1=board;
                    GameBoard1(count:count+CPr-1,CurPlace:CurPlace+CPc-1)=board(count:count+CPr-1,CurPlace:CurPlace+CPc-1)+CurPiece;
                    %break;
                end

                if S_Plot==1

                    [r,c] = size(GameBoard1);                           % Get the matrix size
                    imagesc((1:c)+0.5,(1:r)+0.5,GameBoard1,[0,max(Pcolor)]);            % Plot the image
                    axis equal                                   % Make axes grid sizes equal
                    set(gca,'XTick',1:c+1,'YTick',1:r+1,...  % Change some axes properties
                        'XLim',[1 c+1],'YLim',[1 r+1],...
                        'XTickLabel',0:c,'YTickLabel',0:r,...
                        'GridLineStyle','-','XGrid','on','YGrid','on');
                    hold on
                    plot([0,r],[r-RowCap+1,r-RowCap+1],'r', 'LineWidth',3)
                    title(['Score=',num2str(Score), ', N=', num2str(numPlays)])
                    hold off
                    pause(TimeDelay);
                end
            end

            S=sum(board>0,2)==GameSize(2);

            board(S==1,:)=[];
            Score=Score+sum(S);
            board=[zeros(sum(S),GameSize(2));board];
            if sum(S)>0 && S_Sounds==1
                beep
            end

            if sum(sum(board(1:GameSize(1)-RowCap,:)))>0 || numPlays == N
                GameOver=1;
                if  S_Plot==1
                    title(['ROUND ', num2str(kc),...
                        ': Score=',num2str(Score),', Pieces=', num2str(numPlays)])
                    disp(['ROUND ', num2str(kc),...
                        ': Score=',num2str(Score),', Pieces=', num2str(numPlays)])
                end
                if S_Sounds==1, load gong.mat; sound(y,1*Fs);  end
            end
        end
        if GameOver==1,stoploop=1;  end
    end

    Iscore(kc)=Score; % Store the scores
    %fprintf('Score = %i\n',Score)
    
end


