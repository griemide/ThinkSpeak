% af104_fsk_deliveryDay

author   = 'M. Gries'; author
created  = '19.1.28 '; % based on af104_fsk_eval
modified = '19.1.28 '; % uses dedicate datetime range (e.g. oil delivery day 2018-12-11)
version  = '19.1.28 '; version

% references:
% https://de.mathworks.com/help/thingspeak/thingspeakread.html?searchHighlight=thingspeakread
% [data,timestamps,channelInfo] = thingSpeakRead(12397,'Fields',[1 4],'DateRange',[datetime('Aug 8, 2014'),datetime('Aug 12, 2014')]);

writeChannelID = 310930; % af104-fsk eval
writeAPIKey = '4FX35MCBK93LDMKZ';

readChannelID = 261716; % af104-fsk
FieldID = 2; % sonar (cm)
% DateStrings = {'2017-05-11';'2017-05-12'}; % first channel entries 2017-05-10
DateStrings = {'2018-12-11';'2018-12-12'};
t = datetime(DateStrings,'InputFormat','yyyy-MM-dd');
tRange = transpose(t); % 1x2 vector instead of 2x1 vector required for thingSpeakRead

% datasets (NumPoints) are limited to 8000 for a free licence 
% get Data with corresponding Timestamp and Channel information
[TT,chInfo] = thingSpeakRead(readChannelID,'Fields',FieldID,'DateRange',tRange,'OutputFormat','timetable'); 
display(chInfo, 'ThinkSpeak channel information');

% remove rows with NaN variables
TT = rmmissing(TT);
noOfSamplesPerHour = 10;
noOfSamplesForEvaluation = noOfSamplesPerHour * 8 ;
levelBefore = head(TT,noOfSamplesForEvaluation);
levelAfter = tail(TT,noOfSamplesForEvaluation);

levelBeforeMean = retime(levelBefore,'daily','mean')
levelAfterMean = retime(levelAfter,'daily','mean')
levelDiffDelivery = levelBeforeMean.sonarcm - levelAfterMean.sonarcm

[TTlast] = thingSpeakRead(readChannelID,'Fields',FieldID,'NumMinutes',60,'OutputFormat','timetable');
levelNow = retime(TTlast,'daily','mean') % hourly may result in 2 values

levelDiffNow = levelNow.sonarcm - levelAfterMean.sonarcm
levelRemain = levelDiffDelivery - levelDiffNow

% https://ch.mathworks.com/help/matlab/ref/timeseries.sum.html
% ts = timeseries((1:5)');
% tssum = sum(ts)
% https://ch.mathworks.com/help/matlab/ref/datenum.html
format long
% = [levelNow.Timestamps levelBeforeMean.Timestamps];
tsDiff = [levelBeforeMean.Timestamps levelNow.Timestamps]
DateNumber = datenum(tsDiff)
%ts = transpose(tsDiff)
tssum = sum(DateNumber)
tsdiff = diff(DateNumber)

% EOF