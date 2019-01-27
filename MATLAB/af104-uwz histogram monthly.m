% af104-uwz histogram monthly (Hydrus)

author   = 'M. Gries'; author
created  = '19.1.1  '; % granted from af104-fsz histogram monthly
modified = '19.1.27 '; % fixed errors due to 8000 numpoint limitation
version  = '19.1.27 '; version

% references (af104-fsz histogram over time): 
% https://thingspeak.com/apps/matlab_visualizations/264686/edit

readChannelID = 624218; % af104-uwz
FieldID = 1; % pules in total (per liter)
histogramTitle = 'Histogram Hydrus DN15  (No. 8DME7061328826)';
histogramXlabel = 'Number of Liter within this month (and last)';
histogramYlabel = 'Number of Liter';

% datasets (NumPoints) are limited to 8000 for a free licence 
% get Data with corresponding Timestamp and Channel information
[TT,chInfo] = thingSpeakRead(readChannelID,'Fields',FieldID,'NumDays',64,'OutputFormat','timetable'); 
display(chInfo, 'ThinkSpeak channel information');

% references to table vs. timetable handling (including NaT and NaN resp.)
% https://de.mathworks.com/help/matlab/examples/preprocess-and-explore-bicycle-count-data-using-timetable.html
TT.Properties.DimensionNames;
% remove rows with NaN variables64
TT = rmmissing(TT);
whos TT
head(TT)

Today = datetime('today'); Today
rangeToday = timerange(Today,'days');
ThisMonth = month(Today); ThisMonth
rangeThisMonth = timerange(Today, 'months'); rangeThisMonth
Yesterday =  datetime('yesterday'); Yesterday
rangeYesterday = timerange(Yesterday,'days'); rangeYesterday
LastMonth = ThisMonth - 1; LastMonth
CurrentMonth = datetime('today'); CurrentMonth
PreviousMonth = dateshift(CurrentMonth,'start','month','previous');
rangeLastMonth = timerange(PreviousMonth, 'months'); rangeLastMonth

TTTM = TT(rangeThisMonth,:); % timetable This Month
TTLM = TT(rangeLastMonth,:); % timetable Last Month
whos TTTM TTLM 

TTtime = TT.Timestamps;
TTTMtime = TTTM.Timestamps;
TTLMtime = TTLM.Timestamps;
whos TTtime TTTMtime TTLMtime

cleanTimeStampsDays1 =  day(TTTMtime);
cleanTimeStampsDays2 =  day(TTLMtime);
bins1 = cleanTimeStampsDays1; %  from 1..31 
bins2 = cleanTimeStampsDays2; %  from 1..31
KWhInTotal1 = numel(TTTM);
KWhInTotal2 = numel(TTLM);

% display(bins1, 'Bins (range 1..31)');
display(KWhInTotal1, 'Number Liter after cleaning (This Month)');

h1 = histogram(bins1,'BinLimits',[0.5 31.5],'BinMethod','integers'); % see also xticks
display(h1, 'Used Histogram properties (h1)');
hold on
h2 = histogram(bins2,'BinLimits',[0.5 31.5], 'BinMethod','integers'); % see also xticks
display(h2, 'Used Histogram properties (h2)');

yAxisHeight =  max(h1.Values) + 1; yAxisHeight

% Add title an%d axis labels
title(histogramTitle);
xlabel(histogramXlabel);
xticks([1 5 10 15 20 25 30]); % according bin limits
ylabel(histogramYlabel);
% Add a legend
legend1Text = [int2str(KWhInTotal1), ' Liter in total (this month)'];
legend2Text = [int2str(KWhInTotal2), ' Liter in total (last month)'];
lgd = legend(legend1Text, legend2Text);
lgd.Location = 'best'; 
% lgd.Location = 'southwest';
grid on
grid minor

% EOF