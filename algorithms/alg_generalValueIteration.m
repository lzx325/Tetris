function [J,varargout]=alg_generalValueIteration(P,g,alpha,mode)
eps=1e-5;
[n_states,~,n_actions]=size(P);
J0=zeros(n_states,1);
eg=zeros(n_states,n_actions);
for k=1:n_states
    for l=1:n_actions
        eg(k,l)=P(k,:,l)*squeeze(g(k,l,:));
    end
end
J_prev=ones(n_states,1)*inf;
J=J0;
iter=0;
delta=norm(J-J_prev,'inf');
while delta>=eps
    fprintf("iter: %d, delta: %.4f\n",iter,delta);
    Q=zeros(n_states,n_actions);
    for a=1:n_actions
        Q(:,a)=alpha*P(:,:,a)*J+eg(:,a);
    end 
    J_prev=J;
    if strcmp(mode,"min")
        [J,mu]=min(Q,[],2);
    elseif strcmp(mode,"max")
        [J,mu]=max(Q,[],2);
    end
    delta=norm(J-J_prev,'inf');
    iter=iter+1;
    varargout{1}=mu;
    varargout{2}=Q;
end
fprintf("iter: %d, delta: %.4f\n",iter,delta);
