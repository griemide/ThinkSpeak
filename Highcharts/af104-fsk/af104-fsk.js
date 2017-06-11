/*
Script:   af104-fsk.js
Author:   Michael Gries (c)2017
Creation: 2017-06-10
Modified: 2017-06-11
*/

/* 
Highsoft homepage: https://www.highcharts.com/
Highstock API Reference: http://api.highcharts.com/highstock/
Highchart example using jsfiddle: http://jsfiddle.net/calculathor/oLp97nd1/
*/
    
// Webpage Javascript to chart multiple ThingSpeak channels on two axis with navigator, load historical data, and export cvs data.
// Public Domain, by turgo.
// The charting library is called HighStock.  
// Creative Commons Attribution-NonCommercial 3.0 License. "
// source reference: http://forum.arduino.cc/index.php?topic=213058.msg1560990#msg1560990

var thingSpeakChannel = 261716;
var thingSpeakChannelName = 'af104-fsk';
var chartTitle = 'AF104 F&uuml;llstandskontrolle'; // useHTML:true
var chartSubTitle = 'monitoring HC-SR04 ultrasonic sensor on Wemos D1 mini'; // useHTML:true
var field1color = 'brown';
var field2color = 'blue';
var field3color = 'black';
var fastInitialLoad = 240; // 1 day and 6 minutes each (10*24=240)
var maxLoads = 5; //instead of select box in original code
var updateChart = true;  // instead of Update checkbox in original code
var updateChartLatency = 60000 // seconds

// https://www.epochconverter.com/
var xAxesFlag1time = 1496268000000;
var xAxesFlag1text = 'newBatt';
var xAxesFlag2time = 1496606400000;
var xAxesFlag2text = 'newBatt';

//var lastDate = data[data.length - 1][0],  // Get year of last data point
//   days = 24 * 36e5; // Milliseconds in a day

var dynamicChart;
var channelsLoaded = 0;
// put your ThingSpeak Channel#, Channel Name, and API keys here.
// fieldList shows which field you want to load, and which axis to display that field on, 
var channelKeys =[];
channelKeys.push({channelNumber:thingSpeakChannel, name:thingSpeakChannelName,key:'', 
   fieldList:[
    {field:1,axis:'T'},
    {field:2,axis:'H'},
    {field:3,axis:'H'}
   ]
});
    
// user's timezone offset
var myOffset = new Date().getTimezoneOffset();

// converts date format from JSON
function getChartDate(d) {
    // get the data using javascript's date object (year, month, day, hour, minute, second)
    // months in javascript start at 0, so remember to subtract 1 when specifying the month
    // offset in minutes is converted to milliseconds and subtracted so that chart's x-axis is correct
    return Date.UTC(d.substring(0,4), d.substring(5,7)-1, d.substring(8,10), d.substring(11,13), d.substring(14,16), d.substring(17,19)) - (myOffset * 60000);
}

     
//  This is where the chart is generated.
$(document).ready(function() {
 //Add Channel Load Menu
 var menu=document.getElementById("Channel Select");
 for (var channelIndex=0; channelIndex<channelKeys.length; channelIndex++)  // iterate through each channel
 {
   window.console && console.log('Name',channelKeys[channelIndex].name);
   var menuOption =new Option(channelKeys[channelIndex].name,channelIndex);
   //menu.options.add(menuOption,channelIndex);
 }
 var last_date; // variable for the last date added to the chart
 window.console && console.log('Testing console');
 //make series numbers for each field
 var seriesCounter=0
 for (var channelIndex=0; channelIndex<channelKeys.length; channelIndex++)  // iterate through each channel
  {
    for (var fieldIndex=0; fieldIndex<channelKeys[channelIndex].fieldList.length; fieldIndex++)  // iterate through each channel
      {
        channelKeys[channelIndex].fieldList[fieldIndex].series = seriesCounter; 
        seriesCounter++;
      }
  }
 //make calls to load data from each channel into channelKeys array now
 // draw the chart when all the data arrives, later asyncronously add history
 for (var channelIndex=0; channelIndex<channelKeys.length; channelIndex++)  // iterate through each channel
  {
    channelKeys[channelIndex].loaded = false;  
    loadThingSpeakChannel(channelIndex,channelKeys[channelIndex].channelNumber,channelKeys[channelIndex].key,channelKeys[channelIndex].fieldList);
    
  }
 //window.console && console.log('Channel Keys',channelKeys);
 
 // load the most recent var (fastInitialLoad) from a ThingSpeak channel into a data[] array and return the data[] array
 function loadThingSpeakChannel(sentChannelIndex,channelNumber,key,sentFieldList) {
   var fieldList= sentFieldList;
   var channelIndex = sentChannelIndex;
   // get the Channel data with a webservice call
    $.getJSON('https://www.thingspeak.com/channels/'+channelNumber+'/feed.json?callback=?&amp;offset=0&amp;results='+fastInitialLoad+';key='+key, function(data) 
   {
       // if no access
       if (data == '-1') {
       $('#chart-container').append('This channel is not public.  To embed charts, the channel must be public or a read key must be specified.');
       window.console && console.log('Thingspeak Data Loading Error');
     }
     for (var fieldIndex=0; fieldIndex<fieldList.length; fieldIndex++)  // iterate through each field
     {
       fieldList[fieldIndex].data =[];
       for (var h=0; h<data.feeds.length; h++)  // iterate through each feed (data point)
       {
         var p = []//new Highcharts.Point();
         var fieldStr = "data.feeds["+h+"].field"+fieldList[fieldIndex].field;
             var v = eval(fieldStr);
            p[0] = getChartDate(data.feeds[h].created_at);
            p[1] = parseFloat(v);
            // if a numerical value exists add it
            if (!isNaN(parseInt(v))) { fieldList[fieldIndex].data.push(p); }
       }
       fieldList[fieldIndex].name = eval("data.channel.field"+fieldList[fieldIndex].field);
       }
     window.console && console.log('getJSON field name:',fieldList[0].name);
     channelKeys[channelIndex].fieldList=fieldList;
     channelKeys[channelIndex].loaded=true;
     channelsLoaded++;
     window.console && console.log('channels Loaded:',channelsLoaded);
     window.console && console.log('channel index:',channelIndex);
    if (channelsLoaded==channelKeys.length){createChart();}
     })
   .fail(function() { alert('getJSON request failed! '); });
 }
 
 // create the chart when all data is loaded
 function createChart() {
    // specify the chart options
    var chartOptions = {
    chart: {
        renderTo: 'chart-container',
        zoomType:'y',
        events: {
            load: function() 
            {
                if ('true' === 'true' && (''.length < 1 && ''.length < 1 && ''.length < 1 && ''.length < 1 && ''.length < 1)) 
                {
                    // If the update checkbox is checked, get latest data every 15 seconds and add it to the chart
                    setInterval(function() 
                    {
             //if (document.getElementById("Update").checked)
             if (updateChart) // changed 17.6.11
             {
              for (var channelIndex=0; channelIndex<channelKeys.length; channelIndex++)  // iterate through each channel
              {  
               (function(channelIndex)
               {
                // get the data with a webservice call
                $.getJSON('https://www.thingspeak.com/channels/'+channelKeys[channelIndex].channelNumber+'/feed/last.json?callback=?&amp;offset=0&amp;location=false;key='+channelKeys[channelIndex].key, function(data) 
                { 
                  for (var fieldIndex=0; fieldIndex<channelKeys[channelIndex].fieldList.length; fieldIndex++)
                  {
                    // if data exists
                    var fieldStr = "data.field"+channelKeys[channelIndex].fieldList[fieldIndex].field;
                    var chartSeriesIndex=channelKeys[channelIndex].fieldList[fieldIndex].series;
                    if (data && eval(fieldStr)) 
                    {
                      var p = []//new Highcharts.Point();
                      var v = eval(fieldStr);
                      p[0] = getChartDate(data.created_at);
                      p[1] = parseFloat(v);
                      // get the last date if possible
                      if (dynamicChart.series[chartSeriesIndex].data.length > 0) 
                      { 
                        last_date = dynamicChart.series[chartSeriesIndex].data[dynamicChart.series[chartSeriesIndex].data.length-1].x; 
                      }
                      var shift = false ; //default for shift
                      // if a numerical value exists and it is a new date, add it
                      if (!isNaN(parseInt(v)) && (p[0] != last_date)) 
                      {
                        dynamicChart.series[chartSeriesIndex].addPoint(p, true, shift);
                      }   
                    }
                    //window.console && console.log('channelKeys:',channelKeys);
                    //window.console && console.log('chartSeriesIndex:',chartSeriesIndex);
                    //window.console && console.log('channel index:',channelIndex);
                    //window.console && console.log('field index:',fieldIndex);
                    //window.console && console.log('update series name:',dynamicChart.series[chartSeriesName].name);
                    //window.console && console.log('channel keys name:',channelKeys[channelIndex].fieldList[fieldIndex].name);
                  }
                });
               })(channelIndex);
              }
             }
                        }, updateChartLatency);
                    }
                }
            }
    },
    // default colors used by Highstoch release 5.x
    // colors: ['#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9', '#f15c80', '#e4d354', '#8085e8', '#8d4653', '#91e8e1'],
    // modified colors for used ThingSpeak channel :
    colors: [field1color, field1color, field2color, field3color, '#8085e9', '#f15c80', '#e4d354', '#8085e8', '#8d4653', '#91e8e1'],
    credits: {
        enabled: true,
        href: 'https://thingspeak.com/channels/' + thingSpeakChannel,
        text: 'source: ThingSpeak channel ' + thingSpeakChannelName + ' (' + thingSpeakChannel + ') supported by Highcharts.com'
    },
    rangeSelector: {
        buttons: [
        // /*
        {
            count: 30,
            type: 'minute',
            text: '30m'
        },
        // */
        {
            count: 12,
            type: 'hour',
            text: '12h'
        }, {
            count: 1,
            type: 'day',
            text: 'D'
        }, {
            count: 1,
            type: 'week',
            text: 'W'
        }, {
            count: 1,
            type: 'month',
            text: 'M'
        }, {
            count: 1,
            type: 'year',
            text: 'Y'
        }, {
            type: 'all',
            text: 'All'
        }],
        inputEnabled: true,
        selected: 2  //Change to 4th button as default
    },
    title: {
        useHTML:true, 
        text: chartTitle
    },
    subtitle: {
        useHTML:true, 
        text: chartSubTitle
    },
    plotOptions: {
        line: {
            gapSize:5
            //color: '#d62020'
            //  },
            //  bar: {
            //color: '#d52020'
            //  },
            //  column: {
        },
        series: {
            marker: {radius: 2},
            animation: true,
            step: false,
            turboThreshold:1000,
            borderWidth: 0
            /*
            ,
            zones: [
                {value: 22, color: 'red'},
                {value: 33, color: '#f7a35c'},
                {           color: 'blue'}
            ]
            */
        },
    },
    tooltip: {
        valueDecimals: 1,
        valueSuffix: '',
        xDateFormat:'%y-%m-%d<br/>%H:%M:%S %p' //bug fix
        // reformat the tooltips so that local times are displayed
        //formatter: function() {
        //var d = new Date(this.x + (myOffset*60000));
        //var n = (this.point.name === undefined) ? '' : '<br/>' + this.point.name;
        //return this.series.name + ':<b>' + this.y + '</b>' + n + '<br/>' + d.toDateString() + '<br/>' + d.toTimeString().replace(/\(.*\)/, "");
        //}
    },
    xAxis: {
        title: {text: 'LeftAxis'},
        type: 'datetime',
        ordinal:false,
        min: Date.UTC(2017,03,01),
        dateTimeLabelFormats : {
            // hour: '%l %p',
            // minute: '%l:%M %p'
            hour: '%H:%M',
            minute: '%H:%M:%S'
        }
    },
    yAxis: [{
        labels: {useHTML:true, format: '{value}', style: {color: field1color} },
        title: {
            useHTML:true, 
            text: 'RSSI [dBm]',
            style: {color: field1color}
        },
        allowDecimals: false,
        offset: 30,
        opposite: false,
        id: 'T'
        }, {
        labels: {useHTML:true, format: '{value}', style: {color: field3color} },
        title: {
            useHTML:true, 
            text: 'sonar [cm] / Free heap',
            style: {color: field3color}
        },
        allowDecimals: false,
        id: 'H'
    }],
    exporting: {
        enabled: true,
        csv: {
            dateFormat: '%d/%m/%Y %I:%M:%S %p'
        }
        },
    legend: {enabled: true},
    navigator: {
        baseSeries: 0,  //select which series to show in history navigator, First series is 0
        series: {includeInCSVExport: true}
    },    
    series: []
        /*
        series: [

        {
            type: 'flags',
            name: 'Flags on series',
            data: [{
                x: xAxesFlag1time ,
                title: xAxesFlag1text
            }, {
                x: xAxesFlag2time ,
                title: xAxesFlag2text
            }],
            onSeries: 'dataseries',
            shape: 'squarepin'
        },
        */
        /*
        {
            type: 'flags',
            name: 'Flags on axis',
            data: [{
                x: xAxesFlag1time ,
                title: xAxesFlag1text
            }, {
                x: xAxesFlag2time ,
                title: xAxesFlag2text
            }],
            shape: 'squarepin'
        }
    ]
    */

    //series: [{},{},{}]
    /*
    series: [{
        zones: [{
            value: 33,
            color: '#7cb5ec'
        }, {
            value: 36,
            color: '#7cb5ec'
        }, {
            color: '#7cb5ec'
        }]
    }]
    */
    //series: [{data:[[getChartDate("2017-03-01T00:32:40Z"),75]]}]      
    };

    // add all Channel data to the chart
  for (var channelIndex=0; channelIndex<channelKeys.length; channelIndex++)  // iterate through each channel
  {
    for (var fieldIndex=0; fieldIndex<channelKeys[channelIndex].fieldList.length; fieldIndex++)  // add each field
    {
      window.console && console.log('Channel '+channelIndex+' field '+fieldIndex);
      chartOptions.series.push({data: channelKeys[channelIndex].fieldList[fieldIndex].data,
                                index:channelKeys[channelIndex].fieldList[fieldIndex].series,
                                yAxis:channelKeys[channelIndex].fieldList[fieldIndex].axis,
                                name: channelKeys[channelIndex].fieldList[fieldIndex].name});
    }
  }
  // added flags only after all series are added due to navigator bar display reasons
      chartOptions.series.push({    type: 'flags',
                                    name: 'Log',
                                    shape: 'squarepin',
                                    data: [{
                                        x: xAxesFlag1time ,
                                        title: xAxesFlag1text
                                    }, {
                                        x: xAxesFlag2time ,
                                        title: xAxesFlag2text
                                    }]
                                });

    // set chart labels here so that decoding occurs properly
    //chartOptions.title.text = data.channel.name;
    chartOptions.xAxis.title.text = 'Date';

    // draw the chart
  dynamicChart = new Highcharts.StockChart(chartOptions);

  // update series number to account for the navigator series (The historical series at the bottom) which is the first series.
  for (var channelIndex=0; channelIndex<channelKeys.length; channelIndex++)  // iterate through each channel
  {
    for (var fieldIndex=0; fieldIndex<channelKeys[channelIndex].fieldList.length; fieldIndex++)  // and each field
    {
      for (var seriesIndex=0; seriesIndex<dynamicChart.series.length; seriesIndex++)  // compare each series name
      {
        if (dynamicChart.series[seriesIndex].name == channelKeys[channelIndex].fieldList[fieldIndex].name)
        {
          channelKeys[channelIndex].fieldList[fieldIndex].series = seriesIndex;
        }
      }
    }
  }      

  //dynamicChart.series[0].hide(); //changed 17.6.11
  
  // add all history
  // dynamicChart.showLoading("Loading History..." );
  window.console && console.log('Channels: ',channelKeys.length);
  for (var channelIndex=0; channelIndex<channelKeys.length; channelIndex++)  // iterate through each channel
  {
    window.console && console.log('channelIndex: ',channelIndex);
    (function(channelIndex)
      {
        //load only 1 set of 8000 points
        loadChannelHistory(channelIndex,channelKeys[channelIndex].channelNumber,channelKeys[channelIndex].key,channelKeys[channelIndex].fieldList,0,1); 
      }
    )(channelIndex);
  }
 }
});
 
// load next 8000 points from a ThingSpeak channel and addPoints to a series
function loadChannelHistory(sentChannelIndex,channelNumber,key,sentFieldList,sentNumLoads,maxLoads) {
   var numLoads=sentNumLoads
   var fieldList= sentFieldList;
   var channelIndex = sentChannelIndex;
   var first_Date = new Date();
   if (typeof fieldList[0].data[0] != "undefined") first_Date.setTime(fieldList[0].data[0][0]+7*60*60*1000);//adjust for 7 hour difference from GMT (Zulu time)
   else if (typeof fieldList[1].data[0] != "undefined") first_Date.setTime(fieldList[1].data[0][0]+7*60*60*1000);
   else if (typeof fieldList[2].data[0] != "undefined") first_Date.setTime(fieldList[2].data[0][0]+7*60*60*1000);
   else if (typeof fieldList[3].data[0] != "undefined") first_Date.setTime(fieldList[3].data[0][0]+7*60*60*1000);
   else if (typeof fieldList[4].data[0] != "undefined") first_Date.setTime(fieldList[4].data[0][0]+7*60*60*1000);
   else if (typeof fieldList[5].data[0] != "undefined") first_Date.setTime(fieldList[5].data[0][0]+7*60*60*1000);
   else if (typeof fieldList[6].data[0] != "undefined") first_Date.setTime(fieldList[6].data[0][0]+7*60*60*1000);
   else if (typeof fieldList[7].data[0] != "undefined") first_Date.setTime(fieldList[7].data[0][0]+7*60*60*1000);
   var end = first_Date.toJSON();
   window.console && console.log('earliest date:',end);
   window.console && console.log('sentChannelIndex:',sentChannelIndex);
   window.console && console.log('numLoads:',numLoads);
   // get the Channel data with a webservice call
    $.getJSON('https://www.thingspeak.com/channels/'+channelNumber+'/feed.json?callback=?&amp;offset=0&amp;start=2017-03-01T00:00:00;end='+end+';key='+key, function(data) 
   {
       // if no access
       if (data == '-1') {
       $('#chart-container').append('This channel is not public.  To embed charts, the channel must be public or a read key must be specified.');
       window.console && console.log('Thingspeak Data Loading Error');
     }
     for (var fieldIndex=0; fieldIndex<fieldList.length; fieldIndex++)  // iterate through each field
     {
       //fieldList[fieldIndex].data =[];
       for (var h=0; h<data.feeds.length; h++)  // iterate through each feed (data point)
       {
         var p = []//new Highcharts.Point();
         var fieldStr = "data.feeds["+h+"].field"+fieldList[fieldIndex].field;
             var v = eval(fieldStr);
            p[0] = getChartDate(data.feeds[h].created_at);
            p[1] = parseFloat(v);
            // if a numerical value exists add it
            if (!isNaN(parseInt(v))) { fieldList[fieldIndex].data.push(p); }
       }
       fieldList[fieldIndex].data.sort(function(a,b){return a[0]-b[0]});
       dynamicChart.series[fieldList[fieldIndex].series].setData(fieldList[fieldIndex].data,false);
       //dynamicChart.series[fieldList[fieldIndex].series].addPoint(fieldList[fieldIndex].data,false);
       //fieldList[fieldIndex].name = eval("data.channel.field"+fieldList[fieldIndex].field);
       //window.console && console.log('data added to series:',fieldList[fieldIndex].series,fieldList[fieldIndex].data);
       }
     channelKeys[channelIndex].fieldList=fieldList;
     dynamicChart.redraw()
     window.console && console.log('channel index:',channelIndex);
     numLoads++;
     if (numLoads<maxLoads) {loadChannelHistory(channelIndex,channelNumber,key,fieldList,numLoads,maxLoads);
       //dynamicChart.showLoading("Loading ended" );
     }
     });
}
