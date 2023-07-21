% Expected swim
%This script calculates the amount of afterimage motion we expect
%participants to experience with the different lenses on. 
%We will assume that the afterimage motion is equivolant to the retinal
%slip that is geometrically created during head rotation if we assume that
% the VOR gain is 1. In the experiment the head rotation is +/- 15 deg and
% at a rate of 2Hz. 

dist_from_wall_m = 1.83;
ipd = 0.06;

min_levels = [0.98,0.96];

for i = 1:length(min_levels)

    min = min_levels(i);

    wallmarkers_distbw_deg = 30; %distance between markers on the wall that are +/-15 deg appart. These
                                 %markers indicate the magnitude the head should move side to side.
    wallmarkers_distbw_m = 2*(tand(wallmarkers_distbw_deg./2)*1.83);
    %minified distance.
    wallmarkers_distbw_min_m = wallmarkers_distbw_m*min;
    %minified distance in degrees between wall markers
    wallmarkers_distbw_min_deg = 2.* (atand( (wallmarkers_distbw_min_m./2) ./ dist_from_wall_m ));
    
    %Binocular minification
    %Retinal slip (assuming VOR gain of 1) will be equivolant to the difference
    %in degrees between the minified and unminified marker positions.
    slip_deg_bino = wallmarkers_distbw_min_deg - wallmarkers_distbw_deg;

    %Monocular Minification
    %I we expcted that the retinal slip would be half that of the binouclar
    % retinal slip.
    slip_deg_mono = slip_deg_bino./2;

    %Label to store values later
    if i == 1 % 2%
        slip_deg_bino_2 = slip_deg_bino; %retinal slip for binocular minification
        slip_deg_mono_2 = slip_deg_mono;

    elseif i == 2 % 4%
        slip_deg_bino_4 = slip_deg_bino;
        slip_deg_mono_4 = slip_deg_mono;
    end

end

%store values for plotting
exptSwim_vals = abs([slip_deg_bino_2, slip_deg_mono_2, slip_deg_bino_4, slip_deg_mono_4]);