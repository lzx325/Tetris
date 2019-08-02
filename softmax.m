function p = softmax(v)
%
% p = softmax(v)
%
v = v/(norm(v,inf)+eps)*min(norm(v,inf),700);
p = exp(v);
p = p/norm(p,1);