%clear; close all; clc;
ParameterTable1V3
StyleCell={'--sg','--ob','--^r','--*m'};

IDX=[1 2 3 4];
idx=0;
A1=zeros(length(DGRatio),3);
figure (1)
for n=1:length(IDX)
    idx=idx+1;
    for m=1:length(DGRatio)
        A1(m,n)=ParaSetting{m,IDX(n)}(1);
    end
    plot(DGRatio,A1(:,idx),StyleCell{idx})
    hold on
end
hold off

xlabel('Demand-generation ratio \it{r}')
ylabel('Parameter \it{a_1}')
Legend1=['\delta = ' num2str(Alpha(1))];
Legend2=['\delta = ' num2str(Alpha(2))];
Legend3=['\delta = ' num2str(Alpha(3))];
Legend4=['\delta = ' num2str(Alpha(4))];
legend(Legend1,Legend2,Legend3,Legend4,'Location','SouthWest')
legend('boxoff')
box off
%MyFigStyle
% saveas(gcf,'ParaA1.fig')
% saveas(gcf,'ParaA1.jpg')
% print -depsc ParaA1.eps

idx=0;
A2=zeros(length(DGRatio),3);
figure (2)
for n=1:length(IDX)
    idx=idx+1;
    for m=1:length(DGRatio)
        A2(m,n)=ParaSetting{m,IDX(n)}(2);
    end
    plot(DGRatio,A2(:,idx),StyleCell{idx})
    hold on
end
hold off

xlabel('Demand-generation ratio \it{r}')
ylabel('Parameter \it{a_2}')
% axis([0.5 0.9 0 0.07])
Legend1=['\delta = ' num2str(Alpha(1))];
Legend2=['\delta = ' num2str(Alpha(2))];
Legend3=['\delta = ' num2str(Alpha(3))];
Legend4=['\delta = ' num2str(Alpha(4))];
legend(Legend1,Legend2,Legend3,Legend4,'Location','NorthEast')
legend('boxoff')
box off
%MyFigStyle
% saveas(gcf,'ParaA2.fig')
% saveas(gcf,'ParaA2.jpg')
% print -depsc ParaA2.eps

idx=0;
A3=zeros(length(DGRatio),3);
figure (3)
for n=1:length(IDX)
    idx=idx+1;
    for m=1:length(DGRatio)
        A3(m,n)=ParaSetting{m,IDX(n)}(3);
    end
    plot(DGRatio,A3(:,idx),StyleCell{idx})
    hold on
end
hold off

xlabel('Demand-generation ratio \it{r}')
ylabel('Parameter \it{a_3}')
% axis([0.5 0.9 0 0.55])
Legend1=['\delta = ' num2str(Alpha(1))];
Legend2=['\delta = ' num2str(Alpha(2))];
Legend3=['\delta = ' num2str(Alpha(3))];
Legend4=['\delta = ' num2str(Alpha(4))];
legend(Legend1,Legend2,Legend3,Legend4,'Location','SouthWest')
legend('boxoff')
box off
%MyFigStyle
% saveas(gcf,'ParaA3.fig')
% saveas(gcf,'ParaA3.jpg')
% print -depsc ParaA3.eps

idx=0;
A4=zeros(length(DGRatio),3);
figure (4)
for n=1:length(IDX)
    idx=idx+1;
    for m=1:length(DGRatio)
        A4(m,n)=ParaSetting{m,IDX(n)}(4);
    end
    plot(DGRatio,A4(:,idx),StyleCell{idx})
    hold on
end
hold off

xlabel('Demand-generation ratio \it{r}')
ylabel('Parameter \it{a_4}')
% axis([0.5 0.9 0 0.17])
Legend1=['\delta = ' num2str(Alpha(1))];
Legend2=['\delta = ' num2str(Alpha(2))];
Legend3=['\delta = ' num2str(Alpha(3))];
Legend4=['\delta = ' num2str(Alpha(4))];
legend(Legend1,Legend2,Legend3,Legend4,'Location','NorthEast')
legend('boxoff')
box off
%MyFigStyle
% saveas(gcf,'ParaA4.fig')
% saveas(gcf,'ParaA4.jpg')
% print -depsc ParaA4.eps