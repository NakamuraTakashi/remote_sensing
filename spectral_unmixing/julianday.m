function JD=julianday(year,month,day,TIME0)
% JD=julianday(day,month,year) or JD=julianday(datum)
% where datum is a vector of length(3) = day,month,year
% or length(6) = day,month,year,hour,minutes,seconds
% Program for finding the Julian date for a given year, month and
% day.
% if called in the form julianday(day,month,year,TIME0) or
%    julianday(datum,TIME0) the output is not in julian days but
%    in the  time given by the String TIME0 (as used in
%    date_transform, e.g. 'hours since 1.1.2000'  
% The algorithm is valid for any Gregorian date producing a Julian date
% greater than zero.
% (From Fliegel H.F. and van Flandern T.C. 1968. Comm. ACM, 11, p.657)
%
% years B.C. are aumentet 1, as the year 0 does not exist
% in this calculation year 0 is effectivly the same as year -1
%
% J.Holfort
  
if nargin==0; error('wrong number of arguments'); end
hours=0; minutes=0; seconds=0;
if nargin<=2;
  if length(year)==3
    year=year(1); month=year(2); day=year(3);
  elseif length(year)==6
    year=year(1); month=year(2); day=year(3);
    hours=year(4); minutes=year(5); seconds=year(6);
  else
    jj=size(day);
    if jj(2)==6
      hours=year(:,4); minutes=year(:,5); seconds=year(:,6);
      year=year(:,1); month=year(:,2); day=year(:,3);
    elseif jj(1)==6; 
      hours=year(4,:); minutes=year(5,:); seconds=year(6,:);
      year=year(1,:); month=year(2,:); day=year(3,:);
    elseif length(day)~=1
      error('wrong dimension of day')
    end
  end
end
if nargin==2; TIME0=month; end
if nargin<4; TIME0=''; end
if ~ischar(TIME0); error('date form must be string'); end

ii=year<0; 
if sum(ii)>0;year(ii)=year(ii)+1; end
% input day,month,year
a=fix((month-14)/12);
JD1 = fix( day - 32075 + 1461 * ((year+4800+a)/4));
JD2 = fix(367 * ( (month-2-a*12)/12 ));
b= fix( (year+4900+a)/100);
JD3 = fix ( 3 * (b/4) );
JD = JD1+JD2-JD3;

JD=JD+ (hours +(minutes+seconds/60)/60)/24;

if ~isempty(TIME0)
  JD=date_transform(JD,'julday',TIME0);
end