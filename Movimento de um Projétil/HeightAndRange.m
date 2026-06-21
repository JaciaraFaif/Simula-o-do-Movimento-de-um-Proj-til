function [MaxHeight, Horizontal_Range] = HeightAndRange(v0, angle, Initial_height, g, x)

MaxHeight = Initial_height + (v0^2 * sind(angle)^2) / (2 * g);

if Initial_height == 0
    Horizontal_Range = (v0^2 * sind(2 * angle)) / g;
else
    Horizontal_Range = x(end);
end

end
