function exitTime = TimeToExitBox(x0,y0,actuallyRandom,maxT)
% Returns time to exit a box defined by the [-1,1] interval
% in x and y

%-------------------------------------------------------------------------------
% Check inputs:
if nargin < 3
    actuallyRandom = false;
end
if nargin < 4
    maxT = 100;
end
%-------------------------------------------------------------------------------

isInBox = @(x) (x >= -1 & x <= 1);

if ~isInBox(x0) || ~isInBox(y0)
    error('You have to start in the box!');
end
if ~(x0==-1 || x0==1 || y0==-1 || y0==1)
    warning('You know you''re supposed to start on the edge of the box, don''t you?!')
end

% Perturb initial condition a little:
tinyNoise = 1e-13;
if actuallyRandom
    x0 = x0 - rand*tinyNoise*mySign(x0);
    y0 = y0 - rand*tinyNoise*mySign(y0);
else
    x0 = x0 - tinyNoise*mySign(x0);
    y0 = y0 - tinyNoise*mySign(y0);
end

% Set up the dynamics:
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
    % keyboard
    fprintf(1,'Finished at (%.2g,%.2g)\n',Y(1,end),Y(2,end));
    warning('Never left the box')
else
    exitTime = tEval(find(isOut,1,'first'));
end


%-------------------------------------------------------------------------------
function out = mySign(x)
    if x==0
        out = 1;
    else
        out = sign(x);
    end
end

end
