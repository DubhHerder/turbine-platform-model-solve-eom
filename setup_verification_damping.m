function [params,forces] = setup_verification_damping()

%%% Floating Platform Model
%%% Author: Rufus Oelkers
%%% Chair of Experimental Fluid Dynamics TU Berlin 

%%% Computation of eigenmodes of a
%%% floating platform installed under an offshore wind
%%% turbine

%%% Setup script

%%% For detailed explanation of parameters and model
%%% refer to paper of TU Denmark

%%% DOF 
%%% Vector q contains the 6 DOF of the system
%%% q(1): (x) fore-aft displacement
%%% q(2): (y) side-side displacement
%%% q(3): (z) negative-heave displacement
%%% q(4): (Theta_x) side-side roll
%%% q(5): (Theta_y) fore-aft roll
%%% q(6): (Theta_z) yaw

%%% System parameters 

%%% collected in parameter structure
%%% mn : total mass of rotor/nacelle [kg]
%%% m0 : total mass (0th order mass moment) [kg]
%%% m1 : 1st order mass moment [kg m]
%%% m2 : 2nd order mass moment (mass moment of inertia in roll) [kg m2]
%%% It : mass moment of inertia in torsion [kg m2]
%%% leb : distance from point A to B [m]
%%% lbg : distance from point B to G [m]
%%% lgw : distance from point G to W [m]
%%% lwi : distance from point W to I [m]
%%% lin : distance from point I to N [m]
%%% dw : water depth  [m]

params.g = 9.81;
params.rho_w = 1000;
params.mt = 1.5e6;
params.mn = 0;
params.m0 = 1.5e6;
params.m1 = 5.9605e-008;
params.height = 50;
params.width = 20;
params.depth = 3;
params.D  = sqrt(20^2+3^2);

params.lew = water_depth_monopile(params);
params.leb = buoyancy_centre(params);
params.leg = params.height/2;

params.It = mass_moment_inertia_in_yaw(params);
params.m2 = mass_moment_inertia_in_roll(params);

params.lbg = params.leg-params.leb;

%%% assumption due to missing information about model
%%% distance between cable suspension C and gravitational center G 
params.lcg = -0.3;

%%% Mooring cables
%%% Parameters
params.w  = 108.63;%from jeremiahs thesis 
params.lc = 835.5; %from jeremiahs thesis
params.c = 837.6; %from jeremiahs thesis
params.fc = 89000;
params.dw = 300;

%%% Stiffness Forces

%%% kcx : cable horizontal stiffness, x-direction [N/m]
%%% kcy : cable horizontal stiffness, y-direction [N/m]
%%% kcz : cable vertical stiffness, z-direction [N/m]
%%% kbz : vertical stiffness due to buoyancy [N/m]
%%% khsx : water level hydrostatic stiffness due to fore-aft-roll [N/rad]
%%% khsy : water level hydrostatic stiffness due to side-side-roll [N/rad]
%%% ktc : cable stiffness due to torsion [N/rad]

forces.kcx = 1.2606e005;
forces.kcy = 1.2606e005;
forces.kcz = 1.2606e005;
forces.kbz = vertical_stiffness_due_to_buoyancy(params);
forces.khsx = hydrostatic_stiffness_due_to_side_side_roll(params);
forces.khsy = hydrostatic_stiffness_due_to_fore_aft_roll(params);
forces.ktc = cable_stiffness_due_to_torsion(params);

%%% Damping Forces

%%% Drag parameters
params.xi = 0.2; 
f_zg = 0.0362; % third column from table in paper
params.omega_zg = 2*pi*f_zg; %cyclic/angular frequency
params.cm = 1; %initial guess

forces.chdz = damping_constant_due_to_heave_velocity(params);

end
