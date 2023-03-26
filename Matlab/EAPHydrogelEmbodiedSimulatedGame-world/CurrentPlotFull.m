window = 600;
timeCutoff = 3500;
if exist('rawDataTop','var') ~= 1
    [rawDataTop,rawDataMid,rawDataBot] = GenCurrentData(CombinedCurrentPlus,window,timeCutoff);
end
currentPlot(rawDataTop,rawDataMid,rawDataBot,0,window,timeCutoff);