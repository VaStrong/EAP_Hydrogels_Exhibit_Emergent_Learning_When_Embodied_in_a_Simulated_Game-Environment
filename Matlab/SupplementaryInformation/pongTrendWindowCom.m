function pongTrendWindowCom(CombinedTable)

allTop = [];
allMid = [];
allBot = [];
s = size(CombinedTable,2);
for i = 1 : s
    allTop = [allTop;extractHits(CombinedTable{i},"top")];
    allMid = [allMid;extractHits(CombinedTable{i},"mid")];
    allBot = [allBot;extractHits(CombinedTable{i},"bot")];
end

%extract hit miss ratio
windows = [10 60 200 400];
timeCutoff = 3500;

%graph plotting
figure;
for i = 1:4
    %extract hit miss ratio
    window = windows(i);
    dataTop = windowAverage(allTop,window);
    dataMid = windowAverage(allMid,window);
    dataBot = windowAverage(allBot,window);


    dataTop = dataTop(dataTop(:,1)<=timeCutoff,:);
    dataMid = dataMid(dataMid(:,1)<=timeCutoff,:);
    dataBot = dataBot(dataBot(:,1)<=timeCutoff,:);

    %best fit lines
    deg = 7;
    fitresultT = polyfit(dataTop(:,1), dataTop(:,2),deg);
    fitresultM = polyfit(dataMid(:,1), dataMid(:,2),deg);
    fitresultB = polyfit(dataBot(:,1), dataBot(:,2),deg);

    timeGap = (window/2):timeCutoff;
    %timeGap = 1:timeCutoff;

    %plotting
    subplot(2,2,i);
    hold on

    plot(dataTop(:,1),dataTop(:,2),'b');
    plot(dataMid(:,1),dataMid(:,2),'g');
    plot(dataBot(:,1),dataBot(:,2),'r');
    
    plot(timeGap, polyval(fitresultT, timeGap),'b--');

    plot(timeGap, polyval(fitresultM, timeGap),'g--');

    plot(timeGap, polyval(fitresultB, timeGap),'r--');


    xline(2000,'-.','color','#D95319');

    hold off
    xlabel("Time (s)");
    ylabel("Hit Rate");
    title(["Hit Rate Over Time for Diffrent Segments,", strcat('with a',{' '},num2str(window),' Second Window')]);
    legend(["Top" "Top Best Fit" "Middle" "Middle Best Fit" "Bottom" "Bottom Best Fit"], 'location', 'southeast');
    ylim([0 1]);
    xlim([0 timeCutoff]);

    time = dataMid(:,1);
    data = dataMid(:,2);
end
end