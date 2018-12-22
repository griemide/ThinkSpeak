% Download ThingSpeak data to CSV

author   = 'M. Gries'; author
created  = '18.12.22'; % perform multiple downloads due to 8000 points limitations
modified = '18.12.22'; % tested with channel af104-fsz
version  = '18.12.22'; version

% Implemented download strategy
% https://www.mathworks.com/examples/matlab/mw/matlab-ex71355721-export-table-to-text-file

% references (af104-fsz histogram over time): 
% https://thingspeak.com/apps/matlab_visualizations/264686/edit

readChannelID = 624220; % af104-fsz
FieldID = 3; % KWh counter

% https://de.mathworks.com/help/thingspeak/thingspeakread.html
% 'DateRange',[datetime('Aug 8, 2014'),datetime('Aug 12, 2014')]
DateStart = datetime('Dec 9, 2018');
DateEnd = datetime('today');
DateRangePeriod = [DateStart, DateEnd]; DateRangePeriod

% datasets (NumPoints) are limited to 8000 for a free licence 
% get Data with corresponding Timestamp and Channel information
[data,Timestamps,chInfo] = thingSpeakRead(readChannelID); % recent variables
% [data,Timestamps,chInfo] = thingSpeakRead(readChannelID,'Fields',FieldID,'NumDays',64); 
% [data,Timestamps] = thingSpeakRead(readChannelID,'Fields',FieldID,'NumPoints',8000); 
% [TT,chinfo] = thingSpeakRead(readChannelID,'DateRange',DateRangePeriod,'Fields',FieldID,'OutputFormat','timetable'); 
[T,chinfo] = thingSpeakRead(readChannelID,'Fields',FieldID,'NumDays',64,'OutputFormat','table'); 
display(chInfo, 'ThinkSpeak channel information');
display(chInfo.LastEntryID, 'ThinkSpeak channel records in total');

whos T
T = rmmissing(T);
whos T
head(T)
T1 = T.Timestamps(1)
whos T1

% https://de.mathworks.com/help/thingspeak/thingspeakread.html
% 'DateRange',[datetime('Aug 8, 2014'),datetime('Aug 12, 2014')]

DateEnd = datetime(T1);
DateStart = datetime(T1 - days(5)); DateStart
DateRangePeriod = [DateStart, DateEnd]; DateRangePeriod

[U,chinfo] = thingSpeakRead(readChannelID,'DateRange',DateRangePeriod,'Fields',FieldID,'OutputFormat','table'); 

U = rmmissing(U);
whos U
tail(U)
head(U)


Tsummary = [U;T];
whos T U 
whos Tsummary
Tsummary

%RT = readtable('C:\HC-PP\test.txt');
%whos RT
%writetable(T,'C:\HC-PP\tabledata.txt');
%type C:\HC-PP\tabledata.txt

api = 'http://climatedataapi.worldbank.org/climateweb/rest/v1/';
url = [api 'country/cru/tas/year/USA'];
S = webread(url);
%whos S
%S
%S(1)
%S(2)

s = 10;
H = zeros(s);

for c = 1:s
    for r = 1:s
        H(r,c) = 1/(r+c-1);
    end
end
%whos H
%H


%EOF