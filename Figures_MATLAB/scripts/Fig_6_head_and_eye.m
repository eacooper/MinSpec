%Figure 6 head and eye movement session

%% Calculations 

%would you wear the lenses on a regular basis?
VOMSwear_percent         = sum(VOMSwear) ./ 40 .* 100;
%calculate the binomial error bars. 
[phat,fitconf]           = binofit(sum(VOMSwear),[40,40,40,40,40]); %number of times "yes" and the number of opportunities to say "yes
VOMSwear_percent_fitconf = (fitconf.*100) - VOMSwear_percent';%convert into percentages and differences from the mean

%discomfort rank
VOMSrank_mean = mean(VOMSrank); 
VOMSrank_SD   =  std(VOMSrank); 
VOMSrank_CI   = (1.96.*VOMSrank_SD)./sqrt(40);

%Physical symptoms with baseline subtracted
%subtract baseline symptoms from all symptom scores 
%Note: for saccades and VOR, we took the median of the median of the
%horizontal and vertical saccades. 
VOMSSymp_pursuit_cor  = VOMSSymp_pursuit - VOMSSymp_base; %row=subj %col=HDN %3rd=lens
VOMSSymp_saccades_cor = VOMSSymp_saccades - VOMSSymp_base; 
VOMSSymp_converge_cor = VOMSSymp_converge - VOMSSymp_base;
VOMSSymp_VOR_cor      = VOMSSymp_VOR - VOMSSymp_base; 
VOMSSymp_ms_cor       = VOMSSymp_ms - VOMSSymp_base;

%Take the median of the headache,dizzyness and nausia for each subj as described in preregistration
VOMSSympall_pursuit_cor     = median(VOMSSymp_pursuit_cor,2); %row=subj %col=HDN %3rd=lens
VOMSSympall_saccades_cor    = median(VOMSSymp_saccades_cor,2); 
VOMSSympall_converge_cor    = median(VOMSSymp_converge_cor,2);
VOMSSympall_VOR_cor         = median(VOMSSymp_VOR_cor,2); 
VOMSSympall_ms_cor          = median(VOMSSymp_ms_cor,2);

%mean of eye movement symptom data
VOMSSympall_pursuit_cor_mean  = mean(VOMSSympall_pursuit_cor);
VOMSSympall_saccades_cor_mean = mean(VOMSSympall_saccades_cor);
VOMSSympall_converge_cor_mean = mean(VOMSSympall_converge_cor);
VOMSSympall_VOR_cor_mean      = mean(VOMSSympall_VOR_cor);
VOMSSympall_ms_cor_mean       = mean(VOMSSympall_ms_cor);

%take the SD of each eye movement across HDN
VOMSSympall_pursuit_cor_SD  = nanstd(VOMSSympall_pursuit_cor);
VOMSSympall_saccades_cor_SD = nanstd(VOMSSympall_saccades_cor);
VOMSSympall_converge_cor_SD = nanstd(VOMSSympall_converge_cor);
VOMSSympall_VOR_cor_SD      = nanstd(VOMSSympall_VOR_cor);
VOMSSympall_ms_cor_SD       = nanstd(VOMSSympall_ms_cor);

%95% CI
VOMSSympall_pursuit_cor_CI  = (1.96.*VOMSSympall_pursuit_cor_SD)./sqrt(40);
VOMSSympall_saccades_cor_CI = (1.96.*VOMSSympall_saccades_cor_SD)./sqrt(40);
VOMSSympall_converge_cor_CI = (1.96.*VOMSSympall_converge_cor_SD)./sqrt(40);
VOMSSympall_VOR_cor_CI      = (1.96.*VOMSSympall_VOR_cor_SD)./sqrt(40);
VOMSSympall_ms_cor_CI       = (1.96.*VOMSSympall_ms_cor_SD)./sqrt(40);


%% Plotting

subplot_row = 8;
subplot_col = 4;
LineWidth   = 1.7;
MarkerSize  = 9;
fontsize    = 9;

xval = [1:5]; 
vomstr = {'pursuit','saccades','converge','VOR','ms'};
voms_titles_str = {'Smooth pursuits','Saccades','Convergence','Vestibulo-ocular reflex','Head-body rotation'};

f2 = figure; hold on;
f2.Position = [100 40 1215 355];

% Percent wear plot
subplot(subplot_row,subplot_col,[1,5]); hold on;

for len = 1:length(lennumstr)
    thisbar = bar(xval(len),VOMSwear_percent(len)); thisbar.FaceColor = colorVec2(1,:);
    thisbar.EdgeColor = 'none';
    Er = errorbar(xval(len), VOMSwear_percent(len), VOMSwear_percent_fitconf(len,1), VOMSwear_percent_fitconf(len,2)); Er.Color=[0 0 0]; Er.LineStyle = "none";
end
ylabel('% would wear');
ylim([0,100]);
yticks([0,25,50,75,100]);
yticklabels({'0','25','50','75','100'});
xticks(xval);
xlim([0.5,5.5]);
set(gca,'box','on','FontSize',fontsize);


%Ranking plot
subplot(subplot_row,subplot_col,[9,13,17,21,25,29]); hold on;

%histogram
distributionPlot(VOMSrank,'histOpt',2,'color',colorVec2_cell,'globalNorm',1,'showMM',0); 
alpha(alpha_of_histogram); 

for len = 1:length(lennumstr)
    if len == 3 || len == 5 % to give lenses different marker styles
        plot(xval(len),VOMSrank_mean(len),"o","MarkerFaceColor","none","MarkerEdgeColor",colorVec2(len,:),"MarkerSize",MarkerSize,"LineWidth",LineWidth);
    else
        plot(xval(len),VOMSrank_mean(len),"o","MarkerFaceColor",colorVec2(len,:),"MarkerEdgeColor",colorVec2(len,:),"MarkerSize",MarkerSize,"LineWidth",LineWidth);
    end
    Er = errorbar(xval(len), VOMSrank_mean(len), -VOMSrank_CI(len), VOMSrank_CI(len)); Er.Color=[0 0 0]; Er.LineStyle = "none";
end
yticks(1:5);
ylabel('Mean comfort rank');
ylim([1,5]);
xticks(xval);
xlim([0.5,5.5]);
xticklabels({'0,0','2,2','0,2','4,4,','0,4'});
set(gca,'box','on','plotboxaspectratio',[1 1 1],'FontSize',fontsize); hold on;

%Physical comfort index for each eye movement
subplot_list = [2,6,10,14; 18,22,26,30; 3,7,11,15; 19,23,27,31; 4,8,12,16; 20,24,28,32];

for eye = 1:length(vomstr) %loop over eye movement

    subplot(subplot_row,subplot_col,subplot_list(eye,:)); hold on;

    eval(['title("',voms_titles_str{eye},'")']);

    %Data for each eye movement
    eval(['thisdata = VOMSSympall_',vomstr{eye},'_cor_mean;']);
    eval(['thisdata_ci = VOMSSympall_',vomstr{eye},'_cor_CI;']);
    eval(['thisdata_hist = squeeze(VOMSSympall_',vomstr{eye},'_cor);']);
    
    % Histogram
    distributionPlot(thisdata_hist,'histOpt',2,'color',colorVec2_cell,'globalNorm',1,'showMM',0);
    alpha(alpha_of_histogram); 

    for len = 1:length(lennumstr) %loop through lenses

        if len == 3 || len == 5 %in order to have different marker styles

            plot(xval(len),thisdata(:,:,len),"o","MarkerFaceColor","none","MarkerEdgeColor",colorVec2(len,:),"MarkerSize",MarkerSize,"LineWidth",LineWidth);
        else
            plot(xval(len),thisdata(:,:,len),"o","MarkerFaceColor",colorVec2(len,:),"MarkerEdgeColor",colorVec2(len,:),"MarkerSize",MarkerSize,"LineWidth",LineWidth);
        end
            Er = errorbar(xval(len), thisdata(:,:,len),-thisdata_ci(:,:,len), thisdata_ci(:,:,len)); Er.Color=[0 0 0]; Er.LineStyle = "none";
    end

    xlim([0.5,5.5]);
    ylim([-0.5,2.5]);
    xticks([xval(1:5)]);
    xticklabels({'00','22','02','44','04'});
    if eye == 1 || eye == 4
        ylabel('Likert response minus baseline');
    end

    set(gca,'box','on','plotboxaspectratio',[1 1 1],'FontSize',fontsize);
end
