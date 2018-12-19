% af104-fsz histogram monthly (Ferraris-Strom-Zähler)

author   = 'M. Gries'; author
created  = '18.12.19'; % granted from af104-fsz histogram over time
modified = '18.12.19'; % field3 evaluation (KWh)
version  = '18.12.19'; version

% references (af104-fsz histogram over time): 
% https://thingspeak.com/apps/matlab_visualizations/264686/edit

readChannelID = 624220; % af104-fsz
FieldID = 3; % KWh counter
histogramTitle = 'Histogram Ferraris Type C114';
histogramXlabel = 'number of KWh within last month (and actual)';
histogramYlabel = 'Number of KWh';

% get Data with corresponding Timestamp and Channel information
[data,timeStamp,chInfo] = thingSpeakRead(readChannelID,'Fields',FieldID,'NumDays',5); 

% create timetable
TT =  timetable(timeStamp, data);

% get rid of NaN entries in data
idx=isnan(data)
dataKWh=TT(idx==0)

% find corresponding timestamp

% Check for outliers (value == 20 defines error flag reporting)
anyOutliers = sum(data < 21);
% If any outliers are found in the data
if anyOutliers > 0
    % Find the indices of elements which are not outliers
    cleanDataIndex = find(data > 20);
    % Select only elements that are not outliers
    cleanData = data(cleanDataIndex);
    % Select only timestamps corresponding to clean data
    cleanTimeStamps = timeStamp(cleanDataIndex);
else
    % If no outliers are found, then the data read from the MathWorks
    cleanData = data;
    cleanTimeStamps = timeStamp;
end

Today = datetime('today');
rangeToday = timerange(Today,'days');
Yesterday =  datetime('yesterday');
rangeYesterday = timerange(Yesterday,'days');


TTT = TT(rangeToday,:);
TTY = TT(rangeYesterday,:);

TTtime = TT.timeStamp;
TTTtime = TTT.timeStamp;
TTYtime = TTY.timeStamp;

cleanTimeStampsHours1 =  hour(TTTtime);
cleanTimeStampsHours2 =  hour(TTYtime);
bins1 = cleanTimeStampsHours1 + 1; % shift from 0..23 to 1.24 
bins2 = cleanTimeStampsHours2 + 1; % shift from 0..23 to 1.24 
pulsesInTotal1 = numel(TTT);
pulsesInTotal2 = numel(TTY);

% display(cleanTimeStamps, 'Cleaned time stamps');
% display(cleanTimeStampsHours, 'Cleaned time hours (range  0..23)');
display(bins1, 'Bins (range 1..24)');
display(anyOutliers, 'Number of outliners');
display(pulsesInTotal1, 'Number pulses after cleaning');

%h = histogram(cleanTimeStamps, histogramNoOfBins, 'BinLimits',[0 15000);
%h = histogram(cleanTimeStamps, 'BinMethod','hour');
h1 = histogram(bins1,'BinLimits',[0.5 24.5]); % see also xticks
hold on
h2 = histogram(bins2,'BinLimits',[0.5 24.5]); % see also xticks
% h2.Normalization = 'probability';
% h2.BinWidth = 1;

% Add title an%d axis labels
title(histogramTitle);
xlabel(histogramXlabel);
xticks([1 6 12 18 24]); % according bin limits
ylabel(histogramYlabel);
% Add a legend
legend1Text = [int2str(pulsesInTotal1), ' in total (today)'];
legend2Text = [int2str(pulsesInTotal2), ' in total (yesterday)'];
lgd = legend(legend1Text, legend2Text)
%lgd.Location = 'best'; % issue for given histogram BinLimits
lgd.Location = 'northwest';
grid on
grid minor

display(chInfo, 'ThinkSpeak channel information');
display(h1, 'Used Histogram properties (h1)');
display(h2, 'Used Histogram properties (h2)');

% debugging ...
Today
rangeToday
Yesterday
rangeYesterday
tail(TTY,10)
head(TTT,10)
TT.Properties.DimensionNames
whos cleanTimeStamps cleanData
whos TT TTT TTY 
whos TTtime TTTtime TTYtime

whos TT =  timetable(timeStamp, data);
head(TTKWh,10)
TTKWh

% EOF