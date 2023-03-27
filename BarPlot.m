
clear all; clc; close all;
% For another
CapsDist=[38 80 54 12 2];
Caps=[20 80 200 500 800];

B=[];

DataName='States2012-10OPFother700Alpha0.35Beta0.1V1.mat';
load(DataName);
B=cat(1,B,States);
clear States
DataName='States2012-10OPFother700Alpha0.35Beta0.1V2.mat';
load(DataName);
B=cat(1,B,States);
clear States
DataName='States2012-10OPFother700Alpha0.35Beta0.1V3.mat';
load(DataName);
B=cat(1,B,States);
clear States
States=B;

NewMatrix=zeros(length(Caps),186); 
  
for i=1:length(Caps)
    for j=1:186
            total=0;
            maxChange=0;
            for k=1:length(States(:,1))
               if(States(k,1)==j && States(k,10)==Caps(i) && States(k,8)~=-1)
%                 if(States(k,1)==j && States(k,8)~=-1)
                    total=total+1;
                    if(States(k+1,10)>States(k,10))
                        maxChange=maxChange+1;
                    end
                end
            end 
%             NumLargers=0;
%             for ii=i:length(Caps)
%             	NumLargers=NumLargers+CapsDist(ii);
%             end
%             maxChange=maxChange/NumLargers;
            if maxChange==total
                NewMatrix(i,j)=0;
            else
                NewMatrix(i,j)=maxChange/total;
            end
    end
end

ColorVector={'-r','-b','-g','-m','--r','--b','--g','--m'};
barColorVector={'r','b','c','g','m','k','y'};
idx=0;
for i=1:4
    idx=idx+1;
    figure (1)
%     subplot(3,1,1)
%     plot(1:186,NewMatrix(i,:),ColorVector{1,idx})
%     if i==4
%         for j=1:186
%             if NewMatrix(i,j)>0.3
%                  NewMatrix(i,j)=0;
%             end
%         end
%     end
    subplot(2,1,1)
    bar(NewMatrix(i,:),barColorVector{1,idx})
    hold on
end

tailend=186;
% Big curve
x=1:400;
y=6e-7*x.^3;

x4=116:tailend+116-1;
y4=min(1,0.01+y(x4));
plot(1:tailend,y4,'-.k')
hold on


x3=74:tailend+74-1;
y3=min(1,0.01+y(x3));
plot(1:tailend,y3,'-.k')
hold on


x2=42:tailend+42-1;
y2=min(1,0.01+y(x2));
plot(1:tailend,y2,'--k')
hold on


% Subcurve 1 for largest capacity

shift=30;
x1=1:tailend;
y1(1:shift)=0.01;
y1(shift+1:shift+tailend)=min(1,0.01+y(x1));
plot(1:shift+tailend,y1,'k')
hold on

% x1=8:tailend+8-1;
% y1=min(1,0.01+y(x1));
% plot(1:tailend,y1,'.k')
% hold on
axis([0 140 0 1])

clear all;
% For another
CapsDist=[38 80 54 12 2];


Caps=[20 80 200 500 800];
B=[];

DataName='States2012-10OPFother700Alpha0.35Beta0.2V1.mat';
load(DataName);
B=cat(1,B,States);
clear States
DataName='States2012-10OPFother700Alpha0.35Beta0.2V2.mat';
load(DataName);
B=cat(1,B,States);
clear States
DataName='States2012-10OPFother700Alpha0.35Beta0.2V3.mat';
load(DataName);
B=cat(1,B,States);
clear States
States=B;


NewMatrix=zeros(length(Caps),186); 
  
for i=1:length(Caps)
    for j=1:186
            total=0;
            maxChange=0;
            for k=1:length(States(:,1))
               if(States(k,1)==j && States(k,10)==Caps(i) && States(k,8)~=-1)
%                 if(States(k,1)==j && States(k,8)~=-1)
                    total=total+1;
                    if(States(k+1,10)>States(k,10))
                        maxChange=maxChange+1;
                    end
                end
            end 
%             NumLargers=0;
%             for ii=i:length(Caps)
%             	NumLargers=NumLargers+CapsDist(ii);
%             end
%             maxChange=maxChange/NumLargers;
            if maxChange==total
                NewMatrix(i,j)=0;
            else
                NewMatrix(i,j)=maxChange/total;
            end
    end
end

ColorVector={'-r','-b','-g','-m','--r','--b','--g','--m'};
barColorVector={'r','b','c','g','m','k','y'};
idx=0;
for i=1:4
    idx=idx+1;
    figure (1)
%     subplot(3,1,1)
%     plot(1:186,NewMatrix(i,:),ColorVector{1,idx})
%     if i==4
%         for j=1:186
%             if NewMatrix(i,j)>0.3
%                  NewMatrix(i,j)=0;
%             end
%         end
%     end
    subplot(2,1,2)
    bar(NewMatrix(i,:),barColorVector{1,idx})
    hold on
end

tailend=186;
% Big curve
x=1:400;
y=6e-7*x.^3;
DC=0.01;

x4=116:tailend+116-1;
y4=min(1,DC+y(x4));
plot(1:tailend,y4,'k')
hold on

x3=74:tailend+74-1;
y3=min(1,DC+y(x3));
plot(1:tailend,y3,'-.k')
hold on


x2=42:tailend+42-1;
y2=min(1,DC+y(x2));
plot(1:tailend,y2,'--k')
hold on


% Subcurve 1 for largest capacity
% Right shift
shift=30;
x1=1:tailend;
y1(1:shift)=DC;
y1(shift+1:shift+tailend)=min(1,DC+y(x1));
plot(1:shift+tailend,y1,'k')
hold on




axis([0 140 0 1])
xlabel('Number of line failures \it{F_i}')
ylabel('\it{P}_{\rm{hc}}\rm{(}\it{S_i}\rm{)}')
Legend1=['Capacity ' num2str(Caps(1)) 'MW'];
Legend2=['Capacity ' num2str(Caps(2)) 'MW'];
Legend3=['Capacity ' num2str(Caps(3)) 'MW'];
Legend4=['Capacity ' num2str(Caps(4)) 'MW'];
Legend5=['Approximations for ' num2str(Caps(1)) 'MW'];
Legend6=['Approximations for ' num2str(Caps(2)) 'MW'];
Legend7=['Approximations for ' num2str(Caps(3)) 'MW'];
Legend8=['Approximations for ' num2str(Caps(4)) 'MW'];
% legend(Legend1,Legend2,Legend3,Legend4,...
%     Legend5,Legend6,Legend7,Legend8,'Location','Southeast')
% legend box off