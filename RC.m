%bwaaaaaaaa
%8/5/2021

%% Generating Data

%Data to train the RC with
[t, X_train] = ode45('lorenz', [0:0.01:300], [10 10 10]);

%Data to validate the RC with (different ICs)
IC_validate = [10.1 10 10];
[t2, X_validate] = ode45('lorenz', [0:0.01:50],IC_validate);

%% Parameters and Initialization
% W_in = Input Weights
% A = Reservoir/Middle Weights
% W_out = Output Weights
% r_state = Reservoir State
% R = Collection of reservoir states to be used in the linear regression

% dim_system = Dimension of the system (for Lorenz63 this is 3)
% dim_reservoir = Number of nodes in the reservoir (each having
%                  dim_reservoir corresponding weights)
% sigma = Multiplier for the random input matrix
% density = Density of the reservoir matrix (try to make sparse)
% beta = Regularization parameter

dim_system=3;                   
dim_reservoir=300;    
sigma=0.1;                                          
density=0.05;
beta = 0.01;

r_state = zeros(dim_reservoir,1);                          
A = generate_reservoir(dim_reservoir, density);      
W_in = 2*sigma*(rand(dim_reservoir, 3) - 0.5);            
W_out = zeros(3,dim_reservoir);                          
R = zeros(dim_reservoir, length(t));

%% Training the RC

%Using a sigmoid activation function
for i = 1:length(t)
    R(:,i) = r_state;                                                        
    r_state = 1./(1+exp(-(A*r_state + W_in*X_train(i,:)')));         
end

%Using a ridge regression to fit output weights s.t. X(t+h) = W_out*r_state(t)
W_out = (X_train.'*R.')*(inv( (R*R.') + beta.*eye(length( R(:,1) ) ) ) );

%% Predicting w/. the RC
clear r_state

X_predicted = zeros(length(t2),3);

%Want to start predicting from new ICs (IC_validate)
r_state = 1./(1+exp(-(W_in*IC_validate')));

for i = 1:length(t2)
    X_predicted(i,:) = W_out*r_state;                                   
    r_state = 1./(1+exp(-(A*r_state + W_in*X_predicted(i,:)')));        
end

%% Visuals
figure(1)

subplot(3,1,1)
hold on
plot(t2,X_validate(:,1),'b')
plot(t2,X_predicted(:,1),'r')
xlabel('Time')
ylabel('x')
legend('True','Predicted')
grid on

subplot(3,1,2)
hold on
plot(t2,X_validate(:,2),'b')
plot(t2,X_predicted(:,2),'r')
xlabel('Time')
ylabel('y')
grid on

subplot(3,1,3)
hold on
plot(t2,X_validate(:,3),'b')
plot(t2,X_predicted(:,3),'r')
xlabel('Time')
ylabel('z')
grid on
sgtitle('Predicting Lorenz 63')
hold off


figure(2)

plot3(X_validate(:,1), X_validate(:,2), X_validate(:,3),'b');
hold on
plot3(X_predicted(:,1), X_predicted(:,2), X_predicted(:,3),'r');
grid on
title('Predicting Lorenz 63')
xlabel('x')
ylabel('y')
zlabel('z')
legend('True','Predicted')
hold off






