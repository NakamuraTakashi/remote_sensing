%   Shizugawa area 

    filename(1)={'E:\Documents\Dropbox\CORAL_NET\GIS\S2A_MSIL2A_20220603T022331_N0400_R103_T51PUP_20220603T061510.SAFE\geotiff_trimed\B2.tif'}; % ★★★ Band2 Blue
    filename(2)={'E:\Documents\Dropbox\CORAL_NET\GIS\S2A_MSIL2A_20220603T022331_N0400_R103_T51PUP_20220603T061510.SAFE\geotiff_trimed\B3.tif'}; % ★★★ Band3 Green
    filename(3)={'E:\Documents\Dropbox\CORAL_NET\GIS\S2A_MSIL2A_20220603T022331_N0400_R103_T51PUP_20220603T061510.SAFE\geotiff_trimed\B4.tif'}; % ★★★ Band4 Red
    filename(4)={'E:\Documents\Dropbox\CORAL_NET\GIS\S2A_MSIL2A_20220603T022331_N0400_R103_T51PUP_20220603T061510.SAFE\geotiff_trimed\B8.tif'}; % ★★★ Band8 NIR

    N_VIS_BANDS = 3; % Number of Visible bands
    N_TOT_BANDS = 4; % Number of total bands

CRScode = 32651; % Code of UTM coordinate (check property in QGIS)

%% Import data

for i=1:1:N_TOT_BANDS
    [DNrow, R] = readgeoraster(char(filename(i)));
%     Ref(:,:,i) = cast(DNrow, 'double')./2^12;   % All area
    Ref(:,:,i) = cast(DNrow, 'double')./2^14;   % All area
end

X=R.XWorldLimits(1):R.CellExtentInWorldX:R.XWorldLimits(2);
% Y=R.YWorldLimits(1):R.CellExtentInWorldY:R.YWorldLimits(2);
Y=R.YWorldLimits(2):-R.CellExtentInWorldY:R.YWorldLimits(1);

%%

% ****** Plot Ref maps *********************

for i=1:1:N_TOT_BANDS
    figure;
    imshow(Ref(:,:,i), 'DisplayRange',[0 0.1]);
    title(['Reflectance (band ', num2str(i), ')'])
    axis on
    colorbar
end

%% 
% ****** Plot RGB color map *********************
    RGB(:,:,3)=Ref(:,:,1)*3;  % B
    RGB(:,:,2)=Ref(:,:,2)*3;  % G
    RGB(:,:,1)=Ref(:,:,3)*3;  % R   
figure;
imshow(RGB);  % RGB true color image
axis on
clear RGB

%% 

irange=1800:2200;
jrange=7200:8000;
for i=1:1:N_VIS_BANDS
    figure;
    plot(Ref(jrange,irange,4),Ref(jrange,irange,i),'.');
    p(i,:) = polyfit(Ref(jrange,irange,4),Ref(jrange,irange,i),1);
    hold on
    fplot(@(x) p(i,1)*x+p(i,2),[-0.01 0.2]);
    hold off
end
Rmin(1:4)=0;
Rmin(4)=min(min(Ref(jrange,irange,4)));
Rmax=max(max(Ref(jrange,irange,4)));

%% Trim target area (for reduce memory consumption)
% yrange_area = 5500:8000;  xrange_area = 8000:10500;   % ★★★★★★★★★★★★★★★★★★
% 
% Ref_sgc=Ref(yrange_area,xrange_area,:);
% 
% jmax=size(Ref_sgc,1);
% imax=size(Ref_sgc,2);
% 
% X2=X(xrange_area);
% Y2=Y(yrange_area);

Ref_sgc=Ref; % all area
jmax=size(Ref_sgc,1);
imax=size(Ref_sgc,2);

X2=X;
Y2=Y;


%% Save memory 
clear Ref DNrow

%%

% ****** Plot Ref maps *********************

for i=1:1:N_TOT_BANDS
    figure;
    imshow(Ref_sgc(:,:,i), 'DisplayRange',[0 0.2]);
    title(['Reflectance (band ', num2str(i), ')'])
    axis on
    colorbar
end
%% ****** Plot RGB color map *********************
    RGB(:,:,3)=Ref_sgc(:,:,1)*4;  % B
    RGB(:,:,2)=Ref_sgc(:,:,2)*4;  % G
    RGB(:,:,1)=Ref_sgc(:,:,3)*4;  % R   
figure;
imshow(RGB);  % RGB true color image
axis on
clear RGB

%% 

for k=1:1:N_VIS_BANDS
    Rmin(k)=p(k,1)*Rmin(4)+p(k,2);
    for i=1:imax
        for j=1:jmax
            if Ref_sgc(j,i,4)<=Rmax
                cff=p(k,1)*Ref_sgc(j,i,4)+p(k,2)-Rmin(k);
                Ref_sgc(j,i,k)=Ref_sgc(j,i,k)-cff;
            end
        end
    end
end

%%

% % ****** Plot Ref maps *********************
% 
for i=1:1:N_TOT_BANDS
    figure;
    imshow(Ref_sgc(:,:,i), 'DisplayRange',[0.0 0.2]);
    title(['Reflectance (band ', num2str(i), ')'])
    axis on
    colorbar
end
%% 

% % ****** Plot RGB color map *********************
    RGB(:,:,3)=Ref_sgc(:,:,1)*6;  % B
    RGB(:,:,2)=Ref_sgc(:,:,2)*6;  % G
    RGB(:,:,1)=Ref_sgc(:,:,3)*6;  % R   
figure;
imshow(RGB);  % RGB true color image
axis on
clear RGB

%%
    mask = ones(size(Ref_sgc(:,:,4)));
    mask(Ref_sgc(:,:,4)>Rmax)=nan;  % ★★★ NIRの反射が高いところ（陸）をマスク（要調整） ★★★
    mask(Ref_sgc(:,:,2)<0.001)=nan;   % ★★★ Greenの反射が低いところ（外洋/深いところ）をマスク（要調整） ★★★

%% Calculate relative depth

% dl=real(log(Ref_sgc(:,:,3))./log(Ref_sgc(:,:,1))).*mask;
dl=real(log(Ref_sgc(:,:,2))./log(Ref_sgc(:,:,1))).*mask;
% dl=real(log(Ref_sgc(:,:,3))./log(Ref_sgc(:,:,2))).*mask;

figure;
imshow(dl, 'DisplayRange',[0.7 1.8]);  % Relative depth image
axis on
colorbar

%% Fix abnormal values by median filter
dl2 = dl;
dl3 = dl;
for k=1:2
    for i=2:imax-1
        for j=2:jmax-1
            if isnan(dl2(j,i))
                    dl3(j,i) = nan;
            else
                A = [dl2(j,i) dl2(j-1,i) dl2(j+1,i) dl2(j,i-1) dl2(j,i+1) dl2(j-1,i-1) dl2(j+1,i-1) dl2(j-1,i+1) dl2(j+1,i+1)];
                dl3(j,i) = median(A,'omitnan');
            end
        end
    end
    dl2 = dl3;
end

figure;
imshow(dl2, 'DisplayRange',[0.7 1.8]);  % Relative depth image
axis on
colorbar


%% Fill gap and remove isolated cell
dl3 = dl2;
dl4 = dl2;
for k=1:30
    for i=2:imax-1
        for j=2:jmax-1
            A = [dl3(j-1,i) dl3(j+1,i) dl3(j,i-1) dl3(j,i+1) dl3(j-1,i-1) dl3(j+1,i-1) dl3(j-1,i+1) dl3(j+1,i+1)];
            num = sum(isnan(A));
    
            if num >=5
                if isnan(dl3(j,i))==false
                    dl4(j,i) = nan;
                end
            else
                if isnan(dl3(j,i))
                    dl4(j,i) = mean(A,'omitnan');
                end
            end
        end
    end
    dl3 = dl4;
end

figure;
imshow(dl3, 'DisplayRange',[0.7 1.8]);  % Relative depth image
axis on
colorbar

%% Relative depth
R2 = R;
R2.XWorldLimits=[min(X2) max(X2)];
R2.YWorldLimits=[min(Y2) max(Y2)];
R2.RasterSize = size(Ref_sgc,[1 2]);

geotifname='Rel_depth3.tif';
geotiffwrite(geotifname, dl3, R2,'CoordRefSysCode',CRScode);

%% Senditel2 band data with sun-glint correction
geotifname='B2_sgc.tif';
geotiffwrite(geotifname, Ref_sgc(:,:,1), R2,'CoordRefSysCode',CRScode);
geotifname='B3_sgc.tif';
geotiffwrite(geotifname, Ref_sgc(:,:,2), R2,'CoordRefSysCode',CRScode);
geotifname='B4_sgc.tif';
geotiffwrite(geotifname, Ref_sgc(:,:,3), R2,'CoordRefSysCode',CRScode);
geotifname='B8.tif';
geotiffwrite(geotifname, Ref_sgc(:,:,4), R2,'CoordRefSysCode',CRScode);
