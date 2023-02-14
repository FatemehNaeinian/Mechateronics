t1 = linspace(-90,270,20)*pi/180;
t2 = linspace(-30,130,20)*pi/180;
t3 = linspace(-80,260,20)*pi/180;
t4 = linspace(-90,270,20)*pi/180;
t5 = linspace(-90,90,20)*pi/180;
t6 = linspace(-90,270,20)*pi/180;

[T1,T2,T3,T4,T5,T6]=ndgrid(t1,t2,t3,t4,t5,t6);
xM = round(50*cos(T1)+420*cos(T1).*cos(T2)+25*cos(T1).*cos(T2+T3)+440*cos(T1).*sin(T2+T3)+98*cos(T1).*cos(T2+T3).*cos(T4).*sin(T5)+98*sin(T1).*sin(T4).*cos(T5)-98*cos(T1).*cos(T2+T3).*cos(T5));
yM = round(50*sin(T1)+420*sin(T1).*cos(T2)+25*sin(T1).*cos(T2+T3)+440*sin(T1).*sin(T2+T3)+98*sin(T1).*cos(T2+T3).*cos(T4).*sin(T5)+98*cos(T1).*sin(T4).*cos(T5)-98*sin(T1).*cos(T2+T3).*cos(T5));
zM = round(380+420*sin(T2)+25*sin(T2+T3)-440*cos(T2+T3)+98*sin(T2+T3).*cos(T4).*sin(T5)+98*cos(T2+T3).*cos(T5));
plot3(xM(:),yM(:),zM(:),'.')
