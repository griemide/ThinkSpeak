% af104-fsz histogram over time(Ferraris-Strom-Zähler)

% references (histogram ): 
% https://de.mathworks.com/help/matlab/ref/matlab.graphics.chart.primitive.histogram.html

author   = 'M. Gries'; author
created  = '18.12.16'; 
modified = '18.12.16';
version  = '18.12.16'; version

readChannelID = 624220; % af104-fsz
FieldID = 2;
histogramTitle = 'Histogram Ferraris Type C114';
histogramXlabel = 'number of pulses within 24 hours (1 day)';
histogramYlabel = 'Number of pulses';
histogramNoOfBins = 50; % e.g. 0 msec until 15000 msec

[pulses, timeStamp] = thingSpeakRead(readChannelID, 'Fields', FieldID, 'NumDays', 1); 

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

display(cleanData, 'Cleaned data');
display(anyOutliers, 'No of outliners');
display(numel(cleanData), 'No pulses after cleaning');

%h = histogram(cleanTimeStamps, histogramNoOfBins, 'BinLimits',[0 15000);
h = histogram(cleanTimeStamps, 24, 'BinMethod','hour');
title(histogramTitle);
xlabel(histogramXlabel);
ylabel(histogramYlabel);
grid on

display (h, 'histogram properties');

% EOF