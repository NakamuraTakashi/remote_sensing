function F = rss_att(x, Ainf)
Chla=x(1); % chl-a concentration (ug/L)
ag440 = x(2); % 0.05;
B = x(3); %0.3; % Gordon & Morel, 1983

[Kz, Ainf2, u] = ws_att(Chla, ag440, B);

F = sum((Ainf-Ainf2).*(Ainf-Ainf2));
% F = sum(abs(Ainf-Ainf2)./Ainf);

end




