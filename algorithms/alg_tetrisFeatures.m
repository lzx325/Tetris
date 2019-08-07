function [phi]=alg_tetrisFeatures(bd,pc,a,params)
    phi(1)=1;
    %bd_height=boardHeight(bd);
%     phi(2)=max(bd_height);
    %phi(3)=min(bd_height);
    mv=params.moves{pc}{a};
    [bd_new,n_rows_cleared] = nextBoard(bd,mv);
    rw=n_rows_cleared;
    if ~isequal(size(bd_new),size(bd))
        rw=-1;
    end
    bd_new_height=boardHeight(bd_new);
    bd_new_holes=boardHoles(bd_new);
    phi(end+1)=max(bd_new_height);
    phi(end+1)=min(bd_new_height);
    phi(end+1)=rw;
    phi(end+1)=sum(bd_new_holes);
    phi=phi';
    
%     if ~isequal(size(bd_new),bd)
%         phi=zeros(size(phi));
%     end
end