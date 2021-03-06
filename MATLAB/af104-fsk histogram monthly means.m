% af104-fsk histogram monthly means (sonar)

author   = 'M. Gries'; author
created  = '19.1.5  '; % granted from af104-fsk histogram monthly records
modified = '19.1.6  '; % field3 evaluation (KWh)
version  = '19.1.6  '; version

% references (af104-fsk histogram monthly records): 
% https://thingspeak.com/apps/matlab_visualizations/xxxxx/edit

readChannelID = 261716; % af104-fsk
FieldID = 2; % sonar (cm)
histogramTitle = 'Histogram Sonar HC-SR04 (No. af104-fsk)';
histogramXlabel = 'Number of records within this month (and last)';
histogramYlabel = 'Number of records per day';

% datasets (NumPoints) are limited to 8000 for a free licence 
% get Data with corresponding Timestamp and Channel information
[TT,chInfo] = thingSpeakRead(readChannelID,'Fields',FieldID,'NumDays',64,'OutputFormat','timetable'); 
display(chInfo, 'ThinkSpeak channel information');

% references to table vs. timetable handling (including NaT and NaN resp.)
% https://de.mathworks.com/help/matlab/examples/preprocess-and-explore-bicycle-count-data-using-timetable.html
display(TT.Properties.DimensionNames, 'TT properties');
% remove rows with NaN variables
TT = rmmissing(TT);

CurrentMonth = datetime('today'); CurrentMonth
rangeThisMonth = timerange(CurrentMonth, 'months'); rangeThisMonth
PreviousMonth = dateshift(CurrentMonth,'start','month','previous');
rangeLastMonth = timerange(PreviousMonth, 'months'); rangeLastMonth

TTTM = TT(rangeThisMonth,:); % timetable This Month
TTLM = TT(rangeLastMonth,:); % timetable Last Month
whos TTLM TTTM TT            % reverse order printed

DT   = TT.Timestamps;
DTTM = TTTM.Timestamps;
DTLM = TTLM.Timestamps;
whos DTTM DTLM DT 

cleanTimeStampsDays1 =  day(DTTM);
cleanTimeStampsDays2 =  day(DTLM);
bins1 = cleanTimeStampsDays1; %  from 1..31 
bins2 = cleanTimeStampsDays2; %  from 1..31
% display(bins1, 'Bins1 (range 1..31)');
% display(bins2, 'Bins2 (range 1..31)');

% calculate values for the histogram legend
Totals1 = numel(TTTM);
Totals2 = numel(TTLM);
display(Totals1, 'Number of records after cleaning (This Month)');
display(Totals2, 'Number of records after cleaning (Last Month)');

BinLimitsRange = [0.5 31.5];

h1 = histogram(bins1,'BinLimits',BinLimitsRange,'BinMethod','integers'); % see also xticks
%display(h1, 'Used Histogram properties (h1)');
hold on
h2 = histogram(bins2,'BinLimits',BinLimitsRange,'BinMethod','integers'); % see also xticks
%display(h2, 'Used Histogram properties (h2)');

yAxisHeight =  max(h1.Values) + 1; yAxisHeight

% Add title an%d axis labels
title(histogramTitle);
xlabel(histogramXlabel);
xticks([1 5 10 15 20 25 30]); % according bin limits
ylabel(histogramYlabel);
% Add a legend
legend1Text = [int2str(Totals1), ' Records in total (this month)'];
legend2Text = [int2str(Totals2), ' Records in total (last month)'];
lgd = legend(legend1Text, legend2Text);
%lgd.Location = 'best'; 
lgd.Location = 'southwest';
grid on
grid minor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

head(TT)
tail(TT)

% https://de.mathworks.com/help/matlab/matlab_prog/combine-date-and-time-from-separate-variables.html
% TT.Timestamps.Format = 'dd-MMM-yyyy';

% https://de.mathworks.com/help/matlab/ref/retime.html?s_tid=doc_ta
TT2 = retime(TT,'daily','mean');
tail(TT2, 64)

% https://de.mathworks.com/help/matlab/ref/varfun.html
% due to mean method in function retime following varfun function is no longer required
TTmean = varfun(@mean,TT2,'GroupingVariables','Timestamps');
whos TTmean TT2 TT   %TTmean and TT2 for comparison
tail(TTmean, 64)

% https://de.mathworks.com/help/matlab/ref/matlab.graphics.chart.primitive.histogram.html?searchHighlight=histogram&s_tid=doc_srchtitle#buhznbh-1
hold on
x = BinLimitsRange;
% https://de.mathworks.com/help/matlab/ref/table2array.html?s_tid=doc_ta

x = [ 5 6 7 8]; x
y = [77.123 88.134 92.567 102.456];


BT = [NaN 77; 7 88; 3 99; 4 95]; 
BT(2,2) = NaN;
whos BT
BT


% y = yAxisHeight - 100 - BinLimitsRange; % for test purposes only
y2 = TT2.sonarcm;
whos bins1 bins2 x y y2
x
y2
y

%BTT = [month(TT2.Timestamps) day(TT2.Timestamps) TT2.sonarcm]
BTT = [day(TT2.Timestamps) TT2.sonarcm]
BTTS = sortrows(BTT)
% https://de.mathworks.com/help/matlab/ref/unique.html?searchHighlight=unique&s_tid=doc_srchtitle#bs_6vpd-1-occurrence
[BTTSU,ia] = unique(BTTS(:,1),'rows','last')
uBTTSU = BTTS(ia,:)
whos uBTTSU

plot(uBTTSU(:,2),'Color','blue','LineWidth',3.5)
plot(y2,'Color','red','LineWidth',2.5)
legend3plot = '31 sonar daily means [cm]';
legend4plot = '32 sonar daily means [cm]';
lgdUpdate = legend(legend1Text, legend2Text, legend3plot, legend4plot);
whos lgdUpdate

% https://itp.tugraz.at/LV/kernbich/AppSoft-1/appsoft1/node23.html

% EOF