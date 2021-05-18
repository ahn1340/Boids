% Predator class. Subclass of Boid.
classdef Predator < Boid
    methods
        function obj = move(obj, boids)
            [v1x, v1y] = obj.avoid_edge();
            [v2x, v2y] = obj.chase(boids);
            obj.velocity(1) = obj.velocity(1) + (v1x + v2x) / 2;
            obj.velocity(2) = obj.velocity(2) + (v1y + v2y) / 2;
            obj.limit_speed();
            obj.coord(1) = obj.coord(1) + obj.velocity(1);
            obj.coord(2) = obj.coord(2) + obj.velocity(2);
        end
        % Method that makes preds chase boids when they are near them.
        function [x, y] = chase(obj, boids)
            % First, find boids that are close to the pred.
            obj.findNeighbors(boids);
            % Then, try to move to the average position of the neighbors,
            % which makes the pred move towards the flock of boids.
            [x, y] = obj.cohesion();
        end
            
    end
end
