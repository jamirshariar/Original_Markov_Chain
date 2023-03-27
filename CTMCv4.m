% CMTC model and Pt Ptp Ptpp numerical solver for different
% parameters
clc; clear all;
load tail
% IEEE-118 bus system
NumberOfLines=186;
% Truncation (trick to reduce numerical solution time)
L=70;
epsilon=0.05;
% Max number of capacities
Capa=[20 80 200 500 800];
C=length(Capa);

pStableM=zeros(NumberOfLines,C);
deltaT=0.1;
% Weights
Wf=0.5; Wcmax=0.5; % linear superposition
% Choose parameter to be A1, A2, A3, A4 or default (0) by INDEX
% ParameterIndex=0;
% [a1,a2,a3,a4,PARAMETER]=SetupParameter(ParameterIndex);
ParameterTable1 % it has all the values of DGratio, and alpha
% a1=0.35; a2=0.15; a3=0.45; a4=0.15;
% Tc=zeros(length(PARAMETER),NumberOfLines);

for m=1:length(DGRatio)
    for n=1:length(Alpha)
        tic
        % Preallocate transition matrix with size 2*NumberOfLines*C
        Q=zeros(2*NumberOfLines*C,2*NumberOfLines*C);
    %     parameter=PARAMETER(m);
    %     IndexParameterReplace
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
            if i>floor(0.6*NumberOfLines)
                f1=min(1, (epsilon + ( (i-0.5*NumberOfLines)/...
                    (NumberOfLines-0.5*NumberOfLines) )^4) );
            end
            for j=1:2
                % For transiant states j==1
                if j==1
                    % If failure starts from smallest capacity
                    for k=1:C
                        % P_{stop}(C^{\max}_i)
                         f2=max(a4, a3*( (Capa(k)-max(Capa))/max(Capa) )^2 );
                        % Weighted average
                        pStable=Wf*f1 + Wcmax*f2;
                        if pStable>1
                            pStable=1;
                        end
                        pStableM(i,k)=pStable;
%                         [lambdaS lambdaT]=findSumlambda(pStable,deltaT);
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
        for i=1:2*NumberOfLines*C
            Q(i,i)=-1*sum(Q(i,:));
        end
        Q=Q/deltaT;
        
        Q1=Q(1:L*C*2,1:L*C*2);
        Q1(end-39:end,end-39:end)=qt;

        tic
        % Numerical solution
        tspan=0:0.05:10;
        x0=zeros(size(Q1,1),1);
        % Compute Pt=e^(A*Tspan)
        Pt=cell(1,length(tspan));
        for i=1:size(Q1,1)
            x0(i)=1;
            % ith column of e^At
%             [T,x] = ode23s(@MatExp,tspan,x0,[],Q1);
            [T,x] = ode15s(@MatExp,tspan,x0,[],Q1);
            % reset x0
            x0=zeros(size(Q1,1),1);
            for j=1:length(T)
                Pt{j}(:,i)=x(j,:);
            end
        end
        toc
    %     if L<186
    %         if ParameterIndex==0
    %             save('DefaultSmall.mat','Pt','Q','tspan','Capa','NumberOfLines','L','-v7.3')
    %         else
    %             SetDataName;
    %             DataName=strcat(DataName, num2str(m));
    %             save(DataName,'Pt','Q','tspan','Capa','NumberOfLines','L','-v7.3')
    %         end
    %     else
    %         save('Bigload70.mat','Pt','Q','tspan','Capa','NumberOfLines','L','-v7.3')
    %     end
        DataName=strcat('DGRatio',num2str(DGRatio(m)), 'Alpha', num2str(Alpha(n)),'Pt.mat');
        save(DataName,'Pt','Q','tspan','Capa','NumberOfLines','L','-v7.3')
        clear Q Pt
        toc
    end
end


% load Pt.mat
% % Choose transition states INDEX
% F1=1; C1=1;
% 
% F2=3; C2=1;
% S1=2*C*(F1-1)+C1; S2=2*C*(F2-1)+2*C2;
% figure (4)
% y=zeros(1,length(tspan));
% for i=1:length(tspan)
%     y(i)=Pt{i}(S1,S2);
% end
% plot(tspan,y)
% 
% F3=5; C3=2;
% S3=2*C*(F3-1)+2*C3;
% figure (5)
% for i=1:length(tspan)
%     y(i)=Pt{i}(S1,S3);
% end
% plot(tspan,y)
% 
% F4=10; C4=2;
% S4=2*C*(F4-1)+2*C4;
% figure (6)
% for i=1:length(tspan)
%     y(i)=Pt{i}(S1,S4);
% end
% plot(tspan,y)
