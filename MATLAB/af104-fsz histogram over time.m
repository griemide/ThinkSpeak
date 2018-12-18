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

cleanTimeStampsHours =  hour(cleanTimeStamps);
bins = cleanTimeStampsHours + 1;
pulsesInTotal = numel(cleanTimeStampsHours);

display(cleanTimeStamps, 'Cleaned time stamps');
display(cleanTimeStampsHours, 'Cleaned time hours (range  0..23)');
display(bins, 'Bins (range 1..24)');
display(anyOutliers, 'Number of outliners');
display(pulsesInTotal, 'Number pulses after cleaning');

%h = histogram(cleanTimeStamps, histogramNoOfBins, 'BinLimits',[0 15000);
%h = histogram(cleanTimeStamps, 'BinMethod','hour');
h = histogram(bins,'BinLimits',[0.5 24.5]); % see also xticks
% Add title and axis labels
title(histogramTitle);
xlabel(histogramXlabel);
xticks([1 6 12 18 24]); % according bin limits
ylabel(histogramYlabel);
% Add a legend
legendText = [int2str(pulsesInTotal), ' pulses in total'];
lgd = legend(legendText)
%lgd.Location = 'best'; % issue for given histogram BinLimits
lgd.Location = 'northwest';
grid on
grid minor

display(chInfo, 'ThinkSpeak channel information');
display(h, 'Used Histogram properties');

% EOF