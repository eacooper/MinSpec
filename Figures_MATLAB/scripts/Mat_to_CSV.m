% Converting the mat files into CSV files to run statistics in R studio
% The data gets saved as a CSV in the Statistical analysis folder.

%finding path to statistical analysis folder
current_path = pwd;
parent_path = fileparts(current_path);
parent_path2 = fileparts(parent_path);
csv_save_path = strcat(parent_path2,'\Statistical_analysis_R_studio\data');

%VOMs symptoms
eyemove = repelem([1:5],40); %this vector represents the different eye movements
VOMSSymp_matrix = [squeeze(VOMSSympall_pursuit_cor);squeeze(VOMSSympall_saccades_cor);squeeze(VOMSSympall_converge_cor);squeeze(VOMSSympall_VOR_cor);squeeze(VOMSSympall_ms_cor)];     
VOMSSymp_matrix = [eyemove',VOMSSymp_matrix];
VOMSSymp_t = array2table(VOMSSymp_matrix,'VariableNames', {'eyemove','00','22','02','44','04'});
writetable(VOMSSymp_t,strcat(csv_save_path,'\VOMSSymp.csv'));

%rank and wear
measures12 = repelem([1:2]',40);
VOMSrankwear = [VOMSrank;VOMSwear];
VOMSrankwear_t = array2table([measures12,VOMSrankwear],'VariableNames', {'measure','00','22','02','44','04'});
writetable(VOMSrankwear_t,strcat(csv_save_path,'\VOMSrankwear.csv'));


% Exploratory analysis. understanding which head/eye movements created the
% most dizzyness (or other symptoms)
subjNum = repmat(repelem([1:40],1),1,5)';
lenNum2 = repelem([1:5],40)';
VOMS_Symp_D_t = array2table([lenNum2,subjNum,VOMS_Symp_D],'VariableNames', {'lens','subj','pursuit','saccades','converge','VOR','MS'});
writetable(VOMS_Symp_D_t,strcat(csv_save_path,'\VOMSSymp_D.csv'));

%Oscillopisa Motion range
Oscmeasures1 = repelem([1:3],40); %used to mark which type of measurements are which.
Oscmeasures2 = repelem(4,39); %there are only 39 people ranking oscillopisa (see manuscript)
Oscnum = [Oscmeasures1';Oscmeasures2'];
Osc_matrix = [Oscmotion_rangedeg;Oscmotion_score;Oscwear;Oscrank];
Osc_matrix = [Oscnum,Osc_matrix]; %add the number in a column next to the data
Osc_all = array2table(Osc_matrix,'VariableNames', {'measure','00','22','02','44','04'});
writetable(Osc_all,strcat(csv_save_path,'\Osc_all.csv'));
%formated specifically for running ANOVA
subj = repmat([1:40]',5,1);
lenses = repelem([1:5]',numel(Oscmotion_rangedeg)/5,1);
Osc_onecol = reshape(Oscmotion_rangedeg,numel(Oscmotion_rangedeg),1); %all values in a column 
Osc_anova = array2table([subj,lenses,Osc_onecol],'VariableNames', {'subj','lenses','resp'});
writetable(Osc_anova,strcat(csv_save_path,'\Osc_anova.csv'));

%Naturalistic 
measurenat = repelem([1:6]',40); %indicate the type of measure 
Nat_sympQs = [squeeze(NatSympall); squeeze(NatQsall_perceptual); squeeze(NatQs_eyestrain);squeeze(NatQs_control);Natrank;Natwear];
Nat_sympQs_t = array2table([measurenat,Nat_sympQs],'VariableNames', {'measure','00','22','02','44','04'});
writetable(Nat_sympQs_t,strcat(csv_save_path,'\Nat_sympQs.csv'));
%symptoms not corrected
Nat_sump_notcor = squeeze(NatSympall);
Nat_symp_notcor_t = array2table([Nat_sump_notcor],'VariableNames', {'00','22','02','44','04'});
writetable(Nat_symp_notcor_t,strcat(csv_save_path,'\Nat_symp_notcor.csv'));

%Exploritory analysis for perceptual symptoms. rows = perceptual questions col=lenses 
NatPerceptQ = [];
NatPerceptQ_col = [];
for Q = 1:6
    ThisQ = [];
    for len = 1:5
        ThisQ = [ThisQ, NatQs_perceptual(:,Q,len)];
        ThisQ_col = reshape(ThisQ,numel(ThisQ),1); 
    end
    NatPerceptQ = [NatPerceptQ; ThisQ];
    NatPerceptQ_col = [NatPerceptQ_col,ThisQ_col];
end
numberIndicator = repelem([1:6]',40);
NatPerceptQ_t = array2table([numberIndicator,NatPerceptQ], 'VariableNames',{'measure','00','22','02','44','04'});
writetable(NatPerceptQ_t,strcat(csv_save_path,'\NatPerceptQs.csv'));
%Physical symptom organized in columns of symtoms - used for post-hoc
%dizziness analysis
lenindicator = repelem([1:5]',40);
NatPerceptQ_col_t = array2table([lenindicator,NatPerceptQ_col], 'VariableNames',{'len','Interact','Distorted','Location','Swim','Blurry','Double'});
writetable(NatPerceptQ_col_t,strcat(csv_save_path,'\NatPerceptQs_col.csv'));

%Exploritory analysis for physical symptom breakdown. H,D,N will be stacked
% values are not baseline corrected
NatSymp_HDN_data =[];
NatSymp_HDN_col_data=[];
for symp = 1:3
    ThisSymp = [];
    for len = 1:5
        ThisSymp = [ThisSymp, NatSymp(:,symp,len)];
        ThisSymp_col = reshape(ThisSymp,numel(ThisSymp),1); %organize symptoms into one column. 
    end
    NatSymp_HDN_data = [NatSymp_HDN_data;ThisSymp];%  row=subj and H,D,orN col=lenses
    NatSymp_HDN_col_data = [NatSymp_HDN_col_data,ThisSymp_col]; %row=lenses, col=H,D,N
end
numberIndicator = repelem([1:3]',40);
NatSymp_HDN_t = array2table([numberIndicator,NatSymp_HDN_data], 'VariableNames',{'measure','00','22','02','44','04'});
writetable(NatSymp_HDN_t,strcat(csv_save_path,'\NatSymp_HDN.csv'));
%Perceptual symptoms organized in columns of symtoms - used for post-hoc
%swim analysis
lensindicator = repelem((1:5)',40);
NatSymp_HDN_col_t = array2table([lensindicator,NatSymp_HDN_col_data], 'VariableNames',{'len','Headache','Dizziness','Nausea'});
writetable(NatSymp_HDN_col_t,strcat(csv_save_path,'\NatSymp_HDN_col.csv'));
%Phoria difference scores for initial wear of the lenses - pre minus baseline 
% for horizontal and vertical phoria.reformat the data for horizontal and vertical phoria.
NatHPhoria_diff =[]; NatVPhoria_diff =[];
%Phoria adaptation (post-pre) 
NatHPhoria_adapt = [];
NatVPhoria_adapt = [];
for len = 1:5
    AllLenH_dif = [];
    AllLenV_dif = [];
    AllLenH_adapt = [];
    AllLenV_adapt = [];
    for headturn = 1:5
        %making a column of one head turn for all subjects for all lenses
        AllLenH_dif = [AllLenH_dif; NatHPhoria_prebase(:,headturn,len)]; 
        AllLenV_dif = [AllLenV_dif; NatVPhoria_prebase(:,headturn,len)]; 
        %same for adaptation
        AllLenH_adapt = [AllLenH_adapt; NatHPhoria_postpre(:,headturn,len)];
        AllLenV_adapt = [AllLenV_adapt; NatVPhoria_postpre(:,headturn,len)];
    end
    % combining columns that represent each head turn
    NatHPhoria_diff = [NatHPhoria_diff, AllLenH_dif];
    NatVPhoria_diff = [NatVPhoria_diff, AllLenV_dif];
    %same for adaptation
    NatHPhoria_adapt = [NatHPhoria_adapt, AllLenH_adapt];
    NatVPhoria_adapt = [NatVPhoria_adapt, AllLenV_adapt];
end
subj = repmat([1:40]',5,1);
head = repelem([1:5]',40,1);
%Phoria once the lenses are put on write table
%horizontal
NatHPhoria_diff_t = array2table([head,subj,NatHPhoria_diff],'VariableNames', {'headturn','subj','00','22','02','44','04'});
writetable(NatHPhoria_diff_t,strcat(csv_save_path,'\NatHPhoria_diff.csv'));
%vertical
NatVPhoria_diff_t = array2table([head,subj,NatVPhoria_diff],'VariableNames', {'headturn','subj','00','22','02','44','04'});
writetable(NatVPhoria_diff_t,strcat(csv_save_path,'\NatVPhoria_diff.csv'));

%Adaptation to phoria write table
NatHPhoria_ad_t = array2table([head,subj,NatHPhoria_adapt],'VariableNames', {'headturn','subj','00','22','02','44','04'});
writetable(NatHPhoria_ad_t,strcat(csv_save_path,'\NatHPhoria_adapt.csv'));
NatVPhoria_ad_t = array2table([head,subj,NatVPhoria_adapt],'VariableNames', {'headturn','subj','00','22','02','44','04'});
writetable(NatVPhoria_ad_t,strcat(csv_save_path,'\NatVPhoria_adapt.csv'));

%used to run the ANOVAs
%pre minus baseline
subj = repmat([1:40]',5*5,1);
lenses = repelem([1:5]',200,1);
head = repmat(repelem([1:5]',40,1),5,1);
%Inital phoria differnces when the glasses are put on (pre-base)
%horizontal phoria
NatHPhoria_onecol = reshape(NatHPhoria_prebase,numel(NatHPhoria_prebase),1);
NatHPhoria_t = array2table([subj,head,lenses,NatHPhoria_onecol],'VariableNames', {'subj','headturn','lenses','resp'});
writetable(NatHPhoria_t,strcat(csv_save_path,'\NatHPhoria_diff_ANOVA.csv'));
%vertical phoria pre minus baseline
NatVPhoria_onecol = reshape(NatVPhoria_prebase,numel(NatVPhoria_prebase),1);
NatVPhoria_t = array2table([subj,head,lenses,NatVPhoria_onecol],'VariableNames', {'subj','headturn','lenses','resp'});
writetable(NatVPhoria_t,strcat(csv_save_path,'\NatVPhoria_diff_ANOVA.csv'));
%Phoria adaptation (post-pre)
%horizontal
NatHPhoria_adapt_onecol = reshape(NatHPhoria_postpre,numel(NatHPhoria_postpre),1);
NatHPhoria_adapt_t = array2table([subj,head,lenses,NatHPhoria_adapt_onecol],'VariableNames', {'subj','headturn','lenses','resp'});
writetable(NatHPhoria_adapt_t,strcat(csv_save_path,'\NatHPhoria_adapt_ANOVA.csv'));
%vertical
NatVPhoria_adapt_onecol = reshape(NatVPhoria_postpre,numel(NatVPhoria_postpre),1);
NatVPhoria_adapt_t = array2table([subj,head,lenses,NatVPhoria_adapt_onecol],'VariableNames', {'subj','headturn','lenses','resp'});
writetable(NatVPhoria_adapt_t,strcat(csv_save_path,'\NatVPhoria_adapt_ANOVA.csv'));
%All Basline phorias (eyes straight ahead)
phoria_dist = repelem([1:3]',40,1);
Phoria_allBaseline_straight = [NatPhoria_40base; NatPhoria_1base; NatPhoria_6base];
NatPhoria_allDist_straight_t = array2table([phoria_dist,Phoria_allBaseline_straight],'VariableNames', {'dist','H','V'});
writetable(NatPhoria_allDist_straight_t,strcat(csv_save_path,'\NatPhoria_allDist_straight.csv'));

%Motion sickness suseptability (head and body rotation)
SSQscore_t = array2table([SSscore],'VariableNames', {'SSQ'});
writetable(SSQscore_t,strcat(csv_save_path,'\SSQ.csv'));

%Fusional Reserve
%we explore the relationship between eye strain and fusional reserve in our
%exploritory analysis
type = repelem([1:4]',40,1);
Fusional_res_combined = [hReserve_6m;vReserve_6m;hReserve_40cm;vReserve_40cm];%row=subj %col=diverge,converge
Fusional_res_t = array2table([type,Fusional_res_combined],'VariableNames', {'type','Converge','Diverge'});
writetable(Fusional_res_t,strcat(csv_save_path,'\Fusional_reserve.csv'));

