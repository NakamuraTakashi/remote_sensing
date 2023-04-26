ncfname1='C:\Users\Takashi\Dropbox\SceNE\GIS\sentinel2_trimed_sgc.nc';
ncfname2='C:\Users\Takashi\Dropbox\SceNE\GIS\data\Kikai_DEM_merged1.nc';
ncfname3='C:\Users\Takashi\Dropbox\SceNE\GIS\GEBCO_05_Feb_2022_c31cc9c684b0\GEBCO_utm_refine.nc';
x=ncread(ncfname2,'x');
y=ncread(ncfname2,'y');

h1 = ncread(ncfname2,'Band1'); %DEM
h2 = ncread(ncfname3,'Band1'); %GEBCO
b3 = ncread(ncfname1,'band3');
b3=fliplr(b3);
%% 

figure;
imshow(h1, 'DisplayRange',[-50 -1]);  % RGB true color image
axis on
colorbar
figure;
imshow(h2, 'DisplayRange',[-50 -1]);  % RGB true color image
axis on
colorbar
figure;
imshow(b3, 'DisplayRange',[0.05 0.08]);  % RGB true color image
axis on
colorbar

%% 
imax=size(x,1);
jmax=size(y,1);
hm=h2;
for i=1:imax
    for j=1:jmax
        if h2(i,j)<=-100
            hm(i,j)=h2(i,j);
        else
            if h1(i,j)>=-7
                hm(i,j)=h1(i,j);
            elseif h1(i,j)<-7
                bmax=0.055;
                bmin=0.051;
                w=(b3(i,j)-bmin)/(bmax-bmin);
                w=max(w,0);
                w=min(w,1);
                hm(i,j)=w*h1(i,j)+(1-w)*h2(i,j);
            end
        end
    end
end

figure;
imshow(hm, 'DisplayRange',[-100 2]);  % RGB true color image
axis on
colorbar
%% Write Merged map

ncfname='C:\Users\Takashi\Dropbox\SceNE\GIS\Kikai_DEM_merged2.nc';
nccreate(ncfname,'y','Dimensions',{'y',jmax},'Format','classic');
nccreate(ncfname,'x','Dimensions',{'x',imax},'Format','classic');
nccreate(ncfname,'Band1','Dimensions',{'x',imax,'y',jmax},'Format','classic');
ncwrite(ncfname,'y',y);
ncwrite(ncfname,'x',x);
ncwrite(ncfname,'Band1',hm);