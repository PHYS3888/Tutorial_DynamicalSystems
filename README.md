# Dynamics Tutorial

In this tutorial we will test our knowledge of dynamical systems using the [Brain Dynamics Toolbox](https://bdtoolbox.org/).
Some of the material from this tutorial is based on information developed by Stuart Heitmann (the mind behind the Brain Dynamics Toolbox).

## Pre-work

### Inline functions

Central to coding is the concept of a function, which in general takes in a set of inputs, does some computation on them, and then gives some set of outputs.
In Matlab, you can can write functions in several ways, most commonly as `.m` files that define the inputs, and how to compute outputs from those inputs.
You can also write simple functions inline, as follows:

```matlab
doMeASquarePlease = @(x) x^2;
```

This function defines a computation to perform on an input, `x`, defined using the notation `@(x)`, to produce an output as the square of the input.
You can now use this function with an input of, say, 3:

```matlab
doMeASquarePlease(3)
```

You can also define functions with multiple inputs:

```matlab
makeACopyPlease = @(a,b) [a,b,a,b];
```

This makes a row-vector containing the two inputs concatenated twice in order:

```matlab
makeACopyPlease(3,5)
```

You can also use it for any data type:

```matlab
contradictMe = @(s) [s,' That is incorrect.'];
```

In this case it adds text to my input string:

```matlab
contradictMe('I think this will be a boring tutorial.')
```

It's also a handy way to plot a function using `fplot` and specifying a range of inputs:

```matlab
f = @(x) sin(x.^2).*exp(-x) - 2*cos(x.^3); % function to plot
fplot(f,[-3,3]) % plot function f over the domain [-3,3]
```

So now you know about `@()` notation for defining inline functions.
It is a handy thing to know about! :smile:

### Setting Up

To complete this tutorial, you will first need to [download the _Brain Dynamics Toolbox_](https://bdtoolbox.org/).

To access the functionality of the _Brain Dynamics Toolbox_, you will need to tell Matlab where to look.
Navigate to the _Brain Dynamics Toolbox_ directory (that you just downloaded and unzipped) and run the following code:

```matlab
% Tell Matlab to look in the current directory:
addpath(pwd)
% Tell Matlab to also look in the models subdirectory:
addpath(fullfile(pwd,'models'))
```

Then move your Matlab directory back to the directory containing the material for this tutorial (all tutorials assume that code will be run from the tutorial directory).

[_Note_: An alternative is to right-click on this directory in the Matlab File Browser and select 'Add to Path -> Selected Folders and Subfolders'.]

:sweat_smile: Now we're ready to get started.

## Part 1: The Linear Ordinary Differential Equation (ODE)

The two-dimensional linear ODE is a good place to start for understanding basic concepts of linear dynamical systems.

Recall the general form from lectures:

![2D Linear ODE](figs/2D_ODE.png)

where _a_, _b_, _c_, _d_ are constants.

### Getting a feel for _The Brain Dynamics Toolbox_ (BDT)

Let's get started exploring this simple system using the _BDT_.
Normally you would have to code the equations, direct Matlab to solve them, and then write your own plotting functions to understand the numerical solutions.
The _BDT_ cuts out all of the implementation overhead so we can get straight into exploring and understanding the dynamics :smile:

For the 2D Linear system, we can start an interactive session as follows:

```matlab
% Define the Linear2DSystem system:
sys = Linear2DSystem();
% Open this system in the GUI:
bdGUI(sys);
```

#### Getting familiar with the interactive plots in _BDT_

1. Verify that the equation solutions are re-evaluated immediately as you change the initial conditions using the slider in the 'Phase Portrait 2D' panel (and also in the 'Time Portrait' panel).
   Set a range of initial conditions on `x` and `y` by selecting the 'Initial Conditions' checkbox (and note that this determines the range of `x` and `y` shown in the plots).
   Verify that you can now set specific initial conditions within this range by pressing the 'RAND' button.
2. Make sure the 'Vector Field' option is turned on (from the 'Phase Portrait 2D' Menu), and watch different random trajectories follow the flow.
    - __NB__: Be aware that some versions of the toolbox visualize this arrows pointing in the direction of flow, while other versions use 'telltales' (which point in the direction of flow as if wind was blowing on a piece of ribbon).
3. Walk through time by dragging the 'Time Domain' slider.
4. What happens to the dynamics when you alter the model parameters using the scale bar?
   Verify that you can change the parameter ranges shown on the scale bar by checking the 'Parameters' tick box.
5. Find parameter values for which the system:
   - decays to the origin, and
   - spirals out towards infinity.

Verify that you understand these two cases in both the 'Time Portrait' and 'Phase Portrait' views.

__:boom: HOT TIP :boom:__: The 'Phase Portrait: Calibrate' option calibrates the axis limits to reveal the full range of the current trajectory.

### Solving a linear system

Recall the following linear system from lectures:

![1D Linear System](figs/2D_system.png)

In lectures, we found that this system has a saddle point at the origin, with eigenvalues `lambda_1 = 2`, `v_1 = [1,1]` and `lambda_2 = -3`, `v_2 = [1,-4]`.

1. Construct the matrix of coefficients for this `[x;y]` linear system in the 2 x 2 matrix, `A`.

2. Numerically verify the eigenvalues that we computed analytically using the `eig` function: `[v,lambda] = eig(A)`.

3. Normalize each eigenvector (columns of `v`) by its first value to verify the eigendirections identified in lectures.

Identify the values of _a_, _b_, _c_, and _d_ for the definition of the linear ODE and use _BDT_ to verify that the vector field is consistent with the qualitative portrait presented the lecture and reproduced below.

_Note:_ Due to the unstable eigendirection, `v_1`, the system will flow out to infinity, so it helps to set a very tight time range by clicking the 'Time Domain' tickbox, e.g., up to a maximum of 1 time unit.

Change the initial conditions to verify that you can get the predicted shapes of trajectories shown in the predicted phase portrait.

_Suggestion:_ You can click the 'Initial Conditions' tickbox to set a range for _x_ and _y_ as -1 to 1, and then explore the system's behavior by clicking the RAND button.

![Phase portrait](figs/LinearDynamicalSystem.png)

### Thinking inside the box :sweat: :octopus:

Imagine that these equations describe the water currents, and that apart from a safe region near the origin, evil octopuses are rampant :octopus::octopus::octopus:.
A rescue chopper is on its way and will arrive in 15 minutes.

If you can be dropped somewhere on the boundary of the safe zone (defined by -1 < _x_ < 1 and -1 < _y_ < 1), where would you choose to be dropped to give yourself the longest time in safe waters (and thus maximize your chances of being saved).

Use the `TimeToExitBox(x0,y0)` function to evaluate when you first leave the box (time in minutes) after starting at `(x0,y0)` (note that this function adds a tiny amount of measurement noise around where you tell it to start). Do not alter this function in answering the following questions.

:question::question::question: __Q1:__
To keep yourself inside the box for as long as possible, where should your start?

:question::question::question: __Q2:__
What is the longest duration that you can keep yourself in the box? Give you answer in minutes to one decimal place.

![Killer Octopus](figs/theBox.png)

#### Solve a linear system

Let's try a system with _a_ = 1, _b_ = -1, _c_ = 10, _d_ = -2.

:question::question::question: __Q3:__
What are the eigenvalues of this system? (Give your answers to two decimal places).

:question::question::question: __Q4:__
Starting the system at some general point, _(x,y)_, what sort of dynamics do you predict?
Select the description that best matches your prediction from the options provided.

Verify your prediction by inputting these parameters into `BDT` and playing with initial conditions across an appropriate range.

## Part 2: Modelling two-person romance :couple: :two_men_holding_hands: :two_women_holding_hands:

Imagine two potential lovers, Carrie and Harrison.
Their feelings for each other can be captured in the two variables `H` (how Harrison feels for Carrie) and `C` (how Carrie feels for Harrison).
The dynamics of `C` depends on two parameters, `c1` and `c2`, and the dynamics of `H` depends on two parameters `h1` and `h2`:

![Carrie and Harrison](figs/HC_system.png)

While understanding dynamical systems is a useful general skill for physicists, this application allows one to obtain supplementary income as a mathematically rigorous relationship psychic at music festivals :revolving_hearts: :crystal_ball:

Imagine that Harrison and Carrie have the same personality and hence respond to each other according to the same rules.
Then we can reduce the four parameters in the full system above to two parameters that reflect this symmetry:

![Harrison Carrie](figs/HC_symmetric.png)

Let's think of time, _t_, as being measured in units of days.

In terms of behaviour in the relationship, can you explain in words what do the parameters _a_ and _b_ correspond to?

### Equally cautious lovers :pensive::pensive:

Let's consider the cautious case, where _a_ < 0 (both avoid throwing themselves at each other) and _b_ > 0 (both respond positively to advances from the other).

Think about the eigenvalues/eigenvectors of this system:
`v_1 = [1,1]`, `lambda_1 = a + b` and `v_2 = [1,-1]`, `lambda_2 = a - b`.
(Do you remember from lectures how to compute these results?)

Let's think about the system's stability, determined by the sign of the two eigenvalues.

- What can you say about the second eigenvalue, `lambda_2`?

- What can you say about the first eigenvalue, `lambda_1`?

- Under what conditions is the fixed point, `(H,C) = (0,0)`, a saddle point?
  - When is it a stable node?

- Sketch the phase portrait (on paper) for both the |_a_| < |_b_| case and the |_a_| > |_b_| case.

---

Now we have some understanding, let's analyse the system numerically.
The system's equations are implemented in the `IdenticalLovers` file for the _BDT_.
Let's load it up:

```matlab
sys = IdenticalLovers();
bdGUI(sys);
```

Have a quick play with the parameters `a` and `b`.

#### More cautious than enthusiastic: `|a| > |b|`

Remember that we analysing the system with _a_ < 0 and _b_ > 0, so |_a_| > |_b_| corresponds to both lovers displaying more cautiousness (|_a_|) than enthusiasm (|_b_|).

What happens to such a relationship in the long term?

Start with |_a_| only slightly larger than |_b_| (e.g., `a = -1.2`, `b = 1`): we should have a stable node at the origin.
Since `|lambda_2| > |lambda_1|`, we expect movement to be faster along the `v_2` direction, and then slower along the `v_1` direction toward the origin.
Play with some different initial conditions and verify that the system displays this behavior.

Look at both the Time Portrait and the Phase Portrait (and don't forget to use the 'Calibrate' option if you can't see the grey circle representing the final state of the system).

What do you expect to happen as you increase |_a_| (make _a_ more negative)?
Can you verify this behavior?

:question::question::question: __Q5:__
Starting at `(H,C) = (-0.5,1)`, and setting `b = 1`, inspect the Time Portrait to determine the highest value of `a` (i.e., minimal |_a_|) for which love dies (`H < 0.1` and `C < 0.1`) within just three days?
Pick from the four options provided: _a_ = -1.8, -1.6, -1.4, -1.2.
_Hint:_ you may wish to use the 'Time Domain' slider (and the 'Data Cursor').


#### Daring and responsive: `|a| < |b|`

Recall that we should see a bifurcation at `|a| = |b|`.
Verify this by again starting at `b=1` and `a=-2`, but now increasing `a` and watching the dynamics.

Can you verify that the `v_1` eigendirection becomes unstable after you cross the bifurcation?

The  `|a| < |b|` case corresponds to both lovers being more daring and sensitive to each other.

- What are the two outcomes for such a relationship?
- What determines which of these two outcomes eventuates?

## Part 3: Sleep-Wake Dynamics

We end by analysing a simple mathematical model of the sleep-wake system, developed here at The University of Sydney.
For this tutorial, we have extracted the core elements of the sleep-wake flip-flop: the mutual inhibition between a sleep-active population and wake-active population.
The model defines the mutual inhibition dynamics between two populations: sleep-active, `Vs`, and wake-active, `Vw`.
We consider how this system exhibits flip-flop dynamics in response to a time-varying sleep drive, `Ds` (biologically, this drive is contributed to by the circadian drive, shown orange in the figure below).

![Sleep-wake system](figs/sleepWakeSystem.png)

### Understanding the model

Let's load up the system:

```matlab
sys = SleepWake();
sleepSys = bdGUI(sys);
```

The model's key variables are `Vs` (sleep) and `Vw` (wake), tell us about how the mean cell-body potential across neurons in each population vary across time.
Here we're going to focus our analysis on the system's fixed points at a given sleep drive, `Ds`.

We start by understanding how population-average voltages can be converted to population-average firing rates using the sigmoid function:

```matlab
Q = @(V) Qmax./(1 + exp(-(V - theta)/sigma));
```

Here we have used the `@(x)` syntax to define an inline Matlab function (as described in the pre-work).

Plot this function, as `Q` as a function of `V`, for the default values of these three parameters:

```matlab
Qmax = 100; % /s
theta = 10; % mV
sigma = 3; % mV
```

:question::question::question:
__Q6:__ Firing-rate function

Using this sigmoidal function, match the mean cell-body potentials relative to resting (mV) to their corresponding firing rates (Hz).
Note where appreciable firing rates (>~1 Hz) emerge.

A sleep state has strong firing in the sleep population (Q > ~1 Hz) but low wake population firing (Q < ~0.1Hz), and vice-versa for a wake state.

### Dynamics in `Vs`-`Vw` space

For default parameters and at sleep drive `Ds = 0`, look at the Phase Portrait of this sleep-wake system.
Click on the 'RAND' button to explore where different initial conditions end up (the grey circle).
Using your knowledge of the relationship between potential (`V`) and firing rate (`Q`), evaluate whether this stable fixed point corresponds to 'sleep' or 'wake'.

Now increase the sleep drive, `Ds = 2`.
Repeat the above, noting where different initial conditions end up, and identifying the final states of the system as either 'sleep' or 'wake'.

Now increase the sleep drive, `Ds = 3`.
Where does the system end up?

### Bifurcation diagram

Our experimenting above demonstrated a dependence of the system's stable states on the sleep drive, `Ds` (including a _bistable region_ where ___both___ sleep and wake are stable).
To understand this structure, we can numerically plot a bifurcation diagram of the system's stable fixed points as a function of `Ds`.
Open the bifurcation panel ('New Panel -> Bifurcation 2D') and use the upper left button (three horizontal lines) do put `Ds` on the _x_-axis and `Vw` on the _y_-axis.

#### Falling asleep

Set an initial condition corresponding to a wake state, and then slide through values of `Ds` across the range `[0,3.5]`.

:question::question::question: __Q7:__
At what critical value of `Ds` does the system 'fall to sleep'?

(:fire: If you want to better resolve the critical point, you can increase the total time in the Time Domain, e.g., to 10s.)

#### Waking up

Set an initial condition corresponding to a sleep state, and then slide through values of `Ds` across the range `[0,3.5]`.

:question::question::question: __Q8:__
At what critical value of `Ds` does the system 'wake up'?

### Simulating a daily circadian rhythm

Biologically, the sleep drive, `Ds`, has two components: an oscillatory circadian component `C` (with an approximately 24h period), and a homeostatic component, `H`, that grows with time awake and decays during recovery sleep.
We can simulate this daily cycle by varying `Ds` up and down.

Switch on the "Evolve" button, which starts the next simulation with an initial condition corresponding to the final state of the previous simulation.
Drag the sleep drive, `Ds`, up and down, simulating cycling between sleep and wake, noting the effect of hysteresis in the model.

Do a few sweeps left and right, saying 'sleep' and 'wake' out aloud whenever the system makes a transition :yum:

#### :fire::fire: [Optional]: Algorithmic sweeping

Instead of manually sliding through values of `Ds`, you can also tell the toolbox to do this sweep using code.
First, make sure the "Evolve" button is switched on, then set a range to sweep over, e.g., `DsRange = [linspace(0,3.5,50),linspace(3.5,0,50)];` (for a resolution of 50 points in both directions).

You can then tell the toolbox to sweep through this range as:

```matlab
for i = 1:length(DsRange)
    sleepSys.par.Ds = DsRange(i);
end
```

### Modeling narcolepsy by weakening the flip-flop

One of the theories of how the sleep disorder, narcolepsy, manifests, is through a weakening of the mutual inhibition between the wake-active and sleep-active populations.
Perhaps people born with a reduced level of this inhibition have less distinctive sleep and wake states (and therefore display narcoleptic symptoms)?

The `v_sw` parameter controls the inhibition strength from the wake population to the sleep population, and in normal humans has an estimated value `v_sw = -2.1`.

Map out the stable sleep and wake states as a function of `Ds` to construct bifurcation diagrams as before, but now repeat this process for progressive reductions in magnitude of wake-to-sleep inhibition, `|v_sw|` (you can use the 'Bifurcation 2D -> Clear' functionality to clean things up).

Repeat this process, progressively decreasing the magnitude of `v_sw`, to estimate the value of `v_sw` at which the bistable region disappears.

:question::question::question: __Q9:__
At what value of `v_sw` does the bistable region disappear?

## :fire: I want more! :fire:

- If you're interested, there are some fascinating other systems in the `models` directory of the Brain Dynamics Toolbox.
- Some papers describing the sleep-wake model developed here in the School of Physics are [here](https://dx.doi.org/10.1098/rsta.2011.0120), [here](https://dx.doi.org/10.1103/physreve.78.051920), and [here](https://dx.doi.org/10.1016/j.jtbi.2010.02.028).
