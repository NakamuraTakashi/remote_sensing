function F = reflectance(x, Ref, Rinf, Asg, Kz, N_VIS_BANDS)

rrs = Rinf + (x(1:N_VIS_BANDS)*Asg(1:N_VIS_BANDS,:)-Rinf).*exp(-2*Kz*x(N_VIS_BANDS+1));
Rmodel = rrs; %Rmodel: 1x6 double, Ref: 1x1x6 double
% Rmodel = 0.5*rrs./(1-1.5*rrs);

dR = Rmodel(:)-Ref(:); % dR 6x1 double
% F = dR.' * dR; % residual sum of square
F = sqrt(dR.'*dR)/sqrt(Rmodel*Rmodel.'); % residual sum of square root with weight
% F = sum( abs(Rmodel(:)-Ref(:))./Ref(:) );
end
    