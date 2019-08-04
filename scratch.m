%%
parfor i=1:3
    c(:,i) = eig(rand(1000)); 
end
%%
A=zeros(2e4,2e4);
parfor(iter=1:2e4)
    A(iter,:)=ones(1,2e4);
end
%%
y=[1,2];
a=@(x,y)(x+y);
b=@(x)(x+y);
b([3,3])
y(1)=10;
b([3,3])
%%
Q=[0,0;
   1,0;
   1,1;];
alg_epsGreedyPolicy(3,Q,0.01)
%%
bd=[...
    0 0 0;
    0 1 1;
    0 1 1;]
next_pc=1;
a=1;
mv=DATA.moves{next_pc}{a}
[bd_new,rw] = nextBoard(bd,mv)
s = getTetrisState(bd,a,DATA.flatBoards,DATA.stateMap);
alg_tetrisFeatures(s,a,DATA.params)
