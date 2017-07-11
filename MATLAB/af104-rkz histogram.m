% Histogram af104-rkz

author = 'M. Gries'; author
version = '17.7.11'; version

readChannelID = 296355;
FieldID = 2;
histogramTitle = 'Histogram Elster V200';
histogramXlabel = 'D1 pulse width [msec]';
histogramYlabel = 'Number of D1 pulses';

pulses = thingSpeakRead(readChannelID, 'Fields', FieldID, 'NumMinutes', 24*60); 
histogram(pulses);
title(histogramTitle);
xlabel(histogramXlabel);
ylabel(histogramYlabel);
grid on