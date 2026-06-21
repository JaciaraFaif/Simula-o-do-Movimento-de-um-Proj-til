function PlotGraph(app, x, y, v, t, Initial_height, v0, angle, g)

axes(app.graph1);
cla(app.graph1);
plot(app.graph1, x, y, 'k', 'LineWidth', 1.5);
hold(app.graph1, 'on');
p = polyfit(x, y, 2);
x_axis_values = linspace(min(x), max(x), 150);
y_axis_values = polyval(p, x_axis_values);
plot(app.graph1, x_axis_values, y_axis_values, '--r', 'LineWidth', 1.2);
title(app.graph1, 'Projectile Trajectory');
xlabel(app.graph1, 'Horizontal Displacment (m)');
ylabel(app.graph1, 'Vertical Displacemnt (m)');
legend(app.graph1, 'Actual', 'Poly-Fitted');
grid(app.graph1, 'on');
hold(app.graph1, 'off');

axes(app.graph2);
cla(app.graph2);
plot(app.graph2, t, v, 'b', 'LineWidth', 1.5);
title(app.graph2, 'Velocity vs Time');
xlabel(app.graph2, 'Time (s)');
ylabel(app.graph2, 'Velocity (m/s)');
grid(app.graph2, 'on');

axes(app.graph3);
cla(app.graph3);
[T, X] = meshgrid(t, x);
Y = Initial_height + v0 * sind(angle) .* T - 0.5 * g .* T.^2;
mesh(app.graph3, X, T, Y);
title(app.graph3, '3D height vs time vs distance');
xlabel(app.graph3, 'Distance (m)');
ylabel(app.graph3, 'Time (s)');
zlabel(app.graph3, 'Height (m)');
grid(app.graph3, 'on');

end