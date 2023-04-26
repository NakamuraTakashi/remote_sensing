filename(1)={'E:\Documents\Dropbox\CORAL_NET\GIS\Bath_data\Panay_bath_S2A.tif'}; % ★★★ srtm
filename(2)={'E:\Documents\Dropbox\CORAL_NET\GIS\Bath_data\Panay_bath_merge_srtm_gebco.tif'}; % ★★★ gebco
filename(3)={'E:\Documents\Dropbox\CORAL_NET\GIS\Bath_data\landmask_Panay10m_v2.tif'}; % ★★★ sentinel2 delived bath

for i=1:1:3
    [data, R] = readgeoraster(char(filename(i)));
    bath(:,:,i) = data;   % All area
end

%%
jmax=size(bath(:,:,1),1);
imax=size(bath(:,:,1),2);
%% 
% bath(:,:,3) = imgaussfilt(bath(:,:,3),10);
%% 

bath(4000:7500,10000:14000,1)=nan;
%% 

bath2=zeros(size(bath(:,:,1)));

% bath2=bath(:,:,2)-bath(:,:,1);
for i=1:imax
    for j=1:jmax
        if isnan(bath(j,i,1))
            bath2(j,i) = bath(j,i,2);
        else
            if bath(j,i,2)>15
                bath2(j,i) = bath(j,i,2);
            elseif bath(j,i,2)<-30
                bath2(j,i) = bath(j,i,2);
            else
                if bath(j,i,3)==0
                    bath2(j,i) = bath(j,i,2);
                else
                    bath2(j,i) = bath(j,i,1);
                end
            end
        end
    end
end
%% 

figure;
imshow(bath2, 'DisplayRange',[-10 20]);  % Relative depth image
axis on
colormap jet
colorbar
%% 
% bath3(:,:) = imgaussfilt(bath2(:,:),10);
%% 

for i=1:imax
    for j=1:jmax
        if bath(j,i,3)>-10
            r = (-tanh(0.5*(bath(j,i,3)-15))+1)*0.5;
%             r = 1;
            bath2(j,i) = r*bath(j,i,3)+(1-r)*bath2(j,i);
        end
    end
end

figure;
imshow(bath2, 'DisplayRange',[-100 100]);  % Relative depth image
axis on
colormap jet
colorbar

%% 
CRScode = 32651; % Code of UTM coordinate (check property in QGIS)

geotifname='Panay_bath_merged_final.tif';
geotiffwrite(geotifname, bath2, R,'CoordRefSysCode',CRScode);


