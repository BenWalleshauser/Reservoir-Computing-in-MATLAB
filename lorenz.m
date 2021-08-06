function dX = lorenz(t,X)

%Lorenz '63 

%Chaotic Parameters:
sigma = 10;   
rho = 28;
beta = 8/3;

%Initialization:
dX = [0;0;0];
x = X(1);
y = X(2);
z = X(3);

%Main:
dX(1) = sigma*(y - x);
dX(2) = x*(rho - z) - y;
dX(3) = x*y - beta*z;

%Lorenz, E. N. (1963).   Deterministic Nonperiodic Flow, Journal of Atmospheric Sciences, 20(2), 130-141.  
%Retrieved Aug 5, 2021, from https://journals.ametsoc.org/view/journals/atsc/20/2/1520-0469_1963_020_0130_dnf_2_0_co_2.xml
end



