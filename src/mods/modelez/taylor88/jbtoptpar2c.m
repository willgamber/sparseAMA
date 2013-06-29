%
% John B. Taylor Multicountry Rational Expectations Model
%	Linearized 12/10/96 by John C. Williams
%
%	Parameter File
%
% ----------------------------------------------------
% Country codes
%	0:	United States
%	1:	Canada
%	2:	France
%	3:	Germany
%	4:	Italy
%	5:	Japan
%	6:	United Kingdom

% ----------------------------------------------------
% tayrulex:	= 1 : Taylor policy rule
%		= 0 : other policy rule

%tayrule0=	1;
tayrule1=	0;
tayrule2=	0;
tayrule3=	0;
tayrule4=	0;
tayrule5=	0;
tayrule6=	0;

% ----------------------------------------------------
% nomrulex:	= 1 : price level policy rule
%		= 0 : other policy rule

%nomrule0=	0;
nomrule1=	0;
nomrule2=	0;
nomrule3=	0;
nomrule4=	0;
nomrule5=	0;
nomrule6=	0;

% -----------------------------------------------------
% Taylor Rule Policy parameters
%	mrulerx	:	lag of short rate
%	mrulepx	:	current four-quarter inflation rate
%	mrulep1x:	lagged four-quarter inflation rate
%	mruleyx	:	current output gap 
%	mruley1x:	lagged output gap 

%mruler0	=	0.;
%mrulep00	=	0.5/4;
%mrulep10	=	0.5/4;
%mrulep20	=	0.5/4;
%mrulep30	=	0.5/4;
%mruley00	=	0.5;
%mruley10	=	0.;
mrulep1	=	0.5;
mruley1	=	0.5;
mrulep2	=	0.5;
mruley2	=	0.5;
mrulep3	=	0.5;
mruley3	=	0.5;
mrulep4	=	0.5;
mruley4	=	0.5;
mrulep5	=	0.5;
mruley5	=	0.5;
mrulep6	=	0.5;
mruley6	=	0.5;

% -----------------------------------------------------
% rholmx: autoregressive parameter in money growth 

rholm0	=	0;
rholm1	=	0;
rholm2	=	0;
rholm3	=	0;
rholm4	=	0;
rholm5	=	0;
rholm6	=	0;

% -----------------------------------------------------
% rholgx: autoregressive parameter in government spending

rhog0	=	0;
qtr4g0	=	0; % = 1 for four-quarter shock (set rhog0=1)
rhog1	=	0;
rhog2	=	0;
rhog3	=	0;
rhog4	=	0;
rhog5	=	0;
rhog6	=	0;

% -----------------------------------------------------
% normalization factors for demand components 
%	set approximately to size of GDP

dummy0=1/3300;
dummy1=1/400;
dummy2=1/1200;
dummy3=1/1500;
dummy4=1/86600;
dummy5=1/267300;
dummy6=1/200;

% -----------------------------------------------------
% linearization parameters
%	computed by `taylor88lindata.m'


% sample : 1971:1 - 1986:2

dummy0=1/3000;
dummy1=1/320;
dummy2=1/1040;
dummy3=1/1400;
dummy4=1/78000;
dummy5=1/220000;
dummy6=1/220;

cdbar0  =        247.42386252*dummy0;
cnbar0  =        738.87003347*dummy0;
csbar0  =        924.90494807*dummy0;
cdbar1  =         24.63779890*dummy1;
cnbar1  =         75.38207079*dummy1;
csbar1  =         75.57866602*dummy1;
cdbar2  =         62.94401364*dummy2;
cnbar2  =        347.26234321*dummy2;
csbar2  =        247.44971113*dummy2;
cbar3   =        772.31551571*dummy3;
cbar4   =      49832.49871981*dummy4;
cdbar5  =       7297.43653599*dummy5;
cnbar5  =      60363.82918269*dummy5;
csbar5  =      61372.97000801*dummy5;
cdbar6  =         13.17116440*dummy6;
cnbar6  =         71.18118382*dummy6;
csbar6  =         48.57896654*dummy6;
inebar0 =        221.19265075*dummy0;
insbar0 =        123.71003924*dummy0;
irbar0  =        148.46178069*dummy0;
iibar0  =         13.82229302*dummy0;
ifbar1  =         67.30794487*dummy1;
iibar1  =          2.82410027*dummy1;
inbar2  =        169.00903108*dummy2;
irbar2  =         59.17720433*dummy2;
iibar2  =          8.46950767*dummy2;
ifbar3  =        306.10444913*dummy3;
iibar3  =          5.79604073*dummy3;
ifbar4  =      13926.41627827*dummy4;
iibar4  =        670.68484752*dummy4;
inbar5  =      35420.82280988*dummy5;
irbar5  =      15001.38317947*dummy5;
iibar5  =       1342.12234569*dummy5;
inbar6  =         33.41236347*dummy6;
irbar6  =          8.74249443*dummy6;
iibar6  =          0.41575733*dummy6;
exbar0  =        300.06695690*dummy0;
exbar1  =         83.46888705*dummy1;
exbar2  =        223.96155852*dummy2;
exbar3  =        389.73434745*dummy3;
exbar4  =      17366.21907784*dummy4;
exbar5  =      30362.20012705*dummy5;
exbar6  =         58.19429954*dummy6;
imbar0  =        320.30853871*dummy0;
imbar1  =         73.41996196*dummy1;
imbar2  =        219.55518339*dummy2;
imbar3  =        368.36109839*dummy3;
imbar4  =      15544.44026429*dummy4;
imbar5  =      35446.98086850*dummy5;
imbar6  =         55.86257640*dummy6;
ybar0   =       3022.91513823*dummy0;
ybar1   =        318.84545689*dummy1;
ybar2   =       1040.24788461*dummy2;
ybar3   =       1386.67581861*dummy3;
ybar4   =      78483.84567462*dummy4;
ybar5   =     219939.80717346*dummy5;
ybar6   =        225.23256178*dummy6;
gbar0	=        613.85380149*dummy0;
gbar1	=         62.90386128*dummy1;
gbar2	=        136.39565863*dummy2;
gbar3	=        276.16753845*dummy3;
gbar4	=      11674.54076171*dummy4;
gbar5	=      42174.36461298*dummy5;
gbar6	=         46.87971232*dummy6;


% -----------------------------------------------------
% trend term for potential output
%	
% t = 1 for 1971:1

t =	31; % t = 1 for 1971:1

yt0 = exp(0* 7.824554 + 0.006021*t)*dummy0;
yt1 = exp(0* 5.513943 + 0.007953*t)*dummy1;
yt2 = exp(0* 6.755867 + 0.006074*t)*dummy2;
yt3 = exp(0* 7.074856 + 0.005077*t)*dummy3;
yt4 = exp(0*11.094975 + 0.005571*t)*dummy4;
yt5 = exp(0*11.977690 + 0.010259*t)*dummy5;
yt6 = exp(0* 5.299993 + 0.003728*t)*dummy6;

%-----

tayrule0=	1;
tayr10	=	1;
tayr20	=	0;
taypm40	=	0;
taypm30	=	0;
taypm20	=	0;
taypm10	=	0;
%tayp00	=	0;
tayp10	=	tayp00;
tayp20	=	tayp00;
tayp30	=	tayp00;
tayp40	=	0;
tayp80	=	tayp00;
tayp120	=	tayp00;
tayxm40	=	0;
tayxm30	=	0;
tayxm20	=	0;
tayxm10	=	0;
%tayx00	=	0;
tayx10	=	0;
tayx20	=	0;
tayplm3	=	0;
tayplm2	=	0;
tayplm1	=	0;
taypl00	=	0;
taypl10	=	0;
taypl20	=	0;
taypl30	=	0;
taywd00 =	0;
taywd10 =	0;
taypi00 =	0;
taypfx0 =	0;
tayc0	=	0;
tayfi0	=	0;
tayii0	=	0;
