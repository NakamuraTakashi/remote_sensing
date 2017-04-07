Num_band = 5;

filename1='D:\Documents\GIS_data\Satellite image\2015-03-19_Yaeyama_RapidEye\2015-03-19T030941_RE3_1B-NAC_22345099_311449\2015-03-19T030941_RE3_1B-NAC_22345099_311449_band1.tif';
filename2='D:\Documents\GIS_data\Satellite image\2015-03-19_Yaeyama_RapidEye\2015-03-19T030941_RE3_1B-NAC_22345099_311449\2015-03-19T030941_RE3_1B-NAC_22345099_311449_band2.tif';
filename3='D:\Documents\GIS_data\Satellite image\2015-03-19_Yaeyama_RapidEye\2015-03-19T030941_RE3_1B-NAC_22345099_311449\2015-03-19T030941_RE3_1B-NAC_22345099_311449_band3.tif';
filename4='D:\Documents\GIS_data\Satellite image\2015-03-19_Yaeyama_RapidEye\2015-03-19T030941_RE3_1B-NAC_22345099_311449\2015-03-19T030941_RE3_1B-NAC_22345099_311449_band4.tif';
filename5='D:\Documents\GIS_data\Satellite image\2015-03-19_Yaeyama_RapidEye\2015-03-19T030941_RE3_1B-NAC_22345099_311449\2015-03-19T030941_RE3_1B-NAC_22345099_311449_band5.tif';

% [DNrow, R] = geotiffread(filename1);
% DN(:,:,1) = cast(DNrow, 'double');   % All area
% [DNrow, R] = geotiffread(filename2);
% DN(:,:,2) = cast(DNrow, 'double');   % All area
% [DNrow, R] = geotiffread(filename3);
% DN(:,:,3) = cast(DNrow, 'double');   % All area
% [DNrow, R] = geotiffread(filename4);
% DN(:,:,4) = cast(DNrow, 'double');   % All area
% [DNrow, R] = geotiffread(filename5);
% DN(:,:,5) = cast(DNrow, 'double');   % All area

[X, cmap, R] = geotiffread(filename1);
