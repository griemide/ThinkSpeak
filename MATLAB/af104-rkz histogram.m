% Histogram af104-rkz

author   = 'M. Gries'; author
created  = '17.7.11'; 
modified = '17.7.15';
version  = '17.7.26'; version

readChannelID = 296355;
FieldID = 2;
histogramTitle = 'Histogram Elster V200';
histogramXlabel = 'D1 pulse width [msec]';
histogramYlabel = 'Number of D1 pulses';

[pulses, timeStamp] = thingSpeakRead(readChannelID, 'Fields', FieldID, 'NumMinutes', 24*60); 
% Check for outliers
anyOutliers = sum(pulses > 2000);
% If any outliers are found in the data
if anyOutliers > 0
    % Find the indices of elements which are not outliers
    cleanDataIndex = find(pulses <= 1999);
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