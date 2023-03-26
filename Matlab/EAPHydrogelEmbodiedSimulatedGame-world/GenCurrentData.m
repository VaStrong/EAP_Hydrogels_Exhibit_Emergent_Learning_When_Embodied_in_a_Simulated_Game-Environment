function [rawDataTop,rawDataMid,rawDataBot] = GenCurrentData(CombinedTable,window,timeCutoff)
f = waitbar(0,'Setting Up Data');

allTop = [];
allMid = [];
allBot = [];

s = size(CombinedTable,2);
for i = 1 : s
    currentData = CombinedTable{i};
    allTop = [allTop;currentData(:,[10,7])];%black
    allMid = [allMid;currentData(:,[10,8])];%brown
    allBot = [allBot;currentData(:,[10,9])];%red
end

allTop(:,1) = allTop(:,1)/1000;
allMid(:,1) = allMid(:,1)/1000;
allBot(:,1) = allBot(:,1)/1000;

waitbar(0.01,f,'Averaging Top Data');
rawDataTop = windowAverage(allTop,window);

waitbar(0.33,f,'Averaging Mid Data');
rawDataMid = windowAverage(allMid,window);

waitbar(0.66,f,'Averaging Bot Data');
rawDataBot = windowAverage(allBot,window);

waitbar(1,f,'Done');
close(f);
end