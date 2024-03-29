function sys = IdenticalLovers()
    % IdenticalLovers  Symmetric Linear ODE in two variables:
    %        H'(t) = a*H(t) + b*C(t)
    %        C'(t) = b*H(t) + a*C(t)
    %   for use with the Brain Dynamics Toolbox.
    %
    % Example 1: Using the Brain Dynamics graphical toolbox
    %   sys = IdenticalLovers();      % construct the system struct
    %   gui = bdGUI(sys);             % open the Brain Dynamics GUI
    %
    % Example 2: Using the Brain Dynamics command-line solver
    %   sys = LinearODE();                              % system struct
    %   sys.pardef = bdSetValue(sys.pardef,'a',-2);      % parameter a=-2
    %   sys.pardef = bdSetValue(sys.pardef,'b',1);     % parameter b=1
    %   sys.vardef = bdSetValue(sys.vardef,'x',rand);   % variable x=rand
    %   sys.vardef = bdSetValue(sys.vardef,'y',rand);   % variable y=rand
    %   tspan = [0 10];                                 % soln time span
    %   sol = bdSolve(sys,tspan);                       % call the solver
    %   tplot = 0:0.1:10;                               % plot time domain
    %   Y = bdEval(sol,tplot);                          % extract solution
    %   plot(tplot,Y);                                  % plot the result
    %   xlabel('time'); ylabel('x,y');
    %
    % Authors
    %   Stewart Heitmann (2017a,2018a)

    % Copyright (C) 2016-2018 QIMR Berghofer Medical Research Institute
    % All rights reserved.
    %
    % Redistribution and use in source and binary forms, with or without
    % modification, are permitted provided that the following conditions
    % are met:
    %
    % 1. Redistributions of source code must retain the above copyright
    %    notice, this list of conditions and the following disclaimer.
    %
    % 2. Redistributions in binary form must reproduce the above copyright
    %    notice, this list of conditions and the following disclaimer in
    %    the documentation and/or other materials provided with the
    %    distribution.
    %
    % THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    % "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    % LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
    % FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
    % COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
    % INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
    % BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    % LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    % CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
    % LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
    % ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    % POSSIBILITY OF SUCH DAMAGE.

    % Handle to our ODE function
    sys.odefun = @odefun;

    % ODE parameter definitions
    sys.pardef = [struct('name','a', 'value',-2, 'lim',[-4 0]);
                  struct('name','b', 'value',1,  'lim',[0 4])];
    % ODE variable definitions
    sys.vardef = [ struct('name','H', 'value',2*rand-1);
                   struct('name','C', 'value',2*rand-1) ];

    % Latex (Equations) panel
    sys.panels.bdLatexPanel.title = 'Equations';
    sys.panels.bdLatexPanel.latex = {
        '$\textbf{Identical Lovers}$';
        '';
        'System of linear ordinary differential equations';
        '{ }{ }{ } $\dot H(t) = a\,H(t) + b\,C(t)$';
        '{ }{ }{ } $\dot C(t) = b\,H(t) + a\,C(t),$';
        'where $a,b$ are constants.';
        };

    % Time Portrait panel
    sys.panels.bdTimePortrait = [];

    % Phase Portrait panel
    sys.panels.bdPhasePortrait.nullclines = 'off';
    sys.panels.bdPhasePortrait.vectorfield = 'on';
    % sys.panels.bdPhasePortrait = [];

    % Solver panel
    % sys.panels.bdSolverPanel = [];

    % Default time span (optional)
    sys.tspan = [0 5];

    % Specify the relevant ODE solvers (optional)
    sys.odesolver = {@ode45,@ode23,@odeEul};

    % ODE solver options (optional)
    sys.odeoption.RelTol = 1e-6;        % Relative Tolerance
    sys.odeoption.Jacobian = @jacfun;   % Handle to Jacobian function
end

% The ODE function.
% The variables Y and dYdt are both (2x1) vectors.
% The parameters a,b are scalars.
function dYdt = odefun(t,Y,a,b)
    dYdt = [a b; b a] * Y;              % matrix multiplication
end
