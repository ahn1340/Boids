% Boids class

classdef Boid < handle
    properties
        coord = [0, 0];                     % boid's position in world
        velocity = [0, 0];                  % boid's velocity
        neighbors = [];                     % other boids that are close to the boid
        close_neighbors = [];               % other boids that are too close.
        color_r = 0;                        %  boid's
        color_g = 0;                        %  color
        color_b = 0;                        %  values
        height = 0;                         % Height of the world.
        width = 0;                          % Width of the world.
        max_speed = 0;                      % Maximum speed of the boid.
    end
    methods
        % Method that sets sets the height and width of the world for boid.
        % Input: height of world, width of world
        function obj = set_height_and_width(obj, height, width)
            obj.height = height;
            obj.width = width;
        end
        
        % Method that sets the maximum speed of the boid.
        % Input: maximum speed of boid
        function obj = set_max_speed(obj, max_speed)
            obj.max_speed = max_speed;
        end
        
        % Method that updates the coordinate of the boid according to its
        % new velocity. The new velocity is adjusted by its previous
        % velocity, and the 5 rules, which are cohesion, separation,
        % alignment, edge avoidance, and predator avoidance.
        % Input : Array of boids, Array of predators
        function obj = move(obj, boids, predators)
            obj.findNeighbors(boids);
            [v1x, v1y] = obj.avoid_edge();
            [v2x, v2y] = obj.cohesion();
            [v3x, v3y] = obj.separation();
            [v4x, v4y] = obj.alignment();
            [v5x, v5y] = obj.avoid_predators(predators);
            % New velocity is previous velocity plus change of velocity due
            % to the rules.
            obj.velocity(1) = obj.velocity(1) + (v1x + v2x + v3x + v4x + v5x) / 2;
            obj.velocity(2) = obj.velocity(2) + (v1y + v2y + v3y + v4y + v5y) / 2;
            obj.limit_speed();
            obj.coord(1) = obj.coord(1) + obj.velocity(1);
            obj.coord(2) = obj.coord(2) + obj.velocity(2);
            % Reset the neighbors arrays for the next iteration.
            obj.neighbors = [];
            obj.close_neighbors = [];
        end
        
        % method that finds other nearby Boids and remember the
        % information. The method calculates the distance between
        % itobj and all the other Boids, then store all Boids whose
        % distance is smaller than 10 in neighbors array.
        function obj = findNeighbors(obj, boids)
            for i = 1 : numel(boids)
                if boids(i) ~= obj
                    % Distance formula.
                    distance = sqrt((obj.coord(1) - boids(i).coord(1))^2 ...
                        + (obj.coord(2) - boids(i).coord(2))^2);
                    % All boids whose distance is less than 30 is now the
                    % boid's neighbor. Cohesion rule applies for them.
                    if distance <= 25
                        obj.neighbors = [obj.neighbors, boids(i)];
                    end
                    % All boids whose distance is less than 5 is now the
                    % boid's close neighbor. Separation rule applies for
                    % them.
                    if distance <= 5
                        obj.close_neighbors = [obj.close_neighbors, boids(i)];
                    end
                end
            end
        end
        
        % Rule 1. Method that calculates the velocity change due to cohesion
        % factor. The method calculates the average position of its
        % neighbors, and returns a vector that is from the boid's current
        % position to the average position divided by a coefficient.
        function [x, y] = cohesion(obj)
            avg_position = [0, 0];
            % If there is no neighbor, then return [0, 0].
            if numel(obj.neighbors) == 0
                x = 0;
                y = 0;
            else
                for i = 1 : numel(obj.neighbors)
                    avg_position = avg_position + obj.neighbors(i).coord;
                end
                avg_position = avg_position / numel(obj.neighbors);
                x = (avg_position(1) - obj.coord(1)) / 20;
                y = (avg_position(2) - obj.coord(2)) / 20;
            end
        end
        
        % Rule 2. Method that calculates the velocity change due to alignment
        % factor. The method calculates the average velocity, divides it by
        % a coefficient, and returns the result.
        function [x, y] = alignment(obj)
            if numel(obj.neighbors) == 0
                x = 0;
                y = 0;
            else
                avg_vector = [0, 0];
                for i = 1 : numel(obj.neighbors)
                    neighbor = obj.neighbors(i);
                    avg_vector(1) = avg_vector(1) + neighbor.velocity(1);
                    avg_vector(2) = avg_vector(2) + neighbor.velocity(2);
                end
                x = avg_vector(1) / numel(obj.neighbors) / 4;
                y = avg_vector(2) / numel(obj.neighbors) / 4;
            end
        end
        
        % Rule 3. Method that calculates the velcotiy change due to
        % separation factor. First, calculate the coordinate difference
        % between the boid and its close neighbors, add them all, and
        % average them. Them. change the sign of the vector so that it
        % faces away from the other boids, and divide it by a coefficient.
        function [x, y] = separation(obj)
            goal_pos = [0, 0];
            if numel(obj.close_neighbors) == 0
                x = 0;
                y = 0;
            else
                for i = 1 : numel(obj.close_neighbors)
                    neighbor = obj.close_neighbors(i);
                    goal_pos(1) = goal_pos(1) -...
                        (neighbor.coord(1) - obj.coord(1));
                    goal_pos(2) = goal_pos(2) -...
                        (neighbor.coord(2) - obj.coord(2));
                end
                x = goal_pos(1) / numel(obj.close_neighbors) / 2;
                y = goal_pos(2) / numel(obj.close_neighbors) / 2;
            end
        end
        
        % Rule 4. Method that makes the boid turn if it is close to the
        % border. The method checks if the boid is approaching the edge,
        % and if it is, then the method returns a vector which faces the
        % opposite direction of the boid's direction.
        function [x, y] = avoid_edge(obj)
            x = 0;
            y = 0;
            % If the boid is reaching the northern border, then the vector
            % returned is [1.5, 0].
            if obj.coord(1) < obj.height / 10
                x = 1.5;
                % If the boid is reaching the southern border, then the vector
                % returned is [-1.5, 0].
            elseif obj.coord(1) > obj.height - (obj.height / 10);
                x = -1.5;
            end
            % If the boid is reaching the western border, then the vector
            % returned is [0, 1.5].
            if obj.coord(2) < obj.width / 10
                y = 1.5;
                % If the boid is reaching the eastern border, then the vector
                % returned is [0, -1.5].
            elseif obj.coord(2) > obj.width - (obj.width / 10);
                y = -1.5;
            end
        end
        
        % Rule 5. Method that makes boid turn away from the predator.
        % If a predator is within a certain distance from the boid, then
        % it returns a vector that faces to the opposite direction of the
        % predator, divided b a coefficient.
        % Input: array of predators
        function [x, y] = avoid_predators(obj, predators)
            x = 0;
            y = 0;
            % If there is no predator, then the method does not affect
            % the boid's direction.
            if predators == 0
                return;
            else
                if numel(predators) ~= 0
                    num_close_predators = 0;
                    for i = 1 : numel(predators)
                        % Calculate distance between boid and predator.
                        dx = obj.coord(1) - predators(i).coord(1);
                        dy = obj.coord(2) - predators(i).coord(2);
                        distance = sqrt(dx^2 + dy^2);
                        % If distance is closer than 30, then calculate
                        % vector that faces directly opposite from predator.
                        if distance < 30
                            num_close_predators = num_close_predators + 1;
                            x = x + (dx * 30 / distance);
                            y = y + (dy * 30 / distance);
                        end
                    end
                    % Add all vectors created from each nearby predators,
                    % and divide it by the number of predators. Then,
                    % return the resulting vector.
                    if num_close_predators ~= 0
                        x = x / num_close_predators / 15;
                        y = y / num_close_predators / 15;
                    end
                end
            end
        end
        
        
        
        % Method that checks the speed of the boid, and reduces the speed
        % if it exceeds the limit speed.
        function obj = limit_speed(obj)
            curr_speed = sqrt(obj.velocity(1)^2 + obj.velocity(2)^2);
            if curr_speed > obj.max_speed
                obj.velocity = obj.velocity * (obj.max_speed / curr_speed);
            end
        end
    end
end

