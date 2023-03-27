% Input data from AnalyticCasProbSolver2.m
clear; close all; clc;
load Dist2V2.mat
StyleCell={'-sr','-xg','-ob','-^c','->m'};
M=40;
NumberOfLines=186; Fi=3;

Level=[0.1 0.3 0.4 0.99];
b=zeros(length(Level),length(Alpha));
for m=1:length(Level)
    for n=1:length(Alpha)
        temp=0;
        for k=M:NumberOfLines
            temp=temp+Dist2(m,n,k);
        end
        b(m,n)=temp;
    end
end
X=repmat(Alpha,length(Level),1);
Y=repmat(Level',1,length(Alpha));
AlphaFiner=0.1:0.03:0.5;
LevelFiner=0.1:0.01:0.99;
XI=repmat(AlphaFiner,length(LevelFiner),1);
YI=repmat(LevelFiner',1,length(AlphaFiner));
ZI=interp2(X,Y,b,XI,YI);
figure (1)
surf(X,Y,b)
figure (2)
surf(XI,YI,ZI)

figure (3)
idx=0;
IDX=[1 21 31 90];
for i=1:length(IDX);
    idx=idx+1;
    plot (AlphaFiner,ZI(IDX(i),:),StyleCell{idx})
    hold on
end
hold off
xlabel('Line-capacity tolerance \it{\delta}')
ylabel('Cascading-failure probability \it{\rho_i}\rm{(40)}')
Legend1=['\theta = 0'];
Legend2=['\theta = 0.9'];
Legend3=['\theta = 0.8'];
Legend4=['\theta = 1'];
legend(Legend1,Legend2,Legend3,Legend4,'Location','Northwest')
legend('boxoff')
box off
MyFigStyle
% saveas(gcf,'CFProb2.fig')
% saveas(gcf,'CFProb2.jpg')
% print -depsc CFProb2.eps