%Figyre 7 post-hoc analysis of dizziness in the head and eye movement
%session

%% Calculations

% Rearage data for r studio analysis
allMovements = [VOMSSymp_pursuit_cor,VOMSSymp_saccades_cor,VOMSSymp_converge_cor,VOMSSymp_VOR_cor,VOMSSymp_ms_cor];
Cols = [1,4,7,10,13; 2,5,8,11,14; 3,6,9,12,15];
sympstr = {'H','D','N'};
for symp = 1:3
    AllMoves =[];
    for movements = 1:5
        AllLens = [];
        for len = 1:5
            %creates a column with all of the responses for one symptom for
            % one movement for all participants and all five lenses.
            AllLens = [AllLens; allMovements(:,Cols(symp,movements),len)];
        end
        %Puts the columns of types of movemnet side by side
        AllMoves = [AllMoves,AllLens];
    end
    eval(['VOMS_Symp_',sympstr{symp},' = AllMoves;']); %row=subj and len col=eye and head movements
end

%mean across symptoms excluding 0,0. 
lenNum      = repelem([1:5],40)';
VOMS_symp_d = [lenNum,VOMS_Symp_D]; %used for determining which lens is which
VOMS_symp_h = [lenNum,VOMS_Symp_H];
VOMS_symp_n = [lenNum,VOMS_Symp_N];

VOMS_Symp_D_ex0_mean = mean(VOMS_symp_d((VOMS_symp_d(:,1)>1),2:6));
VOMS_Symp_D_ex0_SD   = std(VOMS_symp_d((VOMS_symp_d(:,1)>1),2:6));
VOMS_Symp_D_ex0_CI   = (1.96.*VOMS_Symp_D_ex0_SD)./sqrt(40);
VOMS_Symp_H_ex0_mean = mean(VOMS_symp_h((VOMS_symp_h(:,1)>1),2:6));
VOMS_Symp_H_ex0_SD   = std(VOMS_symp_h((VOMS_symp_h(:,1)>1),2:6));
VOMS_Symp_H_ex0_CI   = (1.96.*VOMS_Symp_H_ex0_SD)./sqrt(40);
VOMS_Symp_N_ex0_mean = mean(VOMS_symp_n((VOMS_symp_n(:,1)>1),2:6));
VOMS_Symp_N_ex0_SD   = std(VOMS_symp_n((VOMS_symp_n(:,1)>1),2:6));
VOMS_Symp_N_ex0_CI   = (1.96.*VOMS_Symp_N_ex0_SD)./sqrt(40);


%% Plot
%plot symptoms across all lenses (excluding 0,0) to determine which head 
% and eye movements produce the most H, D, or N. 

LineWidth = 1.7;
MarkerSize = 9;
Sympstr = {'H','D','N'};
fontsize = 9;
alpha_of_histogram = 0.15;
xval = [1:5]; 
figure, hold on;

for symp = 1:3 %loop over the symptoms

   if symp == 1 %nausea
        thisdata = VOMS_Symp_N_ex0_mean;
        thishist = VOMS_symp_n((VOMS_symp_n(:,1)>1),2:6);
        thisci   = VOMS_Symp_N_ex0_CI;

    elseif symp == 3 %headache
        thisdata = VOMS_Symp_H_ex0_mean;
        thishist = VOMS_symp_h((VOMS_symp_h(:,1)>1),2:6);
        thisci   = VOMS_Symp_H_ex0_CI;
        
   elseif symp == 2 %dizziness
       thisdata = VOMS_Symp_D_ex0_mean;
       thishist = VOMS_symp_d((VOMS_symp_d(:,1)>1),2:6);
       thisci   = VOMS_Symp_D_ex0_CI;
   end
   
%scatter plot
eval([Sympstr{symp},'= plot(xval,thisdata,"-o","Color",colorVec_other(symp,:),"MarkerFaceColor",colorVec_other(symp,:),"MarkerEdgeColor",colorVec_other(symp,:),"MarkerSize",MarkerSize,"LineWidth",LineWidth); hold on;']);
Er = errorbar(xval,thisdata, (thisci.*ones(1,5)),-thisci.*ones(1,5)); Er.Color=[0 0 0]; Er.LineStyle = "none";

end
ylabel('Mean severity (likert scale 1-5)');
xticks(xval);
xticklabels({'Pursuits','Saccades','Convergence','VOR','Head-body rotation'});
xlim([0.5,5.5]);
legend([D,H,N],'Dizziness','Headache','Nausea');
set(gca,'box','on','plotboxaspectratio',[1.5 1 1],'FontSize',fontsize);
hold off;