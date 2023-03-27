clc; close all; clear all;
load SpecificMC37.mat
% % Regenerate random time
% X(2,:)=exprnd(1./X(1,:));
% ACCtimeAvg(1)=0;
% ACCtime(1)=0;
% for i=2:size(X,2)+1
%     ACCtimeAvg(i)=ACCtimeAvg(i-1)+1/X(1,i-1);
%     ACCtime(i)=ACCtime(i-1)+X(2,i-1);
% end
pretime=[0 0.5];
prefailure=Fi*ones(1,2);
tailtime=linspace(ACCtime(end),3.5*ACCtime(end-1),5);
tailfailure=linspace(size(X,2)+Fi-1,size(X,2)+Fi-1,5);
x=cat(2,pretime,1+ACCtime(1:end-1),1+tailtime);
y=cat(2,prefailure,Fi:size(X,2)+Fi-1,tailfailure);
time=linspace(0,27,10000);
f(1)=0;
idx=4;
for i=1:length(time)
    if time(i)>x(idx) && time(i)<x(39)
        idx=idx+1;
        f(i)=1;
    end
end
f(end+1:length(time))=0;
% Accumulative
F(1)=Fi;
for i=2:length(time)
    F(i)=F(i-1)+f(i);
end
figure (1)
plot(time,F,'r--')
hold on

clear all;
load SpecificMC48.mat
% % Regenerate random time
% X(2,:)=exprnd(1./X(1,:));
% ACCtimeAvg(1)=0;
% ACCtime(1)=0;
% for i=2:size(X,2)+1
%     ACCtimeAvg(i)=ACCtimeAvg(i-1)+1/X(1,i-1);
%     ACCtime(i)=ACCtime(i-1)+X(2,i-1);
% end
pretime=[0 0.5];
prefailure=zeros(1,2);
tailtime=linspace(ACCtime(end-1),2.8*ACCtime(end-1),5);
tailfailure=linspace(size(X,2)+Fi-1,size(X,2)+Fi-1,5);
x=cat(2,pretime,1+ACCtime(1:end-1),1+tailtime);
y=cat(2,prefailure,Fi:size(X,2)+Fi-1,tailfailure);
time=linspace(0,27,10000);
f(1)=0;
idx=4;
for i=1:length(time)
    if time(i)>x(idx) && time(i)<x(49)
        idx=idx+1;
        f(i)=1;
    end
end
f(end+1:length(time))=0;
% Accumulative
F(1)=Fi;
for i=2:length(time)
    F(i)=F(i-1)+f(i);
end

figure (1)
plot(time,F,'b-.')
hold on

clear all;
load SpecificMC53V2.mat
% % Regenerate random time
% X(2,:)=exprnd(1./X(1,:));
% ACCtimeAvg(1)=0;
% ACCtime(1)=0;
% for i=2:size(X,2)+1
%     ACCtimeAvg(i)=ACCtimeAvg(i-1)+1/X(1,i-1);
%     ACCtime(i)=ACCtime(i-1)+X(2,i-1);
% end
pretime=[0 0.5];
prefailure=zeros(1,2);
tailtime=linspace(ACCtime(end-1),4.6*ACCtime(end-1),5);
tailfailure=linspace(size(X,2)+Fi-1,size(X,2)+Fi-1,5);
x=cat(2,pretime,1+ACCtime(1:end-1),1+tailtime);
y=cat(2,prefailure,Fi:size(X,2)+Fi-1,tailfailure);
time=linspace(0,27,10000);
f(1)=0;
idx=4;
for i=1:length(time)
    if time(i)>x(idx) && time(i)<x(54)
        idx=idx+1;
        f(i)=1;
    end
end
f(end+1:length(time))=0;
% Accumulative
F(1)=Fi;
for i=2:length(time)
    F(i)=F(i-1)+f(i);
end

figure (1)
plot(time,F,'m:')
hold on

clear all;
load SpecificMC163V5.mat
% % Regenerate random time
% X(2,:)=exprnd(1./X(1,:));
% ACCtimeAvg(1)=0;
% ACCtime(1)=0;
% for i=2:size(X,2)+1
%     ACCtimeAvg(i)=ACCtimeAvg(i-1)+1/X(1,i-1);
%     ACCtime(i)=ACCtime(i-1)+X(2,i-1);
% end
pretime=[0 0.5];
prefailure=zeros(1,2);
tailtime=linspace(ACCtime(end-1),1.15*ACCtime(end-1),5);
tailfailure=linspace(size(X,2)+Fi-1,size(X,2)+Fi-1,5);
x=cat(2,pretime,1+ACCtime(1:end-1),1+tailtime);
y=cat(2,prefailure,Fi:size(X,2)+Fi-1,tailfailure);
time=linspace(0,27,10000);
f(1)=0;
idx=4;
for i=1:length(time)
    if time(i)>x(idx) && time(i)<x(164)
        idx=idx+1;
        f(i)=1;
    end
end
f(end+1:length(time))=0;
% Accumulative
F(1)=Fi;
for i=2:length(time)
    F(i)=F(i-1)+f(i);
end

figure (1)
plot(time,F,'g')
hold off
box off

xlabel('Time, min')
ylabel('Accumulative failures')
MyFigStyle(1)
