% *************************************************************************
%    Extract spectral signature
%      ver 20022/01/18   Copyright (c) 2016 Takashi NAKAMURA
%    Edited by Palika Wannawilai 2023/01/22
% *************************************************************************

sig_filename = {'Data/spec_sig/01_Acropora_muricata.csv'           % Reflectance files for component
                'Data/spec_sig/02_Pavona_frondifera.csv' 
                'Data/spec_sig/03_seagrass.csv' 
                'Data/spec_sig/04_brown_macroalgae.csv' 
                'Data/spec_sig/05_algallawn.csv' 
                'Data/spec_sig/06_Acropora_pulcra.csv' 
                'Data/spec_sig/07_Montipora_digitata.csv' 
                'Data/spec_sig/08_brown_macroalgae.csv' 
                'Data/spec_sig/09_green_macroalgae.csv' 
                'Data/spec_sig/10_green_macroalgae.csv' 
                'Data/spec_sig/11_red_algae.csv' 
                'Data/spec_sig/12_sand.csv' 
                'Data/spec_sig/13_Ulva_spp.csv' 
                'Data/spec_sig/14_Padina_spp.csv' 
                'Data/spec_sig/15_Sargassum_sp1_akarui.csv' 
                'Data/spec_sig/15_Sargassum_sp2_komakai.csv' 
                'Data/spec_sig/15_Sargassum_sp3_nokogiri.csv' 
                'Data/spec_sig/16_Turbinaria_ornata.csv' 
                'Data/spec_sig/17_black_soil.csv' 
                'Data/spec_sig/18_red_soil.csv' 
                'Data/spec_sig/19_hardpan.csv' 
                'Data/spec_sig/20_reef_rock.csv' 
                };
            
res_filename = 'Data/spec_sig/radiance_response_sentinel2B.csv';   % Radiance response file for satellite sensor

out_filename = 'Data/spec_sig/spec_sig4S2.csv';
%% 
num_files = size(sig_filename,1);

% ****** Read files ***********
Res = csvread(res_filename,1,0);

fid=fopen(out_filename,'w');

for j=1:num_files

    Sig = csvread(char(sig_filename(j)),1,0);
    
    x=Res(102:602,1);
    rb=Res(102:602,[3:6,10]); %radiance response from 400-900 wavelength of bands 2,3,4,5,8A
%     rb=Res(102:602,3:7); %radiance response from 400-900 wavelength of bands 2,3,4,5,6

    Sig_inp = interp1(Sig(:,1),Sig(:,2),x);
    for i=1:5
        ssb(j,i)=sum(Sig_inp.*rb(:,i))/sum(rb(:,i));
        ssx(j,i)=sum(x.*rb(:,i))/sum(rb(:,i));
    end
    
    fprintf(fid,'%d, %d, %d, %d, %d, %s\n',ssb(j,:),char(sig_filename(j)));
    
    %% Plot
    plot(ssx(j,:),ssb(j,:))
    hold on
    plot(x,Sig_inp)
end
fclose(fid);



