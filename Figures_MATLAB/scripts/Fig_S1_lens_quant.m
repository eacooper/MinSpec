%Figure S1 Lens quantification

%% Calculations

%This script calculates the percent minification of all of the lenses
load_quantifying_lens_data;

%% Plotting

subplot_row = 3;
subplot_col = 4;
len_subplot = [1,5,9]; 

f5 = figure; hold on;
f5.Position = [100 40 915 455];

LineWidth     = 1.5;
LineWidth_ref = 1;
MarkerSize    = 60;
fontsize      = 10;
MarkerSize_sm = 10;

%plot the positions and the regression line 
for len = 1:3
    subplot(subplot_row,subplot_col,len_subplot(len)); hold on;
    eval(['title("',lenLevelStr{len},'");']);

    eval([legdStr{len}, ' = scatter(baseline_min_',LenlevelStr_short{len},'(1,:,1),baseline_min_',LenlevelStr_short{len},'(2,:,1),MarkerSize_sm,"MarkerEdgeColor","k","MarkerFaceColor","none","LineWidth",LineWidth);']); % 0% minification

    if len == 1
        xlabel('x location of points (pixels)');
        ylabel('x location of minified points (pixels)');
    end
    set(gca,'box','on','plotboxaspectratio',[1 1 1],'FontSize',fontsize);
    xlim([0,3040]);
    ylim([0,3040]);

    %regression line 
    ref1 = refline(m(1,1,len),b(1,1,len)); ref1.Color = colorVec_other(len,:); ref1.LineWidth = LineWidth_ref;
end

%PLOT SLOPES of the regression lines
xval = 1:3;
subplot(subplot_row,subplot_col,[3,4,7,8,11,12]); hold on; 
for len = 1:3
    scatter([ones(1,2).*xval(len)],m_p(1,:,len),MarkerSize,'o',"MarkerEdgeColor",colorVec_other(len,:),"MarkerFaceColor","none",'LineWidth',LineWidth);
end

xlim([0.6,3.4]);
ylim([-1.2,4.9]);
%reference lines for minification
ref = refline(0,4); ref.Color = colorVec_other(3,:); ref.LineWidth = LineWidth_ref;
ref = refline(0,2); ref.Color = colorVec_other(2,:); ref.LineWidth = LineWidth_ref;
ref = refline(0,0); ref.Color = colorVec_other(1,:); ref.LineWidth = LineWidth_ref;
xlabel('Intended minification (%)');
ylabel('Measured minification (%)');
h=gca; h.XAxis.TickLength = [0 0]; 
xticks(1:3);
xticklabels({'0','2','4'});
set(gca,'box','on','plotboxaspectratio',[1 1 1],'FontSize',fontsize);


