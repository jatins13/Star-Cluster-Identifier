clc;close all;
%-------------------------------------------------------------------------%
    %first we converted imported table to an array and then rejected unknown
    %values in some it was depicted by ?
    %these are unit convension of variable we used through vizier
    %J/A+A/558/A53 Milky Way global survey of star clusters. II. (Kharchenko+, 2013)
    % RAhour F13.8  h     Right Ascension J2000.0, epoch 2000.0
    % DEdeg F13.7  deg    Declination J2000.0, epoch 2000.0
    % Bmag F8.3   mag    ?=99.990 Blue magnitude (1)
    % Vmag F8.3   mag    ?=99.990 Visual or red magnitude (2)
    % pmRA F10.2  mas/yr ?=9999.90 Proper Motion in RA*cos(DE)
    % pmDE F10.2  mas/yr ?=9999.90 Proper Motion in DE
    % e_pm F8.2   mas/yr ?=-9.99 Error of proper motion
    % RV F9.2     km/s   ?=999.99 Radial velocity
    % e_RV F7.2   km/s   ?=-9.99 Error of RV
    % Rcl F8.4    deg    Angular distance from cluster centre
%-------------------------------------------------------------------------%
%b=table2array(b);
%ra=table2array(ra);
%dec=table2array(dec);
%v=table2array(v);
%for i=1:length(pmra1)
%   if pmra1(i)==9999.90
%      rcl(i)=-1;
% end
%end
%pmra(pmra==9999.90)=[];
%pmdec(pmdec==9999.90)=[];
%e_pm(e_pm==-9.99)=[];
%rcl(rcl==-1)=[];
b1=zeros(size(b));%B_mag
v1=zeros(size(b));%V_mag
%to eleminate unknown values 
for i=1:length(b)
    if v(i)~=-99.990 && b(i)~=-99.990
        b1(i)=b(i);
        v1(i)=v(i);
    else
        b1(i)=-99;
        v1(i)=-99;
    end
end
v1(v1==-99)=[];b1(b1==-99)=[];
b_v=b1-v1;%(B-V)mag
%For plotting CMD 
scatter(b_v,v1,'.');title('CM Diagram');xlabel('(B-V)mag');ylabel('Mv(mag)'); %Color Magnitude plot 
figure;
%--------------------------------------------------------------------------%
    %if mass of stars was given then alternate method is using mass luminosity
    %relation and using Mo as mass of sun;
    %l=zeros(size(v1));%luminosity here it is ratio of L/Lo where Lo is stellar luminosity 
    %using mass luminosity relation given in wikki if mass is given 
    %for i=1:length(v1)
     %   if v1(i)<0.43*Mo
       %     l(i)=0.23*(v1(i)/Mo)^2.3;
     %   elseif 0.43*Mo<v1(i)<2*Mo
     %   elseif 2*Mo<v1(i)<20*Mo
      %      l(i)=1.4*(v1(i)/Mo)^3.5;
       % elseif 20*Mo<v1(i)<55*Mo
        %    l(i)=(v1(i)/Mo)^3.5;
        %else
         %  l(i)=3200*(v1(i)/Mo);
        %end
    %end
    %but here we have magnitude in visual band which measure of luminosity so
    %we just plotted directly Mv vs (B-V);
%--------------------------------------------------------------------------%
%--------------------------------------------------------------------------%
    %now using right accession and declination we can get direct view of  how
    %cluster is spread in space and thus to know stars distribution we also
    %plot contours of predicted distribution using its mean and variance
    %similarly can be done with proper motion right accession and proper motion
    %declination to get an idea that what is ideal boundary of the cluster
%--------------------------------------------------------------------------%
mu=[mean(ra),mean(dec)];Sigma=[var(ra) var(dec)];
x1 = 0.1310:0.0125:0.6707; x2 = -73.3264:0.025:-70.8334;
[X1,X2] = meshgrid(x1,x2);
F = mvnpdf([X1(:) X2(:)],mu,Sigma);
F = reshape(F,length(x2),length(x1));
mvncdf([0 0],[1 1],mu,Sigma);
scatter(ra, dec,1);
hold on;
contour(x1,x2,F);title('RA vs DEC');ylabel('RA(in h)');xlabel('DEC(in deg)');
hold off;
figure;
surf(x1,x2,F);title('predicted distribution function of stars');ylabel('RA');xlabel('DEC');figure;%normal distribution of stars
%PM_RA vs PM_DEC of stars based on proper motion 
mu=[mean(pmra,1),mean(pmdec,1)];Sigma=[var(pmra,1) var(pmdec,1)];
x1 = -377.5700:2:466.5700; x2 = -312.2000:4:412.7300;
[X1,X2] = meshgrid(x1,x2);
F = mvnpdf([X1(:) X2(:)],mu,Sigma);
F = reshape(F,length(x2),length(x1));
mvncdf([0 0],[1 1],mu,Sigma);  %to find Cummulative density function and drawing countour on proper motion RA vs proper motion DEC plot.
scatter(pmra,pmdec,1);  
hold on;
contour(x1,x2,F);title('pmRA vs pmDEC');ylabel('pmRA(in mas/yr)');xlabel('pmDEC(in mas/yr)');
hold off;
figure;
surf(x1,x2,F);title('predicted distribution function of stars according to proper motion');ylabel('pmRA');xlabel('pmDEC');figure; %normal distribution of stars based on proper motion 
subplot(2,1,1);plot(rcl,pmra,'.');xlabel('rcl(deg)');ylabel('pmra mas/yr');subplot(2,1,2);plot(rcl,pmdec,'.');xlabel('rcl(deg)');ylabel('pmdec mas/yr');%plot of pmra vs angular distance of stars from cluster's center and pmdec vs angular distance  of stars from cluster's center
x=[];y=[];
e_xy=[];X=[];Y=[];
for i=1:length(rcl)
    if rcl(i)==0
       x=[x; pmra(i)];
       y=[y ;pmdec(i)];
       e_xy=[e_xy ;e_pm(i)];
       X=[X;ra(i)];
       Y=[Y;dec(i)];
    end
end
centre=[mean(x) mean(y)];  %centre of cluster
RA=mean(X);Dec=mean(Y);      %Cluster's centre RA and DEC
temp=4600.*(1./(0.92.*(b_v)+1.7)+1./(0.92.*(b_v)+0.62)); %temperature of every star using theoritical formula in kelvin
%-------------------------------------------------------------------------%
    %if mass was given then whose value is near to 0.08*Mass of sun age of star
    %at that point is the age of cluster i.e it is turn off point of main
    %sequence of this cluster. turn off point is the point where [Fe/H] ratio
    %decay i.e main sequence stars convert to red dwarf region stars. On
    %average clusters age are nearly 1.2*10^10 years. formula to calculate age
    %is main sequence lifetime=(10^10)*(M/(1.98847*10^30)).^(-2.5);here
    %10^10 years is age of sun
%-------------------------------------------------------------------------%
