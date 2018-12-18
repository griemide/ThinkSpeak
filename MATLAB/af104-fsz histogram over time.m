% af104-fsz histogram over time(Ferraris-Strom-Zähler)

% references (histogram ): 
% https://de.mathworks.com/help/matlab/ref/matlab.graphics.chart.primitive.histogram.html

author   = 'M. Gries'; author
created  = '18.12.16'; 
modified = '18.12.18'; % bin range changed from 0..23 to 1.24 (see xticks)
version  = '18.12.18'; version

readChannelID = 624220; % af104-fsz
FieldID = 2;
histogramTitle = 'Histogram Ferraris Type C114';
histogramXlabel = 'number of pulses within last 24 hours (1 day)';
histogramYlabel = 'Number of pulses';


[pulses, timeStamp, chInfo] = thingSpeakRead(readChannelID, 'Fields', FieldID, 'NumDays', 1); 

% Check for outliers (value == 20 defines error flag reporting)
anyOutliers = sum(pulses < 21);
% If any outliers are found in the data
if anyOutliers > 0
    % Find the indices of elements which are not outliers
    cleanDataIndex = find(pulses > 20);
    % Select only elements that are not outliers
    cleanData = pulses(cleanDataIndex);
    % Select only timestamps corresponding to clean data
    cleanTimeStamps = timeStamp(cleanDataIndex);
else
    % If no outliers are found, then the data read from the MathWorks
    cleanData = pulses;
    cleanTimeStamps = timeStamp;
end

Today = datetime('today');
rangeToday = timerange(Today,'days');
Yesterday =  datetime('yesterday');
rangeYesterday = timerange(Yesterday,'days');

TT =  timetable(cleanTimeStamps, cleanData);
TTT = TT(rangeToday,:);
TTY = TT(rangeYesterday,:);

cleanTimeStampsHours =  hour(cleanTimeStamps);
bins1 = cleanTimeStampsHours + 1;
bins2 = cleanTimeStampsHours + 2;
pulsesInTotal = numel(cleanTimeStampsHours);


display(cleanTimeStamps, 'Cleaned time stamps');
display(cleanTimeStampsHours, 'Cleaned time hours (range  0..23)');
display(bins1, 'Bins (range 1..24)');
display(anyOutliers, 'Number of outliners');
display(pulsesInTotal, 'Number pulses after cleaning');

%h = histogram(cleanTimeStamps, histogramNoOfBins, 'BinLimits',[0 15000);
%h = histogram(cleanTimeStamps, 'BinMethod','hour');
h1 = histogram(bins1,'BinLimits',[0.5 24.5]); % see also xticks
hold on
h2 = histogram(bins2,'BinLimits',[0.5 24.5]);
% h2.Normalization = 'probability';
% h2.BinWidth = 1;

% Add title an%d axis labels
title(histogramTitle);
xlabel(histogramXlabel);
xticks([1 6 12 18 24]); % according bin limits
ylabel(histogramYlabel);
% Add a legend
legend1Text = [int2str(pulsesInTotal), ' pulses in total'];
legend2Text = [int2str(pulsesInTotal), ' pulses in total'];
% legendText = [int2str(pulsesInTotal), ' pulses in total'];

lgd = legend(legend1Text, legend2Text)
%lgd.Location = 'best'; % issue for given histogram BinLimits
lgd.Location = 'northwest';
grid on
grid minor

display(chInfo, 'ThinkSpeak channel information');
display(h1, 'Used Histogram properties (h1)');
display(h2, 'Used Histogram properties (h2)');


Today
rangeToday
Yesterday
rangeYesterday
whos cleanTimeStamps cleanData
whos TT TTT TTY

TTY

% EOF