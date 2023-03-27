clear all; clc; close all;
CapsDist=[38 80 54 12 2];
Caps=[20 80 200 500 800];

% ColorVector={'--gv','--bo','-k'};
% temp=[0.9878 0.0122; 0.9874 0.0126; 0.9455 0.0545];
% for i=1:length(ColorVector)
%     figure (200)
%     plot([Caps(4),Caps(5)],temp(i,:),ColorVector{1,i})
%     hold on
% end
ColorVector={'--r^','--gs','--b.'};

B=[];
DataName='States2012-10OPFother700Alpha0.35Beta0V1.mat';
load(DataName);
B=cat(1,B,States);
clear States
%DataName='States2012-10OPFother700Alpha0.35Beta0V2.mat';
load(DataName);
B=cat(1,B,States);
clear States
%DataName='States2012-10OPFother700Alpha0.35Beta0V3.mat';
load(DataName);
B=cat(1,B,States);
clear States
States=B;

count=0; % counts number of possible (min(LineCap), max(LineCap))
for i=1:(length(Caps)) 
    for j=1:i
        count=count+1;
        CatCap(count,2)=Caps(i); % max Cap
        CatCap(count,1)=Caps(j); % min Cap
        CatCap(count,3)=0; % Probability of being Stable
        CatCap(count,4)=0; % total number of times this state is in data
         
    end
end
% Find the prob of changing max min or staying with the same max and min
for i=1:length(CatCap)
        MinChange=0;
        MaxChange=0;
        NoChange=0;
        BothChange=0;
        Hcount=0;
        TotalNum=0;
        
        for k=1:length(States(:,1))
             if(States(k,9)==CatCap(i,1) && States(k,10)==CatCap(i,2))
                 TotalNum=TotalNum+1;
                 if(States(k,8)==-1)
                     %Nothing
                 else
                     Hcount=Hcount+1;
                    if(States(k+1,9)==States(k,9) && States(k+1,10)==States(k,10))
                        NoChange=NoChange+1;
                    else
                            if(i==10)
                                mahs=1;
                            end
                            if(States(k+1,9)==States(k,9))
                                MaxChange=MaxChange+1;
                            end
                            if(States(k+1,10)==States(k,10))
                                MinChange=MinChange+1;
                            end
                        
                    end

                end
            end
        end
%         NumNonStabels=CatCap(i,4)-CatCap(i,5);
        if(Hcount~=0)
            MinMaxChanegRate(i,1)=NoChange/Hcount; % Prob of no chaneg
            MinMaxChanegRate(i,2)=MinChange/Hcount; % Prob of min change
            MinMaxChanegRate(i,3)=MaxChange/Hcount;  % prob of max change
            MinMaxChanegRate(i,4)=BothChange/Hcount;
            MinMaxChanegRate(i,5)=CatCap(i,1);
            MinMaxChanegRate(i,6)=CatCap(i,2);
            MinMaxChanegRate(i,7)=Hcount;
            MinMaxChanegRate(i,8)=TotalNum;
            
        else
            MinMaxChanegRate(i,1)=0; % Prob of no chaneg
            MinMaxChanegRate(i,2)=0; % Prob of min change
            MinMaxChanegRate(i,3)=0;  % prob of max change
            MinMaxChanegRate(i,4)=0;
            MinMaxChanegRate(i,5)=CatCap(i,1);
            MinMaxChanegRate(i,6)=CatCap(i,2);
            MinMaxChanegRate(i,7)=0;
            MinMaxChanegRate(i,8)=0;
            
        end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Find the prob of changing max min or staying with the same max and min
for i=1:length(Caps)
        MaxChange=0;
        MaxNotChange=0;
        NewMinChange=0;
        Hcount=0;
        for k=1:length(States(:,1))
             if(States(k,10)==Caps(i))
                 
                 if(States(k,8)==-1)
                     %Nothing
                 else
                     Hcount=Hcount+1;
                    if(States(k+1,9)==States(k,9) && States(k+1,10)==States(k,10))
                        MaxNotChange=MaxNotChange+1;
                    else
                            if(States(k+1,9)==States(k,9))
                                MaxChange=MaxChange+1;
                            end
                            if(States(k+1,10)==States(k,10))
                                NewMinChange=NewMinChange+1;
                            end
                        
                    end

                end
            end
        end
%         NumNonStabels=CatCap(i,4)-CatCap(i,5);
        if(Hcount~=0)
            MaxChangeProb(i,:)= MaxChange/Hcount; 
            MinChangeProb(i,:)=NewMinChange/Hcount;
        else
            MaxChangeProb(i,:)=0;
            MinChangeProb(i,:)=0;
        end
end
% ColorVector={'-r','-b','-g','-m','--r','--b','--g','--m'};
% figure(400)
% plot(Caps,1-MaxChangeProb,'-sr');
% hold on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Transitions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NumTransits=zeros(length(Caps));
for i=1:length(Caps)
    TotalMaxCapUnstable=0;
    for k=1:length(States(:,1))
        if(States(k,10)==Caps(i))
            if(States(k,8)~=-1)
                TotalMaxCapUnstable=TotalMaxCapUnstable+1;
                indexto=find(Caps==States(k+1,10));
                NumTransits(i,indexto)=NumTransits(i,indexto)+1;
            end
        end
    end
    NumTransits(i,:)=NumTransits(i,:)./TotalMaxCapUnstable;
end
figure(200)

idx=0;
for i=1:length(Caps)-2
    idx=idx+1;
%     if idx<3
%         plot(Caps(idx+3:end),...
%             NumTransits(i,(idx+3:end))/sum(NumTransits(i,(idx+3:end))),'-or');
%     else
    plot(Caps(idx+1:end),...
        NumTransits(i,(idx+1:end))/sum(NumTransits(i,(idx+1:end))),ColorVector{1,idx});
%     end
    hold on;
end



clear all;
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

count=0; % counts number of possible (min(LineCap), max(LineCap))
for i=1:(length(Caps)) 
    for j=1:i
        count=count+1;
        CatCap(count,2)=Caps(i); % max Cap
        CatCap(count,1)=Caps(j); % min Cap
        CatCap(count,3)=0; % Probability of being Stable
        CatCap(count,4)=0; % total number of times this state is in data
         
    end
end
% Find the prob of changing max min or staying with the same max and min
for i=1:length(CatCap)
        MinChange=0;
        MaxChange=0;
        NoChange=0;
        BothChange=0;
        Hcount=0;
        TotalNum=0;
        
        for k=1:length(States(:,1))
             if(States(k,9)==CatCap(i,1) && States(k,10)==CatCap(i,2))
                 TotalNum=TotalNum+1;
                 if(States(k,8)==-1)
                     %Nothing
                 else
                     Hcount=Hcount+1;
                    if(States(k+1,9)==States(k,9) && States(k+1,10)==States(k,10))
                        NoChange=NoChange+1;
                    else
                            if(i==10)
                                mahs=1;
                            end
                            if(States(k+1,9)==States(k,9))
                                MaxChange=MaxChange+1;
                            end
                            if(States(k+1,10)==States(k,10))
                                MinChange=MinChange+1;
                            end
                        
                    end

                end
            end
        end
%         NumNonStabels=CatCap(i,4)-CatCap(i,5);
        if(Hcount~=0)
            MinMaxChanegRate(i,1)=NoChange/Hcount; % Prob of no chaneg
            MinMaxChanegRate(i,2)=MinChange/Hcount; % Prob of min change
            MinMaxChanegRate(i,3)=MaxChange/Hcount;  % prob of max change
            MinMaxChanegRate(i,4)=BothChange/Hcount;
            MinMaxChanegRate(i,5)=CatCap(i,1);
            MinMaxChanegRate(i,6)=CatCap(i,2);
            MinMaxChanegRate(i,7)=Hcount;
            MinMaxChanegRate(i,8)=TotalNum;
            
        else
            MinMaxChanegRate(i,1)=0; % Prob of no chaneg
            MinMaxChanegRate(i,2)=0; % Prob of min change
            MinMaxChanegRate(i,3)=0;  % prob of max change
            MinMaxChanegRate(i,4)=0;
            MinMaxChanegRate(i,5)=CatCap(i,1);
            MinMaxChanegRate(i,6)=CatCap(i,2);
            MinMaxChanegRate(i,7)=0;
            MinMaxChanegRate(i,8)=0;
            
        end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Find the prob of changing max min or staying with the same max and min
for i=1:length(Caps)
        MaxChange=0;
        MaxNotChange=0;
        NewMinChange=0;
        Hcount=0;
        for k=1:length(States(:,1))
             if(States(k,10)==Caps(i))
                 
                 if(States(k,8)==-1)
                     %Nothing
                 else
                     Hcount=Hcount+1;
                    if(States(k+1,9)==States(k,9) && States(k+1,10)==States(k,10))
                        MaxNotChange=MaxNotChange+1;
                    else
                            if(States(k+1,9)==States(k,9))
                                MaxChange=MaxChange+1;
                            end
                            if(States(k+1,10)==States(k,10))
                                NewMinChange=NewMinChange+1;
                            end
                        
                    end

                end
            end
        end
%         NumNonStabels=CatCap(i,4)-CatCap(i,5);
        if(Hcount~=0)
            MaxChangeProb(i,:)= MaxChange/Hcount; 
            MinChangeProb(i,:)=NewMinChange/Hcount;
        else
            MaxChangeProb(i,:)=0;
            MinChangeProb(i,:)=0;
        end
end
% ColorVector={'-r','-b','-g','-m','--r','--b','--g','--m'};
% figure(400)
% plot(Caps,1-MaxChangeProb,'-sr');
% hold on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Transitions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NumTransits=zeros(length(Caps));
for i=1:length(Caps)
    TotalMaxCapUnstable=0;
    for k=1:length(States(:,1))
        if(States(k,10)==Caps(i))
            if(States(k,8)~=-1)
                TotalMaxCapUnstable=TotalMaxCapUnstable+1;
                indexto=find(Caps==States(k+1,10));
                NumTransits(i,indexto)=NumTransits(i,indexto)+1;
            end
        end
    end
    NumTransits(i,:)=NumTransits(i,:)./TotalMaxCapUnstable;
end
figure(200)

idx=0;
ColorVector={'--yv','--mo','--c*'};
for i=1:length(Caps)-2
    idx=idx+1;
%     if idx<3
%         plot(Caps(idx+3:end),...
%             NumTransits(i,(idx+3:end))/sum(NumTransits(i,(idx+3:end))),'-or');
%     else
    plot(Caps(idx+1:end),...
        NumTransits(i,(idx+1:end))/sum(NumTransits(i,(idx+1:end))),ColorVector{1,idx});
%     end
    hold on;
end


% 
x=[20 80 200 500 800];
a=2.22;
b=1.52;
c=0.52;
d=0.03;
w=[a b c d];

for i=1:length(w)
    y1(i)=w(i)/(sum(w));
    y2(i)=w(i)/(sum(w)-w(1));
    y3(i)=w(i)/(sum(w)-w(1)-w(2));
    
end

plot(x(2:5),y1(1:4), 'k');
hold on
plot(x(3:5),y2(2:4), 'k')
hold on;
plot(x(4:5),y3(3:4), 'k')

xlabel('Maximum capacity of the failed lines')
ylabel('Transition probabilities')
Legend1=['\theta =0, C^{max}_i=20MW'];
Legend2=['\theta =0, C^{max}_i=80MW'];
Legend3=['\theta =0, C^{max}_i=200MW'];
Legend4=['\theta =0.1, C^{max}_i=20MW'];
Legend5=['\theta =0.1, C^{max}_i=80MW'];
Legend6=['\theta =0.1, C^{max}_i=200MW'];
Legend7=['Approx.'];
legend(Legend1,Legend2,Legend3,Legend4,...
    Legend5,Legend6,Legend7,'Location','Northeast')
legend boxoff
box off
MyFigStyle