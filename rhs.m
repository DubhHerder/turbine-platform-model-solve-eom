function [ dqdt ] = rhs( t,q,K,D,params )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

F = force_vector(params,q);

dqdt = -K*q-D*q;

end

