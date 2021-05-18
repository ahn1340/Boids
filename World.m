% World class

classdef World < handle
    properties
        world = [];     % World matrix
        green_mat = []; % matrix containing green channel of the world
        blue_mat = [];  % matrix containing blue channel of the world
        red_mat = [];   % matrix containing red channel of the world
        height = 0;     % row index of world
        width = 0;      % column index of world
    end
    methods
        % Constructor.
        function obj = World(height, width)
            obj.height = height;
            obj.width = width;
            % Initialize all world matrices as zeros.
            obj.world = zeros(height, width, 3);
            obj.green_mat = zeros(height, width);
            obj.blue_mat = zeros(height, width);
            obj.red_mat = zeros(height, width);
        end
            
        % Method that outputs the matrix that will be read into video.
        % Output: world matrix
        function mat = outputWorld(obj) 
            obj.world = cat(3, obj.red_mat, obj.green_mat, obj.blue_mat);
            mat = obj.world;
            % Make all world matrices as zeros for next generation.
            obj.red_mat = zeros(obj.height, obj.width);
            obj.green_mat = zeros(obj.height, obj.width);
            obj.blue_mat = zeros(obj.height, obj.width);
            obj.world = zeros(obj.height, obj.width, 3);
        end

        % Method that draws boids on the matrix.
        % Input: Boid object
        function obj = draw_boids(obj, boid)
            % Bresenham's line drawing algorithm.
            [x, y] = bresenham(boid.coord(1), boid.coord(2),...
            boid.coord(1) + boid.velocity(1) * 2, boid.coord(2)...
            + boid.velocity(2) * 2);

            % Draw boid as a line from its current position to its
            % next position.
            for k = 1 : numel(x)
                if x(k) - 1 <= obj.height && x(k) - 1 >= 1 &&...
                y(k) - 1 <= obj.width && y(k) - 1 >= 1
                    obj.green_mat(x(k) - 1, y(k) - 1) = 1 * boid.color_g;
                    obj.blue_mat(x(k) - 1, y(k) - 1) = 1 * boid.color_b;
                    obj.red_mat(x(k) - 1, y(k) - 1) = 1 * boid.color_r;
                end
            end
            
        end
        
        % Method that draws predator as a 3 * 3 square of red pixels.
        % Input: Predator object
        function obj = draw_predator(obj, pred)
            if round(pred.coord(1) - 1) > 0 && round(pred.coord(1) + 1) < obj.height...
            && round(pred.coord(2) - 1) > 0 && round(pred.coord(2) + 1) < obj.width
                for i = -1 : 1
                    for j = -1 : 1
                        obj.red_mat(round(pred.coord(1) + i),...
                        round(pred.coord(2)) + j) = 1;
                    end
                end
            end
        end 
    end
end
