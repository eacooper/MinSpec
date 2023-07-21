%Figure 9 distortion tollerance


%% calculations

%would you wear the lenses on a regular basis?
Natpercent = sum(Natwear)./40.*100; %percent wear for all glasses for this session
Natsum     = sum(Natwear); %sum of yes responses for each session. needed for error bars

%Running the regression
%We want both the monocular and binocular regression lines to have the
%same value when x=0 (They should predict the same value when there is
%zero minification).
% specify a line in which we fit the slope, but assert that the intercept =
% 87.5 (the 0 mag probability)

ft = fittype('(a*x)+87.5');

%linear regression
%binocular mag
fitobject_bin = fit([0,2,4]',[Natpercent(1),Natpercent(2),Natpercent(4)]',ft);
b_bin = 87.5; % y intercept
slope_bin = fitobject_bin.a;  %y-b / x
%monocular mag
fitobject_mon = fit([0,2,4]',[Natpercent(1),Natpercent(3),Natpercent(5)]',ft);
b_mon = 87.5; %intercept
slope_mon = fitobject_mon.a;  %y-b / x

%Binomial confidence intervals
%This gives the lower and upper confidence intervals.
%control
[phat,contfitconf] = binofit(Natsum(1),40); 
%binocular
[phat,binfitconf]  = binofit([Natsum(2),Natsum(4)]',[40,40]');
%monocular
[phat,monofitconf] = binofit([Natsum(3),Natsum(5)]',[40,40]'); 
%error bars are in proportion. convert to percentage to plot. You also
%have to subtract the mean so it is the increase or decrease from the mean.
contfitconf_per = (contfitconf.*100) - Natpercent(1);
binfitconf_per  = (binfitconf .* 100) - [Natpercent(2),Natpercent(4)]';
monofitconf_per = (monofitconf .* 100) - [Natpercent(3),Natpercent(5)]';


%% Plotting

LineWidth      = 2;  %marker edge
LineWidth_line = 1;
MarkerSize     = 100;
fontsize       = 15;
alpha_line     = 1;

figure, hold on;
%control
scatter(0,Natpercent(1),MarkerSize,"MarkerEdgeColor",colorVec_mb(1,:),"MarkerFaceColor",colorVec_mb(2,:),'LineWidth',LineWidth);
Er = errorbar(0,Natpercent(1), -contfitconf_per(1), contfitconf_per(2)); Er.Color=[0 0 0]; Er.LineStyle = "none"; %binomial error bar
%plot binocular 2 and 4%
scatbin = scatter([-2,-4],[Natpercent(2),Natpercent(4)],MarkerSize,"MarkerEdgeColor","none","MarkerFaceColor",colorVec_mb(1,:));
Er = errorbar([-2,-4],[Natpercent(2),Natpercent(4)], -binfitconf_per(1,:), binfitconf_per(2,:)); Er.Color=colorVec_mb(1,:); Er.LineStyle = "none"; %binomial error bar
%plot monocular 2 and 4%
scatmon = scatter([-2,-4],[Natpercent(3),Natpercent(5)],MarkerSize,"MarkerEdgeColor","none","MarkerFaceColor",colorVec_mb(2,:),'LineWidth',LineWidth);
Er = errorbar([-2,-4],[Natpercent(3),Natpercent(5)], -monofitconf_per(1,:), monofitconf_per(2,:)); Er.Color=colorVec_mb(2,:); Er.LineStyle = "none"; %binomial error bar

%REGRESSION LINE
ref_bin = refline(-slope_bin,b_bin); %binocular
ref_bin.Color = colorVec_mb(1,:);  ref_bin.LineWidth = LineWidth_line;
ref_mon = refline(-slope_mon,b_mon); %monocular
ref_mon.Color = colorVec_mb(2,:); ref_mon.LineStyle = '-'; ref_mon.LineWidth = LineWidth_line;

%Estimated regression lines for the magnification side
plot([0,4],[87.5,17.5],'--',"Color", [colorVec_mb(1,:),alpha_line],"LineWidth",LineWidth_line); %binocular 
plot([0,4],[87.5,1.5],'--',"Color", [colorVec_mb(2,:),alpha_line],"LineWidth",LineWidth_line); %monocular

xticks([-4,-2,0,2,4]);
xticklabels({'-4','-2','0','2','4'});
xlabel('Magnification (%)');
ylabel('Would wear on a regular basis (%)');
xlim([-4.5,4.5]);
ylim([0,100]);
legend([scatbin,scatmon,ref_bin,ref_mon],'Binocular minification','Monocular minification','linear regression bino','linear regression mono');
set(gca,'box','on','plotboxaspectratio',[1.5 1 1],'FontSize',fontsize);
