function fox3d

findobj('Tag','fig_1');

set(0,'Units','pixels')
dim = get(0,'ScreenSize');
fig_1 = figure('Position',[0,35,dim(3)-200,dim(4)-110],'Name','Graphical Demo','NumberTitle','off','CloseRequestFcn',@del_app,'Tag','fig_1','menubar','none');

hold on;

light;
daspect([1 1 1]);
view(135,25);
xlabel('X','hittest','off'),ylabel('Y','hittest','off'),zlabel('Z','hittest','off');
title('Graphical Demo');
axis([-800 800 -800 800 -200 1200]);
grid on;
box on;

Initialize;

patch([-200 -200 200 200],[200 -200 -200 200],[0 0 0 0],'y','hittest','off');
patch([-200 -200 -200 -200],[200 200 -200 -200],[0 -200 -200 0],'y','hittest','off');
patch([-200 -200 200 200],[-200 -200 -200 -200],[0 -200 -200 0],'y','hittest','off');
patch([200 200 200 200],[200 200 -200 -200],[0 -200 -200 0],'y','hittest','off');
patch([-200 -200 200 200],[200 200 200 200],[0 -200 -200 0],'y','hittest','off');
patch([-1000 -1000 1000 1000],[1000 -1000 -1000 1000],[-200 -200 -200 -200],[0,0.5,0.1],'facealpha',0.7,'hittest','off');

C_p = uipanel(fig_1,'units','pixels','Position',[20 300 300 170],'Title','Control Panel','FontSize',11);

% Create the push buttons: pos is: [left bottom width height]

uicontrol(C_p,'String','Run Demo','callback',@demo_button_press,'Position',[30 60 110 30],'Interruptible','off','FontSize',10);

uicontrol(C_p,'String','Random Move','callback',@rnd_demo_button_press,'Position',[160 60 110 30],'Interruptible','off','FontSize',10);

uicontrol(C_p,'String','Clear','callback',@clr_trail_button_press,'Position',[30 10 110 30],'Interruptible','off','FontSize',10);

uicontrol(C_p,'String','Home','callback',@home_button_press,'Position',[160 10 110 30],'Interruptible','off','FontSize',10);
% Kinematics Panel

K_p = uipanel(fig_1,...
    'units','pixels',...
    'Position',[20 45 300 250],...
    'Title','Kinematics','FontSize',11);

uicontrol(K_p,'style','popupmenu',...
    'string',{'Jointspace','Workspace'},...
    'value',1,...
    'interruptible','off',...
    'callback',@popup_press,...
    'units','pixels',...
    'position',[70 190 160 30],...
    'FontSize',10);

jointspace_flag=true;
%
%     Angle    Range                Default Name
%     Theta 1: 320 (-160 to 160)    90       Waist Joint
%     Theta 2: 165 (-55 to 115)   -90       Shoulder Joint
%     Theta 3: 175 (-25 to 150)   -90       Elbow Joint
%     Theta 4: 300 (-150 to 150)     0       Wrist Roll
%     Theta 5: 200 (-110 to 110)     0       Wrist Bend
%     Theta 6: 720 (-360 to 360)     0       Wrist Swivel

LD = 105; % Left, used to set the GUI.
HT = 18;  % Height
BT = 156; % Bottom
%%  GUI buttons for Theta 1.  pos is: [left bottom width height]
t1_slider = uicontrol(K_p,'style','slider',...
    'Max',160,'Min',-160,'Value',0,...
    'SliderStep',[0.01 0.2],...
    'callback',@slider_button_press,...
    'Position',[LD+20 BT 120 HT],...
    'Interruptible','off');
%min
min1=uicontrol(K_p,'style','text',...
    'String','-160',...
    'Position',[LD-10 BT+1 25 HT-4]); % L, from bottom, W, H
%max
max1=uicontrol(K_p,'style','text',...
    'String','+160',...
    'Position',[LD+145 BT+1 30 HT-4]); % L, B, W, H
%label
info1=uicontrol(K_p,'style','text',...  % Nice program Doug. Need this
    'String','¦È1',...                % due to no TeX in uicontrols.
    'Position',[LD-100 BT 20 HT]); % L, B, W, H
t1_edit = uicontrol(K_p,'style','edit',...
    'String',0,...
    'callback',@edit_button_press,...
    'Position',[LD-75 BT 50 HT]); % L, B, W, H
%
%%  GUI buttons for Theta 2.
BT = 126;   % Bottom
t2_slider = uicontrol(K_p,'style','slider',...
    'Max',115,'Min',-55,'Value',0,...        % Mech. stop limits !
    'SliderStep',[0.01 0.2],...
    'callback',@slider_button_press,...
    'Position',[LD+20 BT 120 HT],...
    'Interruptible','off');
%min
min2=uicontrol(K_p,'style','text',...
    'String','-55',...
    'Position',[LD-10 BT+1 25 HT-4]); % L, from bottom, W, H
%max
max2=uicontrol(K_p,'style','text',...
    'String','+115',...
    'Position',[LD+145 BT+1 30 HT-4]); % L, B, W, H
%label
info2=uicontrol(K_p,'style','text',...
    'String','¦È2',...
    'Position',[LD-100 BT 20 HT]); % L, B, W, H
t2_edit = uicontrol(K_p,'style','edit',...
    'String',0,...
    'callback',@edit_button_press,...
    'Position',[LD-75 BT 50 HT]); % L, B, W, H
%
%%  GUI buttons for Theta 3.
BT = 96;   % Bottom
t3_slider = uicontrol(K_p,'style','slider',...
    'Max',150,'Min',-25,'Value',0,...
    'SliderStep',[0.01 0.2],...
    'callback',@slider_button_press,...
    'Position',[LD+20 BT 120 HT],...
    'Interruptible','off');
%min
min3=uicontrol(K_p,'style','text',...
    'String','-25',...
    'Position',[LD-10 BT+1 25 HT-4]); % L, from bottom, W, H
%max
max3=uicontrol(K_p,'style','text',...
    'String','+150',...
    'Position',[LD+145 BT+1 30 HT-4]); % L, B, W, H
%label
info3=uicontrol(K_p,'style','text',...
    'String','¦È3',...
    'Position',[LD-100 BT 20 HT]); % L, B, W, H
t3_edit = uicontrol(K_p,'style','edit',...
    'String',0,...
    'callback',@edit_button_press,...
    'Position',[LD-75 BT 50 HT]); % L, B, W, H
%
%%  GUI buttons for Theta 4.
BT = 66;   % Bottom
t4_slider = uicontrol(K_p,'style','slider',...
    'Max',150,'Min',-150,'Value',0,...
    'SliderStep',[0.01 0.2],...
    'callback',@slider_button_press,...
    'Position',[LD+20 BT 120 HT],...
    'Interruptible','off');
%min
min4=uicontrol(K_p,'style','text',...
    'String','-150',...
    'Position',[LD-10 BT+1 25 HT-4]); % L, from bottom, W, H
%max
max4=uicontrol(K_p,'style','text',...
    'String','+150',...
    'Position',[LD+145 BT+1 30 HT-4]); % L, B, W, H
%label
info4=uicontrol(K_p,'style','text',...
    'String','¦È4',...
    'Position',[LD-100 BT 20 HT]); % L, B, W, H
t4_edit = uicontrol(K_p,'style','edit',...
    'String',0,...
    'callback',@edit_button_press,...
    'Position',[LD-75 BT 50 HT]); % L, B, W, H
%
%%  GUI buttons for Theta 5.
BT = 36;   % Bottom
t5_slider = uicontrol(K_p,'style','slider',...
    'Max',110,'Min',-110,'Value',0,...
    'SliderStep',[0.01 0.2],...
    'callback',@slider_button_press,...
    'Position',[LD+20 BT 120 HT],...
    'Interruptible','off');
%min
min5=uicontrol(K_p,'style','text',...
    'String','-110',...
    'Position',[LD-10 BT+1 25 HT-4]); % L, from bottom, W, H
%max
max5=uicontrol(K_p,'style','text',...
    'String','+110',...
    'Position',[LD+145 BT+1 30 HT-4]); % L, B, W, H
%label
info5=uicontrol(K_p,'style','text',...
    'String','¦È5',...
    'Position',[LD-100 BT 20 HT]); % L, B, W, H
t5_edit = uicontrol(K_p,'style','edit',...
    'String',0,...
    'callback',@edit_button_press,...
    'Position',[LD-75 BT 50 HT]); % L, B, W, H
%
%%  GUI buttons for Theta 6.
BT = 6;   % Bottom
t6_slider = uicontrol(K_p,'style','slider',...
    'Max',360,'Min',-360,'Value',0,...
    'SliderStep',[0.01 0.2],...
    'callback',@slider_button_press,...
    'Position',[LD+20 BT 120 HT],...
    'Interruptible','off');
%min
min6=uicontrol(K_p,'style','text',...
    'String','-360',...
    'Position',[LD-10 BT+1 25 HT-4]); % L, from bottom, W, H
%max
max6=uicontrol(K_p,'style','text',...
    'String','+360',...
    'Position',[LD+145 BT+1 30 HT-4]); % L, B, W, H
%label
info6=uicontrol(K_p,'style','text',...
    'String','¦È6',...
    'Position',[LD-100 BT 20 HT]); % L, B, W, H
t6_edit = uicontrol(K_p,'style','edit',...
    'String',0,...
    'callback',@edit_button_press,...
    'Position',[LD-75 BT 50 HT]); % L, B, W, H
rotate3d on;

min_group=[min1,min2,min3,min4,min5,min6];
max_group=[max1,max2,max3,max4,max5,max6];
info_group=[info1,info2,info3,info4,info5,info6];
slider_group=[t1_slider,t2_slider,t3_slider,t4_slider,t5_slider,t6_slider];
edit_group=[t1_edit,t2_edit,t3_edit,t4_edit,t5_edit,t6_edit];

setappdata(fig_1,'min_group',min_group);
setappdata(fig_1,'max_group',max_group);
setappdata(fig_1,'info_group',info_group);
setappdata(fig_1,'slider_group',slider_group);
setappdata(fig_1,'edit_group',edit_group);
setappdata(fig_1,'jointspace_flag',jointspace_flag);
setappdata(fig_1,'resolution',0.5);
end
% initialization of main function
function Initialize

[linkdata]=load('FoxbotLinksData.mat','s1','s2', 's3','s4','s5','s6','s7','workspace');
setappdata(gcf,'linkdata',linkdata);

% Forward Kinematics
setappdata(gcf,'ThetaOld',[0,-90,0,0,0,0]);%initial pose

T_01 = tmat(-pi/2, 75, 360, 0);
T_12 = tmat(0, 270, 0, -pi/2);
T_23 = tmat(-pi/2, 110, 0, 0);
T_34 = tmat(pi/2, 0, 306, 0);
T_45 = tmat(-pi/2, 0, 0, 0);
T_56 = tmat(0, 0, 0, 0);

% Each link fram to base frame transformation
T_02 = T_01*T_12;
T_03 = T_02*T_23;
T_04 = T_03*T_34;
T_05 = T_04*T_45;
T_06 = T_05*T_56;

% Actual vertex data of robot links
Link1 = linkdata.s1.V;
Link2 = (T_01*linkdata.s2.V')';
Link3 = (T_02*linkdata.s3.V')';
Link4 = (T_03*linkdata.s4.V')';
Link5 = (T_04*linkdata.s5.V')';
Link6 = (T_05*linkdata.s6.V')';
Link7 = (T_06*linkdata.s7.V')';
workspace=([eye(3) [75 0 360]';[0 0 0 1]]*(linkdata.workspace.V)')';
%Area_V = [Link2;Link3;Link4;Link5;Link6;Link7]*[1 0 0 0;0 1 0 0;0 0 0 0;0 0 0 1];
%Area_F = [linkdata.s2.F2;linkdata.s3.F3;linkdata.s4.F4;linkdata.s5.F5;linkdata.s6.F6;linkdata.s7.F7];

line([0 200],[0 0],[0 0],'color','r','linewidth',3);
line([0 0],[0 200],[0 0],'color','g','linewidth',3);
line([0 0],[0 0],[0 200],'color','b','linewidth',3);

% points are no fun to watch, make it look 3d.
patch('faces',linkdata.workspace.F,'vertices',workspace(:,1:3),...
    'facec',[0 0 0.5],'edgecolor','none','facealpha',0.07,'hittest','off');
L1 = patch('faces', linkdata.s1.F, 'vertices' ,Link1(:,1:3),...
    'facec', [0.717,0.116,0.123],'EdgeColor','none','facealpha',0.7,'hittest','off');
L2 = patch('faces', linkdata.s2.F, 'vertices' ,Link2(:,1:3),...
    'facec', [0.216,1,.583],'EdgeColor','none','facealpha',1,'hittest','off');
L3 = patch('faces', linkdata.s3.F, 'vertices' ,Link3(:,1:3),...
    'facec', [0.306,0.733,1],'EdgeColor','none','facealpha',1,'hittest','off');
L4 = patch('faces', linkdata.s4.F, 'vertices' ,Link4(:,1:3),...
    'facec', [1,0.542,0.493],'EdgeColor','none','facealpha',1,'hittest','off');
L5 = patch('faces', linkdata.s5.F, 'vertices' ,Link5(:,1:3),...
    'facec', [0.216,1,.583],'EdgeColor','none','facealpha',0.5,'hittest','off');
L6 = patch('faces', linkdata.s6.F, 'vertices' ,Link6(:,1:3),...
    'facec', [1,1,0.255],'EdgeColor','none','facealpha',0.5,'hittest','off');
L7 = patch('faces', linkdata.s7.F, 'vertices' ,Link7(:,1:3),...
    'facec', [0.306,0.733,1],'EdgeColor','none','facealpha',0.5,'hittest','off');
Tr = plot3(0,0,0,'b.'); % holder for trail paths

coord(1)=line([0 1],[0 0],[0 0],'color','r','linewidth',2);
coord(2)=line([0 0],[0 1],[0 0],'color','g','linewidth',2);
coord(3)=line([0 0],[0 0],[0 1],'color','b','linewidth',2);
xyz=T_06*[200*eye(3) zeros(3,1);ones(1,4)];
set(coord,{'xdata','ydata','zdata'},...
    {[xyz(1,4) xyz(1,1)],[xyz(2,4) xyz(2,1)],[xyz(3,4) xyz(3,1)];...
    [xyz(1,4) xyz(1,2)],[xyz(2,4) xyz(2,2)],[xyz(3,4) xyz(3,2)];...
    [xyz(1,4) xyz(1,3)],[xyz(2,4) xyz(2,3)],[xyz(3,4) xyz(3,3)]});

%A = patch('faces', Area_F, 'vertices' ,Area_V(:,1:3),...
%    'facec', [0.3,0.3,0.3],'EdgeColor','none');

%
setappdata(gcf,'patch_h',[L1,L2,L3,L4,L5,L6,L7,Tr,coord]);

fox.a=[0.075 0.27 0.11 0 0 0];
fox.alpha=[-pi/2 0 -pi/2 pi/2 -pi/2 0];
fox.d=[0.36 0 0 0.306 0 0];
fox.I=cat(3,diag([0, 0.35, 0]),...
    diag([0.13, 0.524, 0.539]),...
    diag([0.066, 0.086, 0.0625]),...
    diag([1.8e-2, 0.8e-2, 1.8e-2]),...
    diag([0.3e-3, 0.4e-3, 0.3e-3]),...
    diag([0.15e-3, 0.15e-3, 0.04e-3]));
fox.r=[0, 0, 0;-0.151, 0.006, -0.102;-0.0203, -0.0141, 0.010;...
   0, -0.09, 0;0, 0, 0.02;0, 0, 0.082];
fox.m=[0 10.4 6.8 4.6 0.34 0.18];
fox.Jm=[200e-6 200e-6 200e-6 30e-6 30e-6 30e-6];
fox.G=[120 120 120 80 80 50];
fox.B=[1.48e-3 .817e-3 1.38e-3 71.2e-6 82.6e-6 36.7e-6];
fox.Tc=[0.41 -0.41;0.11 -0.11;0.17, -0.17;0.06, -0.06;...
    0.05, -0.05;0.03, -0.03];
fox.qlim=[-160 160;-145 25;-115 60;-150 150;-110 110;-360 360]*pi/180;
fox.taulim=[240 240 240 180 80 80];
setappdata(gcf,'fox',fox);
end
% fig close request callback
function del_app(varargin)
rmappdata(gcf,'linkdata');
rmappdata(gcf,'ThetaOld');
rmappdata(gcf,'patch_h');
rmappdata(gcf,'min_group');
rmappdata(gcf,'max_group');
rmappdata(gcf,'info_group');
rmappdata(gcf,'slider_group');
rmappdata(gcf,'edit_group');
rmappdata(gcf,'jointspace_flag');
rmappdata(gcf,'resolution');
rmappdata(gcf,'fox');

delete(gcf);
end
%%                                            Uicontrol callbacks
% Sliders' callback
function slider_button_press(h,~)
slider_group=getappdata(gcf,'slider_group');
axis_num=find(slider_group==h);
T_Old = getappdata(gcf,'ThetaOld');
if getappdata(gcf,'jointspace_flag')
    T_Old(axis_num) = get(h,'Value')-(axis_num==2||axis_num==3)*90;
    foxani(T_Old,getappdata(gcf,'resolution'),false);
else
    T=foxfkine(T_Old);
    if axis_num<4
        p_old=T(axis_num,4);
        p_new=get(h,'Value');
        p=linspace(p_old,p_new,ceil(abs(p_new-p_old))+1);
        T=repmat(T,1,1,length(p));
        T(axis_num,4,:)=p;
    else
        o_old=0;
        o_new=get(h,'Value')/180*pi;
        o=linspace(o_old,o_new,ceil(abs(o_new-o_old)/getappdata(gcf,'resolution'))+1);
        R0=T(1:3,1:3);
        T=repmat(T,1,1,length(o));
        for i=1:length(o)
            R_axis=(axis_num==4)*rotx(o(i))+(axis_num==5)*roty(o(i))+(axis_num==6)*rotz(o(i));
            T(1:3,1:3,i)=R_axis*R0;
        end
    end
    q=foxikine(T);
    figure(h.Parent.Parent);
    for i=1:size(q,1)
        foxani(q(i,:),getappdata( gcf,'resolution'),true);
    end
end
end
% Edits' callback
function edit_button_press(h,~)
edit_group=getappdata(gcf,'edit_group');
axis_num=find(edit_group==h);
T_Old = getappdata(gcf,'ThetaOld');


if getappdata(gcf,'jointspace_flag')
    user_entry = check_edit(h,axis_num);
    T_Old(axis_num)=user_entry-(axis_num==2||axis_num==3)*90;
    foxani(T_Old,getappdata(gcf,'resolution'),false);
else
    T=foxfkine(T_Old);
    if axis_num<4
        user_entry = check_edit(h,axis_num);
        p_old=T(axis_num,4);
        p_new=user_entry;
        p=linspace(p_old,p_new,ceil(abs(p_new-p_old))+1);
        T=repmat(T,1,1,length(p));
        T(axis_num,4,:)=p;
    end
    q=foxikine(T);
    figure(h.Parent.Parent);
    for i=1:size(q,1)
        foxani(q(i,:),getappdata( gcf,'resolution'),true);
    end
end



    function user_entry = check_edit(h,axis_num)
        
        slider_group=getappdata(gcf,'slider_group');
        user_entry = str2double(get(h,'String'));
        min_v=get(slider_group(axis_num),'min');
        max_v=get(slider_group(axis_num),'max');
        if isnan(user_entry)
            warning('input should be numeric');
            user_entry=round(get(slider_group(axis_num),'Value'));
            set(h,'String',user_entry);
        elseif user_entry <= min_v
            warning(['input should be no less than ' num2str(min_v)]);
            user_entry = min_v;
            set(h,'String',user_entry);
        elseif user_entry >= max_v
            warning(['input should be no more than ' num2str(max_v)]);
            user_entry = max_v;
            set(h,'String',user_entry);
        end
    end

end
% popup's callback
function popup_press(h,~)
min_group=getappdata(gcf,'min_group');
max_group=getappdata(gcf,'max_group');
info_group=getappdata(gcf,'info_group');
slider_group=getappdata(gcf,'slider_group');
edit_group=getappdata(gcf,'edit_group');
theta_old=getappdata(gcf,'ThetaOld');

jointspace_flag=get(h,'value')==1;
setappdata(gcf,'jointspace_flag',jointspace_flag);
if jointspace_flag
    set(min_group,{'string'},{'-160';'-55';'-25';'-150';'-110';'-360'});
    set(max_group,{'string'},{'160';'115';'150';'150';'110';'360'});
    set(info_group,{'string'},{'¦È1';'¦È2';'¦È3';'¦È4';'¦È5';'¦È6'});
    set(slider_group,{'min','max','value'},...
        {-160,160,theta_old(1);...
        -55,115,theta_old(2)+90;...
        -25,150,theta_old(3)+90;...
        -150,150,theta_old(4);...
        -110,110,theta_old(5);...
        -360,360,theta_old(6)});
    set(edit_group,{'string'},...
        {theta_old(1);theta_old(2)+90;theta_old(3)+90;...
        theta_old(4);theta_old(5);theta_old(6)});
    set(edit_group(4:6),'style','edit');
else
    T=foxfkine(theta_old);
    
    set(min_group,{'string'},{'-629';'-670';'-79';'-180';'-180';'-180'});
    set(max_group,{'string'},{'670';'670';'955';'180';'180';'180'});
    set(info_group,{'string'},{'x';'y';'z';'rx';'ry';'rz'});
    set(slider_group,{'min','max','value'},...
        {-629,670,T(1,4);...
        -670,670,T(2,4);...
        -79,955,T(3,4);...
        -180,180,0;...
        -180,180,0;...
        -180,180,0});
    set(edit_group,{'string'},...
        {T(1,4);T(2,4);T(3,4);...
        T(1,3);T(2,3);T(3,3)});
    set(edit_group(4:6),'style','text');
end


end
% ikine demo button's callback
function demo_button_press(~,~)

t = 0:.01:1;
o=zeros(6,length(t));
o(1,:) = 150*(1-t).*cos(10*pi*t)+350;
o(2,:) = 150*(1-t).* sin(10*pi*t);
o(3,:) = 550+150*t;
o(4,:) = 0;
o(5,:) = 0;
o(6,:) = -1;
T=o2h(o);
q=foxikine(T);
foxani(q(1,:),getappdata( gcf,'resolution'),false);
for i=1:size(q,1)
    foxani(q(i,:),getappdata( gcf,'resolution'),true);
end

foxani([0,-90,0,0,0,0],getappdata(gcf,'resolution'),false);
end
% go home button's callback
function home_button_press(~,~)
foxani([0,-90,0,0,0,0],getappdata(gcf,'resolution'),false); % show it animate home
end
% clear trail button's callback
function clr_trail_button_press(~,~)
%disp('pushed clear trail bottom');
handles = getappdata(gcf,'patch_h');           %
set( handles(8),'xdata',0,'ydata',0,'zdata',0);
% assignin('base','J',jacobe0(getappdata(gcf,'ThetaOld')));
end
% random demo button's callback
function rnd_demo_button_press(~, ~)
%disp('pushed random demo bottom');
% a = 10; b = 50; x = a + (b-a) * rand(5)
%     Angle    Range                Default Name
%     Theta 1: 320 (-160 to 160)    90       Waist Joint
%     Theta 2: 165 (-55 to 115)   -90       Shoulder Joint
%     Theta 3: 175 (-25 to 150)   -90       Elbow Joint
%     Theta 4: 300 (-150 to 150)     0       Wrist Roll
%     Theta 5: 200 (-110 to 110)     0       Wrist Bend
%     Theta 6: 720 (-360 to 360)     0       Wrist Swivel

theta1 = -160 + 320*rand(1); 
theta2 = -55 + 170*rand(1)-90; 
theta3 = -25 + 175*rand(1)-90;
theta4 = -150 + 300*rand(1);
theta5 = -110 + 220*rand(1);
theta6 = -360 + 720*rand(1);
foxani([theta1,theta2,theta3,theta4,theta5,theta6],getappdata(gcf,'resolution'),true)
end
%%                                                      Animation
% robot's animation
function foxani(theta,resolution,ltrail)

ThetaOld = getappdata(gcf,'ThetaOld');
n=ceil(max(abs(ThetaOld-theta)./[320 170 175 300 220 720]*170)/resolution)+1;
t1 = linspace(ThetaOld(1),theta(1),n);
t2 = linspace(ThetaOld(2),theta(2),n);
t3 = linspace(ThetaOld(3),theta(3),n);
t4 = linspace(ThetaOld(4),theta(4),n);
t5 = linspace(ThetaOld(5),theta(5),n);
t6 = linspace(ThetaOld(6),theta(6),n);

jointspace_flag=getappdata(gcf,'jointspace_flag');
linkdata=getappdata(gcf,'linkdata');
handles = getappdata(gcf,'patch_h');
slider_group=getappdata(gcf,'slider_group');
edit_group=getappdata(gcf,'edit_group');

t_01 = tmat(-pi/2, 75, 360, t1*pi/180);
t_12 = tmat(0, 270, 0, t2*pi/180);
t_23 = tmat(-pi/2, 110, 0, t3*pi/180);
t_34 = tmat(pi/2, 0, 306, t4*pi/180);
t_45 = tmat(-pi/2, 0, 0, t5*pi/180);
t_56 = tmat(0, 0, 0, t6*pi/180);

for i = 2:n
    % Forward Kinematics
    T_01=t_01(:,:,i);
    T_02 = T_01*t_12(:,:,i);
    T_03 = T_02*t_23(:,:,i);
    T_04 = T_03*t_34(:,:,i);
    T_05 = T_04*t_45(:,:,i);
    T_06 = T_05*t_56(:,:,i);
    
    Link2 = (T_01*linkdata.s2.V')';
    Link3 = (T_02*linkdata.s3.V')';
    Link4 = (T_03*linkdata.s4.V')';
    Link5 = (T_04*linkdata.s5.V')';
    Link6 = (T_05*linkdata.s6.V')';
    Link7 = (T_06*linkdata.s7.V')';
    xyz=T_06*[200*eye(3) zeros(3,1);ones(1,4)];

    set(handles(2:7),{'vertices'},{Link2(:,1:3);...
        Link3(:,1:3);...
        Link4(:,1:3);...
        Link5(:,1:3);...
        Link6(:,1:3);...
        Link7(:,1:3)});
    set(handles(9:11),{'xdata','ydata','zdata'},...
        {[xyz(1,4) xyz(1,1)],[xyz(2,4) xyz(2,1)],[xyz(3,4) xyz(3,1)];...
        [xyz(1,4) xyz(1,2)],[xyz(2,4) xyz(2,2)],[xyz(3,4) xyz(3,2)];...
        [xyz(1,4) xyz(1,3)],[xyz(2,4) xyz(2,3)],[xyz(3,4) xyz(3,3)]});

    if ltrail
        D=T_06*[1 0 0 0;0 1 0 0;0 0 1 110;0 0 0 1];
        handles(8).XData=[handles(8).XData,D(1,4)];
        handles(8).YData=[handles(8).YData D(2,4)];
        handles(8).ZData=[handles(8).ZData D(3,4)];
    end
    
    drawnow limitrate;
    if jointspace_flag
        set(edit_group,{'String'},{t1(i);t2(i)+90;t3(i)+90;t4(i);t5(i);t6(i)}); % Update slider and text.
        set(slider_group,{'Value'},{t1(i);t2(i)+90;t3(i)+90;t4(i);t5(i);t6(i)});
    else
        set(slider_group,{'value'},{T_06(1,4);T_06(2,4);T_06(3,4);0;0;0});
        set(edit_group,{'string'},{T_06(1,4);T_06(2,4);T_06(3,4);T_06(1,3);T_06(2,3);T_06(3,3)});
    end
end

setappdata(gcf,'ThetaOld',theta);
end
%%                                                     Kinematics
% inverse kinematics
function q = foxikine(T)
limits=[-160 160;-145 25;-115 60;-150 150;-110 110;-360 360]*pi/180;
a2=270;a3=110;d4=306;
q=zeros(size(T,3),6);
for i=1:size(T,3)
    T_i=T(:,:,i);
    q(i,1) = angle(T_i(1,4)+T_i(2,4)*1i);% shoulder left
    if q(i,1)<limits(1,1)||q(i,1)>limits(1,2)
        q(i,1) = angle(-T_i(1,4)-T_i(2,4)*1i);%shoulder right
        T_01 = tmat(-pi/2, 75, 360, q(i,1));
        T_16=T_01\T_i;
        pt=T_16(1,4)+T_16(2,4)*1i;
        l3=a3+d4*1i;
        if RangeCheck(pt)
            alpha=145/180*pi+angle(pt);
            beta=asin(a2*sin(alpha)/abs(l3));
            r_min=a2*sin(alpha+beta)/sin(beta);
            if abs(pt) > r_min
                %elbow up
                q(i,2)=angle(pt)-acos((pt*pt'+a2*a2-l3*l3')/2/abs(pt)/a2);
                q(i,3)=pi-acos((a2*a2+l3*l3'-pt*pt')/2/a2/abs(l3))-angle(l3);
            else
                %elbow down
                q(i,2)=angle(pt)+acos((pt*pt'+a2*a2-l3*l3')/2/abs(pt)/a2);
                q(i,3)=acos((a2*a2+l3*l3'-pt*pt')/2/a2/abs(l3))-pi-angle(l3);
            end
        else
            h=errordlg('joint 2 and 3 cannot reach the current configuration!','path planning error');
            q(i:end,:)=[];
            q=q*180/pi;
            pause(1),if isvalid(h),delete(h);end
            return;
        end
    else
        T_01 = tmat(-pi/2, 75, 360, q(i,1));
        T_16=T_01\T_i;
        pt=T_16(1,4)+T_16(2,4)*1i;
        l3=a3+d4*1i;
        if RangeCheck(pt)
            %elbow up
            q(i,2)=angle(pt)-acos((pt*pt'+a2*a2-l3*l3')/2/abs(pt)/a2);
            q(i,3)=pi-acos((a2*a2+l3*l3'-pt*pt')/2/a2/abs(l3))-angle(l3);
        else
            h=errordlg('joint 2 and 3 cannot reach the current configuration!','path planning error');
            q(i:end,:)=[];
            q=q*180/pi;
            pause(1),if isvalid(h),delete(h);end
            return
        end
    end
    
    T_12 = tmat(0, 270, 0, q(i,2));
    T_23 = tmat(-pi/2, 110, 0, q(i,3));
    T_13 = T_12*T_23;
    
    Td4 = [1 0 0 0;0 1 0 0;0 0 1 306;0 0 0 1];
    
    T_46 = Td4\(T_13\T_16);
    
    q_p = rotm2zyz(T_46(1:3,1:3),true);
    q_n = rotm2zyz(T_46(1:3,1:3),false);
    if abs(q_p(1)) > abs(q_n(1))
        q(i,4:6) = q_n;
    else
        q(i,4:6) = q_p;
    end
%     if abs(q(i,5)) < 10/180*pi
%         q(i,5) = 10/180*pi*sign(q(i,5));
%     end
    if any(q(i,4:6)<limits(4:6,1)'|q(i,4:6)>limits(4:6,2)')
            h=errordlg('joint 4~6 can not reach the current configuration!','path planning error');
            q(i:end,:)=[];
            q=q*180/pi;
            pause(1),if isvalid(h),delete(h);end
            return;
    end
end
q=q*180/pi;

    function q=rotm2zyz(R,positive)
        q=zeros(1,3);
        if (1-R(3,3))<eps('single')
            q(1)=0;
            q(2)=0;
            q(3)=angle(R(1,1)+R(2,1)*1i);
        elseif positive
            q(2)=-acos(R(3,3));
            q(1)=angle(R(1,3)+R(2,3)*1i);
            q(3)=angle(-R(3,1)+R(3,2)*1i);
        else
            q(2)=acos(R(3,3));
            q(1)=angle(-R(1,3)-R(2,3)*1i);
            q(3)=angle(R(3,1)-R(3,2)*1i);
        end
    end

    function [l,r_min,r_max]=RangeCheck(pt)
        %         limits=[-160 160;-145 25;-115 60;-150 150;-110 110;-360 360]*pi/180;
        %         a2=270;a3=110;d4=306;
        %         l3=a3+d4*1i;
        theta=angle(pt);
        r=abs(pt);
        if theta >= angle(-541-100i) && theta <limits(2,1)
            alpha=-145/180*pi-theta;
            beta=asin(a2*sin(alpha)/abs(l3));
            r_max=a2*sin(alpha+beta)/sin(beta);
            r_min=551;
            l=r>=r_min && r<=r_max;
        elseif theta>=limits(2,1) && theta<angle(-278-475i)
            r_min=551;r_max=595;
            l=r>=r_min && r<=r_max;
        elseif theta>=angle(-278-475i) && theta<angle(93.25-237.78i)
            alpha=145/180*pi+theta;
            beta=asin(a2*sin(alpha)/abs(l3));
            r_min=a2*sin(alpha+beta)/sin(beta);
            r_max=595;
            l=r>=r_min && r<=r_max;
        elseif theta>=angle(93.25-237.78i) && theta<limits(2,2)
            r_min=256;r_max=595;
            l=r>=r_min && r<=r_max;
        elseif theta>=limits(2,2) && theta<=angle(-50+250i)
            alpha=theta-25/180*pi;
            beta=asin(a2*sin(alpha)/abs(l3));
            r_max=a2*sin(alpha+beta)/sin(beta);
            r_min=256;
            l=r>=r_min && r<=r_max;
        else
            l=false;r_min=NaN;r_max=NaN;
        end
    end


end
% forward kinematics
function T_06=foxfkine(q)
T_06 = tmat(-pi/2, 75, 360, q(1)*pi/180)*tmat(0, 270, 0, q(2)*pi/180)*tmat(-pi/2, 110, 0, q(3)*pi/180)*...
    tmat(pi/2, 0, 306, q(4)*pi/180)*tmat(-pi/2, 0, 0, q(5)*pi/180)*tmat(0, 0, 0, q(6)*pi/180);
end
% tool orientation to homogeneous transform
function T=o2h(o)
% each column of o is a configuration
d6=110;n=[1 0 0];
o(4:6,:)=o(4:6,:)./repmat(sqrt(sum(o(4:6,:).*o(4:6,:))),3,1);
T=zeros(4,4,size(o,2));
T(1:3,4,:)=o(1:3,:)-d6*o(4:6,:);
T(4,4,:)=ones(1,size(o,2));
for i=1:size(o,2)
    if abs(n*o(4:6,i))==1
        T(1:3,1,i)=[1 0 0]'*sign(o(6,i));
        T(1:3,2,i)=[0 1 0]'*sign(o(6,i));
        T(1:3,3,i)=o(4:6,i);
    else
        x=n'-n*o(4:6,i)*n';
        x=x/(x'*x);
        T(1:3,1,i)=x;
        T(1:3,2,i)=axang2rotm([o(4:6,i)' pi/2])*x;
        T(1:3,3,i)=o(4:6,i);
    end
    
end
end
% homogeneous transform matrix calculation
function T = tmat(alpha, a, d, theta)
n=length(theta);
% alpha = alpha*pi/180;    %Note: alpha is in radians.
% theta = theta*pi/180;    %Note: theta is in radians.
theta=reshape(theta,1,1,n);
alpha =repmat(alpha,1,1,n);
a=repmat(a,1,1,n);
d=repmat(d,1,1,n);
c = cos(theta);
s = sin(theta);
ca = cos(alpha);
sa = sin(alpha);
T = [c -s.*ca s.*sa a.*c; s c.*ca -c.*sa a.*s; zeros(1,1,n) sa ca d; ...
    zeros(1,1,n) zeros(1,1,n) zeros(1,1,n) ones(1,1,n)];
end
% convert axis-angle vector to rotation matrix
function R = axang2rotm(v)
x=v(1);y=v(2);z=v(3);theta=v(4);
c=cos(theta);s=sin(theta);t=1-c;
R =  [t*x*x + c	  t*x*y - z*s	   t*x*z + y*s
      t*x*y + z*s	  t*y*y + c	       t*y*z - x*s
      t*x*z - y*s	  t*y*z + x*s	   t*z*z + c];
end
function R = rotx(t)  
ct = cos(t);
st = sin(t);
R = [1   0    0
     0   ct  -st
     0   st   ct];
end
function R = roty(t)  
ct = cos(t);
st = sin(t);
R = [ct   0  -st
     0    1   0
     st   0   ct];
end
function R = rotz(t)  
ct = cos(t);
st = sin(t);
R = [ct  -st  0
     st  ct   0
     0   0    1];
end

