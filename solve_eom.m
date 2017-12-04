function [ q,t ] = solve_eom( )

%%% DOF 
%%% Vector q contains the 6 DOF of the system

%%% q(1): (x) fore-aft displacement [m]
%%% q(2): (y) side-side displacement [m]
%%% q(3): (z) negative-heave displacement [m]
%%% q(4): (Theta_x) side-side roll [rad]
%%% q(5): (Theta_y) fore-aft roll [rad]
%%% q(6): (Theta_z) yaw [rad]
%%% q(7): (x) fore-aft displacement velocity [m/s]
%%% q(8): (y) side-side displacement velocity [m/s]
%%% q(9): (z) negative-heave displacement velocity [m/s]
%%% q(10): (Theta_x) side-side roll velocity [rad/s]
%%% q(11): (Theta_y) fore-aft roll velocity [rad/s]
%%% q(12): (Theta_z) yaw velocity [rad/s]

%%% Obtain system parameters and forces

[params,forces] = setup_verification_case_1();

%%% Construct mass and stiffness matrix

M = mass_matrix_for_solving(params);
K = stiffness_matrix_for_solving(params,forces);

roll = 5 *pi*180;
pitch = 2 *pi*180;
yaw = 0 *pi*180;

%%% initial condition
q0 = [0 0 1 roll pitch yaw 0 0 0 0 0 0];
%q0 = [0 1 1 0 0 0 0 0 0 0 0 0];

%%% time intervall
t0 = 0;
tf = 60;
tspan = [t0 tf];
%%%configure mass matrix
options=odeset('Mass',M); 

%%% solve with ode23s
[T,Q]=ode23s(@(t,q) rhs(t,q,K) ,tspan ,q0 ,options); 

hold on
plot(T,Q(:,1),'r');
plot(T,Q(:,2),'g');
plot(T,Q(:,3),'m');
plot(T,Q(:,4),'k');
plot(T,Q(:,5),'b');
plot(T,Q(:,6),'c');

legend('x','y','z','side-side','fore-aft','yaw');

%axis([t0 tf -1 1]);

end

