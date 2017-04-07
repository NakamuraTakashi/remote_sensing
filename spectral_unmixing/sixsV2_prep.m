res_filename = 'Data/radiance_response_WV2.csv';   % Radiance response file for satellite sensor
out_filename = 'resWV2_6S.txt';

fid=fopen(out_filename,'w');

Res = csvread(res_filename,1,0);

wl = 350:2.5:1100;

for j=2:10
    res_new = interp1(Res(:,1),Res(:,j),wl);
    id_filter = res_new > 0.01;
    res_filter= res_new(id_filter);
    wl_filter = wl(id_filter);
    fprintf(fid, '%0.4f %0.4f\n', min(wl_filter)/1000, max(wl_filter)/1000 );
    for i=1:size(res_filter,2)
        fprintf(fid, '%0.3f ', res_filter(i) );
    end
    fprintf(fid, '\n');
end
fclose(fid);