clear all; clc; close all;
% % 
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


DistOPF=zeros(1,NumberOfLines);
Q=zeros(2*NumberOfLines*C,2*NumberOfLines*C);
a1=0.5; a2=0.1; a3=0.48; a4=0.27;
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
                    pContSub=min(1,0.01+6e-7*(i+20)^3);
                    Q(2*(i-1)*C+2*(k-1)+1,2*i*C+2*(k-1)+1)=...
                        pCont*(1-pContSub);
                end
                if k==4
                    pContSub=min(1,0.01+6e-7*(i-60)^3);
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
            end
        end
        % For stable states, do nothing
%             if j==2
%                 A( (i-1)*C+j, : )=0;
%             end
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
        DistOPF(M)=DistOPF(M)+temp;
    end
    if mod(j,2*C)==0
        M=M+1;
    end
end

figure (1)
plot(5:186,DistOPF(5:186),'b--')
hold on



% 90% 0.33
DistNOPF=zeros(1,NumberOfLines);
Q=zeros(2*NumberOfLines*C,2*NumberOfLines*C);
a1=0.23; a2=0.04; a3=0.2; a4=0.08;
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
            end
        end
        % For stable states, do nothing
%             if j==2
%                 A( (i-1)*C+j, : )=0;
%             end
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
figure (1)
plot(5:186,DistNOPF(5:186),'g-.')


DistNOPF=zeros(1,NumberOfLines);
Q=zeros(2*NumberOfLines*C,2*NumberOfLines*C);
a1=0.13; a2=0.02; a3=0.1; a4=0.02;
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
                    end
                end
                % For stable states, do nothing
    %             if j==2
        %                 A( (i-1)*C+j, : )=0;
    %             end
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

figure (1)
plot(5:186,DistNOPF(5:186),'m.')
hold on

% 
DistOPF=zeros(1,NumberOfLines);
Q=zeros(2*NumberOfLines*C,2*NumberOfLines*C);
a1=0.01; a2=0.015; a3=0.015; a4=0.01;
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
                    pContSub=min(1,0.03+6e-7*(i+35)^3);
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
            end
        end
        % For stable states, do nothing
%             if j==2
%                 A( (i-1)*C+j, : )=0;
%             end
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
        DistOPF(M)=DistOPF(M)+temp;
    end
    if mod(j,2*C)==0
        M=M+1;
    end
end

figure (1)
plot(5:186,DistOPF(5:186),'r')
hold on

xlabel('Blackout size')
ylabel('Probability')
Legend1='r=0.7,\delta=0.3,\theta=0';
Legend2='r=0.7,\delta=0.4,\theta=0.1';
Legend3='r=0.7,\delta=0.45,\theta=0.1';
Legend4='r=0.7,\delta=0.45,\theta=0.2';
legend(Legend1,Legend2,Legend3,Legend4,'Location','Northeast')
legend boxoff
box off
MyFigStyle
% saveas(gcf,'DistGradualStress.fig')
% saveas(gcf,'DistGradualStress.jpg')
% print -depsc DistGradualStress.eps