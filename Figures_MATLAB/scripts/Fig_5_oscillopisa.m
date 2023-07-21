%Figure 5 Oscillopisa session

%% Calculations

%Would you wear the lenses on a regular basis?
Oscwear_percent         = sum(Oscwear) ./ 40 .* 100;
%calculate the binomial error bars 
[phat,fitconf]          = binofit(sum(Oscwear),[40,40,40,40,40]); %number of times "yes" and the number of opportunities to say "yes
Oscwear_percent_fitconf = (fitconf.*100) - Oscwear_percent';%convert into percentages and differences from the mean

%motion rank
Oscrank_mean = mean(Oscrank);
Oscrank_SD   = std(Oscrank);
Oscrank_CI   = (1.96.*Oscrank_SD)./sqrt(39); % one subject did not provide ranking

%afterimage motion in degrees
dw_m = 0.4818; %distance to the wall
dl_m = 0.008; %distance between lines 
dl_deg = atand(dl_m/dw_m); %distance between lines in degrees
Oscmotion_rangedeg = Oscmotion_range.*dl_deg; %range of motion in degrees
%mean and SD
Oscmotion_rangedeg_mean = mean(Oscmotion_rangedeg); 
Oscmotion_rangedeg_SD   = std(Oscmotion_rangedeg);
Oscmotion_rangedeg_CI   = (1.96.*Oscmotion_rangedeg_SD)./sqrt(40);

%Motion score
Oscmotion_score_mean = mean(Oscmotion_score);
Oscmotion_score_SD   = std(Oscmotion_score);
Oscmotion_score_CI   = (1.96.*Oscmotion_score_SD)./sqrt(40);

%Expected swim / retinal slip
Expected_swim; 

%% Plotting

subplot_row = 8;
subplot_col = 3;
LineWidth   = 1.7;
MarkerSize  = 9;
fontsize    = 9;

%expected percieved swim values taking into account the baseline 00
%percieved swim. 
exptSwim = exptSwim_vals + Oscmotion_rangedeg_mean(1);

f2 = figure; hold on;
f2.Position = [100 40 915 405];

% Percent wear on a regular basis
subplot(subplot_row,subplot_col,[1,4]); hold on;

for len = 1:length(lennumstr) %loop over lenses
    thisbar = bar(xval(len),Oscwear_percent(len)); thisbar.FaceColor = colorVec2(1,:);
    thisbar.EdgeColor = 'none';
    Er = errorbar(xval(len), Oscwear_percent(len), Oscwear_percent_fitconf(len,1), Oscwear_percent_fitconf(len,2)); Er.Color=[0 0 0]; Er.LineStyle = "none";
end

ylabel('% would wear');
ylim([0,100]);
yticks([0,25,50,75,100]);
yticklabels({'0','25','50','75','100'});
xticks(xval);
xlim([0.5,5.5]);
set(gca,'box','on','FontSize',fontsize);


%Ranking plot
subplot(subplot_row,subplot_col,[7,10,13,16,19,22]); hold on;

%histogram
distributionPlot(Oscrank,'histOpt',2,'color',colorVec2_cell,'globalNorm',1,'showMM',0); 
alpha(alpha_of_histogram); %makes histogram transparent

for len = 1:length(lennumstr)
    if len == 3 || len == 5 % to give lenses different marker styles
        plot(xval(len),Oscrank_mean(len),"o","MarkerFaceColor","none","MarkerEdgeColor",colorVec2(len,:),"MarkerSize",MarkerSize,"LineWidth",LineWidth);
    else
        plot(xval(len),Oscrank_mean(len),"o","MarkerFaceColor",colorVec2(len,:),"MarkerEdgeColor",colorVec2(len,:),"MarkerSize",MarkerSize,"LineWidth",LineWidth);
    end
    Er = errorbar(xval(len), Oscrank_mean(len), -Oscrank_CI(len), Oscrank_CI(len)); Er.Color=[0 0 0]; Er.LineStyle = "none";
end
yticks(1:5);
ylabel('Mean motion rank');
ylim([1,5]);
xticks(xval);
xlim([0.5,5.5]);
xticklabels({'0,0','2,2','0,2','4,4,','0,4'});
set(gca,'box','on','plotboxaspectratio',[1 1 1],'FontSize',fontsize);


%Plot Motion Range and Motion score
subplot_list = [5,8,11,14,17,20; 6,9,12,15,18,21];

for eachplot = 1:2

    subplot(subplot_row,subplot_col,subplot_list(eachplot,:)); hold on;

    if eachplot == 1 %afterimage motion range
        
        thisdata = Oscmotion_rangedeg_mean;
        thisdata_ci = Oscmotion_rangedeg_CI;
        thisdata_hist = Oscmotion_rangedeg;

        %refline for the expected swim
        plot([1.5:0.1:2.5],(ones(1,11).*exptSwim(1)),':',"Color",colorVec2(2,:),"LineWidth",1); %22
        plot([2.5:0.1:3.5],(ones(1,11).*exptSwim(2)),':',"Color",colorVec2(3,:),"LineWidth",1); %02
        plot([3.5:0.1:4.5],(ones(1,11).*exptSwim(3)),':',"Color",colorVec2(4,:),"LineWidth",1); %44
        plot([4.5:0.1:5.5],(ones(1,11).*exptSwim(4)),':',"Color",colorVec2(5,:),"LineWidth",1); %04

        ylabel('Afterimage movement (deg)');
        ylim([0,10]);


    elseif eachplot == 2 % motion score
        
        thisdata      = Oscmotion_score_mean;
        thisdata_ci   = Oscmotion_score_CI;
        thisdata_hist = Oscmotion_score;

        ylabel('Perceived motion (Likert scale 1-5)');
        ylim([1,5]);
        yticks([1,2,3,4,5]);
    end
    
    %hisograms
    distributionPlot(thisdata_hist,'histOpt',2,'color',colorVec2_cell,'globalNorm',1,'showMM',0); %Hist opt makes it like a histogram
    alpha(alpha_of_histogram); 

    %scatter plots
    for len = 1:length(lennumstr)

        if len == 3 || len == 5
            plot(xval(len),thisdata(len),"o","MarkerFaceColor","none","MarkerEdgeColor",colorVec2(len,:),"MarkerSize",MarkerSize,"LineWidth",LineWidth);
        else
            plot(xval(len),thisdata(len),"o","MarkerFaceColor",colorVec2(len,:),"MarkerEdgeColor",colorVec2(len,:),"MarkerSize",MarkerSize,"LineWidth",LineWidth);
        end
        Er = errorbar(xval(len), thisdata(len), -thisdata_ci(len), thisdata_ci(len)); Er.Color=[0 0 0]; Er.LineStyle = "none";
    end

    xlim([0.5,5.5]);
    xticks([xval]);
    xticklabels({'00','22','02','44','04'});
    set(gca,'plotboxaspectratio',[1 1 1],'box','on','FontSize',fontsize);
end



