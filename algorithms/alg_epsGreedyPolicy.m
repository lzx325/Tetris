function [A]=alg_epsGreedyPolicy(state,Q,eps)
    [~,n_actions]=size(Q);
    allowed_actions=find(Q(state,:)>-inf);
    A=zeros(1,n_actions);
    A(allowed_actions)=eps/length(allowed_actions);
    Q_best=max(Q(state,:));
    Q_best_idx=find(Q(state,:)==Q_best);
    best_action=Q_best_idx(randi(length(Q_best_idx)));
    A(best_action)=A(best_action)+1-eps;
end