%Calculating the expected phoria for different gaze positions


min_levels           = [0.98,0.96]; %2 and 4% minification
NatHPhoria_expect_pd = []; %stores expectations
straightHphoria      = [];
rightHphoria         = [];%used for place holders
leftHphoria          = [];
UpVphoria            = [];
DownVphoria          = [];

%% CALCULATING EXPECTED PHORIA WHEN LENSES ARE WORN

%Subject is looking straight ahead
ipd    = 0.06;
dist   = 1;
p1_m   = ipd./2; %original position of target relative to gaze normal of one eye. 
% The original target is on a plane 1m away centered relative to the cyclopian eye.
% We know the position of the original target in degrees because we can caluclate 
% the angle of convergence with the distnace to the target.
p1_deg = atand((ipd./2)./dist); %position of target in degrees
%convert to prism diopters (equ 9 pg 12 Meister & Sheedy)
p1_pd  = tand(p1_deg) .* 100;

%% Expected phoria when gaze is straight

for i = 1:length(min_levels) %loop through the minification levels
    
    % HORIZONTAL PHORIA
    % Binocular minification
    %Minifires are put on the participant changing the HORIZONTAL position of the target.
    %calculate the new position of the target for one eye.
    %Note: it is important to perform the magnification in the world and not in
    %degrees because these will produce different results. 
    min    = min_levels(i);
    p2_m   = p1_m .* min; % position after minification in meters
    p2_deg = atand(p2_m./dist); %in degrees
    p2_pd  = tand(p2_deg) .* 100; %in prism diopters
 
    %Calculate horizontal phoria
    %If we assume that the participant did not change thier convergence with
    %the minifying lens, then they would appear to have esophoria.
    %The degree of esophoria can be calculated by taking the difference between
    %the new target and old target in degrees.
    %multiply result by 2 to account for the change in angle to both eyes.
    dif_deg = (p1_deg - p2_deg).*2;
    dif_pd  = (p1_pd - p2_pd).*2;

    % Monocular minification
    %What would we expect for monocular minification? half as much? I think
    %that we would expect half as much for monocular minification because the
    %effect is only in one eye.
    dif_mono_pd = dif_pd./2;


    % VERTICAL PHORIA
    % Binocular and monocular minification
    %at a gaze position of straight ahead we do not expect to see vertical phoria.
    %for binocular and monocular minification.
    straightVphoria = [0,0,0,0];

    %store expectations into an array. 
    straightHphoria = [straightHphoria,dif_pd,dif_mono_pd]; %row = head turn, col = 22, 02, 44 04

end


%% Expected phoria when gaze is eccentric / head is turned

for i = 1:length(min_levels) %loop through the minification levels

    min = min_levels(i);

    %When the head is turned 10 degrees let's think about it as a 10 deg eccentric
    %gaze position. (this assumption will not account for a change in the z demention of
    %the eye's position).
    %In excentric gaze positions minification will produce greater 
    % displacement of the points compared to looking straight ahead. 

    %With 10 deg eccentric gaze, the position of the original point will be 10
    %degrees to the right or the left relative to the cyclopian eye.
    headturn_deg = 10; %head turn is how we think about it in the expt
    
    %Find the position of the target at 10 deg in the world relative to gaze normal for
    %the closer and farther eye from the target
    x1_10degtriangle = tand(headturn_deg).*dist; %Distance in the world from perpendicular to the cyclopian eye to the target at 10 deg 
    p1close_m = x1_10degtriangle - (ipd./2); %distance in the world from gaze normal of close eye to the target at 10 deg 
    p1close_deg = atand(p1close_m./dist);
    %minified position of target relative to the eye close to the 10deg target
    p2close_m = p1close_m .* min;
    p2close_deg = atand(p2close_m./dist);

    %Do the same for the far eye.
    p1far_m = p1close_m + ipd;
    p1far_deg = atand(p1far_m./dist);
    %minnified far eye
    p2far_m = p1far_m .* min;
    p2far_deg = atand(p2far_m ./ dist);

    %calculate original vergence
    %You subtract the angle from gaze normal of each eye. this will get you the vergence.
    orig_converge = abs(p1close_deg - p1far_deg); %Original convergence angle

    % HORIZONTAL PHORIA
    % Binocular minification
    %Minified convergence
    min_converge = abs(p2close_deg - p2far_deg);
    %Calculate horizontal phoria. If we assume that they eyes do not 
    % diverge in response to the minification then the participant will
    % have esophoria.
    phoria_horezturn_deg = orig_converge - min_converge;
    phoria_horezturn_pd = tand(phoria_horezturn_deg) .* 100;

    % Monocular minification
    %A right head turn is equivolant to the far eye experiencing minification
    %but not the close eye.
    min_converge_mono_rt = abs(p1close_deg - p2far_deg); %convergence under monocular minifiation in the right eye
    %Calculate horizontal phoria. 
    phoria_mono_rt_deg = orig_converge - min_converge_mono_rt; %subtract original convergence to convergence during minification.
    phoria_mono_rt_pd = tand(phoria_mono_rt_deg) .* 100;

    %A left head turn is equivolant to the close eye experiencing minification
    %but not the far eye.
    min_converge_mono_left = abs(p2close_deg - p1far_deg);
    %calculate horizontal phoria
    phoria_mono_left_deg = orig_converge - min_converge_mono_left; %it is a negative number indicating exophoria
    phoria_mono_left_pd = tand(phoria_mono_left_deg) .* 100;

    %store results
    rightHphoria = [rightHphoria,phoria_horezturn_pd,phoria_mono_rt_pd]; %right turn
    leftHphoria = [leftHphoria,phoria_horezturn_pd,phoria_mono_left_pd]; %left turn


    % VERTICAL PHORIA (i.e. up and down head turn)
    % we expect to see some hyper- and hypo- phoria during upward and
    % downward head turns directions. this will be easier to solve because 
    % the horizontal displacement between the eyes is irrelevant. 
    % find the original y position of the target at 10 deg
    p1_updown_m = tand(headturn_deg) .* dist; %y position of target location reletive to the center of the phoria chart
    p1_updown_deg = headturn_deg;
    p2_updown_m = p1_updown_m .* min; %minified position of target
    p2_updown_deg = atand(p2_updown_m ./ dist); %find the minified angle to the target

    %Binocular minification 
    % for binocular minification there will not by a hyper or
    % hypophoria because both eyes are being turned the same amount by the same amount. 
    phoria_bino_up_pd = 0;
    phoria_bino_down_pd = 0;

    %Monocular minification 
    %downward head turn (or upward gaze) will make image appear more
    %downward. The eyes will not deviate downward as much as demanded by the 
    % minifiers so the eyes will appear hyper. An upward head turn 
    % (or downward gaze) will deviate the image
    %upward. The eyes will not deviated upward as much as demanded by the 
    % minifier so the eyes will appear to be hypo. 
    phoria_mono_up_deg = -abs(p1_updown_deg - p2_updown_deg); %negative because it should be hypo
    phoria_mono_up_pd = tand(phoria_mono_up_deg) .* 100;
    phoria_mono_down_deg = abs(p1_updown_deg - p2_updown_deg);
    phoria_mono_down_pd = tand(phoria_mono_down_deg) .* 100;

    %store the expected values
    UpVphoria = [UpVphoria,phoria_bino_up_pd,phoria_mono_up_pd];
    DownVphoria = [DownVphoria,phoria_bino_down_pd,phoria_mono_down_pd];

end

%store expectations into an array. 
NatHPhoria_expect_pd = [straightHphoria; rightHphoria;leftHphoria]; %row = straight,right,left col=22,02,44,04
NatVPhoria_expected_pd = [straightVphoria; UpVphoria;DownVphoria]; %row=up,dow col=22,02,44,04

