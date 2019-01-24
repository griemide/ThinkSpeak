% af104_fsk_eval

author   = 'M. Gries'; author
created  = '19.1.24 '; % new script whiccch combines two singe analysis scripts
modified = '19.1.24 '; % thingSpeakWrite funtionality added
version  = '19.1.24 '; version

% af104_fsk_MeanPerDay.m  (Part 2) 
% analysis_tecson_oel.m (Part 1)

writeChannelID = 310930; % af104-fsk eval
writeAPIKey = '4FX35MCBK93LDMKZ';


%%% PART 1 %%%

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
% Note:
% writing a value on same timestamp will produce thingSpeakWrite error
% since timestamp used is already with sam time protion. E.g. '22-Jan-2019 00:00:00'
TTYmean.Timestamps = datetime('now');
TTYmean.sonarcm = round(TTYmean.sonarcm,1);
whos TTYmean
TTYmean
meanValue = round(TTYmean.sonarcm,1);


%%% PART 2 %%%

% copied from analysis_tecson_oel.m script

% urlfilter example based on following example
% https://de.mathworks.com/help/thingspeak/read-live-web-data-for-vessels-at-the-port-of-boston.html

% Specify the url containing information on current oel price [ct per liter]
url = 'https://www.tecson.de/pheizoel.html';
writeChannelID = 310930; % af104-fsk eval
writeAPIKey = '4FX35MCBK93LDMKZ';
% Fetch data and parse:
%   <tr>
%   <td><strong>Referenzpreis heute:</strong></td>
%   <td><strong>68,2&nbsp;ct/l</strong></td>
%   </tr>
webText = webread(url);
rawValue = urlfilter(webText, 'Referenzpreis heute:', 1); 
display(rawValue, 'urlfilter result:');
% value on webpage displayed with 1 decimal
% but urlfilter extract without deccimal point
% therefore devide by 1 decimal (i.e. 10)
CentPerLiter = rawValue / 10;
display(CentPerLiter, 'TECSON Referenzpreis heute:');
%or calculate in Euro per 1000 Liter
EuroPerCBM = CentPerLiter * 1000 / 100;
display(EuroPerCBM, 'Euro per 1000 Liter:');

%%% SUMMARY PART %%%

% combine both calulations to one new record (values)
eval = [meanValue CentPerLiter]
response=thingSpeakWrite(writeChannelID, eval, 'Writekey', writeAPIKey)
display(response,'Response by ThingSpeak server');

% EOF

