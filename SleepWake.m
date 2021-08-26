function sys = SleepWake()
    % SleepWake  The Phillips-Robinson Sleep ModelG
    %   Implements the system of linear ordinary differential equations
    %        ts*Vs'(t) = -Vs(t) + v_sw*Qw(t) + Ds
    %        tw*Vw'(t) = -Vw(t) + v_ws*Qs(t) + Dw
    %   for use with the Brain Dynamics Toolbox.
    %
    % Example 1: Using the Brain Dynamics graphical toolbox
    %   sys = SleepWake();      % construct the system struct
    %   gui = bdGUI(sys);       % open the Brain Dynamics GUI
    %
    % Example 2: Using the Brain Dynamics command-line solver
    %   sys = LinearODE();                              % system struct
    %   sys.pardef = bdSetValue(sys.pardef,'a',-2);     % parameter a=-2
    %   sys.pardef = bdSetValue(sys.pardef,'b',1);      % parameter b=1
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
    sys.pardef = [struct('name','ts','value',0.1,'lim',[0.1,1]);
                   struct('name','tw','value',0.1,'lim',[0.1,1]);
                   struct('name','v_sw','value',-2.1,'lim',[-2.5,-1.0]);
                   struct('name','v_ws','value',-1.8,'lim',[-2.5,-1.0]);
                   struct('name','Dw','value',1.3,'lim',[1,1.5]);
                   struct('name','Ds','value',0,'lim',[0,3.5])];

    % ODE variable definitions
    sys.vardef = [struct('name','Vs','value',0,'lim',[-20,4]);
                  struct('name','Vw','value',-15,'lim',[-20,4])];

    % Latex (Equations) panel
    sys.panels.bdLatexPanel.title = 'Equations';
    sys.panels.bdLatexPanel.latex = {
        '$\textbf{The Phillips-Robinson Sleep-Wake Model}$'
        ''
        'Mean cell-body potentials on sleep-active, $V_s$, and wake-active, $V_w$, populations of neurons'
        '{ }{ }{ } $t_s \dot V_s(t) = -V_s(t) + \nu_{sw}Q_w(t) + D_s,$'
        '{ }{ }{ } $t_w \dot V_w(t) = -V_w(t) + \nu_{ws}Q_s(t) + D_w,$'
        'where $t_s, t_w, \nu_{sw}, \nu_{ws}, D_w$ are constants.'
        '$D_s$ is the oscillatory drive to the sleep-active population.'
        };

    % Time Portrait panel
    sys.panels.bdTimePortrait = [];

    % Phase Portrait panel
    sys.panels.bdPhasePortrait.nullclines = 'off';

    % Solver panel
    % sys.panels.bdSolverPanel = [];

    % Default time span (optional)
    sys.tspan = [0,5];

    % Specify the relevant ODE solvers (optional)
    sys.odesolver = {@ode45,@ode23,@odeEul};

    % ODE solver options (optional)
    sys.odeoption.RelTol = 1e-6;        % Relative Tolerance
    sys.odeoption.InitialStep = 0.01;   % Required by odeEul solver
end

% The ODE function.
% The variables Y and dYdt are both (2x1) vectors.
function dYdt = odefun(t,Y,ts,tw,v_sw,v_ws,Dw,Ds)
    % Unpack variables from Y:
    Vs = Y(1); % sleep voltage
    Vw = Y(2); % wake voltage

    % Convert voltages to mean firing rates:
    Qs = sigmoid(Vs);
    Qw = sigmoid(Vw);

    % Convert voltages to mean firing rates:
    dVs_dt = 1/ts*(-Vs + v_sw*Qw + Ds);
    dVw_dt = 1/tw*(-Vw + v_ws*Qs + Dw);

    % Output dYdt
    dYdt = [dVs_dt; dVw_dt];
end

% Computing mean firing rate from mean cell-body potential
function Q = sigmoid(V)
    Qmax = 100; % /s
    theta = 10; % mV
    sigma = 3; % mV
    Q = Qmax./(1+exp(-(V-theta)/sigma));
end
