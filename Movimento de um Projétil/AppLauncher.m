clc;
clear;

disp("Welcome to the ENGI316 Projectile Simulator!");
response = input('Would you like to proceed? (yes/no): ', 's');

if strcmpi(response, 'yes')
    fprintf('Launching simulation...\n');
    run  ProjectileMotionSimulator.mlapp
else
    fprintf('Simulation has been canceled. \n');
end



















