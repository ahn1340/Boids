# Boids
MATLAB implementation of Boids simulation, as part of school project

[Boids][boids] is an artificial life program that simulates the flocking behavior of birds. 

[boids]: https://en.wikipedia.org/wiki/Boids

The movement of boids is governed by three principles:
1. separation: each boid steers away from all other neighborin boids to not collide.
2. alignment: each boid steers towards the average directions of other neighboring boids.
3. cohesion: each boid steers towards the center position of the neighboring boids.

The three principles give rise to the emergent behavior of boids flocking with each other, resembling that of birds.

This implementation also includes predators that chase the boids. Boids try to run away from the predators when they are within a certain distance.

## How to run
Simply run Boids.m.


## How to change setting
Boids.m contains the parameters that determine:
1. number of boids
2. number of predators
3. height & width of the world
4. simulation length
5. maximum speed of boids and predators

Play around with the settings.

The initial positions and velocities of boids and predators are always random, so each simulation will produce a unique outcome.

## Boids without predators
![caption](videos/without-predators.gif)

## Boids with predators
![caption](videos/with-predators.gif)
