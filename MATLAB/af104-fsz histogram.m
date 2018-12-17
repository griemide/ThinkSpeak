% af104-fsz histogram (Ferraris-Strom-Zähler)

% references (histogram ): 
% https://de.mathworks.com/help/matlab/ref/matlab.graphics.chart.primitive.histogram.html

author   = 'M. Gries'; author
created  = '18.12.6' ; % granted from af104-fsk
modified = '18.12.17'; % Legend, FaceColor and chInfo added
version  = '18.12.17'; version % print current version

readChannelID = 624220; % af104-fsz
FieldID = 2;
histogramTitle = 'Histogram Ferraris Type C114';
histogramXlabel = 'pulse width [msec]';
histogramYlabel = 'No. of pulses within 1 day';
% define limits
histogramBinLowerLimit = 0;
histogramBinUpperLimit = 14000; % evaluated maximn ist approx 12850 msec
histogramBinSteps = 250;
histogamBinLimits = [histogramBinLowerLimit, histogramBinUpperLimit];
histogramNoOfBins = (histogramBinUpperLimit-histogramBinLowerLimit)/histogramBinSteps; 
% alternative (use BinWidth property)
histogramBinWidth = 250; 

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

display(cleanData, 'Cleaned data');
display(anyOutliers, 'No of outliners');
display(numel(cleanData), 'No pulses after cleaning');

pulsesInTotal = numel(cleanData);

% h = histogram(cleanData, histogramNoOfBins, 'BinLimits',[0 14000]);
h = histogram(cleanData, 'BinWidth', histogramBinWidth);
% Add title and axis labelstitle(histogramTitle);
title(histogramTitle);
xlabel(histogramXlabel);
ylabel(histogramYlabel);
h.FaceColor = 'red';
% Add a legend
legendText = [int2str(pulsesInTotal), ' pulses in total'];
lgd = legend(legendText)
lgd.Location = 'best'; 
grid on

display(chInfo, 'ThinkSpeak channel information');
display (h, 'histogram properties');

% EOF