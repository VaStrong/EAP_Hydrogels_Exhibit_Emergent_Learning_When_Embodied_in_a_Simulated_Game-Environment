function combinedPongRallyTrend(CombinedTable, learn)

window = 600;
timeCutoff = 2000;
alp = 0.2;

allData = [];
s = size(CombinedTable,2);
for i = 1 : s
    allData = [allData;extractRallys(CombinedTable{i})];
end

rawData = sortrows(allData);
rawData = windowAverage(rawData,window);
rawData = rawData(rawData(:,1)<=timeCutoff,:);
%------------------------------

allTop = [];
allMid = [];
allBot = [];
s = size(CombinedTable,2);
for i = 1 : s
    allTop = [allTop;extractHits(CombinedTable{i},"top")];
    allMid = [allMid;extractHits(CombinedTable{i},"mid")];
    allBot = [allBot;extractHits(CombinedTable{i},"bot")];
end

%graph plotting
    %extract hit miss ratio
    dataTop = windowAverage(allTop,window);
    dataMid = windowAverage(allMid,window);
    dataBot = windowAverage(allBot,window);


    dataTop = dataTop(dataTop(:,1)<=timeCutoff,:);
    dataMid = dataMid(dataMid(:,1)<=timeCutoff,:);
    dataBot = dataBot(dataBot(:,1)<=timeCutoff,:);

    %plotting
    figure;
    hold on

    color = 'b';
    positions = dataTop(:,1);
    data = dataTop(:,2);
    error = dataTop(:,5);
    x2 = [positions', fliplr(positions')];
    inBetween = [(data-error)', fliplr((data+error)')];
    fill(x2, inBetween,color,'FaceAlpha',alp,'EdgeColor','none');
    plot(positions,data,color)
    %disp(max(error));

    color = 'g';
    positions = dataMid(:,1);
    data = dataMid(:,2);
    error = dataMid(:,5);
    x2 = [positions', fliplr(positions')];
    inBetween = [(data-error)', fliplr((data+error)')];
    fill(x2, inBetween,color,'FaceAlpha',alp,'EdgeColor','none');
    plot(positions,data,color)
    %disp(max(error));

    color = 'r';
    positions = dataBot(:,1);
    data = dataBot(:,2);
    error = dataBot(:,5);
    x2 = [positions', fliplr(positions')];
    inBetween = [(data-error)', fliplr((data+error)')];
    fill(x2, inBetween,color,'FaceAlpha',alp,'EdgeColor','none');
    plot(positions,data,color)
    %disp(max(error));
    if learn
        [midMaxLearn, mml] = max(dataMid(:,2));
        [botMaxLearn, bml] = max(dataBot(:,2));
        scatter(dataMid(mml,1),midMaxLearn,100,'k.');
        scatter(dataBot(bml,1),botMaxLearn,100,'k.');
        xline(mean([dataMid(mml,1), dataBot(bml,1)]),'-.','color','#7E2F8E');
        %disp(mean([dataMid(mml,1), dataBot(bml,1)]));
    end

    hold off

    ylim([0 1]);
    ylabel("Hit Rate");

%-----------------------------------------------------------------------------------rally length
yyaxis right
hold on

fitresult = polyfit(rawData(:,1), rawData(:,2),4);
timeGap = 600/2:timeCutoff;

color = [0.9290 0.6940 0.1250];
positions = rawData(:,1);
data = rawData(:,2);
error = rawData(:,5);
x2 = [positions', fliplr(positions')];
inBetween = [(data-error)', fliplr((data+error)')];
fill(x2, inBetween,color,'FaceAlpha',alp,'EdgeColor','none');
plot(positions,data,'-','color',color)
%disp(max(error));

if learn
    plot(timeGap, polyval(fitresult, timeGap),'--','color',color);
    
    temp = real(roots(polyder(fitresult)));
    temp = temp(temp<timeCutoff&temp>(window/2));
    [NU,loc] = max(polyval(fitresult, temp));
    MaxLearn = temp(loc);
    disp(MaxLearn);
    scatter(MaxLearn,polyval(fitresult, MaxLearn),100,'k.');
    xline(838,'-.','color','#D95319');
    xline(1487,'-.','color','#77AC30');
end

hold off
ylabel("Rally Length");
if learn
    ylim([3.5 8]);
else
    ylim([-2 2.5]);
end
set(gca, 'YColor','k');
curtick = get(gca, 'yTick');
if learn
    yticks(unique(round(curtick)));
else
    yticks(unique( round( (curtick>0) .* curtick ) ) );
end

% common lables

    xlim([0 timeCutoff]);
    xlabel("Time (s)");
    title(["Hit Rate for Diffrent Segments", strcat('and Rally Lengths Over Time, with a',{' '},num2str(window),' Second Window')]);
    if learn
        legend(["" "Top" "" "Middle" "" "Bottom" "" "" "" "" "Averaged Rally Length" "Rally Length Best Fit Line"], 'location', 'southwest');
    else
        legend(["" "Top" "" "Middle" "" "Bottom" "" "Averaged Rally Length" "Best Fit Line"], 'location', 'northwest');
    end

end