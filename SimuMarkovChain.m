clc; clear all;
load tail
% IEEE-118 bus system
NumberOfLines=186;
epsilon=0.002;
% Max number of capacities
Capa=[20 80 200 500 1500];
C=length(Capa);

pStableM=zeros(NumberOfLines,C);
deltaT=0.1;
% Weights
Wf=0.5; Wcmax=0.5;
% Preallocate transition matrix with size 2*NumberOfLines*C
Q=zeros(2*NumberOfLines*C,2*NumberOfLines*C);
ParameterTable1
m=3; n=2;
% m=6; n=6;
a1=ParaSetting{m,n}(1);
a2=ParaSetting{m,n}(2);
a3=ParaSetting{m,n}(3);
a4=ParaSetting{m,n}(4);
% If start from 1 failure
for i=1:NumberOfLines-1
    % j==1 for transient, j==2 for stable states
    % find stability probability parametricly first
    % P_{stop}(F_i)
    if i<=floor(a2*NumberOfLines)
        f1=epsilon + a1*( (a2*NumberOfLines-i)/(a2*NumberOfLines) )^4;
    end
    if i>floor(a2*NumberOfLines) && i<=floor(0.5*NumberOfLines)
        f1=epsilon;
    end
    if i>floor(0.5*NumberOfLines)
        f1=min(1, (epsilon + ( (i-0.5*NumberOfLines)/...
            (NumberOfLines-0.5*NumberOfLines) )^4) );
    end
    for j=1:2
        % For transiant states j==1
        if j==1
            % If failure starts from smallest capacity
            for k=1:C
                % P_{stop}(C^{\max}_i)
                f2=max(a4, a3*( (Capa(k)-max(Capa))/max(Capa) )^4 );
                % Weighted average
                pStable=Wf*f1 + Wcmax*f2;
                if pStable>1
                    pStable=1;
                end
                pStableM(i,k)=pStable;
                %[lambdaS lambdaT]=findSumlambda(pStable,deltaT);
                [lambdaS lambdaT]=findSumlambda(pStable);
                % Continue probability
                pCont=1-pStable;
                % Rates for cascade-stop transitions
                Q( 2*(i-1)*C+2*(k-1)+j, 2*(i-1)*C+2*(k-1)+j+1)=pStable;
                % Rates for cascade-continue transitions
                % Going to same Cmax
                if k==1
                    pContSub=min(1,0.03+6e-7*(i+112)^3);
                    Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+1)=...
                        pCont*(1-pContSub);
                end
                if k==2
                    pContSub=min(1,0.03+6e-7*(i+75)^3);
                    Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+1)=...
                        pCont*(1-pContSub);
                end
                if k==3
                    pContSub=min(1,0.03+6e-7*(i+20)^3);
                    Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+1)=...
                        pCont*(1-pContSub);
                end
                if k==4
                    pContSub=min(1,0.03+6e-7*(i-60)^3);
                    if pContSub<0.03
                        pContSub=0.03;
                    end
                    Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+1)=...
                        pCont*(1-pContSub);
                end
                if k==5
                    pContSub=0;
                    Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+1)=...
                        pCont*(1-pContSub);
                end

                % Going to larger Cmax
                a=2.22;
                b=1.52;
                c=0.52;
                d=0.03;
                w=[a b c d];
                if k==1
                    Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+3)=...
                        pContSub*pCont*w(1)/(sum(w));
                    Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+5)=...
                        pContSub*pCont*w(2)/(sum(w));
                    Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+7)=...
                        pContSub*pCont*w(3)/(sum(w));
                    Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+9)=...
                        pContSub*pCont*w(4)/(sum(w));
                end
                if k==2
                    Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+3)=...
                        pContSub*pCont*w(2)/(sum(w)-w(1));
                    Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+5)=...
                        pContSub*pCont*w(3)/(sum(w)-w(1));
                    Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+7)=...
                        pContSub*pCont*w(4)/(sum(w)-w(1));
                end
                if k==3
                    Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+3)=...
                        pContSub*pCont*w(3)/(sum(w)-w(1)-w(2));
                    Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+5)=...
                        pContSub*pCont*w(4)/(sum(w)-w(1)-w(2));
                end
                if k==4
                    Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+3)=...
                        pContSub*pCont*1;
                end
                % Old 
%                         temp=k;
%                         Totalw=sum(w(k:C));
%                         while temp<=C
%                             Q( 2*(i-1)*C+2*(k-1)+1, 2*i*C+2*temp-1 ) = ...
%                                 lambdaT*w(temp)/Totalw;
%                             temp=temp+1;
%                         end
            end
        end
    end
end
% Assign rates=0 for F_i=NumberOfLines
Q(2*(NumberOfLines-1)*C+1:2*C*NumberOfLines,:)=0;

Q=Q/deltaT;

% MC-Chain
P=Q/10;
% Start point
Fi=3;Ci=2;
Realization=10000;
LOG=cell(1,Realization);
for iter=1:Realization
    % Starting index
    startIdx=2*(Fi-1)*C+2*Ci-1;
    Idx(1)=startIdx;
    i=1;
    while mod(Idx(i),2)==1
        i=i+1;
        % Flip a coin
        temp=rand;
        % Find next step idx using accumulation algorithm
        j=Idx(i-1);
        while temp~=0
            if sum(P(Idx(i-1),Idx(i-1):(j+1)))>temp
                temp=0;
                Idx(i)=j+1;
            end
            j=j+1;   
        end
    end
    % Find rate between state transitions
    for i=2:length(Idx)
        Rate(i-1)=Q(Idx(i-1),Idx(i));
        CapaTrack(i-1)=ceil( mod(Idx(i),2*C)/2 );
    end
    % Find time to complete MC simulation
    Time=exprnd(1./Rate);
    LOG{1,iter}=cat(1,Rate,CapaTrack,Time);
    clear Idx Rate CapaTrack
end



i=1; temp=size(LOG{1,i},2);
while i<Realization
    if size(LOG{1,i},2)>temp
        temp=size(LOG{1,i},2);
        j=i;
    end
    i=i+1;
end
% Pick one example cell
j=98;
X=LOG{1,j};
clear ACCtimeAvg ACCtime
ACCtimeAvg(1)=0;
ACCtime(1)=0;
X(3,:)=exprnd(1./X(1,:));
for i=2:size(X,2)+1
    ACCtimeAvg(i)=ACCtimeAvg(i-1)+1/X(1,i-1);
    ACCtime(i)=ACCtime(i-1)+X(3,i-1);
end
y=Fi:size(X,2)+Fi; y(end)=y(end)-1;
z=cat(2,Ci,X(2,1:end-1),X(2,end-1));
% figure (1)
% plotyy(ACCtime,y,ACCtime,z)
% save('SpecificMC71WithCapa.mat','X','Fi','Ci')
% save('CloudMC.mat','LOG','Fi','Ci')