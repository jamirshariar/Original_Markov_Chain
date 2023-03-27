% Input data from AnalyticCasProbSolver1.m
clear; close all; clc;
load DistV3.mat
StyleCell={'-sr','-xg','-ob','->m'};
% Define blackout size
M=40;
NumberOfLines=186;

b=zeros(length(DGRatio),length(Alpha));
for m=1:length(DGRatio)
    for n=1:length(Alpha)
        temp=0;
        for k=M:NumberOfLines
            temp=temp+Dist2(m,n,k);
        end
        b(m,n)=temp;
    end
end
X=repmat(Alpha,length(DGRatio),1);
Y=repmat(DGRatio',1,length(Alpha));
AlphaFiner=0.25:0.01:0.5;
DGRatioFiner=0.01:0.03:0.99;
XI=repmat(AlphaFiner,length(DGRatioFiner),1);
YI=repmat(DGRatioFiner',1,length(AlphaFiner));
ZI=interp2(X,Y,b,XI,YI);


figure (1)
idx=0;
% Choose idx as you need for different delta
% IDX=[1 11 21 26];
IDX=[16 21 24 26];
for i=1:length(IDX)
    idx=idx+1;
    plot (DGRatioFiner,ZI(:,IDX(i)),StyleCell{idx})
    hold on
end
hold off
xlabel('Demand-generation ratio \it{r}')
ylabel('Cascading-failure probability \it{\rho}_i\rm{(40)}')
% Legend1=['\delta = ' num2str(Alpha(1))];
% Legend2=['\delta = ' num2str(Alpha(2))];
% Legend3=['\delta = ' num2str(Alpha(3))];
% Legend4=['\delta = ' num2str(Alpha(4))];
Legend1=['\delta = 0.35'];
Legend2=['\delta = 0.4'];
Legend3=['\delta = 0.48'];
Legend4=['\delta = 0.5'];
legend(Legend1,Legend2,Legend3,Legend4,'Location','NorthWest')
legend('boxoff')
box off
%MyFigStyle
% saveas(gcf,'CFProb.fig')
% saveas(gcf,'CFProbExample.jpg')
% print -depsc CFProb.eps