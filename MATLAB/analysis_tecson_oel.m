% analysis_tecson_oel

author   = 'M. Gries'; author
created  = '19.1.22 '; % granted from MATLAB Analysis example
modified = '19.1.22 '; % used with oel supplier reference webpage
version  = '19.1.22 '; version

% based on following example
% https://de.mathworks.com/help/thingspeak/read-live-web-data-for-vessels-at-the-port-of-boston.html

% Specify the url containing information on current oel price [ct per liter]
url = 'https://www.tecson.de/pheizoel.html';

% TODO - Replace the [] with channel ID to write data to:
writeChannelID = [];

% TODO - Enter the Write API Key between the '' below:
writeAPIKey = '';

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

% thingSpeakWrite(writeChannelID, CentPerLiter, 'Writekey', writeAPIKey);

% EOF