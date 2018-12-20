% af104-fsz histogram monthly (Ferraris-Strom-Zähler)

author   = 'M. Gries'; author
created  = '18.12.19'; % granted from af104-fsz histogram over time
modified = '18.12.19'; % field3 evaluation (KWh)
modified = '18.12.20'; % removind NaN variables in timetable
version  = '18.12.20'; version

% references (af104-fsz histogram over time): 
% https://thingspeak.com/apps/matlab_visualizations/264686/edit

readChannelID = 624220; % af104-fsz
FieldID = 3; % KWh counter
histogramTitle = 'Histogram Ferraris Type C114';
histogramXlabel = 'number of KWh within last month (and actual)';
histogramYlabel = 'Number of KWh';

% get Data with corresponding Timestamp and Channel information
[data,timeStamp,chInfo] = thingSpeakRead(readChannelID,'Fields',FieldID,'NumDays',5); 
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

display(bins1, 'Bins (range 1..24)');
display(pulsesInTotal1, 'Number pulses after cleaning');

h1 = histogram(bins1,'BinLimits',[0.5 24.5]); % see also xticks
display(h1, 'Used Histogram properties (h1)');
hold on
h2 = histogram(bins2,'BinLimits',[0.5 24.5]); % see also xticks
display(h2, 'Used Histogram properties (h2)');

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


% debugging ...
Today
rangeToday
Yesterday
rangeYesterday
tail(TTY,20)
head(TTT,20)
whos TT TTT TTY 
whos TTtime TTTtime TTYtime

% EOF