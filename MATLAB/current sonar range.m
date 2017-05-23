% used for channel application af104-fsk

% http://www.mathworks.com/help/matlab/ref/annotationtextbox-properties.html

fieldSamples = thingSpeakRead(261716, 'Fields', 2, 'NumPoints', 1000);

% Channel color used in channel field config window: #317db5
r = hex2dec('31')/255;
g = hex2dec('7d')/255;
b = hex2dec('b5')/255;
textColor = [r g b]  % print output

maxValue = max(fieldSamples);
meanValue = mean(fieldSamples);
minValue = min(fieldSamples);

UOM = 'cm';
UOMmin = [' ' UOM ' (min)'];
UOMmax = [' ' UOM ' (max)'];

annotation('textbox',[0.0 0.4 0.9 0.6],...
 'HorizontalAlignment','right',...
 'VerticalAlignment','middle',...
 'LineStyle','none',...
 'String',[num2str(maxValue,3) UOMmax],...
 'Color','0.5 0.5 0.5',...
 'FontSize',28);
 
annotation('textbox',[0.0 0.2 0.9 0.6],...
 'HorizontalAlignment','right',...
 'VerticalAlignment','middle',...
 'LineStyle','none',...
 'String',[num2str(meanValue,3) UOM],...
 'Color',textColor,...
 'FontSize',72);
 
annotation('textbox',[0.0 0.0 0.9 0.6],...
 'FontName','FixedWidth',...
 'HorizontalAlignment','right',...
 'VerticalAlignment','middle',...
 'LineStyle','none',...
 'String',[num2str(minValue,3) UOMmin],...
 'Color','0.5 0.5 0.5',...
 'FontSize',28);
 

