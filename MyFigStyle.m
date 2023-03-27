% Function with my style for the figures
function  MyFigStyle(FS,AFS,TFS,FN,LW,TypeOfFig)
%
% MyFigStyle(FS,AFS,TFS,FN,LW,Image) format axes and lines of plots. 
%   FS is the font size of the x, y and z labels. 
%   AFS is the Font Size of the numbers on the axes.
%   TFS is the Font size of the title. 
%   FN is a string the Font Name of the font type to use.
%   LW is the Line Width.
%   TypeOfFig is a code indicating if the figure is 2D (0), Image (1)
%       or a 3D (2) plot.
% The default values are:
% FS=16
% AFS=11
% TFS=18
% FN='Times';
% LW=2
% TypeOfFig=0;

if (nargin==0)
    FS=16;TFS=20;LW=2;AFS=18;FN='Times'; TypeOfFig=0;
end
if (nargin==1)
    TypeOfFig=FS;
    FS=16;TFS=18;LW=2;AFS=11;FN='Times';
end
if (nargin>1 && nargin<5)
    disp('ERROR: not enough input parameters.');
    error('See syntax typing: help MyfigStyle');
end
if (nargin==5)
    W=1*(~isnumeric(FS))-1*(~isnumeric(AFS))+sqrt(-1)*(~isnumeric(TFS))+...
        -sqrt(-1)*(~isnumeric(LW));
    switch (W)
        case 1
            disp('ERROR: FS has to be a number');
            error('Error using MyFigStyle');
        case -1
            disp('ERROR: AFS has to be a number');
            error('Error using MyFigStyle');
        case sqrt(-1)
            disp('ERROR: TFS has to be a number');
            error('Error using MyFigStyle');
        case -sqrt(-1)
            disp('ERROR: LW has to be a number');
            error('Error using MyFigStyle');
    end
    if (isstr(FN)==0)
        disp('ERROR: FN has to be an string with a valid Font name');
        error('Error using MyFigStyle');
    end
end

h=gcf;
for i=1:length(h)
    % Lines
    SP=get(h(i),'Children');
    for j=1:length(SP)
        LN=get(SP(j),'Children');
        if (TypeOfFig==0 || TypeOfFig==2)
            for k=1:length(LN);
                set(LN(k),'LineWidth',LW);
            end
        end
        % Axes
        set(SP(j),'FontName',FN)
        set(SP(j),'FontSize',AFS)
        % Labels and title
        T=get(SP(j),'Title');
        set(T,'FontName',FN);
        set(T,'FontSize',TFS);
        T=get(SP(j),'XLabel');
        set(T,'FontName',FN);
        set(T,'FontSize',FS);
        T=get(SP(j),'YLabel');
        set(T,'FontName',FN);
        set(T,'FontSize',FS);
        if (TypeOfFig==2)
            T=get(SP(j),'ZLabel');
            set(T,'FontName',FN);
            set(T,'FontSize',FS);
        end
    end
end
