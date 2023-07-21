%load the data for lens quantification
%We took photos through the minification lenses and without the
%minification lenses to quantify the minification. 
%This script creates two varibles that hold all the data needed for analysis of the
%quantification of the lenses. 

load('0a.mat');load('0a_baseline.mat');load('0b.mat');load('0b_baseline.mat');
load('2a.mat');load('2a_baseline.mat');load('4b.mat');load('4b_baseline.mat');
load('2b.mat');load('2b_baseline.mat');load('4a.mat');load('4a_baseline.mat');

len_level_str = {'0','2','4'};
len_letter_str = {'a','b'};

%Create variables to hold all the data for the smaller FOV
baseline_min_0=[]; % 0% 
baseline_min_2=[]; % 2%
baseline_min_4=[];% 4%
dotnum = length(pts_0a_baseline_sm); %needed for regression

for len = 1:length(len_level_str)

    for sublen = 1:length(len_letter_str) %loop over lens letter

        eval(['this_base_data = pts_',len_level_str{len},len_letter_str{sublen},'_baseline_sm;']); %load baseline data for a given min level
        eval(['this_min_data = pts_',len_level_str{len},len_letter_str{sublen},'_sm;']); %load minification data for a given min level

        x_position_base = this_base_data(1,:); %grab only the x position of the grid points
        x_position_min = this_min_data(1,:);

        if len == 1 % 0%
            baseline_min_0(:,:,sublen) = [x_position_base; x_position_min]; %row=baselinex,minificationx col=eachpt 3rd=a,b len
           
            %Run a regression so that we can plot the slopes of the line
            regress_output = regress(baseline_min_0(2,:,sublen)', [ones(dotnum,1), baseline_min_0(1,:,sublen)']);

        elseif len ==2 % 2%
            baseline_min_2(:,:,sublen) = [x_position_base; x_position_min];
                       
            %Run a regression so that we can plot the slopes of the line
            regress_output = regress(baseline_min_2(2,:,sublen)', [ones(dotnum,1), baseline_min_2(1,:,sublen)']);

        elseif len == 3 % 4%
            baseline_min_4(:,:,sublen) = [x_position_base; x_position_min];
                        
            %Run a regression so that we can plot the slopes of the line
            regress_output = regress(baseline_min_4(2,:,sublen)', [ones(dotnum,1), baseline_min_4(1,:,sublen)']);
        end
        %collect slope and intercept
        m(1,sublen,len) = regress_output(2); %col=sublens, 3rd=0,2,4 min
        b(1,sublen,len) = regress_output(1);

    end
end
%convert slope and intercept into percents
m_p = (1 - m) .* 100; %col=sublens, 3rd=0,2,4 min
b_p = (1 - b) .* 100;

x_position_base=[];x_position_min=[];

