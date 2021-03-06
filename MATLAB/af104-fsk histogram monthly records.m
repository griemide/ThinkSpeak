% af104-fsk histogram monthly records (sonar)

author   = 'M. Gries'; author
created  = '19.1.5  '; % granted from af104-fsz histogram monthly
modified = '19.1.5  '; % field3 evaluation (KWh)
version  = '19.1.5  '; version

% references (af104-uwz histogram monthly): 
% https://thingspeak.com/apps/matlab_visualizations/264686/edit

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
Totals1 = numel(TTTM);
Totals2 = numel(TTLM);

% display(bins1, 'Bins (range 1..31)');
% display(Totals1, 'Number of records after cleaning (This Month)');

h1 = histogram(bins1,'BinLimits',[0.5 31.5],'BinMethod','integers'); % see also xticks
%display(h1, 'Used Histogram properties (h1)');
hold on
h2 = histogram(bins2,'BinLimits',[0.5 31.5], 'BinMethod','integers'); % see also xticks
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

% EOF