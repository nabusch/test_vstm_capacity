function INFO = define_trials(INFO)

P = INFO.P;

%%

itrial = 0;

for irepeat = 1:P.paradigm.n_trials
    for isetsize = 1:length(P.paradigm.setsizes)
        
        itrial = itrial + 1;
        T(itrial).trial = itrial;
        
        this_setsize = P.paradigm.setsizes(isetsize);
        T(itrial).setsize = this_setsize;
        
        rad_step = (2*pi) / this_setsize;
        rad_jitter = 0.33 * rad_step;
        
        
        % Get a random location on the color wheel as the "starting color" for
        % this trial. Then place all other colors for all other items evenly
        % across the color wheel.
        rad_start = 2*pi*rand;
        
        for i = 1:this_setsize
            
            % If desired, jitter the colors around the colorwheel a little.
            % This is especially useful for set size 2 where oterwise the
            % two items would always be 180 degrees apart. So each targets
            % color becaomes the other target's foil.
            if P.paradigm.jitter_colors == 1
                T(itrial).jitter = 2*rad_jitter .* rand - rad_jitter;
                thetas(i) = wrapToPi((rad_start + ((i-1)*rad_step)+T(itrial).jitter));
            else
                T(itrial).jitter = 0;
                thetas(i) = wrapToPi(rad_start + ((i-1)*rad_step));
            end
            %             x = round(P.colors.a + P.colors.radius * sin(thetas(i)));
            %             y = round(P.colors.b + P.colors.radius * cos(thetas(i)));
            %
            %
            %             T(itrial).colors(i,:) = lab2rgb([P.colors.lightness, x, y],'OutputType','uint8');
            
            
            T(itrial).colors(i,:) = theta2rgb(thetas(i), P.colors.a, ...
                P.colors.b, P.colors.radius, P.colors.lightness);
        end
        
        rand_inds = randperm(this_setsize);
        
        % Randomize the order of colors across item positions, so that the
        % progression of colors across neighboring items is not always the same.
        T(itrial).colors = T(itrial).colors(rand_inds,:);
        T(itrial).thetas = thetas(rand_inds);
        
        % Determine position of the to-be-tested item.
        T(itrial).itest = randi(this_setsize);
        
        % Get the color of the foil corresponding to the to-be-tested item.
        % We want this color to be 180 degrees different.
        foil_theta = wrapToPi( ...
            T(itrial).thetas(T(itrial).itest) + pi);
        %         x = round(P.colors.a + P.colors.radius * sin(foil_theta));
        %         y = round(P.colors.b + P.colors.radius * cos(foil_theta));
        
        T(itrial).foil_color = theta2rgb(foil_theta, P.colors.a, ...
            P.colors.b, P.colors.radius, P.colors.lightness);
        
        % Does the probe stimulus display the foil in the top or in the
        % bottom position?
        T(itrial).is_foil_on_top = round(rand);
        
        T(itrial).t_trial_on  = [];
        T(itrial).t_target_on = [];
        T(itrial).t_delay_on  = [];
        T(itrial).t_probe_on  = [];
        T(itrial).report      = [];
        T(itrial).correct     = [];
        T(itrial).rt          = [];
        
    end
end

INFO.T = Shuffle(T);


%%
% Quick check that the thetas are really evenly distributed across the
% circle.
% figure(1); hold all
% for i = 1:P.paradigm.setsize
%     plot(sin(theta(i)), cos(theta(i)), 'o', 'MarkerSize', 25, ...
%         'MarkerFaceColor', colors(i,:), ...
%         'MarkerEdgeColor', 'none');
% end
% hold off;  axis square

%% Make a figure with a complete color circle, fur publication etc.
% for i = 1:360
%    x = round(P.colors.a + P.colors.radius * sind(i));
%    y = round(P.colors.b + P.colors.radius * cosd(i));
%    trialInfo.labCirclePoints(:,i) = [x;y];
%    trialInfo.colors(:,i) = lab2rgb([P.colors.lightness, x, y],'OutputType','uint8');
% end
%
% figure('color', 'w');
% hold on
% for i = 1:360
%    x = round(P.colors.a + P.colors.radius * sind(i));
%    y = round(P.colors.b + P.colors.radius * cosd(i));
%
%     plot(x, y, 'o', 'MarkerSize', 25, 'MarkerFaceColor', trialInfo.colors(:,i), 'MarkerEdgeColor', 'none')
% end
% axis square
% axis off
% hold off
