function pongTrendSampleSize(CombinedTable)

allTop = {};
topTemp = [];
allMid = {};
midTemp = [];
allBot = {};
botTemp = [];
s = size(CombinedTable,2);
for i = 1 : s
    topTemp = [topTemp;extractHits(CombinedTable{i},"top")];
    allTop{i} = topTemp;
    midTemp = [midTemp;extractHits(CombinedTable{i},"mid")];
    allMid{i} = midTemp;
    botTemp = [botTemp;extractHits(CombinedTable{i},"bot")];
    allBot{i} = botTemp;
end

%extract hit miss ratio
%windows = [10 30 60 100 200 400 600];
timeCutoff = 2000;%1800;%3500;
window = 600;

figure;
title(["Standard Deviation of Hit Rate Over Time for Dataset Sizes Consisting of N Experimental Runs"]);
stdTop = [];
stdMid = [];
stdBot = [];
if s > 12
    set = 1:2:s;
else 
    set = 1:s;
end
counter = 1;
for i = set
    dataTop = allTop{i};
    dataMid = allMid{i};
    dataBot = allBot{i};
    %dataTop = dataTop(dataTop(:,1)<=timeCutoff,:);
    %dataMid = dataMid(dataMid(:,1)<=timeCutoff,:);
    %dataBot = dataBot(dataBot(:,1)<=timeCutoff,:);

    dataTopSD = windowAverage(dataTop,window);
    dataMidSD = windowAverage(dataMid,window);
    dataBotSD = windowAverage(dataBot,window);
    
    CITop = (dataTopSD(:,3)./sqrt(dataTopSD(:,4)));
    CIMid = (dataMidSD(:,3)./sqrt(dataMidSD(:,4)));
    CIBot = (dataBotSD(:,3)./sqrt(dataBotSD(:,4)));

    stdTop = [stdTop ; std(dataTop(:,2)) mean(dataTopSD(:,3)) mean(dataTopSD(:,4)) mean(CITop)];
    stdMid = [stdMid ; std(dataMid(:,2)) mean(dataMidSD(:,3)) mean(dataMidSD(:,4)) mean(CIMid)];
    stdBot = [stdBot ; std(dataBot(:,2)) mean(dataBotSD(:,3)) mean(dataBotSD(:,4)) mean(CIBot)];

    %plotting
    subplot(ceil(size(set,2)/2),2,counter)
    counter = counter + 1;
    hold on
    plot(dataTopSD(:,1),dataTopSD(:,3),'b')
    plot(dataMidSD(:,1),dataMidSD(:,3),'g');
    plot(dataBotSD(:,1),dataBotSD(:,3),'r')

    hold off
    xlabel("Time (s)");
    ylabel(["Standard Deviation";"(Hit Rate)"]);
    title(strcat('N=',num2str(i)));
    %legend(["Top" "Middle" "Bottom"], 'location', 'northeast');
    ylim([0 0.6]);
    xlim([0 timeCutoff]);
end
legend(["Top" "Middle" "Bottom"]);

figure;
subplot(1,3,1)
hold on
plot(set,stdTop(:,1),'b')
plot(set,stdMid(:,1),'g')
plot(set,stdBot(:,1),'r')
hold off
xlabel("Number of Experiments");
ylabel("Standard Deviation (Hit Rate)");
%title(["Hit Rate Over Time for Diffrent Segments,", strcat('with a',{' '},num2str(window),' Second Window')]);
legend(["Top" "Middle" "Bottom"], 'location', 'northeast');

subplot(1,3,2)
hold on
plot(set,stdTop(:,4),'b')
plot(set,stdMid(:,4),'g')
plot(set,stdBot(:,4),'r')
hold off
xlabel("Number of Experiments");
ylabel("Mean Standard Error");
%title(["Hit Rate Over Time for Diffrent Segments,", strcat('with a',{' '},num2str(window),' Second Window')]);
legend(["Top" "Middle" "Bottom"], 'location', 'northeast');

subplot(1,3,3)
hold on
plot(set,stdTop(:,3),'b')
plot(set,stdMid(:,3),'g')
plot(set,stdBot(:,3),'r')
hold off
xlabel("Number of Experiments");
ylabel("Mean Sample Size with Window");
%title(["Hit Rate Over Time for Diffrent Segments,", strcat('with a',{' '},num2str(window),' Second Window')]);
legend(["Top" "Middle" "Bottom"], 'location', 'northwest');
end