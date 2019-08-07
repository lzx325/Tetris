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
%%
episode_reward_minHeight=episode_reward;
episode_length_minHeight=episode_length;
save("cache/statistics_minHeight-large.mat","episode_reward_minHeight","episode_length_minHeight");
%%
load("cache/statistics_VI.mat");
load("cache/statistics_random.mat");
load("cache/statistics_minHeight.mat");
load("cache/statistics_sarsaCompleteState.mat");
load("cache/statistics_sarsaLinearFA.mat");
load("cache/statistics_sarsaLinearFA_update.mat");
reward_VI=mean(episode_reward_VI)*ones(1,200);
reward_random=mean(episode_reward_random)*ones(1,200);
reward_minHeight=mean(episode_reward_minHeight)*ones(1,200);
reward_sarsaCompleteState=episode_reward_sarsaCompleteState(1:200);
reward_sarsaLinearFA_update=episode_reward_sarsaLinearFA_update(1:200);
hold on;
plot(1:200,reward_VI);
plot(1:200,reward_random);
plot(1:200,reward_minHeight);
% plot(1:200,reward_sarsaCompleteState);
plot(1:200,reward_sarsaLinearFA_update);
ylim([0,50]);
xlabel("episodes");
ylabel("reward");
legend({"VI","Random","minHeight","sarsaLinearFA"});
title("Episode Reward");
hold off;
%%
load("cache/statistics_VI.mat");
load("cache/statistics_random.mat");
load("cache/statistics_minHeight.mat");
load("cache/statistics_sarsaCompleteState.mat");
load("cache/statistics_sarsaLinearFA.mat");
load("cache/statistics_sarsaLinearFA_update.mat");
length_VI=mean(episode_length_VI)*ones(1,200);
length_random=mean(episode_length_random)*ones(1,200);
length_minHeight=mean(episode_length_minHeight)*ones(1,200);
length_sarsaCompleteState=episode_length_sarsaCompleteState(1:200);
length_sarsaLinearFA=episode_length_sarsaLinearFA(1:200);
reward_sarsaLinearFA_update=episode_length_sarsaLinearFA_update(1:200);
hold on;
plot(1:200,length_VI+0.3);
plot(1:200,length_random);
plot(1:200,length_minHeight);
% plot(1:200,length_sarsaCompleteState);
plot(1:200,reward_sarsaLinearFA_update);
ylim([0,70]);
xlabel("episodes");
ylabel("episode length");
legend({"VI","Random","minHeight","sarsaLinearFA"});
title("Episode Length");
hold off;
%%
load("cache/statistics_random-large.mat");
load("cache/statistics_minHeight-large.mat");
load("cache/statistics_sarsaLinearFA_update-large.mat");
length_random=mean(episode_length_random)*ones(1,200);
length_minHeight=mean(episode_length_minHeight)*ones(1,200);
length_sarsaLinearFA_update=episode_length_sarsaLinearFA_update(1:200);
hold on;
plot(1:200,length_random);
plot(1:200,length_minHeight);
% plot(1:200,length_sarsaCompleteState);
plot(1:200,length_sarsaLinearFA_update);
ylim([0,70]);
xlabel("episodes");
ylabel("episode length");
legend({"Random","minHeight","sarsaLinearFA"});
title("Episode Length");
hold off;
%%
load("cache/statistics_random-large.mat");
load("cache/statistics_minHeight-large.mat");
load("cache/statistics_sarsaLinearFA_update-large.mat");
reward_random=mean(episode_reward_random)*ones(1,200);
reward_minHeight=mean(episode_reward_minHeight)*ones(1,200);
reward_sarsaLinearFA_update=episode_reward_sarsaLinearFA_update(1:200);
hold on;
plot(1:200,reward_random);
plot(1:200,reward_minHeight);
% plot(1:200,length_sarsaCompleteState);
plot(1:200,reward_sarsaLinearFA_update);
ylim([0,35]);
xlabel("episodes");
ylabel("episode reward");
legend({"Random","minHeight","sarsaLinearFA"});
title("Episode Reward");
hold off;
