clc;close all;

%-------------------------------------------------------------------------%
    %first we converted imported table to an array and then rejected unknown
    %values in some it was depicted by ?
    %these are unit convension of variable we used through vizier
    %J/A+A/558/A53 Milky Way global survey of star clusters. II. 
    % RAhour F13.8  h    Right Ascension J2000.0, epoch 2000.0
    % DEdeg F13.7  deg   Declination J2000.0, epoch 2000.0
    % Bmag F8.3   mag    ?=-99.990 Blue magnitude (1)
    % Vmag F8.3   mag    ?=-99.990 Visual or red magnitude (2)
    % pmRA F10.2  mas/yr ?=9999.90 Proper Motion in RA*cos(DE)
    % pmDE F10.2  mas/yr ?=9999.90 Proper Motion in DE
    % Rcl F8.4    deg    Angular distance from cluster centre
%-------------------------------------------------------------------------%

%Converting Table to Array

%b_i=table2array(b_i);
%v_i=table2array(v_i);
%ra=table2array(ra);
%dec=table2array(dec);
%pmra_i=table2array(pmra_i);
%pmdec_i=table2array(pmdec_i);
%rcl=table2array(rcl);

%PREDICTION OF MISSING VALUES BY LINEAR REGRESSION USING PCA

fprintf('Model for B_mag\n');b=predict_values([ra,dec],b_i);
fprintf('\nModel for V_mag\n');v=predict_values([ra,dec],v_i);
fprintf('\nModel for pmra\n');pmra=predict_values([ra,dec],pmra_i);
fprintf('\nModel for pmdec\n');pmdec=predict_values([ra,dec],pmdec_i);

%Color Magnitude Diagram
b_v=b-v;
scatter(b_v,v,'.');title('CM Diagram');xlabel('(B-V)mag');ylabel('Mv(mag)');
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
%normal distribution of stars
surf(x1,x2,F);title('predicted distribution function of stars');ylabel('RA');xlabel('DEC');figure;

%PM_RA vs PM_DEC of stars based on proper motion 
mu=[mean(pmra,1),mean(pmdec,1)];Sigma=[var(pmra,1) var(pmdec,1)];
x1 = -377.5700:2:466.5700; x2 = -312.2000:4:412.7300;
[X1,X2] = meshgrid(x1,x2);
F = mvnpdf([X1(:) X2(:)],mu,Sigma);
F = reshape(F,length(x2),length(x1));
%to find Cummulative density function and drawing countour on proper motion RA vs proper motion DEC plot.
mvncdf([0 0],[1 1],mu,Sigma);  
scatter(pmra,pmdec,1);  
hold on;
contour(x1,x2,F);title('pmRA vs pmDEC');ylabel('pmRA(in mas/yr)');xlabel('pmDEC(in mas/yr)');
hold off;
figure;

%normal distribution of stars based on proper motion
surf(x1,x2,F);title('predicted distribution function of stars according to proper motion');ylabel('pmRA');xlabel('pmDEC');figure;  

%plot of pmra vs angular distance of stars from cluster's center and pmdec vs angular distance  of stars from cluster's center
subplot(2,1,1);plot((rcl),(pmra),'.');xlabel('rcl(deg)');ylabel('pmra mas/yr');subplot(2,1,2);plot(rcl,(pmdec),'.');xlabel('rcl(deg)');ylabel('pmdec mas/yr');figure;

%temperature of every star using theoritical formula in kelvin
temp=4600.*(1./(0.92.*(b_v)+1.7)+1./(0.92.*(b_v)+0.62)); 

%-------------------------------------------------------------------------%
    %if mass was given then whose value is near to 0.08*Mass of sun age of star
    %at that point is the age of cluster i.e it is turn off point of main
    %sequence of this cluster. turn off point is the point where [Fe/H] ratio
    %decay i.e main sequence stars convert to red dwarf region stars. On
    %average clusters age are nearly 1.2*10^10 years. formula to calculate age
    %is main sequence lifetime=(10^10)*(M/(1.98847*10^30)).^(-2.5);here
    %10^10 years is age of sun
%-------------------------------------------------------------------------%
%Descriptive Statistics for RA,DEC,pmRA and pmDEC.

%Maximum and minimum values:-
[max_value_ra,indexramax]=max(ra);
[max_value_dec,indexdecmax]=max(dec);
[min_value_ra,indexramin]=min(ra);
[min_value_dec,indexdecmin]=min(dec);
[max_value_pmra,indexpmramax]=max(pmra);
[max_value_pmdec,indexpmdecmax]=max(pmdec);
[min_value_pmra,indexpmramin]=min(pmra);
[min_value_pmdec,indexpmdecmin]=min(pmdec);

%Ranges:-
range_ra=max_value_ra-min_value_ra;
range_dec=max_value_dec-min_value_dec;
range_pmra=max_value_pmra-min_value_pmra;
range_pmdec=max_value_pmdec-min_value_pmdec;

%Mean, Median(50% quartile) and Mode:-
mean_ra=mean(ra);
mean_dec=mean(dec);
median_ra=median(ra);
median_dec=median(dec);
mode_ra=mode(ra);
mode_dec=mode(dec);
mean_pmra=mean(pmra);
mean_pmdec=mean(pmdec);
median_pmra=median(pmra);
median_pmdec=median(pmdec);
mode_pmra=mode(pmra);
mode_pmdec=mode(pmdec);

%Standard deviation and variance:-
stadev_ra=std(ra);
stadev_dec=std(dec);
var_ra=var(ra);
var_dec=var(dec);
stadev_pmra=std(pmra);
stadev_pmdec=std(pmdec);
var_pmra=var(pmra);
var_pmdec=var(pmdec);


%Quartiles (25% and 75%):-
quartile1ra=(median_ra+min_value_ra)/2;
quartile2ra=(median_ra+max_value_ra)/2;
quartile1dec=(median_dec+min_value_dec)/2;
quartile2dec=(median_dec+max_value_dec)/2;
quartile1pmra=(median_pmra+min_value_pmra)/2;
quartile2pmra=(median_pmra+max_value_pmra)/2;
quartile1pmdec=(median_pmdec+min_value_pmdec)/2;
quartile2pmdec=(median_pmdec+max_value_pmdec)/2;

%Box Plot --> Indicates Median, 25th and 75th quartiles.
%Whiskers are lines extending from each end of the box to show the extent of the rest of the data.
%Outliers are data with values beyond the ends of the whiskers.
boxplot(ra);title('Boxplot of RA without normalization');xlabel('Stars');ylabel('RA');
figure;
boxplot(dec);title('Boxplot of DEC without normalization');xlabel('Stars');ylabel('DEC');
figure;
boxplot(pmra);title('Boxplot of pmRA without normalization');xlabel('Stars');ylabel('pmRA');
figure;
boxplot(pmdec);title('Boxplot of pmDEC without normalization');xlabel('Stars');ylabel('pmDEC');
figure;

%Box Plot after Normalization
ranorm=(ra-mean_ra)/(stadev_ra);
boxplot(ranorm);title('Boxplot of RA with normalization');xlabel('Stars');ylabel('RA');
figure;
decnorm=(dec-mean_dec)/(stadev_dec);
boxplot(decnorm);title('Boxplot of DEC with normalization');xlabel('Stars');ylabel('DEC');
figure;
pmranorm=(pmra-mean_pmra)/(stadev_pmra);
boxplot(pmranorm);title('Boxplot of pmRA with normalization');xlabel('Stars');ylabel('pmRA');
figure;
pmdecnorm=(pmdec-mean_pmdec)/(stadev_pmdec);
boxplot(pmdecnorm);title('Boxplot of pmDEC with normalization');xlabel('Stars');ylabel('pmDEC');
figure;

%Histograms--> 
histogram(ra);title('RA');xlabel('Intervals or Bins');ylabel('Frequency');
figure;
histogram(dec);title('DEC');xlabel('Intervals or Bins');ylabel('Frequency');
figure;
histogram(pmra);title('pmRA');xlabel('Intervals or Bins');ylabel('Frequency');
figure;
histogram(pmdec);title('pmDEC');xlabel('Intervals or Bins');ylabel('Frequency');

%Multiple scatter plots
figure;
scatter([dec;pmdec],[ra;pmra],'.');title('Without normalization');xlabel('DEC,pmDEC');ylabel('RA,pmRA');
figure;
scatter([decnorm;pmdecnorm],[ranorm;pmranorm],'.');title('With normalization');xlabel('DEC,pmDEC');ylabel('RA,pmRA');
