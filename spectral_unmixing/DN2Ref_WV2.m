function Ref = DN2Ref_WV2(DN, datestr, lat, lon, ACF, meanSunEl)

    EBW  = [ 4.730000e-02  5.430000e-02  6.300000e-02  3.740000e-02  5.740000e-02  3.930000e-02  9.890000e-02  9.960000e-02 ]; % Spectral Band's Effective Bandwidth

    Esun  =[ 1758.2229     1974.2416     1856.4104     1738.4791     1559.4555     1342.0695     1069.7302     861.2866    ]; % Mean solar exoatmospheric irradiances (W/m2/um) by WRC, 
%     Esun  =[ 1759.24       1977.40       1857.89       1738.11       1554.95       1302.19       1061.40       856.816      ]; % Mean solar exoatmospheric irradiances (W/m2/um) by ChKur, 
%     Esun  =[ 1773.81       2007.27       1829.62       1701.85       1538.85       1346.09       1053.21       856.599      ]; % Mean solar exoatmospheric irradiances (W/m2/um) by Thuillier 2003, 


    JD = juliandate(datetime(datestr));
    D = JD-2451545.0;
    g = 357.529 + 0.98560028*D;
    des = 1.00014 - 0.01671*cos(g) - 0.00014*cos(2*g);
    
    theta_s = (90 - meanSunEl)/180;
    
    L = zeros(size(DN));
    Ref = zeros(size(DN));
    
    for i=1:1:8
        L(:,:,i) = DN(:,:,i)*ACF(i)/EBW(i);
        Ref(:,:,i) = L(:,:,i)*des^2*pi/Esun(i)/cos(theta_s);
    end

end