%%
parfor i=1:3
    c(:,i) = eig(rand(1000)); 
end
%%
A=zeros(2e4,2e4);
parfor(iter=1:2e4)
    A(iter,:)=ones(1,2e4);
end
