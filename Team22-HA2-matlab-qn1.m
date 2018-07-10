clear;
T = csvread("coal-mine.csv");
d = 3;
M = 10000;
t = zeros(d+1,M);
theta_dist = zeros(1,M);
lambda_dist = zeros(d,M);
tmin= 1851;
tmax=1963;
t(1,:) = tmin;
t(d+1,:) = 1963;
t(2:d,1) = transpose(sort(tmin+rand(1,d-1)*(tmax-tmin)));
para = 2;
theta = gamrnd(2,para);
lambda = gamrnd(2,theta,d,1);
track_tOne = zeros(d-1,M);
track_tOneFinal = zeros(d-1,M);
theta_dist(1) =theta;
lambda_dist(:,1) = lambda;
p = 0.5;
for j=1:M-1
    theta_dist(j+1) = gamrnd(2d+2,1/(sum(lambda_dist(:,j)) + para));
    for i=1:(d)
        %Number of disasters in subinterval [t_i, t_i+1)
        sum_dis = sum(T >=t(i,j) & T < t(i+1,j));
        n(i,j)= sum_dis;
    end 
        lambda_dist(:,j+1)=gamrnd(2+n(:,j),1./(diff(t(:,j))+ theta_dist(j+1)));
    for i=2:(d)
        R = p*(t(i+1,j)-t(i-1,j+1));
        t_star = -R + (R+R)*rand(1,1) + t(i,j); %choose something from uniform distribution
        t_one = (t_star-t(i-1,j+1))*(t(i+1,j)-t_star)/(t(i,j) - (t(i-1,j+1)))/(t(i+1,j) - (t(i,j)));
        if t_star > t(i+1,j)
            t_one = 0;
        elseif t_star < t(i-1,j+1)
            t_one = 0;
        end
        track_tOne(i,j) = t_one;
        t_one_final = min(1,t_one);
        track_tOneFinal(i,j) = t_one_final;
        u = rand();
        if u<=t_one_final
            t(i,j+1) = t_star;
        else
            t(i,j+1)=t(i,j);
        end
    end    
end

figure;
for i=2:d
    %histogram when n= 20
    histogram(t(i,:),20);
    title("Histogram for t")
    hold on;
    xlabel("t")
    ylabel("Frequency")
end

figure;
for i=1:d
     %histogram when n= 20
    histogram(lambda_dist(i,:),[0:0.1:3]);
    hold on;
    title("Histogram for lambda ")
    xlabel("lambda")
    ylabel("Frequency")        
end

figure;
histogram(theta_dist,20);
title("Histogram for theta ")
xlabel("theta")
ylabel("Frequency")   
    
