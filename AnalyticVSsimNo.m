%clear all; clc; close all;
% % AnalyticVSsimNo

%%%%% may be even commenting the tail.mat would not efect the ananlysis of
%%%%% the code. Find out what it is actually doing?
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

ii=2*C*(Fi-1)+2*Ci-1;  %% why?

% Weights
Wf=0.5; Wcmax=0.5;

deltaT=0.1; % Average time between failures, (In Mahshid paper observe (1) and (2) equations and their description)

tic

load States2012-6OPF700Alpha0.27.mat

%%% comment the below two lines of code if using the previous line data 

% load 2_8_2_2_States7.mat
% States = States1;


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

figure (1)
plot(5:186,Blackoutsize(5:186),'--bo')
hold on
% figure (2)
% bar(b);
% h = findobj(gca,'Type','patch');
% set(h,'FaceColor','b','EdgeColor','w','facealpha',0.5)
% hold on

DistOPF=zeros(1,NumberOfLines);
        Q=zeros(2*NumberOfLines*C,2*NumberOfLines*C); % The transition matrix
        
a1=0.4; a2=0.07; a3=0.5; a4=0.15;

        % If start from 1 failure
        for i=1:NumberOfLines-1
            % j==1 for transient, j==2 for stable states
            % find stability probability parametricly first
            % P_{stop}(F_i) % Equation 8 in Mahshid paper
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
                        % P_{stop}(C^{\max}_i) % Equation 9 in Mahshid paper
                        f2=max(a4, a3*( (Capa(k)-max(Capa))/max(Capa) )^4 );
                        % Weighted average % Equation 7 in Mahsihd paper
                        pStable=Wf*f1 + Wcmax*f2;
                        if pStable>1
                            pStable=1;
                        end
%                       pStableM(i,k)=pStable;

                        % It seems like this block of code is not needed (Probably was used for the old version of the code)
                        % [lambdaS lambdaT]=findSumlambda(pStable,deltaT);
                        [lambdaS, lambdaT]=findSumlambda(pStable); 
                        
                        
                        % Continue probability % PStable is basically the P_Stop 
                        pCont=1-pStable; 
                        
                        % Rates for cascade-stop transitions  (For every transitory state there is a single assocciated absorbing 
                        % state, which we denote by S*_i (See Fig. 3, in Mahshid paper))
                        
                        Q( 2*(i-1)*C+2*(k-1)+j, 2*(i-1)*C+2*(k-1)+j+1)=pStable; % S*_i
                        
                        % Rates for cascade-continue transitions
                        % Going to same Cmax
                        
                        if k==1
                            pContSub=min(1,0.03+6e-7*(i+112)^3); % may be equation 11, and B=112, which is C_max dependent
                            Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+1)=...
                                pCont*(1-pContSub); % Here this pContSub is the conditional cascade-continue transition probability,P_cont(S_i,S_j)
                            % as described in (6) in Mahshid paper.
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
                        
                        
                        % Going to larger Cmax % Equaion 12 and the valul
                        a=2.22;
                        b=1.52;
                        c=0.52;
                        d=0.03; % may be for 800 MW, in the paper the value 0.01 is given for 1500 MW
                        w=[a b c d];
                        if k==1 % From 20 MW we can go to 4 more possible options as given below.
                            Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+3)=...
                                pContSub*pCont*w(1)/(sum(w));  % Equation 12 in Mahshid paper
                            Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+5)=...
                                pContSub*pCont*w(2)/(sum(w));
                            Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+7)=...
                                pContSub*pCont*w(3)/(sum(w));
                            Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+9)=...
                                pContSub*pCont*w(4)/(sum(w));
                        end
                        if k==2 % From 80 MW we can go to 3 more possible options as given below.
                            Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+3)=...
                                pContSub*pCont*w(2)/(sum(w)-w(1));
                            Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+5)=...
                                pContSub*pCont*w(3)/(sum(w)-w(1));
                            Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+7)=...
                                pContSub*pCont*w(4)/(sum(w)-w(1));
                        end
                        if k==3 % From 200 MW we can go to 2 more possible options as given below.
                            Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+3)=...
                                pContSub*pCont*w(3)/(sum(w)-w(1)-w(2));
                            Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+5)=...
                                pContSub*pCont*w(4)/(sum(w)-w(1)-w(2));
                        end % From 500 MW we can go to 1 more possible option as given below.
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
            Q(i,i)=-1*sum(Q(i,:)); % for i == j equation 1, in Mahshid paper
        end
        Q=Q/deltaT;

        [V,D] = eig(Q);
        U=diag(V);
        
        M=1;
        for j=2:2:2*NumberOfLines*C
            % Analytical
            if U(j)~=0
                temp=V(ii,j)/U(j);
                DistOPF(M)=DistOPF(M)+temp;
            end
            if mod(j,2*C)==0
                M=M+1;
            end
        end
%     end
% end
toc
figure (1)
plot(5:186,DistOPF(5:186),'r-')

xlabel('Blackout size')
ylabel('Probability ')
Legend1='Simulation result';
Legend2='Theoretical curve';
legend(Legend1,Legend2,'Location','Northeast')
legend boxoff
box off
MyFigStyle
% saveas(gcf,'SimuDistNoStress.fig')
% saveas(gcf,'SimuDistNoStress.jpg')
% print -depsc SimuDistNoStress.eps
% 

%%  Notable remarks of my own understanding of the code (make sure whether they are correct or not)

% The transition matrix Q, Every other row in that matrix is zero because
% that is the absorbing state indicating I = 1, so there is not transition.
% I = 1 and F = |186| and C =|5|