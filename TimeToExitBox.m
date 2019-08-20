function exitTime = TimeToExitBox(x0,y0,maxT)
% Returns time to exit a box defined by the [-1,1] interval
% in x and y

if nargin < 3
    maxT = 10;
end

isInBox = @(x) (x >= -1 & x <= 1);

if ~isInBox(x0) || ~isInBox(y0)
    error('You have to start in the box!');
end
if x0==0 && y0==0
    warning('Hey! Don''t be cheating!')
end

tinyNoise = 1e-6;
x0 = x0 - rand*tinyNoise*sign(x0);
y0 = y0 - rand*tinyNoise*sign(y0);

sys = LinearODE();

% Set system parameters:
sys.pardef = bdSetValue(sys.pardef,'a',1);
sys.pardef = bdSetValue(sys.pardef,'b',1);
sys.pardef = bdSetValue(sys.pardef,'c',4);
sys.pardef = bdSetValue(sys.pardef,'d',-2);

% Set initial conditions:
sys.vardef = bdSetValue(sys.vardef,'x',x0);
sys.vardef = bdSetValue(sys.vardef,'y',y0);

% Solve the system:
tSpan = [0,maxT];
sol = bdSolve(sys,tSpan);

% Evaluate the system on time grid:
gridPoints = 100;
tEval = linspace(0,maxT,gridPoints);
Y = bdEval(sol,tEval);

% evaluate exitTime
isOut = any(~isInBox(Y));
if ~any(isOut)
    exitTime = NaN;
    keyboard
    fprintf(1,'Finished at (%.2g,%.2g)\n',Y(1,end),Y(2,end));
    warning('Never left the box')
else
    exitTime = tEval(find(isOut,1,'first'));
end



end
