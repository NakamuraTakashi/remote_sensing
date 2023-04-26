filename(1)={'E:\Documents\Dropbox\collaboration\Kurihara\Shizugawa\GIS\Satellite_images\S2A_MSIL2A_20211130T012011_N0301_R031_T54SWH_20211130T034519.SAFE\matlab_outputs\Shizugawa_abs_depth2_fillgap3.tif'}; % ★★★ Band2 Blue
filename(2)={'E:\Documents\Dropbox\collaboration\Kurihara\Shizugawa\GIS\bathymetry\Shizugawa3_10m.tif'}; % ★★★ Band2 Blue

for i=1:2
    [data, R] = readgeoraster(char(filename(i)));
    bath(:,:,i) = data;   % All area
end

%%
jmax=size(bath(:,:,1),1);
imax=size(bath(:,:,1),2);
%% 
% bath(:,:,3) = imgaussfilt(bath(:,:,3),10);
%% 

bath2=zeros(size(bath(:,:,1)));
for i=1:imax
    for j=1:jmax
        if bath(j,i,2)>-0.7
            r = (tanh(0.1*(bath(j,i,2)-4))+1)/2;
            bath2(j,i) = r*bath(j,i,2)+(1-r)*bath(j,i,1);
%             if bath(j,i,1)>bath2(j,i)
% %                 bath2(j,i)=bath(j,i,1);
%             end
        else
            bath2(j,i) = bath(j,i,2);
        end
    end
end

figure;
imshow(bath2, 'DisplayRange',[-3 20]);  % Relative depth image
axis on
colorbar

%% 
CRScode = 32654; % Code of UTM coordinate (check property in QGIS)

geotifname='Shizugawa3_bath_10m_grd_final.tif';
geotiffwrite(geotifname, bath2, R,'CoordRefSysCode',CRScode);


