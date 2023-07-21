%This script runs all of the scripts that make the plots in the Manuscript
clear all; close all;

current_path = pwd;
parent_path = fileparts(current_path);
folder_path = strcat(parent_path, '/data/Lens_data');
addpath(folder_path);
addpath("./distributionPlot/distributionPlot");
addpath("./Intersection_of_two_lines_function");

folder_path = strcat(parent_path, '/data');
addpath(folder_path);

load('AllData');

%Data formatting
% hReserve_40cm,     horizontal fusional reserve at 40cm row=subj col=diverge,converge
% vReserve_40cm,     vertical fusional reserve at 40cm row=subj col=diverge,converge
% hReserve_6m,       horizontal fusional reserve at 6m row=subj col=diverge,converge
% vReserve_6m,       vertical fusional reserve at 6m row=subj col=diverge,converge
% NatHPhoria_1base,  Horez phoria at 1m col=straight right left up down %1 m distance without lenses
% NatVPhoria_1base,  Vertucal phoria at 1m
% NatPhoria_1base,   phoria before lenses are worn at 1m row=subj 
%                    col= horizontal, vertical phoria. This has some
%                    duplicate information to the first two variables 
% NatPhoria_6base,   phoria before lenses are worn measured at 6m
%                    row=subj col=horizontal, vertical phoria
% NatPhoria_40base,  same as above except measured at 40 cm
% NatHPhoria_pre,    col=straight right left up down %pre task. Horizontal phoria
% NatVPhoria_pre,    col=straight right left up down %pre task. Vertical phoria
% NatVPhoria_post,   vertical phoria after lenses removed row=subj col=head turn straight right left up down
% NatHPhoria_post,   horizontal phoria after lenses removed
% NatPerceptQ,       row=preceptual questions for each subj stacked (Obj interact, obj size, obj
%                    location, swim, blurr, double), col=lenses (00,22,02,44,04)
% NatQs_eyestrain,   row=eye strain each subj, col=lenses (00,22,02,44,04)
% NatQs_perceptual,  row=subj col=question (Obj interact, obj size, obj
%                    location, swim, blurr, double), 3rd=lenses(00,22,02,44,04)
% Natrank,           row=subj col=lenses (00,22,02,44,04)
% NatSymp,           row=subj col=HDN, 3rd=lens(00,22,02,44,04)
% Natwear,           row=subj col=lenses (00,22,02,44,04)
% Oscmotion_range,   reported movement of afterimage relative to lines on stimulus row=subj col=lenses (00,22,02,44,04)
% Oscmotion_score,   likert score 1-5 row=subj col=lenses (00,22,02,44,04)
% Oscrank,           col=glasses (00,22,02,44,04)
% Oscwear,           would you wear the lenses on a regular basis Y/N col=len row=subj, yes=1 no=0
% Note: VOMS refers to the head and eye movement session. 
% VOMSrank,          ranking data row=subj, col=lens (00,22,02,44,04)
% VOMSSymp_base,     baseline symptoms 1-5 taken before each eye movement row=subj,
%                    col=HDN, 3rd=len (00,22,02,44,04)
% VOMSSymp_converge, symptom score 1-5 after converging row=subj col=HDN,
%                    3rd=lens(00,22,02,44,04)
% VOMSSymp_ms,       head and body rotation same format as above
% VOMSwear,          wear on a daily basis Y/N row=subj col=lens (00,22,02,44,04)
% NatQs_control,     head or neck pain control question 1-5 row=subj 3rd=lens (00,22,02,44,04)
% SSscore,           motion sickness seseptability score as described in paper


%% Plotting variables 

color_08           = [0.2000, 0.2000,0.2000];
color_01           = [0,0.5364,0.8892];
color_07           = [0.4902,0.1137,0.1922];
colorVec_other     = [0.4660, 0.6740, 0.1880; 0.4940, 0.1840, 0.5560; 0.9290, 0.6940,0.1250];
colorVec2          = [color_08;color_01;color_01;color_07;color_07];
colorVec2_cell     = {[colorVec2(1,:)],[colorVec2(2,:)],[colorVec2(3,:)],[colorVec2(4,:)],[colorVec2(5,:)]};
colorVec_mb        = [0, 0.5000,0;0.7500, 0.7500, 0];
LenlevelStr_short  = {'0','2','4'};
alpha_of_histogram = 0.15;
lennumstr          = {'1','2','3','4','5'}; 
xval               = [1,2,3,4,5];
LensStr            = {'0,0','2,2','0,2','4,4','0,4'};
lenLevelStr        = {'0% minification';'2% minification';'4% minification'};
legdStr            = {'one';'two';'three';'four';'five'};

%% scripts for plots

%Figure 4 naturalistic task
Fig_4_naturalistic_task;

%figure 5, Oscillopsia session
Fig_5_oscillopisa;

%Figure 6, Controlled head and eye movement session
Fig_6_head_and_eye;

%Figure 7, post-hoc analysis of dizziness from the controlled head and eye
%movement session. 
Fig_7_diz_head_and_eye; 

%Figure 8, Eyestrain and phoria
Fig_8_strain_phoria;

%Figure 9, Distortion tollerance
Fig_9_dist_toll;

%Subplementary Figure - Quantifying lenses
Fig_S1_lens_quant;

%Script that converts the data matfiles into csvs for r studio statistical
%analysis
Mat_to_CSV;


