%clear all; clc; close all;
% % AnalyticVSsimYes

load tail.mat
% IEEE-118 bus system
NumberOfLines=186;
epsilon=0.01;
% Max number of capacities
Capa=[20 80 200 500 800];
C=length(Capa);
% Choose initial state INDEX
Fi=2; Ci=2;
% AvgF=zeros(1,length(tspan));
ii=2*C*(Fi-1)+2*Ci-1;


% Weights
Wf=0.5; Wcmax=0.5;
deltaT=0.1;
tic

load States2012-6OPF890Alpha0.45.mat

%%% comment the below two lines of code if using the previous line data 
% load 2_8_2_2_States7.mat
% States = States1;

NumberOfLines=186;
Blackoutsize=zeros(NumberOfLines,1);
for i=1:length(States(:,1))
    if(States(i,8)==-1)
        Blackoutsize(States(i,1))=Blackoutsize(States(i,1))+1;
    end
end
Blackoutsize=Blackoutsize/sum(Blackoutsize);
v=hist(Blackoutsize,62);
v=v/sum(v);
for k=1:186/3
    b((k-1)*3+1:k*3)=v(k);
end
b=b/3;
figure (3)
plot(5:186,Blackoutsize(5:186),'--bo')
hold on

DistNOPF=zeros(1,NumberOfLines);
        Q=zeros(2*NumberOfLines*C,2*NumberOfLines*C); % The two is for I=0 (cascade continue state), I=1 (absorbing state)
a1=0.17; a2=0.01; a3=0.1; a4=0.01;
        % If start from 1 failure
        for i=1:NumberOfLines-1
            % j==1 for transient, j==2 for stable states
            % find stability probability parametricly first
            % P_{stop}(F_i)
            if i<=floor(a2*NumberOfLines)
                f1=epsilon + a1*( (a2*NumberOfLines-i)/(a2*NumberOfLines) )^4;
            end
            if i>floor(a2*NumberOfLines) && i<=floor(0.3*NumberOfLines)
                f1=epsilon;
            end
            if i>floor(0.3*NumberOfLines)
                f1=min(1, (epsilon + ( (i-0.3*NumberOfLines)/...
                    (NumberOfLines-0.3*NumberOfLines) )^4) );
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
%                       pStableM(i,k)=pStable;
                        % Continue probability
                        pCont=1-pStable;
                        % Rates for cascade-stop transitions
                        Q( 2*(i-1)*C+2*(k-1)+j, 2*(i-1)*C+2*(k-1)+j+1)=pStable;
                        % Rates for cascade-continue transitions
                        
                        % Going to same Cmax
                        if k==1
                            pContSub=min(1,0.01+6e-7*(i+112)^3);
                            Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+1)=...
                                pCont*(1-pContSub);
                        end
                        if k==2
                            pContSub=min(1,0.01+6e-7*(i+75)^3);
                            Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+1)=...
                                pCont*(1-pContSub);
                        end
                        if k==3
                            pContSub=min(1,0.01+6e-7*(i+35)^3);
                            Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+1)=...
                                pCont*(1-pContSub);
                        end
                        if k==4
                            pContSub=min(1,0.01+6e-7*(i-35)^3);
                            if pContSub<0.01
                                pContSub=0.01;
                            end
                            Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+1)=...
                                pCont*(1-pContSub);
                        end
                        if k==5
                            pContSub=0;
                            Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+1)=...
                                pCont*(1-pContSub);
                        end

                        % Going to larger Cmax (% ((1-delta)*P_Cmax(s_i,S_j)*P_hc(S_i), part of the equation (10) in mahshid paper.)
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
                    end
                end
            end
        end
        % Assign rates=0 for F_i=NumberOfLines
        Q(2*(NumberOfLines-1)*C+1:2*C*NumberOfLines,:)=0;
        for i=1:2*NumberOfLines*C
            Q(i,i)=-1*sum(Q(i,:));
        end

        [V,D] = eig(Q);
        U=diag(V);
        
        M=1;
        for j=2:2:2*NumberOfLines*C
            % Analytical
            if U(j)~=0
                temp=V(ii,j)/U(j);
                DistNOPF(M)=DistNOPF(M)+temp;
            end
            if mod(j,2*C)==0
                M=M+1;
            end
        end
%     end
% end
toc
figure (3)
plot(5:186,DistNOPF(5:186),'r')
hold on
xlabel('Blackout size')
ylabel('Probability')

Legend1='Simulation result';
Legend2='Theoretical curve';
legend(Legend1,Legend2,'Location','Northeast')
legend boxoff
box off
MyFigStyle
% saveas(gcf,'SimuDistStress.fig')
% saveas(gcf,'SimuDistStress.jpg')
% print -depsc SimuDistStress.eps