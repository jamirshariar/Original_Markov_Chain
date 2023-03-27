function [lambdaS lambdaT]=findSumlambda(pStable)

% lambdaT=10*exp(-2*pStable);
lambdaT=20*exp(-5*pStable);
lambdaS=(pStable/(1-pStable))*lambdaT;
end