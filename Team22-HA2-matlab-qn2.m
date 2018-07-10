y = csvread("mixture-observations.csv");
n =length(y);
N = 100;
w = zeros(n,N);
theta = 0.5; % putting a random thetre here initialization

track_theta = zeros(N,1);
for j = 1:N
    for i=1:n
        gOne = normpdf(y(i),1,2);
        gZero = normpdf(y(i),0,1);
        w(i,j) = (theta*gOne)/(theta*gOne +(1-theta)*gZero);
    end
    theta = 1/n*(sum(w(:,j)));
    track_theta(j,1) = theta;
end

%Plot points
figure
plot(1:N,track_theta); 
title('Estimation of Theta')
xlabel('EM interation index')
ylabel('theta estimate')
% Plot histogram for y
figure;
histogram(y,20);
xlabel("y")
ylabel("frequency")