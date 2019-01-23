% af104-fsk MeanPerDay

author   = 'M. Gries'; author
created  = '19.1.22 '; % granted from af104-fsk histogram monthly means
modified = '19.1.23 '; % thingSpeakWrite funtionality added
version  = '19.1.23 '; version

% references (af104-fsk histogram monthly records): 
% https://thingspeak.com/apps/matlab_visualizations/xxxxx/edit

readChannelID = 261716; % af104-fsk
FieldID = 2; % sonar (cm)

% datasets (NumPoints) are limited to 8000 for a free licence 
% get Data with corresponding Timestamp and Channel information
[TT,chInfo] = thingSpeakRead(readChannelID,'Fields',FieldID,'NumDays',2,'OutputFormat','timetable'); 
display(chInfo, 'ThinkSpeak channel information');

% references to table vs. timetable handling (including NaT and NaN resp.)
% https://de.mathworks.com/help/matlab/examples/preprocess-and-explore-bicycle-count-data-using-timetable.html
display(TT.Properties.DimensionNames, 'TT properties');
% remove rows with NaN variables
TT = rmmissing(TT);

Today = datetime('today')
rangeToday = timerange(Today,'days');
Yesterday =  datetime('yesterday')
rangeYesterday = timerange(Yesterday,'days');

TTY = TT(rangeYesterday,:); % timetable This Day
whos TTY TT            % reverse order printed

TTYmean = retime(TTY,'daily','mean');
whos TTYmean
TTYmean

writeChannelID = 310930; % af104-fsk eval
writeAPIKey = '4FX35MCBK93LDMKZ';
thingSpeakWrite(writeChannelID, TTYmean, 'Writekey', writeAPIKey);
% Note:
% writing a value on same timestamp will produce thingSpeakWrite error
% since timestamp used is already with sam time protion. E.g. '22-Jan-2019 00:00:00'

% EOF