function [Kz, Ainf, u] = ws_att(Chla, ag440, B)
% Chla=0.2; % chl-a concentration (ug/L)
% ag440 = 0.05; % 0.05;
% 
% B = 0.1; %0.3; % Gordon & Morel, 1983
g0 = 0.07;
g1 = 0.155;
g2 = 0.752;

res_filename = 'Data/radiance_response_WV2.csv';   % Radiance response file for satellite sensor
aw_filename = 'Data\aw_Smith_Baker_1981.txt';
ap_filename = 'Data\aphy_Lee_et_al_1998.txt';

% ************************************************************************
Res = csvread(res_filename,1,0);

wl=390:750;

aw_d = readtable(aw_filename,'Format','%f%f%f%f%f');
aw = interp1(aw_d.wl,aw_d.aw,wl,'pchip');

ap440=0.06*Chla^0.65;
% [aphy_data, aphy_ver, aphy_case]  = tblread( 'Data\aphy_Lee_et_al_1998.txt','\t');
ap_d = readtable(ap_filename,'Format','%f%f%f');
ap0 = interp1(ap_d.wl,ap_d.a0,wl,'pchip');
ap1 = interp1(ap_d.wl,ap_d.a1,wl,'pchip');
ap = (ap0+ap1*log(ap440))*ap440;

ag = ag440*exp(-0.015*(wl-440));

at = aw + ap + ag;

bw = interp1(aw_d.wl,aw_d.bfw,wl,'pchip');

bp = B*Chla^0.62*550./wl;

bt = bw + bp;

alpha = at + bt;

ut = bt./(at+bt);

for i=1:6;
    res = interp1(Res(:,1),Res(:,i+2),wl,'pchip');
    Kz(i) = sum(res.*alpha)/sum(res);
    u(i) = sum(res.*ut)/sum(res);
end
% rrs_dp = (g0+g1*u.^g2).*u; % Lee et al. 1998
% rrs_dp = (0.084+0.170*u).*u; % Lee et al. 1999 (for higher scattering coastal water)
% rrs_dp = (0.0949+0.0794*u).*u; % Gordon et al. 1988
rrs_dp = (0.089+0.125*u).*u; % Lee et al. 2002

Ainf = rrs_dp;
% Ainf = 0.5*rrs_dp./(1-1.5*rrs_dp);
end




