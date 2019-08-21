# Tutorial: Dynamical Systems
In this tutorial we will test our knowledge of dynamical systems using the [Brain Dynamics Toolbox](https://bdtoolbox.org/).
Some of the material from this tutorial is based on information developed by Stuart Heitmann (the mind behind the Brain Dynamics Toolbox).

### Setting up
You will first need to download the [Brain Dynamics Toolbox](https://bdtoolbox.org/).
Go to [the website](https://bdtoolbox.org/), then scroll down and press the 'Subscribe and Download' button.
You will then receive an email that will provide you with a link to download the software.
To access the functionality of the Brain Dynamics Toolbox, you will need to tell Matlab where to look.

Navigate to the directory in which the Brain Dynamics Toolbox is installed and run:
```matlab
% Tell Matlab to look in the current directory:
addpath(pwd)
% Tell Matlab to also look in the models subdirectory:
addpath(fullfile(pwd,'models'))
```

This tutorial assumes that you will be running all code from within this tutorial directory.
Let's head head back to the tutorial directory; we're ready to get started.

## Part 1: The Linear ODE

The two-dimensional linear ordinary differential equation is a good place to start for understanding basic concepts of linear dynamical systems.

Recall the general form from lectures:
```math
dx/dt = ax + by
dy/dt = cx + dy
```
where `a`, `b`, `c`, `d` are constants.

### Getting a feel for The Brain Dynamics Toolbox

Let's get started exploring this simple system using the BDToolbox.
Normally you would have to code the equations, direct Matlab to solve them, and then write your own plotting functions to understand the numerical solutions.
The BDToolbox cuts out all of the implementation overhead so we can get straight into exploring and understanding the dynamics.

For the Linear ODE system, we can get an interactive session started as follows:
```matlab
% Define the LinearODE system as sys:
sys = LinearODE();
% Open this system in the GUI:
bdGUI(sys);
```

#### Getting familiar with the interactive plots
__HOT TIP__: The 'Phase Portrait: Calibrate Axes' option sets the axis limits to reveal the full range of the current trajectory.
1. Verify that the equation solutions are re-evaluated immediately as you change the initial conditions using the slider (also in the 'Time Domain' panel). Set a range of initial conditions on `x` and `y` by selecting the 'Initial Conditions' checkbox (and note that this determines the range of `x` and `y` shown in the plots). Verify that you can now set specific initial conditions within this range by pressing the 'RAND' button.
2. Turn on the 'Vector Field' option and watch different random trajectories follow the flow. (_Note_: the flow is indicated using 'tell-tales' that indicate the trail of a particle placed in the vector field).
3. Walk through time by dragging the 'Time Domain' slider.
4. What happens to the dynamics when you alter the model parameters using the scale bar? Verify that you can change the parameter ranges shown on the scale bar by checking the 'Parameters' tick box.
5. Find parameter values for which the system: (i) decays to the origin, and (ii) spirals out towards infinity.
Verify that you understand these two cases in the 'Time Portrait' and the 'Phase Portrait' views.

### Solving a linear system

Recall the linear system from lectures:

```math
dx/dt = x + y
dy/dt = 4x - 2y
```

In lectures, we found that this system has a saddle point at the origin, with eigenvalues `lambda_1 = 2`, `v_1 = [1,1]` and `lambda_2 = -3`, `v_2 = [1,-4]`.

Construct the matrix of coefficients for this `[x;y]` linear system in the 2 x 2 matrix, `A`.

Numerically verify the eigenvalues that we computed analytically using the `eig` function: `[v,lambda] = eig(A)`.

Normalize each eigenvector (columns of `v`) by its first value to verify the eigendirections identified above.

Identify the values of `a,b,c,d` for the definition of the linear ODE and use the BDtoolbox to verify that the vector field is consistent with the qualitative portrait presented the lecture (reproduced below).
Change the initial conditions to verify that you can get the predicted shapes of trajectories shown in the predicted phase portrait.

![](figs/LinearDynamicalSystem.png)

#### :question::question::question: Thinking inside the box :sweat:
Imagine that these equations describe the water currents, and that apart from a safe region near the origin, evil octopuses :octopus::octopus::octopus: are rampant.
A rescue chopper is on its way, in 5 hours.
If you can be dropped anywhere within the safe zone, where would you pick to be dropped to give yourself the longest time in safe waters (and thereby maximize your chances of being saved).

Imagine a box defined by `-1 < x < 1` and `-1 < y < 1`.
Where in this region would you start the system for it to stay as close as possible to the origin for as long as possible?

Use the `TimeToExitBox` function to evaluate when you first leave the box (note it adds a tiny amount of noise around where you tell it to start).
What is the longest duration that you can keep the system in the box?
Where did you start the system?

![](figs/theBox.png)

#### :question::question::question: Solve a linear system

Let's try a system with `a = 1`, `b = -1`, `c = 10`, `d = -2`.

What are the eigenvalues of this system?
What sort of dynamics should it have?

Verify your prediction by inputting these parameters into the BDtoolbox and playing with initial conditions across an appropriate range.

## Part 2: Modelling two-person romance :couple: :two_men_holding_hands: :two_women_holding_hands:

Imagine two potential lovers, Carrie and Harrison.
Their feelings for each other can be captured in the two variables `H` (how Harrison feels for Carrie) and `C` (how Carrie feels for Harrison).
The dynamics of `C` depends on two parameters, `c1` and `c2`, and the dynamics of `H` depends on two parameters `h1` and `h2`:

```matlab
dH/dt = h1*H + h2*C
dC/dt = c1*H + c2*C
```

While understanding dynamical systems is a useful general skill for physicists, this application allows one to obtain supplementary income as a mathematically rigorous relationship psychic at music festivals :revolving_hearts::crystal_ball:

Imagine that Harrison and Carrie have the same personality and hence respond to each other according to the same rules.
Then we can reduce the four parameters in the full system above to two parameters that reflect this symmetry:

```matlab
dH/dt = a*H + b*C
dC/dt = b*H + a*C
```

Let's think of time, `t`, as being measured in units of days.

In terms of behavior in the relationship, what do the parameters `a` and `b` correspond to here?

### Equally cautious lovers :pensive::pensive:

Let's consider the cautious case, where `a < 0` (both avoid throwing themselves at each other) and `b > 0` (both respond positively to advances from the other).

Think about the eigenvalues/eigenvectors of this system:
`v_1 = [1,1]`, `lambda_1 = a+b` and `v_2 = [1,-1]`, `lambda_2 = a-b`.

Let's think about the system's stability, determined by the sign of the two eigenvalues.

What can you say about our second eigenvalue, `lambda_2`?

What can you say about the first eigenvalue, `lambda_1`?

Under what conditions is the fixed point, (H,C) = (0,0), a saddle point?
When is it a stable node?

Sketch the phase portrait in both the `|a| < |b|` case and the `|a| > |b|` case.

---

Now we have some understanding, let's analyze the system numerically.
The system's equations are implemented in the `IdenticalLovers.m` file for the Brain Dynamics Toolbox.
Let's load it up:

```matlab
sys = IdenticalLovers();
bdGUI(sys);
```

Have a quick play with the parameters `a` and `b`.

#### More cautious than enthusiastic: `|a| > |b|`
This condition corresponds to both lovers displaying more cautiousness than enthusiasm.

What happens to such a relationship in the long term?

Start with `|a|` only slightly larger than `|b|` (e.g., `a = -1.2`, `b = 1`), and then start increasing `|a|`.
Explain the change in the dynamics in terms of the eigenvalues and eigenvectors of the system?
(Look in both the Time Portrait and the Phase Portrait).

:question::question::question:
Starting at `(H,C) = (-0.5,1)`, and setting `b = 1`, what is the critical value of `a` that determines whether love will die within five days?

#### Daring and responsive: `|a| < |b|`

The  `|a| < |b|` case corresponds to both lovers being more daring and sensitive to each other.
What are the two outcomes for such a relationship?
What determines which of these two outcomes eventuates?

## Part 3: Sleep-Wake Dynamics

We end by analyzing a simple mathematical model of the sleep-wake system, see [here](https://dx.doi.org/10.1098/rsta.2011.0120), [here](https://dx.doi.org/10.1103/physreve.78.051920), and [here](https://dx.doi.org/10.1016/j.jtbi.2010.02.028) for papers analyzing the full system.

For this tutorial, we have extracted the core elements of the sleep-wake flip-flop: the mutual inhibition between a sleep-active population and wake-active population.
The model defines the mutual inhibition dynamics between two populations: sleep-active, `Vs`, and wake-active, `Vw`.
We consider how this system exhibits flip-flop dynamics in response to a time-varying sleep drive, `Ds` (biologically, this drive is contributed to by the circadian drive, shown orange in the figure below).

![](figs/sleepWakeSystem.png)


### Understanding the model

Let's load up the system:
```matlab
sys = SleepWake();
bdGUI(sys)
```

The model's core variables are `Vs` (sleep) and `Vw` (wake), tell us about how the mean cell-body potential across neurons in each population vary across time.
Here we're going to focus our analysis on the system's fixed points at a given sleep drive, `Ds`.

We start by understanding how population-average voltages can be converted to population-average firing rates using the sigmoid function:
```matlab
Q = @(V) Qmax./(1+exp(-(V-theta)/sigma));
```

Plot this function, as `Q` as a function of `V`, for the default values of these three parameters:
```matlab
Qmax = 100; % /s
theta = 10; % mV
sigma = 3; % mV
```

#### :question::question::question: Firing rate function
Using this sigmoidal function, match the mean cell-body potentials (mV) to their corresponding firing rates (Hz).
Note where appreciable firing rates (~>1 Hz) emerge.

### Dynamics in `Vs`-`Vw` space
For default parameters and at a given sleep drive `Ds = 0`, look at the system's phase portrait.
Click on the 'RAND' button to explore where different initial conditions end up.
Using your knowledge of the relationship between potential (`V`) and firing rate (`Q`), evaluate whether this fixed point corresponds to 'sleep' or 'wake'.

Now increase the sleep drive, `Ds = 2`.
Repeat the above, noting where different initial conditions end up, and identifying the final states of the system as either 'sleep' or 'wake'.

Now increase the sleep drive, `Ds = 3`.
Where does the system end up?

### Bifurcation diagram

Our experimenting above demonstrated a dependence of the system's stable states on the sleep drive, `Ds` (including a _bistable region_).
To understand this structure, we can numerically plot a bifurcation diagram of the system's stable fixed points as a function of `Ds`.
Open the bifurcation panel ('New Panel -> Bifurcation') and use the button (three horizontal lines) do put `Ds` on the x-axis and `Vw` on the y-axis.

#### :question::question::question: Falling asleep
Set an initial condition corresponding to a wake state, and then slide through values of `Ds` across the range `[0,3.5]`.
At what critical value of `Ds` does the system 'fall to sleep'?

#### :question::question::question: Waking up
Set an initial condition corresponding to a sleep state, and then slide through values of `Ds` across the range `[0,3.5]`.
At what critical value of `Ds` does the system 'wake up'?

### Simulating a daily circadian rhythm
Biologically, the sleep drive, `Ds`, has two components: an oscillatory circadian component `C` (with an approximately 24h period), and a homeostatic component, `H`, that grows with time awake and decays during recovery sleep.
We can simulate this daily cycle by varying `Ds` up and down.
Turn on the `evolve` button, which starts the next simulation with an initial condition corresponding to the final state of the previous simulation.
Drag the sleep drive, `Ds`, up and down, simulating cycling between sleep and wake, noting the effect of hysteresis in the model.

#### :question::question::question: Modeling narcolepsy by weakening the flip-flop
One of the theories of how the sleep disorder, narcolepsy, manifests, is through a weakening of the mutual inhibition between the wake- and sleep-active populations.
Perhaps people born with a reduced level of inhibition have less robustness in their sleep and wake states?

The `v_sw` parameter controls the interaction from the wake population to the sleep population.
Simulate a reduction in wake-to-sleep inhibition and determine the value of `v_sw` for which the bistable region disappears?

#### :fire: Extras :fire:

If you're interested, you can keep playing with more systems listed in the `models` directory of the BDToolbox.
