function SU_main(I_AREA, NUM_AREA) 
% *************************************************************************
%    Main function of Spectral unmixing technique
%      ver 2017/01/26   Copyright (c) 2015-2017 Takashi NAKAMURA
% *************************************************************************

%% 
% ****** Spectral unmixing technique ************************************** 
tic
% ***** Load data *********************************************************
load('output/SU_prep8.mat');

mask_area=mask_area;
N_PAIRS=N_PAIRS;
N_VIS_BANDS=N_VIS_BANDS;
Ref_area=Ref_area;
Ainf=Ainf;
u=u;
cosZw=cosZw;
% Asg=Asg;
Kz=Kz;
Asg_matrix=Asg_matrix;

kmax=size(Ref_area,1);
jmax=size(Ref_area,2);

x0(1:N_VIS_BANDS) = 1/N_VIS_BANDS;  % initial coverage
x0(N_VIS_BANDS+1) = 2.0;            % initial depth (m)

A=[];
b=[];
% Aeq=[ 1 1 1 1 0 ];
Aeq=[ ones(1,N_VIS_BANDS),  0 ];
beq=  1;
% lb =[ 0 0 0 0 0 ];
lb =[ zeros(1,N_VIS_BANDS), 0 ];
% ub =[ 1 1 1 1 30];
ub =[ ones(1,N_VIS_BANDS), 30 ];


% ***** Area triming ***********************
stp = floor(kmax/NUM_AREA);
kmin=(I_AREA-1)*stp+1;
if I_AREA < NUM_AREA
    kmax = I_AREA*stp;
end
kend = kmax-kmin+1;
Ref_trm = Ref_area(kmin:kmax,:,1:N_VIS_BANDS);

% ****** initialization *********************
% coverage = zeros([size(Ref_area(:,:,1)) N_COMP]);  % coverage(coverage==0) = nan;
% depth = zeros(size(Ref_area(:,:,1)));  % depth(depth==0) = nan;
% rss = zeros(size(Ref_area(:,:,1)));  % rss(rss==0) = nan;
% i_rss_min = ones(size(Ref_area(:,:,1)));  % rss(rss==0) = nan;
% cov_tmp2 = zeros([size(Ref_area(:,:,1)) N_VIS_BANDS]);  % coverage(coverage==0) = nan;
coverage = zeros([size(Ref_trm(:,:,1)) N_COMP]);  % coverage(coverage==0) = nan;
depth = zeros(size(Ref_trm(:,:,1)));  % depth(depth==0) = nan;
rss = zeros(size(Ref_trm(:,:,1)));  % rss(rss==0) = nan;
i_rss_min = ones(size(Ref_trm(:,:,1)));  % rss(rss==0) = nan;
cov_tmp2 = zeros([size(Ref_trm(:,:,1)) N_VIS_BANDS]);  % coverage(coverage==0) = nan;

% ****** loop start *********************

%Cluster settings
myCluster = parcluster('local');
myCluster.NumWorkers = 11;
saveProfile(myCluster);

parpool(myCluster,11)  % ÅöÅöÅö for parallel computing ÅöÅöÅö
parfor k=1:kend      % ÅöÅöÅö for parallel computing ÅöÅöÅö
% for k=1:kend
    for j=1:jmax
        if isnan(Ref_trm(k,j,1))
            continue
        end
        
%         rs_min = 1.0;
%         i_rs_min = 1;
        rss(k,j)=1.0e10;
        for ipr=1:N_PAIRS       
            Asg = Asg_matrix(:,:,ipr);
            obj = @(x) reflectance(x, Ref_trm(k,j,:), Ainf, Asg, Kz, N_VIS_BANDS);
%             obj = @(x) reflectance2(x, Ref_area(k,j,1:N_VIS_BANDS), Ainf, Asg, cosZw, u, Kz, N_VIS_BANDS);
            [x, rss_tmp] = fmincon(obj,x0,A,b,Aeq,beq,lb,ub);
            
            if rss(k,j) > rss_tmp
                rss(k,j) = rss_tmp;
                i_rss_min(k,j) = ipr;
                cov_tmp  = x(1:N_VIS_BANDS);
                depth(k,j) = x(N_VIS_BANDS+1);
            end

        end
        cov_tmp2(k,j,:) = cov_tmp;
        
        disp([k, j]);
        disp([ depth(k,j) rss(k,j) ]);
    end
%     toc
end
%% 
toc

for k=1:kend
    for j=1:jmax
        coverage(k,j,pairs(i_rss_min(k,j),:)) = cov_tmp2(k,j,:);
    end
end
delete(gcp('nocreate'))  % ÅöÅöÅö for parallel computing ÅöÅöÅö

%% 
% ***** Save data *********************************************************
SAVE_FILE=strcat('output/SU_results_',num2str(I_AREA,'%0.4u'),'.mat');
save(SAVE_FILE, 'coverage', 'depth', 'rss','kmin','kmax');




