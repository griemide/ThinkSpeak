% Download ThingSpeak data to CSV

author   = 'M. Gries'; author
created  = '18.12.22'; % perform multiple downloads due to 8000 points limitations
modified = '18.12.23'; % tested with channel af104-fsz
version  = '18.12.23'; version

% Implemented download strategy:
% { preconditions are: 
%   - 8000 records maximum per reading
%   - NaN values in variables
%   - fixed number of NaN values within on period (e.g. 70 NaN withinh 1 KWh)
% }
%  1. get channel Info as chInfo first to evaluate structure
%  2. get chInfo.Created to determine start date of first reading
%  3. get chInfo.LastEntryID to determine interartion of the for-loop
%  4. read first records over whole period i.e. until today
%  5. remove missing (i.e. NaN) vaiables first before further evaluations
%  6. determine datetime value of last record which will be next start day
%  7. determine number of records read 



% references (af104-fsz histogram over time): 
% https://thingspeak.com/apps/matlab_visualizations/264686/edit

% https://de.mathworks.com/help/thingspeak/thingspeakread.html
readChannelID = 624220; % af104-fsz
FieldID = 3; % KWh counter

% datasets (NumPoints) are limited to 8000 for a free licence 
MaxRecordsPerRead = 8000;
% therefore get Data with corresponding Timestamp and Channel information first
[data,Timestamps,chInfo] = thingSpeakRead(readChannelID); % recent variables
display(chInfo, 'ThinkSpeak channel information');
display(chInfo.Created, 'ThinkSpeak channel earliest possible date');
display(chInfo.LastEntryID, 'ThinkSpeak channel records in total');

TotalNoOfRecords = chInfo.LastEntryID;
Periods  = TotalNoOfRecords / MaxRecordsPerRead;

% ...thinkSpeakRead... 'DateRange',[datetime('Aug 8, 2014'),datetime('Aug 12, 2014')]
% When you perform operations involving datetime arrays, the arrays either must all have a time zone associated with them, 
% or they must all have no time zone.
DateCreated = chInfo.Created + days(27); DateCreated
whos DateCreated
DateStart = datetime(DateCreated); DateStart
whos DateStart
DateEndPeriod = DateCreated + days(5); DateEndPeriod
whos DateEndPeriod
DateEnd = datetime(DateEndPeriod); DateEnd
%DateEnd = datetime(,'Timezone','local'); DateEnd30
whos DateEnd
DateRangePeriod = [DateStart, DateEnd]; DateRangePeriod

% [data,Timestamps,chInfo] = thingSpeakRead(readChannelID,'Fields',FieldID,'NumDays',64); 
% [data,Timestamps] = thingSpeakRead(readChannelID,'Fields',FieldID,'NumPoints',8000); 
[TT,chinfo] = thingSpeakRead(readChannelID,'DateRange',DateRangePeriod,'Fields',FieldID,'OutputFormat','timetable'); 
% [TT,chinfo] = thingSpeakRead(readChannelID,'Fields',FieldID,'NumDays',64,'OutputFormat','timetable'); 

whos TT
TT = rmmissing(TT);
whos TT
head(TT)
tail(TT)
T1 = TT.Timestamps(1)
whos T1
Tmax = numel(TT); Tmax
Tn = TT.Timestamps(Tmax); Tn
TT

% https://de.mathworks.com/help/thingspeak/thingspeakread.html
% 'DateRange',[datetime('Aug 8, 2014'),datetime('Aug 12, 2014')]

DateStart = datetime(Tn,'Timezone','local'); DateStart
DateEnd = datetime('now','Timezone','local'); DateEnd
whos DateStart DateEnd
DateRangePeriod = [DateStart, DateEnd]; DateRangePeriod

[TU,chinfo] = thingSpeakRead(readChannelID,'DateRange',DateRangePeriod,'Fields',FieldID,'OutputFormat','timetable'); 

% https://de.mathworks.com/help/matlab/matlab_prog/clean-timetable-with-missing-duplicate-or-irregular-times.html
TU = rmmissing(TU);
whos TU
tail(TU)
head(TU)

Tsummary = [TU;TT];
whos TT TU 
whos Tsummary
Tsummary = unique(Tsummary);
whos Tsummary
Tsummary

% https://www.mathworks.com/examples/matlab/mw/matlab-ex71355721-export-table-to-text-file

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

TotalNoOfRecords 
Periods

%EOF