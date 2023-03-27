% Three (two simulation and one analytic) transition fuctions in one plot
clear all; clc; close all;
% Caps=[12 20 45 48 55 100 130 145 200 325 350 375 400 425 450 500 800 850 1000];
% Caps = [40 60 80 100 150 200 350 450 650];
% FakeCaps = [20 40 65 100 120 150 250 400 800];
% CapsDist=[38 33 33 31 17 13 10 7 4];
% Caps=[40 80 120 300 800];
CapsDist=[71 37 34 24 10];
% Caps=[80 200 500 800 1500];
% CapsDist=[68 43 33 31 17];
Caps=[20 80 200 500 800];
% CapDist=[];
% Without load shedding

B=[];
DataName='States2012-10OPFother500Alpha0.25Beta0V4.mat';
load(DataName);
% B=cat(1,B,States);
% clear States
% DataName='States2012-10OPFother700Alpha0.36Beta0V2.mat';
% load(DataName);
% B=cat(1,B,States);
% clear States
% DataName='States2012-10OPFother700Alpha0.36Beta0V3.mat';
% load(DataName);
% B=cat(1,B,States);
% clear States
% States=B;

%     A=States;
%     Concat=[B; A];
%     B=Concat;
%     clear States;
% end
% States=B;
NumOfStablesCap=zeros(1,length(Caps));
TotalCap=zeros(1,length(Caps));
MaxNumFailures=max(States(:,1));

x2=1:MaxNumFailures;
NumOfStablesFail=zeros(1,MaxNumFailures);
TotalMax=zeros(1,MaxNumFailures);
NumStables=0;
for i=1:length(States(:,1))
    if(States(i,8)==-1)
       NumStables=NumStables+1;
    end
end
for i=2:MaxNumFailures
    for j=1:length(States(:,1))
        if(States(j,1)==i && States(j,8)==-1)
            NumOfStablesFail(i)=NumOfStablesFail(i)+1;
            
        end
        if(States(j,1)==i)
            TotalMax(i)=TotalMax(i)+1;
        end
    end
end
NumOfStablesFail=NumOfStablesFail./TotalMax;
y2=NumOfStablesFail;
%%%%%%%%%%%%%%%%%%% Maximum stability prob. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TotalMaxCapStable=0;
TotalMaxCap=0;
MaxStabilityProb=zeros(1,length(Caps));
for i=1:length(Caps)
    for j=1:length(States(:,1))
        if(States(j,10)==Caps(i))
            TotalMaxCap=TotalMaxCap+1;
            if(States(j,8)==-1)
                TotalMaxCapStable=TotalMaxCapStable+1;
            end
        end
    end
    MaxStabilityProb(i)=TotalMaxCapStable/TotalMaxCap;
end
z2=MaxStabilityProb;




B=[];
DataName='States2012-10OPFother700Alpha0.25Beta0V1.mat';
load(DataName);
% B=cat(1,B,States);
% clear States
% DataName='States2012-10OPFother700Alpha0.36Beta0.1V2.mat';
% load(DataName);
% B=cat(1,B,States);
% clear States
% DataName='States2012-10OPFother700Alpha0.36Beta0.1V3.mat';
% load(DataName);
% B=cat(1,B,States);
% clear States
% States=B;

NumOfStablesCap=zeros(1,length(Caps));
TotalCap=zeros(1,length(Caps));
MaxNumFailures=max(States(:,1));

x3=1:MaxNumFailures;
NumOfStablesFail=zeros(1,MaxNumFailures);
TotalMax=zeros(1,MaxNumFailures);
NumStables=0;
for i=1:length(States(:,1))
    if(States(i,8)==-1)
       NumStables=NumStables+1;
    end
end
for i=2:MaxNumFailures
    for j=1:length(States(:,1))
        if(States(j,1)==i && States(j,8)==-1)
            NumOfStablesFail(i)=NumOfStablesFail(i)+1;
            
        end
        if(States(j,1)==i)
            TotalMax(i)=TotalMax(i)+1;
        end
    end
end
NumOfStablesFail=NumOfStablesFail./TotalMax;
y3=NumOfStablesFail;

TotalMaxCapStable=0;
TotalMaxCap=0;
MaxStabilityProb=zeros(1,length(Caps));
for i=1:length(Caps)
    for j=1:length(States(:,1))
        if(States(j,10)==Caps(i))
            TotalMaxCap=TotalMaxCap+1;
            if(States(j,8)==-1)
                TotalMaxCapStable=TotalMaxCapStable+1;
            end
        end
    end
    MaxStabilityProb(i)=TotalMaxCapStable/TotalMaxCap;
end
z3=MaxStabilityProb;
% 

B=[];
DataName='States2012-10OPFother900Alpha0.25Beta0V3.mat';
load(DataName);
% B=cat(1,B,States);
% clear States
% DataName='States2012-10OPFother700Alpha0.36Beta0.2V2.mat';
% load(DataName);
% B=cat(1,B,States);
% clear States
% DataName='States2012-10OPFother700Alpha0.36Beta0.2V3.mat';
% load(DataName);
% B=cat(1,B,States);
% clear States
% States=B;

NumOfStablesCap=zeros(1,length(Caps));
TotalCap=zeros(1,length(Caps));
MaxNumFailures=max(States(:,1));

x4=1:MaxNumFailures;
NumOfStablesFail=zeros(1,MaxNumFailures);
TotalMax=zeros(1,MaxNumFailures);
NumStables=0;
for i=1:length(States(:,1))
    if(States(i,8)==-1)
       NumStables=NumStables+1;
    end
end
for i=2:MaxNumFailures
    for j=1:length(States(:,1))
        if(States(j,1)==i && States(j,8)==-1)
            NumOfStablesFail(i)=NumOfStablesFail(i)+1;
            
        end
        if(States(j,1)==i)
            TotalMax(i)=TotalMax(i)+1;
        end
    end
end
NumOfStablesFail=NumOfStablesFail./TotalMax;
y4=NumOfStablesFail;

TotalMaxCapStable=0;
TotalMaxCap=0;
MaxStabilityProb=zeros(1,length(Caps));
for i=1:length(Caps)
    for j=1:length(States(:,1))
        if(States(j,10)==Caps(i))
            TotalMaxCap=TotalMaxCap+1;
            if(States(j,8)==-1)
                TotalMaxCapStable=TotalMaxCapStable+1;
            end
        end
    end
    MaxStabilityProb(i)=TotalMaxCapStable/TotalMaxCap;
end
z4=MaxStabilityProb;
% 

% Analytical functions
L=186; epsilon=0.02;
a1=0.4; a2=40;
% Define where to increase
a=floor(0.6*L);
y1=zeros(1,L);
for F=1:a2
    y1(F)=a1*((a2-F)/a2)^4 + epsilon;
end
for F=(a2+1):a
    y1(F)=epsilon;
end
for F=a+1:L
    y1(F)=min(((F-a)/(L-a))^4 + epsilon, 1);
end
% for F=floor(0.8*L)+1:L
%     y1(F)=1;
% end

C=20:800;
a3=0.53; a4=0.24;
z1=zeros(1,length(C));
for i=1:length(C)
    z1(i)=max(a3*((max(Caps)-C(i))/max(Caps))^2, a4);
end


figure (100)
plot(x2,y2,'r--s')
hold on
plot(x3,y3,'g--^')
hold on
plot(x4,y4,'b--*')
hold on
plot(1:L,y1(1:L),'k')
hold on
% axis([0 195 0 1])
% title('Loading level 0.7')
xlabel('\it{F_i}')
ylabel('\it{P}_{\rm{stop}}^{\rm{1}}\rm{(}\it{F_i}\rm{)}')
Legend1=['\theta = 0'];
Legend2=['\theta = 0.1'];
Legend3=['\theta = 0.2'];
Legend4=['Analytic approximation'];
legend(Legend1,Legend2,Legend3,Legend4,'Location','Northwest')
legend('boxoff')
box off
MyFigStyle
% saveas(gcf,'FunctionF.fig')
% saveas(gcf,'FunctionF.eps')
% % saveas(gcf,'FunctionF.jpg')
% print -depsc FunctionF.eps
figure (200)
plot(Caps,z2,'r--s')
hold on
plot(Caps,z3,'g--^')
hold on
plot(Caps,z4,'b--*')
hold on
plot(C,z1,'k')
hold off
xlabel('\it{C^{max}_i}')
ylabel('\it{P}^{\rm{2}}_{\rm{stop}}\rm{(}\it{C}^{\rm{max}}_{i}\rm{)}')
Legend1=['\theta = 0'];
Legend2=['\theta = 0.1'];
Legend3=['\theta = 0.2'];
Legend4=['Analytic approximation'];
legend(Legend1,Legend2,Legend3,Legend4,'Location','Northeast')
legend('boxoff')
box off
MyFigStyle
% saveas(gcf,'FunctionCmax.fig')
% saveas(gcf,'FunctionCmax.eps')
% % saveas(gcf,'FunctionCmax.jpg')
% print -depsc FunctionCmax.eps

