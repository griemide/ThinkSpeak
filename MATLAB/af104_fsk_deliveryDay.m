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
noOfSamplesForEvaluation = noOfSamplesPerHour * 3;
levelBefore = head(TT,noOfSamplesForEvaluation)
levelAfter = tail(TT,noOfSamplesForEvaluation)

% EOF