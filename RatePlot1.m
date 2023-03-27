% Input data from AnalyticRateSolver1.m
%clear all; clc; close all;
load RateCombineV1.mat

X=repmat(Alpha,length(DGRatio),1);
Y=repmat(DGRatio',1,length(Alpha));
a=rate(:,:,1);
AlphaFiner=0.01:0.01:0.5;
DGRatioFiner=0.01:0.01:0.99;
XI=repmat(AlphaFiner,length(DGRatioFiner),1);
YI=repmat(DGRatioFiner',1,length(AlphaFiner));
ZIa=interp2(X,Y,a,XI,YI);
figure (1)
surf(Alpha,DGRatio,a)
xlabel('Tolerance \it{\delta}')
ylabel('Demand-generation ratio \it{r}')
zlabel('E\{R_{S_i}\}')

figure (2)
surf(XI,YI,ZIa)
xlabel('Line-capacity tolerance \it{\delta}')
ylabel('Demand-generation ratio \it{r}')
zlabel('E\{R_{S_i}\}')