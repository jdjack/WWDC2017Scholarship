# WWDC2017Scholarship

This was my accepted submission for the WWDC 2017 scholarships. It used Perlin Noise to generate a flow field, and 300 blocks were thrown into it. They would then choose a random set of moves (chosen from TurnLeft, TurnRight, MoveSlow, MoveMed, MoveFast) and try to reach the end point. Using a Genetic Algorithm it will then select the ones which got closest, and in the shortest amount of time, to breed into the next generation. After around 10 Generations, 50% achieve the goal, and after 30, 99% achieve the goal.

The Algorithm is written with Generics and so can be used in other projects should it be wanted, and the full Perlin Noise code can be found on my account, in 1D, 2D and 3D - not just the 2D version used in my project here.
