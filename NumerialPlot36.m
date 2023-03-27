% Input from CTMCV4.m
%clc; clear all; close all;
%load DGRatio0.7Alpha0.27PtV2.mat

load DGRatio0.01Alpha0.5Pt.mat

C=length(Capa);
x=tspan;

Fj=40; Cj=1;
target=2*C*(Fj-1)+2*Cj;


Fi=3; Ci=[1 3 4];
ColorVector={'-or','-*g','-^b','-sk','-vy','-om'};
idx=0;
for j=Ci
    k = 2*C*(Fi-1)+2*j-1;
    for i=1:length(x)
        y(i)=sum(Pt{1,i}(k,target:2*L*C));
    end
    idx=idx+1;
    figure (1)
    plot(x,y,ColorVector{1,idx})
    hold on
    clear y
end

clear y
Fi=6; Ci=[1 3 4];

for j=Ci
    k = 2*C*(Fi-1)+2*j-1;
    for i=1:length(x)
        y(i)=sum(Pt{1,i}(k,target:2*L*C));
    end
    idx=idx+1;
    figure ()
    plot(x,y,ColorVector{1,idx})
    hold on
    clear y
end
xlabel('Time \it{t}')
ylabel('Probability \it{B\rm{(}\it{t,M|S_i}\rm{)}\rm{(}\it{t}\rm{)}}')
box off
%MyFigStyle

clear all;
load DGRatio0.9Alpha0.27PtV2.mat
C=length(Capa);
x=tspan;

Fj=40; Cj=1;
target=2*C*(Fj-1)+2*Cj;


Fi=3; Ci=[1 3 4];
ColorVector={'-or','-*g','-^b','-sk','-vy','-om'};
idx=0;
for j=Ci
    k = 2*C*(Fi-1)+2*j-1;
    for i=1:length(x)
        y(i)=sum(Pt{1,i}(k,target:2*L*C));
    end
    idx=idx+1;
    figure ()
    plot(x,y,ColorVector{1,idx})
    hold on
    clear y
end

clear y
Fi=6; Ci=[1 3 4];

for j=Ci
    k = 2*C*(Fi-1)+2*j-1;
    for i=1:length(x)
        y(i)=sum(Pt{1,i}(k,target:2*L*C));
    end
    idx=idx+1;
    figure (2)
    plot(x,y,ColorVector{1,idx})
    hold on
    clear y
end
xlabel('Time \it{t}')
ylabel('Probability \it{B\rm{(}\it{t,M|S_i}\rm{)}\rm{(}\it{t}\rm{)}}')
axis([0 10 0 0.27])

Legend1=['F_i=3, C^{max}_i=20MW'];
Legend2=['F_i=3, C^{max}_i=200MW'];
Legend3=['F_i=3, C^{max}_i=500MW'];
Legend4=['F_i=6, C^{max}_i=20MW'];
Legend5=['F_i=6, C^{max}_i=200MW'];
Legend6=['F_i=6, C^{max}_i=500MW'];
legend(Legend1,Legend2,Legend3,Legend4,Legend5,Legend6,'Location','Southeast')
%MyFigStyle
% legend boxoff

box off
