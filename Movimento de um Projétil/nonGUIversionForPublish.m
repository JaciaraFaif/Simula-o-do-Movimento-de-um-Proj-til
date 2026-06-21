%THIS IS A NON GUI VERSION OF THE CODE FOR PUBLISHING PURPOSES ONLY%

v0=input('Please enter initial Velocity in metres/second: ');
angle = input('Please enter launch angle in degrees: ');
Initial_height=input('Please enter initial height of projectile: ');
g =9.81;

[x,y,v,t]=ProjectileTrajectory(v0,angle,Initial_height,g);
xlswrite('Projectile_Motion_Data',[t', x', y', v'], 'Sheet 1', 'A1:D150');

for i = 2:length(y)
    if y(i) <= 0
        fprintf('\nProjectile will hit the the ground at t = %.2f seconds.\n', t(i));
        break;
    end
end

[MaxHeight, Horizontal_Range]=HeightAndRange(v0, angle, Initial_height, g, x);
fprintf('\nMaximum height:');
if MaxHeight<20
    fprintf('Projectile reached low altitude of %.2fm\n\n', MaxHeight);
elseif MaxHeight<50
    fprintf('Projectile reached medium of %.2fm\n\n', MaxHeight);
else
    fprintf('Projectile reached high altitude of %.2fm \n\n', MaxHeight);
end

fprintf('Horizontal range:');
disp(Horizontal_Range);

syms T
y_sym = Initial_height + v0 * sind(angle) * T - 0.5 * g * T^2;
vy_sym = diff(y_sym);
t_eval = 1;
vy_at_1s = double(subs(vy_sym, T, t_eval));
fprintf('Vertical velocity at t = %.2f seconds (symbolic): %.2f m/s\n', t_eval, vy_at_1s);

figure;
plot(x, y, 'k', 'LineWidth', 1.5); hold on;
p = polyfit(x, y, 2);
x_axis_values = linspace(min(x), max(x), 150);
y_axis_values = polyval(p, x_axis_values);
plot(x_axis_values, y_axis_values, '--r', 'LineWidth', 1.2);
title('Projectile Trajectory');
xlabel('Horizontal Displacement (m)');
ylabel('Vertical Displacement (m)');
legend('Actual', 'Poly-Fitted');
grid on;
hold off;

figure;
plot(t, v, 'b', 'LineWidth', 1.5);
title('Velocity vs Time');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
grid on;

figure;
[T, X] = meshgrid(t, x);
Y = Initial_height + v0 * sind(angle) .* T - 0.5 * g .* T.^2;
mesh(X, T, Y);
title('3D Height vs Time vs Distance');
xlabel('Distance (m)');
ylabel('Time (s)');
zlabel('Height (m)');
grid on;




