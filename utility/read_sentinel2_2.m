%   Palau area 
% 座標参照系（CRS）	EPSG:32653 - WGS 84 / UTM zone 53N - 出力レイヤ
% 領域	399960.0000000000000000,690240.0000000000000000 : 509760.0000000000000000,900000.0000000000000000
% 単位	メートル
% 幅	10980
% 高さ	20976
    filename(1)={'E:\Documents\Dropbox\Palau\Palau_personal\PalauGISdata\Satellite_images\S2B_merged\T53NM__20211026T013459_B02_10m.tif'}; % ★★★ Band2 Blue
    filename(2)={'E:\Documents\Dropbox\Palau\Palau_personal\PalauGISdata\Satellite_images\S2B_merged\T53NM__20211026T013459_B03_10m.tif'}; % ★★★ Band3 Green
    filename(3)={'E:\Documents\Dropbox\Palau\Palau_personal\PalauGISdata\Satellite_images\S2B_merged\T53NM__20211026T013459_B04_10m.tif'}; % ★★★ Band4 Red
    filename(4)={'E:\Documents\Dropbox\Palau\Palau_personal\PalauGISdata\Satellite_images\S2B_merged\T53NM__20211026T013459_B08_10m.tif'}; % ★★★ Band8 NIR

    N_VIS_BANDS = 3; % Number of Visible bands
    N_TOT_BANDS = 4; % Number of total bands

CRScode = 32653; % Code of UTM coordinate (check property in QGIS)

%% Import data

for i=1:1:N_TOT_BANDS
    [DNrow, R] = readgeoraster(char(filename(i)));
    Ref(:,:,i) = cast(DNrow, 'double')./2^12;   % All area
end

X=R.XWorldLimits(1):R.CellExtentInWorldX:R.XWorldLimits(2);
% Y=R.YWorldLimits(1):R.CellExtentInWorldY:R.YWorldLimits(2);
Y=R.YWorldLimits(2):-R.CellExtentInWorldY:R.YWorldLimits(1);

%%

% ****** Plot Ref maps *********************

for i=1:1:N_TOT_BANDS
    figure;
    imshow(Ref(:,:,i), 'DisplayRange',[0 0.4]);
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

irange=3000:8000;
jrange=19000:19500;
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
yrange_area = 1:14000;  xrange_area = 1:7500;   % ★★★★★★★★★★★★★★★★★★

Ref_sgc=Ref(yrange_area,xrange_area,:);
jmax=size(Ref_sgc,1);
imax=size(Ref_sgc,2);

X2=X(xrange_area);
Y2=Y(yrange_area);

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
    RGB(:,:,3)=Ref_sgc(:,:,1)*2;  % B
    RGB(:,:,2)=Ref_sgc(:,:,2)*2;  % G
    RGB(:,:,1)=Ref_sgc(:,:,3)*2;  % R   
figure;
imshow(RGB);  % RGB true color image
axis on
clear RGB

%%
    mask = ones(size(Ref_sgc(:,:,4)));
    mask(Ref_sgc(:,:,4)>Rmax)=nan;  % ★★★ NIRの反射が高いところ（陸）をマスク（要調整） ★★★
    mask(Ref_sgc(:,:,2)<0.05)=nan;   % ★★★ Greenの反射が低いところ（外洋/深いところ）をマスク（要調整） ★★★
%%

% dl=real(log(Ref_sgc(:,:,3))./log(Ref_sgc(:,:,1))).*mask;
dl=real(log(Ref_sgc(:,:,2))./log(Ref_sgc(:,:,1))).*mask;
% dl=real(log(Ref_sgc(:,:,3))./log(Ref_sgc(:,:,2))).*mask;
figure;
% imshow(dl, 'DisplayRange',[1 2]);  % Relative depth image
imshow(dl, 'DisplayRange',[0 2]);  % Relative depth image
% imshow(dl, 'DisplayRange',[1 2]);  % Relative depth image
axis on
colorbar
%% Relative depth
R2 = R;
R2.XWorldLimits=[min(X2) max(X2)+R.CellExtentInWorldY];
R2.YWorldLimits=[min(Y2)-R.CellExtentInWorldY max(Y2)];
R2.RasterSize = size(Ref_sgc,[1 2]);

geotifname='Rel_depth.tif';
geotiffwrite(geotifname, dl, R2,'CoordRefSysCode',CRScode);

%% Senditel2 band data with sun-glint correction
geotifname='B2_sgc.tif';
geotiffwrite(geotifname, Ref_sgc(:,:,1), R2,'CoordRefSysCode',CRScode);
geotifname='B3_sgc.tif';
geotiffwrite(geotifname, Ref_sgc(:,:,2), R2,'CoordRefSysCode',CRScode);
geotifname='B4_sgc.tif';
geotiffwrite(geotifname, Ref_sgc(:,:,3), R2,'CoordRefSysCode',CRScode);
geotifname='B8.tif';
geotiffwrite(geotifname, Ref_sgc(:,:,4), R2,'CoordRefSysCode',CRScode);
