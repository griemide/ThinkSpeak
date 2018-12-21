% af104-fsz histogram monthly (Ferraris-Strom-Zähler)

author   = 'M. Gries'; author
created  = '18.12.19'; % granted from af104-fsz histogram over time
modified = '18.12.19'; % field3 evaluation (KWh)
modified = '18.12.20'; % removing NaN variables in timetable
modified = '18.12.21'; % changed graph hoursPerDay into DaysPerMonth 
version  = '18.12.21'; version

% references (af104-fsz histogram over time): 
% https://thingspeak.com/apps/matlab_visualizations/264686/edit

readChannelID = 624220; % af104-fsz
FieldID = 3; % KWh counter
histogramTitle = 'Histogram Ferraris Type C114 (Serial-No. 47630023)';
histogramXlabel = 'number of KWh within this month (and last)';
histogramYlabel = 'Number of KWh';

% get Data with corresponding Timestamp and Channel information
[data,timeStamp,chInfo] = thingSpeakRead(readChannelID,'Fields',FieldID,'NumDays',64); 
display(chInfo, 'ThinkSpeak channel information');

% references to table vs. timetable handling (including NaT and NaN resp.)
% https://de.mathworks.com/help/matlab/examples/preprocess-and-explore-bicycle-count-data-using-timetable.html

% create timetable
TT = timetable(timeStamp, data);
TT.Properties.DimensionNames
% remove rows with NaN variables
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
% rangeLastMonth = datemnth(Today, -1); requires Financial Toolbox.
CurrentMonth = datetime('today'); CurrentMonth
PreviousMonth = dateshift(CurrentMonth,'start','month','previous');
rangeLastMonth = timerange(PreviousMonth, 'months'); rangeLastMonth

TTTM = TT(rangeThisMonth,:); % timetable This Month
TTLM = TT(rangeLastMonth,:); % timetable Last Month
whos TTTM TTLM 

TTtime = TT.timeStamp;
TTTMtime = TTTM.timeStamp;
TTLMtime = TTLM.timeStamp;
whos TTtime TTTMtime TTLMtime

cleanTimeStampsDays1 =  day(TTTMtime);
cleanTimeStampsDays2 =  day(TTLMtime);
bins1 = cleanTimeStampsDays1; %  from 1..31 
bins2 = cleanTimeStampsDays2; %  from 1..31
KWhInTotal1 = numel(TTTM);
KWhInTotal2 = numel(TTLM);

display(bins1, 'Bins (range 1..31)');
display(KWhInTotal1, 'Number KWh after cleaning (This Month)');

h1 = histogram(bins1,'BinLimits',[0.5 31.5]); % see also xticks
display(h1, 'Used Histogram properties (h1)');
hold on
h2 = histogram(bins2,'BinLimits',[0.5 31.5]); % see also xticks
display(h2, 'Used Histogram properties (h2)');

% Add title an%d axis labels
title(histogramTitle);
xlabel(histogramXlabel);
xticks([1 5 10 15 20 25 30]); % according bin limits
ylabel(histogramYlabel);
% Add a legend
legend1Text = [int2str(KWhInTotal1), ' KWh in total (this month)'];
legend2Text = [int2str(KWhInTotal2), ' KWh in total (last month)'];
lgd = legend(legend1Text, legend2Text)
lgd.Location = 'best'; 
%lgd.Location = 'northwest';
grid on
grid minor

% debugging ...
tail(TTLM,20)
head(TTTM,20)
ThisMonth 
rangeThisMonth
LastMonth
rangeLastMonth
%E = eomday(2018,2)

% EOF