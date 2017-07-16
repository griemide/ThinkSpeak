% af104-rkz pulse - get latest quantity of used water [liter]

% references:
% https://de.mathworks.com/help/matlab/examples/creating-plots-with-two-y-axes.html
% https://thingspeak.com/apps/matlab_visualizations

author = 'M. Gries'; author   % print
version = '17.7.16'; version  % print

OUTPUT = false;
PLOT_LEFT  = false;
PLOT_RIGHT = true;
PLOT_BOTH  = PLOT_LEFT & PLOT_RIGHT;

readChannelID = 296355;
FieldID1 = 1; % Liter
FieldID2 = 2; % D1 Pulses
Minutes = 24*60; % range

% ThingSpeak 'brown'
r = 165/255;
g = 40/255;
b = 41/255;
FaceColor = [r g b];

liter  = thingSpeakRead(readChannelID, 'Fields', FieldID1, 'NumMinutes',Minutes); 
pulses = thingSpeakRead(readChannelID, 'Fields', FieldID2, 'NumMinutes', Minutes); 
if OUTPUT
    display(PLOT_BOTH);
    literPerPulse = [liter pulses];
    display(literPerPulse);
end

% built diagramm
figure
title('V200')
xlabel('Time')

if PLOT_LEFT
    yyaxis left
    ylabel('Liter')
    plot(liter)
end

if PLOT_BOTH
    hold off
    clf
end

if PLOT_RIGHT
    bar(pulses,'FaceColor',FaceColor)
    yyaxis right
    plot(pulses)
    %ylim([0 2000])
    %xlim([0 100])
end

