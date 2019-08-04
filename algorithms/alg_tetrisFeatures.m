function [phi]=alg_tetrisFeatures(bd,pc,a,params)
    n_features=4;
    phi=zeros(n_features,1);
    phi(1)=1;
    %bd_height=boardHeight(bd);
%     phi(2)=max(bd_height);
    %phi(3)=min(bd_height);
    mv=params.moves{pc}{a};
    [bd_new,rw] = nextBoard(bd,mv);
    bd_new_height=boardHeight(bd_new);
    phi(2)=max(bd_new_height);
    phi(3)=min(bd_new_height);
    phi(4)=rw;
end