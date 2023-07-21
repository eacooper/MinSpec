%Figure 8 Eyestrain and phoria


%% Calculations

%Calculations for eye strain
NatQsall_eyestrain_mean = mean(NatQs_eyestrain);
NatQsall_eyestrain_SD   = std(NatQs_eyestrain);
NatQsall_eyestrain_CI   = (1.96.*NatQsall_eyestrain_SD)./sqrt(40);

%Phoria induced by the lenses
% phoria when the lenses are just put on minus the phoria before the lenses
% are put on. Distance of measurement is 1m.
NatHPhoria_prebase = NatHPhoria_pre - NatHPhoria_1base; 
NatVPhoria_prebase = NatVPhoria_pre - NatVPhoria_1base; 

NatHPhoria_prebase_mean = mean(NatHPhoria_prebase);
NatVPhoria_prebase_mean = mean(NatVPhoria_prebase);
NatHPhoria_prebase_CI   = (1.96.*std(NatHPhoria_prebase))./sqrt(40);
NatVPhoria_prebase_CI   = (1.96.*std(NatVPhoria_prebase))./sqrt(40);

%Phoria adaptation (or lack there of) initial phoria with the glasses on
%minus phoria with the glasses on after the task is performed. This is not 
% plotted but it is used for statistical analysis
NatHPhoria_postpre = NatHPhoria_post - NatHPhoria_pre; 
NatVPhoria_postpre = NatVPhoria_post - NatVPhoria_pre; 

%Calculate expected phoria to include in the plots
Expected_phoria;

%% Figure
subplot_row = 2;
subplot_col = 4;
LineWidth   = 1.7;
MarkerSize  = 9;
fontsize    = 9;
 
f3 = figure; hold on;
f3.Position = [100 40 1215 455];

%Eye strain
subplot(subplot_row,subplot_col,[4,8]); hold on;
title('Eye strain');

%histogram
distributionPlot(squeeze(NatQs_eyestrain),'histOpt',2,'color',colorVec2_cell,'globalNorm',1,'showMM',0); 
alpha(alpha_of_histogram);

for len = 1:length(LensStr)

    if len == 3 || len == 5
        plot(xval(len),NatQsall_eyestrain_mean(1,1,len),"o","MarkerFaceColor","none","MarkerEdgeColor",colorVec2(len,:),"MarkerSize",MarkerSize,"LineWidth",LineWidth);
    else
        plot(xval(len),NatQsall_eyestrain_mean(1,1,len),"o","MarkerFaceColor",colorVec2(len,:),"MarkerEdgeColor",colorVec2(len,:),"MarkerSize",MarkerSize,"LineWidth",LineWidth);
    end
    Er = errorbar(xval(len), NatQsall_eyestrain_mean(1,1,len), -NatQsall_eyestrain_CI(1,1,len), NatQsall_eyestrain_CI(1,1,len)); Er.Color=[0 0 0]; Er.LineStyle = "none";
end

xlim([0.5,5.5]);
ylim([1,4]);
ylabel('Symptom severity (Likert scale 1-5)');
xticks(xval);
xticklabels({'0,0','2,2','0,2','4,4,','0,4'});
yticks([1,2,3,4]);
yticklabels({'1','2','3','4'})
set(gca,'box','on','plotboxaspectratio',[1 1 1],'FontSize',fontsize);

%Horizontal Phoria
% the difference between the pre - baseline horizontal phoria. 
headstr = {'Straight gaze','Left gaze','Right gaze'}; %straight, right head turn, left head turn 
%normalize the expected phoria values by adding the 00 phoria to the estimates
NatHPhoria_expect_pd_norm = NatHPhoria_expect_pd + NatHPhoria_prebase_mean(1,1:3,1)'; %row = straight,right,left col=lens (22,02,44,04)

for head = 1:length(headstr) %loop over head directions

    subplot(subplot_row,subplot_col,head); hold on;
    eval(['title("',headstr{head},'");']);

    distributionPlot(squeeze(NatHPhoria_prebase(:,head,:)),'histOpt',2,'color',colorVec2_cell,'globalNorm',1,'showMM',0); %Hist opt makes it like a histogram
    alpha(alpha_of_histogram);

    for len = 1:5
        if len == 3 || len == 5 %no marker fill for unilateral minifcation

            plot(xval(len),NatHPhoria_prebase_mean(1,head,len),"o","MarkerFaceColor","none","MarkerEdgeColor",colorVec2(len,:),"MarkerSize",MarkerSize,"LineWidth",LineWidth);
        
        else
            plot(xval(len),NatHPhoria_prebase_mean(1,head,len),"o","MarkerFaceColor",colorVec2(len,:),"MarkerEdgeColor",colorVec2(len,:),"MarkerSize",MarkerSize,"LineWidth",LineWidth);

        end

        Er = errorbar(xval(len),NatHPhoria_prebase_mean(1,head,len),-NatHPhoria_prebase_CI(1,head,len),NatHPhoria_prebase_CI(1,head,len));
        Er.Color=[0 0 0]; Er.LineStyle = "none";
    end

    %line for the expected phoria
    plot([1.6:0.1:2.4],(ones(1,9).*NatHPhoria_expect_pd_norm(head,1)),':',"Color",colorVec2(2,:),"LineWidth",LineWidth); %22
    plot([2.6:0.1:3.4],(ones(1,9).*NatHPhoria_expect_pd_norm(head,2)),':',"Color",colorVec2(3,:),"LineWidth",LineWidth); %02
    plot([3.6:0.1:4.4],(ones(1,9).*NatHPhoria_expect_pd_norm(head,3)),':',"Color",colorVec2(4,:),"LineWidth",LineWidth); %44
    plot([4.6:0.1:5.4],(ones(1,9).*NatHPhoria_expect_pd_norm(head,4)),':',"Color",colorVec2(5,:),"LineWidth",LineWidth); %04
    
    if head == 1
        xlabel('Minification (%)');
        ylabel('Change in phoria induced by lenses');
    end
    xticks([1:5]);
    xticklabels({'0,0','2,2','0,2','4,4','0,4'});
    xlim([0.5,5.5]);
    ylim([-4,5.5]);
    hline = refline(0,NatHPhoria_prebase_mean(1,head,1)); % represents no change
    hline.Color = 'k';
    set(gca,'box','on','plotboxaspectratio',[1 1 1],'FontSize',fontsize);
end

%Vertical phoria
headstr = {'Straight gaze','Down gaze','Up gaze'}; %straight, up head turn, down head turn
subplotind = 5; %used to properly index into the subplots
%normalize the expected phoria values by adding the 00 phoria to our
%estimates
NatVPhoria_expected_pd_norm = NatVPhoria_expected_pd + [NatVPhoria_prebase_mean(1,1,1); NatVPhoria_prebase_mean(1,4:5,1)'];%row=straight,up,down col=22,02,44,04

for head = 1:length(headstr) %loop over head directions
    if head == 1
        headind = 1; % index for straight ahead
    elseif head == 2
        headind = 4; % index for up column
    elseif head == 3
        headind = 5; %index for down column
    end
    
    subplot(subplot_row,subplot_col,subplotind); hold on;
    subplotind = subplotind + 1; 
    eval(['title("',headstr{head},'");']);
    
    %histogram
    distributionPlot(squeeze(NatVPhoria_prebase(:,headind,:)),'histOpt',2,'color',colorVec2_cell,'globalNorm',1,'showMM',0); 
    alpha(alpha_of_histogram);

    for len = 1:5
        if len == 3 || len == 5 %no marker fill for unilateral minifcation

            plot(xval(len),NatVPhoria_prebase_mean(1,headind,len),"o","MarkerFaceColor","none","MarkerEdgeColor",colorVec2(len,:),"MarkerSize",MarkerSize,"LineWidth",LineWidth);
        
        else
            plot(xval(len),NatVPhoria_prebase_mean(1,headind,len),"o","MarkerFaceColor",colorVec2(len,:),"MarkerEdgeColor",colorVec2(len,:),"MarkerSize",MarkerSize,"LineWidth",LineWidth);
        end

        Er = errorbar(xval(len),NatVPhoria_prebase_mean(1,headind,len),-NatVPhoria_prebase_CI(1,headind,len),NatVPhoria_prebase_CI(1,headind,len));
        Er.Color=[0 0 0]; Er.LineStyle = "none";
    end

    %line for the expected phoria
    plot([1.6:0.1:2.4],(ones(1,9).*NatVPhoria_expected_pd_norm(head,1)),':',"Color",colorVec2(2,:),"LineWidth",LineWidth); %22
    plot([2.6:0.1:3.4],(ones(1,9).*NatVPhoria_expected_pd_norm(head,2)),':',"Color",colorVec2(3,:),"LineWidth",LineWidth); %02
    plot([3.6:0.1:4.4],(ones(1,9).*NatVPhoria_expected_pd_norm(head,3)),':',"Color",colorVec2(4,:),"LineWidth",LineWidth); %44
    plot([4.6:0.1:5.4],(ones(1,9).*NatVPhoria_expected_pd_norm(head,4)),':',"Color",colorVec2(5,:),"LineWidth",LineWidth); %04

    if head == 1
        xlabel('% Minification');
        ylabel('Change in phoria induced by lenses');
    end
    xticks([1:5]);
    xticklabels({'0,0','2,2','0,2','4,4','0,4'});
    xlim([0.5,5.5]);
    ylim([-2,3]);
    hline = refline(0,NatVPhoria_prebase_mean(1,headind,1)); % represents no change
    hline.Color = 'k';
    set(gca,'box','on','plotboxaspectratio',[1 1 1],'FontSize',fontsize);
end
