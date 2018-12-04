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
