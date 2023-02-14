T = [wx.Data';wy.Data';wz.Data';vx.Data';vy.Data';vz.Data'];
theta = [w1.Data';w2.Data';w3.Data';w4.Data';w5.Data';w6.Data'];
n = size(tout, 1);

thetaDot = zeros(6, n-1);
for i = 1:6
     thetaDot(i, :) = diff(theta (i, :)) ./ diff(tout');
end

newT = zeros(6, n);
for i = 10:80:(n-1)
    t1=theta(1, i);
    t2=theta(2, i);
    t3=theta(3, i);
    t4=theta(4, i);
    t5=theta(5, i);
    t6=theta(6, i);

    a1=[50*cos(t1);50*sin(t1);380];
    a2=[420*cos(t1);420*sin(t1);0];
    a3=[25*cos(t1);25*sin(t1);0];
    a4=[0;0;440];
    a5=[0;0;0];
    a6=[0;0;98];

    q1=[cos(t1),0,sin(t1);sin(t1),0,-cos(t1);0,1,0];
    q2=[cos(t2),-sin(t2),0;sin(t2),cos(t2),0;0,0,1];
    q3=[cos(t3),0,sin(t3);sin(t3),0,-cos(t3);0,1,0];
    q4=[cos(t4),0,sin(t4);sin(t4),0,-cos(t4);0,1,0];
    q5=[cos(t5),0,sin(t5);sin(t5),0,-cos(t5);0,1,0];
    q6=[cos(t6),-sin(t6),0;sin(t6),cos(t6),0;0,0,1];

    r6=q1*q2*q3*q4*q5*a6;
    r5=r6+q1*q2*q3*q4*a5;
    r4=r5+q1*q2*q3*a4;
    r3=r4+q1*q2*a3;
    r2=r3+q1*a2;
    r1=r2+a1;

    e1=[0;0;1];
    e2=q1*[0;0;1];
    e3=q1*q2*[0;0;1];
    e4=q1*q2*q3*[0;0;1];
    e5=q1*q2*q3*q4*[0;0;1];
    e6=q1*q2*q3*q4*q5*[0;0;1];

    A = [e1,e2,e3,e4,e5,e6];
    B =[cross(e1,r1),cross(e2,r2),cross(e3,r3),cross(e4,r4),cross(e5,r5),cross(e6,r6)];
    J = [A;B];
    newT(:, i) = J * thetaDot(:, i);
end

count = (abs(T - newT) <= 10);
rate = sum(sum(count))/(size(count,1)*size(count,2))
