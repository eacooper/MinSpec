% Figure 4, Naturalistic task

%% Calculations 

%Natwear calculations
Natwear_percent          = sum(Natwear) ./ 40 .* 100;

%binomial error bars 
[phat,fitconf]           = binofit(sum(Natwear),[40,40,40,40,40]); 
Natwear_percent_fitconf  = (fitconf.*100) - Natwear_percent'; %convert into percentages

%naturalistic ranking
Natrank_mean             = mean(Natrank);
Natrank_SD               =  std(Natrank); 
Natrank_CI               = (1.96.*Natrank_SD)./sqrt(40);

%physical symptoms index
NatSympall               = median(NatSymp,2); %median across H,D,N 
NatSympall_mean          = mean(NatSympall);
NatSympall_SD            = std(NatSympall);
NatSympall_CI            = (1.96.*NatSympall_SD)./sqrt(40);

%perceptual symptom index
NatQsall_perceptual      = median(NatQs_perceptual,2); %median for each participant across all symptoms HDN
NatQsall_perceptual_mean = mean(NatQsall_perceptual);
NatQsall_perceptual_SD   = std(NatQsall_perceptual);
NatQsall_perceptual_CI   = (1.96.*NatQsall_perceptual_SD)./sqrt(40);

%Individual phsical and perceptual symptoms
NatSymp_mean             = mean(NatSymp); %row=subj col=H,D,N
NatQseach_mean           = mean(NatQs_perceptual); %mean across participants for each question including eye strain

%% Plotting

subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
subplot_row = 8;
subplot_col = 3;

LineWidth = 1.7;
MarkerSize = 9;
fontsize = 9;

f1 = figure, hold on;
f1.Position = [100 40 915 405];

% Percent of people who would wear the glasses on a regular basis
subplot(subplot_row,subplot_col,[1,4]); hold on;

for len = 1:length(lennumstr) %loop over lenses
    
    thisbar = bar(xval(len),Natwear_percent(len)); thisbar.FaceColor = colorVec2(1,:);
    thisbar.EdgeColor = 'none';
    Er = errorbar(xval(len), Natwear_percent(len), Natwear_percent_fitconf(len,1), ...
              Natwear_percent_fitconf(len,2)); Er.Color=[0 0 0]; Er.LineStyle = "none";
end

ylabel('% would wear');
ylim([0,100]);
yticks([0,25,50,75,100]);
yticklabels({'0','25','50','75','100'});
xticks(xval);
xlim([0.5,5.5]);
set(gca,'box','on','FontSize',fontsize);


%Discomfort ranking plot
subplot(subplot_row,subplot_col,[7,10,13,16,19,22]); hold on;

distributionPlot(Natrank,'histOpt',2,'color',colorVec2_cell,'globalNorm',1,'showMM',0); 
alpha(alpha_of_histogram); %makes histogram transparent

for len = 1:length(lennumstr)

    if len == 3 || len == 5 % to give lenses different marker styles
        plot(xval(len),Natrank_mean(len),"o","MarkerFaceColor","none","MarkerEdgeColor",colorVec2(len,:),"MarkerSize",MarkerSize,"LineWidth",LineWidth);
    else
        plot(xval(len),Natrank_mean(len),"o","MarkerFaceColor",colorVec2(len,:),"MarkerEdgeColor",colorVec2(len,:),"MarkerSize",MarkerSize,"LineWidth",LineWidth);
    end

    Er = errorbar(xval(len), Natrank_mean(len), -Natrank_CI(len), Natrank_CI(len)); Er.Color=[0 0 0]; Er.LineStyle = "none";
end
yticks(1:5);
ylabel('Mean comfort rank');
ylim([1,5]);
xticks(xval);
xlim([0.5,5.5]);
xticklabels({'0,0','2,2','0,2','4,4,','0,4'});
set(gca,'box','on','plotboxaspectratio',[1 1 1],'FontSize',fontsize);


%Physical and perceptual index
subplot_list = [2,5,8,11; 3,6,9,12];

for i = 1:2 %physical or perceptual index loop

    subplot(subplot_row,subplot_col,subplot_list(i,:)); hold on;

        %grab the correct data
        if i == 1 %physical symptoms
            title('Physical symptom index'); 
            thisdata = NatSympall_mean; %not baseline corrected.
            thisdata_ci = NatSympall_CI;
            thisdata_hist = squeeze(NatSympall); 
            

        elseif i == 2
            title('Perceptual effects index');
            thisdata = NatQsall_perceptual_mean;
            thisdata_ci = NatQsall_perceptual_CI;
            thisdata_hist = squeeze(NatQsall_perceptual);
        end
    
    %plotting histogram
    distributionPlot(thisdata_hist,'histOpt',2,'color',colorVec2_cell,'globalNorm',1,'showMM',0); 
    alpha(alpha_of_histogram);

    for len = 1:length(lennumstr) %loop over lenses

        if len == 3 || len == 5
            plot(xval(len),thisdata(1,1,len),"o","MarkerFaceColor","none","MarkerEdgeColor",colorVec2(len,:),"MarkerSize",MarkerSize,"LineWidth",LineWidth);
        else
            plot(xval(len),thisdata(1,1,len),"o","MarkerFaceColor",colorVec2(len,:),"MarkerEdgeColor",colorVec2(len,:),"MarkerSize",MarkerSize,"LineWidth",LineWidth);
        end
         Er = errorbar(xval(len), thisdata(1,1,len), -thisdata_ci(1,1,len), thisdata_ci(1,1,len)); Er.Color=[0 0 0]; Er.LineStyle = "none";
    end

    xticks(xval);
    xlim([0.5,5.5]);
    ylim([1,4]);
    xticklabels({'0,0','2,2','0,2','4,4,','0,4'})

    if i == 1
       ylabel('Symptom severity (Likert scale 1-5)');        
    end

    set(gca,'box','on','plotboxaspectratio',[1 1 1],'FontSize',fontsize);
end


%Individual perceptual and physical symptoms 
LineWidth = 1;
MarkerSize = 8;
fontsize = 12;
min_level_list = [3 2 1 ; 5 4 1]; %[1 2 3 ; 1 4 5];
subplot_order = [1,3,2,4];
counter = 0;

figure,
for thisplot = 1:2 %loop over physical or perceptual symtptoms

    if thisplot == 1

        thisdata = NatSymp_mean;
        thistheta = deg2rad([0,120,240,0]);
    else
        thisdata = NatQseach_mean;
        thistheta = deg2rad([0,60,120,180,240,300,0] );
    end


    for min_levels = 1:2 %loop thorugh the 2 or 4 % lenses

        counter = counter + 1;

        subplot(2,2,subplot_order(counter));

        for len = 1:3 %Just plot the 00 and one lens level in each polar plot

            thislen = min_level_list(min_levels,len); %identify which lens to be plotted in this plot

            if thislen == 3 || thislen == 5 %monocular
                polarplot(thistheta,[thisdata(1,:,thislen),thisdata(1,1,thislen)],'--',"Color",colorVec2(thislen,:),"MarkerFaceColor","none","MarkerEdgeColor",colorVec2(thislen,:),"MarkerSize",MarkerSize,"LineWidth",LineWidth); hold on;
            else %binocular
                polarplot(thistheta,[thisdata(1,:,thislen),thisdata(1,1,thislen)],'-',"Color",colorVec2(thislen,:),"MarkerFaceColor",colorVec2(thislen,:),"MarkerEdgeColor",colorVec2(thislen,:),"MarkerSize",MarkerSize,"LineWidth",LineWidth); hold on;
            end

            %set axis
            pax = gca;
            pax.ThetaZeroLocation = 'top';
            pax.ThetaAxisUnits = 'radians';
        end

        if thisplot == 1
            thetaticks([thistheta(1:3)]);
            thetaticklabels({'Headache','Dizziness','Nausea'});
            rlim([0.8,2]); %this is like the y

        elseif thisplot == 2
            thetaticks([thistheta(1:6)]);
            thetaticklabels({'Obj. interaction','Obj. distorted','Obj. location ','Swim','Blurry','Double'});
            rlim([0.2,2.3]);
        end
        set(gca,'box','off','FontSize',fontsize); hold on;

    end
end

