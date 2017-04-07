filename='D:\Documents\GIS_data\Satellite image\5Sep2012_Shiraho\052875753010_01\052875753010_01_P001_MUL\12SEP05023730-M2AS-052875753010_01_P001.TIF'; % ÅöÅöÅö
info = geotiffinfo(filename)
%% Write Geotiff
latlim = [lat(id_s_lat) lat(id_e_lat)];
lonlim = [lon(id_s_lon) lon(id_e_lon)];
% R = georefcells(latlim,lonlim,size(temp2));
R = georefpostings(latlim,lonlim,size(temp2));
geotiffwrite(['HYCOM_SST_', datestr(date) 'v2.tif'],temp2,R)

% %% 
% % Set lat, lon at specific station. 
% s_lat = 20;
% e_lat = 50;
% s_lon = 110;
% e_lon = 170;
% % Set time at specific date. 
% s_time = ( datenum(1993,9,1,0,0,0) - starting_date )*24; % hours since 2000-01-01 00:00:00
% 
% % Serching index number of nearest grid 
% [M,id_s_lon]  = min(abs(lon - s_lon));
% [M,id_e_lon]  = min(abs(lon - e_lon));
% [M,id_s_lat]  = min(abs(lat - s_lat));
% [M,id_e_lat]  = min(abs(lat - e_lat));
% % Serching index number of nearest time
% [M,id_time] = min(abs(time - s_time));
% 
% % Calculate count for reading data
% c_lon = id_e_lon - id_s_lon +1;
% c_lat = id_e_lat - id_s_lat +1;
% 
% % Read temperature data
% s_temp = ncread(opdurl, 'water_temp',[id_s_lon id_s_lat 1 id_time], [c_lon c_lat 1 1]);
% 
% %% plot figure
% temp2 = transpose(s_temp);
% lon2=lon(id_s_lon:id_e_lon);
% lat2=lat(id_s_lat:id_e_lat);
% date = starting_date + time(id_time)/24;
% fig1 = figure;
% fig1.Colormap=jet(128);
% h1=pcolor(lon2,lat2,temp2);
% h1.LineStyle='none';
% ax1 = fig1.CurrentAxes;
% colorbar(ax1);
% ax1.CLim=[15,32];
% ax1.Title.String=['Sea Surface Temperature (degC),     ', datestr(date)];
% 
