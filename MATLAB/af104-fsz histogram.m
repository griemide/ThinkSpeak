% af104-fsz histogram (Ferraris-Strom-Zähler)

author   = 'M. Gries'; author
created  = '18.12.6'; 
modified = '18.12.6';
version  = '18.12.6'; version

readChannelID = 624220; % af104-fsz
FieldID = 2;
histogramTitle = 'Histogram Ferraris Type C114';
histogramXlabel = 'pulse width [msec]';
histogramYlabel = 'Number of pulses';

[pulses, timeStamp] = thingSpeakRead(readChannelID, 'Fields', FieldID, 'NumMinutes', 24*60); 

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

histogram(cleanData);
title(histogramTitle);
xlabel(histogramXlabel);
ylabel(histogramYlabel);
grid on

% EOF