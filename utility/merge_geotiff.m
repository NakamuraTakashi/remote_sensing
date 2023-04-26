filename(1)={'E:\Documents\Dropbox\SceNE\GIS\Bathymetry\Kikai_Abs_bath_2_fillgap2.tif'}; % ★★★ Band2 Blue
filename(2)={'E:\Documents\Dropbox\SceNE\GIS\Bathymetry\Kikai_DEM5_fillval2.tif'}; % ★★★ Band2 Blue
filename(3)={'E:\Documents\Dropbox\SceNE\GIS\M7019(Ver.2.2)\M7019_Amami_depth_Kikai1_Grd_utm.tif'}; % ★★★ Band2 Blue

for i=1:1:3
    [data, R] = readgeoraster(char(filename(i)));
    bath(:,:,i) = data;   % All area
end

%%
jmax=size(bath(:,:,1),1);
imax=size(bath(:,:,1),2);
%% 
bath(:,:,3) = imgaussfilt(bath(:,:,3),10);
%% 

bath2=zeros(size(bath(:,:,1)));
for i=1:imax
    for j=1:jmax
        if bath(j,i,2)==-9999
            r = (tanh(0.13*(bath(j,i,3)-15))+1)/2;
            bath2(j,i) = r*bath(j,i,3)+(1-r)*bath(j,i,1);
            if bath(j,i,1)>bath2(j,i)
%                 bath2(j,i)=bath(j,i,1);
            end
        else
            bath2(j,i) = -bath(j,i,2);
        end
    end
end

figure;
imshow(bath2, 'DisplayRange',[-10 60]);  % Relative depth image
axis on
colorbar

%% 
CRScode = 32652; % Code of UTM coordinate (check property in QGIS)

geotifname='Kikai1_bath_final.tif';
geotiffwrite(geotifname, bath2, R,'CoordRefSysCode',CRScode);


