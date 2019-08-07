function [Q_pred,phi]=alg_tetrisPrediction(bd,pc,a,W,params)
    phi(1)=1;
    mv=params.moves{pc}{a};
    [bd_new,n_rows_cleared] = nextBoard(bd,mv);
    rw=n_rows_cleared;
    if ~isequal(size(bd_new),size(bd)) && ~isnan(params.reward_game_over)
        rw=params.reward_game_over;
    end
    bd_new_height=boardHeight(bd_new);
    bd_new_holes=boardHoles(bd_new);
    phi(end+1)=max(bd_new_height);
    phi(end+1)=min(bd_new_height);
    phi(end+1)=rw;
    phi(end+1)=sum(bd_new_holes);
    Q_pred=phi*W;
    phi=phi';
%     if ~isequal(size(bd_new),size(bd))
%         Q_pred=params.reward_game_over;
%         phi=zeros(size(phi));
%     end
end