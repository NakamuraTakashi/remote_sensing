function F = reflectance2(x, Ref, Rinf, Asg, cosZw, u, k, N_VIS_BANDS)

H = x(N_VIS_BANDS+1);
rho = x(1:N_VIS_BANDS)*Asg(1:N_VIS_BANDS,:);

% rrs = Rinf.*(1-1.03*exp(-(1/cosZw+1.2*(1+2.0*u).^0.5).*a*H)) ...
%          +0.31*rho.*exp(-(1/cosZw+1.1*(1+4.9*u).^0.5).*a*H);
% rrs = Rinf.*(1-1.03*exp(-(1/cosZw+1.2*sqrt(1+2.0*u)).*a*H)) ...
%          +0.31*rho.*exp(-(1/cosZw+1.1*sqrt(1+4.9*u)).*a*H);
% rrs = Rinf.*(1-exp(-(1/cosZw+1.2*sqrt(1+2.0*u)).*k*H)) ...
%           +rho.*exp(-(1/cosZw+1.1*sqrt(1+4.9*u)).*k*H);
rrs = Rinf.*(1-exp(-(1/cosZw+1.03*sqrt(1+2.4*u)).*k*H)) ...
          +rho.*exp(-(1/cosZw+1.04*sqrt(1+5.4*u)).*k*H);

Rmodel = rrs;
% Rmodel = 0.5*rrs./(1-1.5*rrs);

F = sum( (Rmodel(:)-Ref(:)) .* (Rmodel(:)-Ref(:)) );
% F = sum( abs(Rmodel(:)-Ref(:))./Ref(:) );
end
    