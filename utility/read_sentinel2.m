%   Kikai area 
% 座標参照系（CRS）	EPSG:32652 - WGS 84 / UTM zone 52N - 出力レイヤ
% 領域	499980.0000000000000000,3090240.0000000000000000 : 609780.0000000000000000,3200040.0000000000000000
% 単位	メートル
% 幅	10980
% 高さ	10980
    filename(1)={'C:\Users\Takashi\Dropbox\SceNE\GIS\S2A_MSIL2A_20210923T015701_N0301_R060_T52RES_20210923T044240.SAFE\GRANULE\L2A_T52RES_A032661_20210923T020332\IMG_DATA\R10m\T52RES_20210923T015701_B02_10m.jp2'}; % ★★★ Band2 Blue
    filename(2)={'C:\Users\Takashi\Dropbox\SceNE\GIS\S2A_MSIL2A_20210923T015701_N0301_R060_T52RES_20210923T044240.SAFE\GRANULE\L2A_T52RES_A032661_20210923T020332\IMG_DATA\R10m\T52RES_20210923T015701_B03_10m.jp2'}; % ★★★ Band3 Green
    filename(3)={'C:\Users\Takashi\Dropbox\SceNE\GIS\S2A_MSIL2A_20210923T015701_N0301_R060_T52RES_20210923T044240.SAFE\GRANULE\L2A_T52RES_A032661_20210923T020332\IMG_DATA\R10m\T52RES_20210923T015701_B04_10m.jp2'}; % ★★★ Band4 Red
    filename(4)={'C:\Users\Takashi\Dropbox\SceNE\GIS\S2A_MSIL2A_20210923T015701_N0301_R060_T52RES_20210923T044240.SAFE\GRANULE\L2A_T52RES_A032661_20210923T020332\IMG_DATA\R10m\T52RES_20210923T015701_B08_10m.jp2'}; % ★★★ Band8 NIR

    N_VIS_BANDS = 3; % Number of Visible bands
    N_TOT_BANDS = 4; % Number of total bands
   
    for i=1:1:N_TOT_BANDS
        [DNrow, R] = imread(char(filename(i)));
        Ref(:,:,i) = cast(DNrow, 'double')./2^12;   % All area
    end
%% UTM coordinate

X=499980+5:10:609780-5;
Y=3200040-5:-10:3090240+5;

%%

% ****** Plot Ref maps *********************
% 
% for i=1:1:N_TOT_BANDS
%     figure;
%     imshow(Ref(:,:,i), 'DisplayRange',[0 0.4]);
%     title(['Reflectance (band ', num2str(i), ')'])
%     axis on
%     colorbar
% end

%% 
% ****** Plot RGB color map *********************
%     RGB(:,:,3)=Ref(:,:,1)*3;  % B
%     RGB(:,:,2)=Ref(:,:,2)*3;  % G
%     RGB(:,:,1)=Ref(:,:,3)*3;  % R   
% figure;
% imshow(RGB);  % RGB true color image
% axis on
% clear RGB

%% 

irange=8000:10000;
jrange=3500:5000;
for i=1:1:N_VIS_BANDS
    figure;
    plot(Ref(jrange,irange,4),Ref(jrange,irange,i),'.');
    p(i,:) = polyfit(Ref(jrange,irange,4),Ref(jrange,irange,i),1);
    hold on
    fplot(@(x) p(i,1)*x+p(i,2));
    hold off
end
Rmin(1:4)=0;
Rmin(4)=min(min(Ref(jrange,irange,4)));
Rmax=max(max(Ref(jrange,irange,4)));

%% Trim target area (for reduce memory consumption)
yrange_area = 5750:7500;  xrange_area = 8500:10500;   % ★★★★★★★★★★★★★★★★★★

Ref_sgc=Ref(yrange_area,xrange_area,:);
jmax=size(Ref_sgc,1);
imax=size(Ref_sgc,2);
%% 
X2=X(xrange_area);
Y2=Y(yrange_area);
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
    imshow(Ref_sgc(:,:,i), 'DisplayRange',[0.05 0.07]);
    title(['Reflectance (band ', num2str(i), ')'])
    axis on
    colorbar
end
%% 

% % ****** Plot RGB color map *********************
%     RGB(:,:,3)=Ref_sgc(:,:,1)*3;  % B
%     RGB(:,:,2)=Ref_sgc(:,:,2)*3;  % G
%     RGB(:,:,1)=Ref_sgc(:,:,3)*3;  % R   
% figure;
% imshow(RGB);  % RGB true color image
% axis on
% clear RGB

%%
    mask = ones(size(Ref_sgc(:,:,4)));
    mask(Ref_sgc(:,:,4)>Rmax)=nan;  % ★★★ NIRの反射が高いところ（陸）をマスク（要調整） ★★★
%     mask(Ref_sgc(:,:,2)<0.045)=nan;   % ★★★ Greenの反射が低いところ（外洋/深いところ）をマスク（要調整） ★★★
%%

% dl=real(log(Ref_sgc(:,:,3))./log(Ref_sgc(:,:,1))).*mask;
dl=real(log(Ref_sgc(:,:,2))./log(Ref_sgc(:,:,1))).*mask;
% dl=real(log(Ref_sgc(:,:,3))./log(Ref_sgc(:,:,2))).*mask;
figure;
% imshow(dl, 'DisplayRange',[1 2]);  % Relative depth image
imshow(dl, 'DisplayRange',[1 2]);  % Relative depth image
% imshow(dl, 'DisplayRange',[1 2]);  % Relative depth image
axis on
colorbar
%% Relative depth
% ncfname='C:\Users\Takashi\Dropbox\SceNE\GIS\bath2.nc';
% nccreate(ncfname,'y','Dimensions',{'y',jmax},'Format','classic');
% nccreate(ncfname,'x','Dimensions',{'x',imax},'Format','classic');
% nccreate(ncfname,'band1','Dimensions',{'x',imax,'y',jmax},'Format','classic');
% ncwrite(ncfname,'y',Y2);
% ncwrite(ncfname,'x',X2);
% ncwrite(ncfname,'band1',transpose(dl));

%% Senditel2 band data with sun-glint correction
ncfname='C:\Users\Takashi\Dropbox\SceNE\GIS\sentinel2_trimed_sgc.nc';
nccreate(ncfname,'y','Dimensions',{'y',jmax},'Format','classic');
nccreate(ncfname,'x','Dimensions',{'x',imax},'Format','classic');
nccreate(ncfname,'band2','Dimensions',{'x',imax,'y',jmax},'Format','classic');
nccreate(ncfname,'band3','Dimensions',{'x',imax,'y',jmax},'Format','classic');
nccreate(ncfname,'band4','Dimensions',{'x',imax,'y',jmax},'Format','classic');
nccreate(ncfname,'band8','Dimensions',{'x',imax,'y',jmax},'Format','classic');
ncwrite(ncfname,'y',Y2);
ncwrite(ncfname,'x',X2);
ncwrite(ncfname,'band2',transpose(Ref_sgc(:,:,1)));
ncwrite(ncfname,'band3',transpose(Ref_sgc(:,:,2)));
ncwrite(ncfname,'band4',transpose(Ref_sgc(:,:,3)));
ncwrite(ncfname,'band8',transpose(Ref_sgc(:,:,4)));
