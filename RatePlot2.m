% Input data from AnalyticRateSolver2.m
%clear all; clc; close all;
load RateCombine2.mat

Level=[0 0.1 0.2 1];

X=repmat(Alpha,length(Level),1);
Y=repmat(Level',1,length(Alpha));
a=rate(:,:,1);
AlphaFiner=0.1:0.01:0.5;
LevelFiner=1:-0.01:0;
XI=repmat(AlphaFiner,length(LevelFiner),1);
YI=repmat(LevelFiner',1,length(AlphaFiner));
ZIa=interp2(X,Y,a,XI,YI);


figure (2)
surf(XI,YI,ZIa)
xlabel('Line-capacity tolerance \it{\delta}')
ylabel('Load shedding level \it{\theta}')
zlabel('E[\it{R_{S_i}}\rm{]}')
