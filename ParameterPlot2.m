clear; close all; clc;
ParameterTable2V2
StyleCell={'--sg','--ob','--^r','--*m'};

idx=0;
A1=zeros(length(Level)-1,length(Alpha));
figure (1)
for m=1:length(Level)-1
    idx=idx+1;
    for n=1:length(Alpha)
        A1(m,n)=ParaSetting2{m,n}(1);
    end
    plot(Alpha,A1(idx,:),StyleCell{idx})
    hold on
end
hold off
%MyFigStyle
xlabel('Line-capacity tolerance \it{\delta}')
ylabel('Parameter a_1')
Legend1=['\theta = 0'];
Legend2=['\theta = 0.1'];
Legend3=['\theta = 0.2'];
legend(Legend1,Legend2,Legend3,'Location','Northeast')
legend('boxoff')
box off
%saveas(gcf,'ParaA1Level.fig')
%saveas(gcf,'ParaA1Level.jpg')
%print -depsc ParaA1Level.eps

idx=0;
A2=zeros(length(Level)-1,length(Alpha));
figure (2)
for m=1:length(Level)-1
    idx=idx+1;
    for n=1:length(Alpha)
        A2(m,n)=ParaSetting2{m,n}(2);
    end
    plot(Alpha,A2(idx,:),StyleCell{idx})
    hold on
end
hold off
%MyFigStyle
xlabel('Line-capacity tolerance \it{\delta}')
ylabel('Parameter a_2')
Legend1=['\theta = 0'];
Legend2=['\theta = 0.1'];
Legend3=['\theta = 0.2'];
legend(Legend1,Legend2,Legend3,'Location','Northeast')
legend('boxoff')
box off
%saveas(gcf,'ParaA2Level.fig')
%saveas(gcf,'ParaA2Level.jpg')
%print -depsc ParaA2Level.eps

idx=0;
A3=zeros(length(Level)-1,length(Alpha));
figure (3)
for m=1:length(Level)-1
    idx=idx+1;
    for n=1:length(Alpha)
        A3(m,n)=ParaSetting2{m,n}(3);
    end
    plot(Alpha,A3(idx,:),StyleCell{idx})
    hold on
end
hold off
%MyFigStyle
xlabel('Line-capacity tolerance \it{\delta}')
ylabel('Parameter a_3')
Legend1=['\theta = 0'];
Legend2=['\theta = 0.1'];
Legend3=['\theta = 0.2'];
legend(Legend1,Legend2,Legend3,'Location','Northeast')
legend('boxoff')
box off
%saveas(gcf,'ParaA3Level.fig')
%saveas(gcf,'ParaA3Level.jpg')
%print -depsc ParaA3Level.eps

idx=0;
A4=zeros(length(Level)-1,length(Alpha));
figure (4)
for m=1:length(Level)-1
    idx=idx+1;
    for n=1:length(Alpha)
        A4(m,n)=ParaSetting2{m,n}(4);
    end
    plot(Alpha,A4(idx,:),StyleCell{idx})
    hold on
end
hold off
%MyFigStyle
xlabel('Line-capacity tolerance \it{\delta}')
ylabel('Parameter a_4')
Legend1=['\theta = 0'];
Legend2=['\theta = 0.1'];
Legend3=['\theta = 0.2'];
legend(Legend1,Legend2,Legend3,'Location','Northeast')
legend('boxoff')
box off
%saveas(gcf,'ParaA4Level.fig')
%saveas(gcf,'ParaA4Level.jpg')
%print -depsc ParaA4Level.eps