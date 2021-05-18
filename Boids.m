% Project - Boid Simulation
% Author: Jin Woo Ahn

clear all;
close all;

numBoids = 70;      % Number of boids to be simulated.
numPreds = 0;      % Number of predators to be simulated.
height = 300;       % Height of the world.
width = 300;        % Width of the world.
iteration = 1000;    % Number of simulation times.
b_max_speed = 2;      % Maximum speed of boids.
p_max_speed = 1.8;      % Maximum speed of predators.

% Create a World object.
world = World(height, width);

% Create an array of Boid objects.
boids(numBoids) = Boid;

% Create an array of Predator objects.
if numPreds == 0
    preds = 0;
else
    preds(numPreds) = Predator;
end


% Initialize the boids with random color, coordinate, and velocity.
for i = 1 : numBoids
    boids(i).color_r = rand;
    boids(i).color_g = rand;
    boids(i).color_b = rand;
    boids(i).velocity = [rand * (b_max_speed * 2) - (b_max_speed / 2), rand * (b_max_speed * 2) - (b_max_speed / 2)];
    boids(i).coord = [(rand * height - 1) + 1, (rand * width - 1) + 1];
    boids(i).set_height_and_width(height, width);
    boids(i).set_max_speed(b_max_speed);
end

% Initialize the preds with random coordinate and velocity.
if numPreds ~= 0
    for i = 1 : numel(preds)
        preds(i).coord = [(rand * height - 1) + 1, (rand * width - 1) + 1];
        preds(i).set_max_speed(b_max_speed);
        preds(i).set_height_and_width(height, width);
        preds(i).velocity = [rand * (p_max_speed * 2) - (p_max_speed / 2), rand * (p_max_speed * 2) - (p_max_speed / 2)];
    end
end

% Create video writer object.
video = VideoWriter('Boids.avi', 'Motion JPEG AVI');
% Set the frame rate.
video.FrameRate = 20;
% Open the video file.
open(video);

% Start the simulation.
for t = 1 : iteration
    % Simulation of boids.
    for i = 1 : numBoids
        boids(i).move(boids, preds);
        world.draw_boids(boids(i));
    end
    % Simulation of predators.
    if numPreds ~= 0
        for j = 1 : numel(preds)
            preds(j).move(boids);
            world.draw_predator(preds(j));
        end
    end
    writeVideo(video, imresize(world.outputWorld, [height, width]));
end

% Close video.
close(video);


