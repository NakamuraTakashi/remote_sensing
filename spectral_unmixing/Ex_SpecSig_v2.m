% *************************************************************************
%    Extract spectral signature
%      ver 2016/02/04   Copyright (c) 2016 Takashi NAKAMURA
% *************************************************************************

sig_filename = {'Data/01_Acropora_muricata.csv'           % Reflectance files for component
                'Data/02_Pavona_frondifera.csv' 
                'Data/03_seagrass.csv' 
                'Data/04_brown_macroalgae.csv' 
                'Data/05_algallawn.csv' 
                'Data/06_Acropora_pulcra.csv' 
                'Data/07_Montipora_digitata.csv' 
                'Data/08_brown_macroalgae.csv' 
                'Data/09_green_macroalgae.csv' 
                'Data/10_green_macroalgae.csv' 
                'Data/11_red_algae.csv' 
                'Data/12_sand.csv' 
                'Data/13_Ulva_spp.csv' 
                'Data/14_Padina_spp.csv' 
                'Data/15_Sargassum_sp1_akarui.csv' 
                'Data/15_Sargassum_sp2_komakai.csv' 
                'Data/15_Sargassum_sp3_nokogiri.csv' 
                'Data/16_Turbinaria_ornata.csv' 
                'Data/17_black_soil.csv' 
                'Data/18_red_soil.csv' 
                'Data/19_hardpan.csv' 
                };
            
res_filename = 'Data/radiance_response_WV2.csv';   % Radiance response file for satellite sensor

out_filename = 'Data/SpecSig4WV2.csv';
%% 
num_files = size(sig_filename,1);

% ****** Read files ***********
Res = csvread(res_filename,1,0);

fid=fopen(out_filename,'w');

for j=1:num_files

    Sig = csvread(char(sig_filename(j)),1,0);
    
    x=Res(1:501,1);
    rb=Res(1:501,3:8); %radiance response の1~501行までを使う。3〜8列はband1~6の値
    
    Sig_inp = interp1(Sig(:,1),Sig(:,2),x);
    for i=1:6
        ssb(j,i)=sum(Sig_inp.*rb(:,i))/sum(rb(:,i));
        ssx(j,i)=sum(x.*rb(:,i))/sum(rb(:,i));
    end
    
    fprintf(fid,'%d, %d, %d, %d, %d, %d, %s\n',ssb(j,:),char(sig_filename(j)));
    
    %% Plot
    plot(ssx(j,:),ssb(j,:))
    hold on
    plot(x,Sig_inp)
end
fclose(fid);



