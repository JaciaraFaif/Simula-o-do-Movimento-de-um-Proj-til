function[x,y,v,t]=ProjectileTrajectory(v0,angle,Initial_height,g)

if Initial_height==0
    TOF=(2*v0*sind(angle))/g; 

else
    TOF=(v0*sind(angle)+sqrt((v0*sind(angle))^2+2*g*Initial_height))/g;  

end

t=linspace(0,TOF,150); 
x = v0.*t.*cosd(angle); 
y = Initial_height+v0.*t.*sind(angle)-0.5.*g.*t.^2; 

vx=v0*cosd(angle);
vy=v0*sind(angle)-g.*t;   
v=sqrt(vx.^2+vy.^2);
end

