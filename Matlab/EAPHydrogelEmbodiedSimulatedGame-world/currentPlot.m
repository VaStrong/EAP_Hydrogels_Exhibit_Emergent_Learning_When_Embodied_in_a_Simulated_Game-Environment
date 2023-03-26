function currentPlot(rawDataTop,rawDataMid,rawDataBot,maxLearn,window,timeCutoff)
f = waitbar(0,'Setting Up Data');

timeGap = (window/2):timeCutoff;
alp = 0.2;

%best fit lines
waitbar(0.50,f,'Best Fit Lines Calculation');
fitresultT = polyfit(rawDataTop(:,1), rawDataTop(:,2),7);
fitresultM = polyfit(rawDataMid(:,1), rawDataMid(:,2),7);
fitresultB = polyfit(rawDataBot(:,1), rawDataBot(:,2),7);

waitbar(0.90,f,'Plotting');
figure;
hold on

%---------------top
color = 'b';
positions = rawDataTop(:,1);
data = rawDataTop(:,2);
error = rawDataTop(:,5);
x2 = [positions', fliplr(positions')];
inBetween = [(data-error)', fliplr((data+error)')];
fill(x2, inBetween,color,'FaceAlpha',alp,'EdgeColor','none');
plot(positions,data,color)
disp(max(error));

color = 'g';
positions = rawDataMid(:,1);
data = rawDataMid(:,2);
error = rawDataMid(:,5);
x2 = [positions', fliplr(positions')];
inBetween = [(data-error)', fliplr((data+error)')];
fill(x2, inBetween,color,'FaceAlpha',alp,'EdgeColor','none');
plot(positions,data,color)
disp(max(error));

color = 'r';
positions = rawDataBot(:,1);
data = rawDataBot(:,2);
error = rawDataBot(:,5);
x2 = [positions', fliplr(positions')];
inBetween = [(data-error)', fliplr((data+error)')];
fill(x2, inBetween,color,'FaceAlpha',alp,'EdgeColor','none');
plot(positions,data,color)
disp(max(error));

if maxLearn
    plot(timeGap, polyval(fitresultT, timeGap),'b--');
    temp = real(roots(polyder(fitresultT)));
    temp = temp(temp<timeCutoff);
    [NU,loc] = max(polyval(fitresultT, temp));
    topMaxLearn = temp(loc);
    plot(timeGap, polyval(fitresultM, timeGap),'g--');
    temp = real(roots(polyder(fitresultM)));
    [NU,loc] = max(polyval(fitresultM, temp));
    midMaxLearn = temp(loc);
    plot(timeGap, polyval(fitresultB, timeGap),'r--');
    temp = real(roots(polyder(fitresultB)));
    [NU,loc] = max(polyval(fitresultB, temp));
    botMaxLearn = temp(loc);

    scatter(topMaxLearn,polyval(fitresultT, topMaxLearn),100,'k.');
    scatter(midMaxLearn,polyval(fitresultM, midMaxLearn),100,'k.');
    scatter(botMaxLearn,polyval(fitresultB, botMaxLearn),100,'k.');
    xline(mean([topMaxLearn, midMaxLearn, botMaxLearn]),'-.','color','#7E2F8E');

else
    [topMaxLearn, tml] = max(rawDataTop(:,2));
    [midMaxLearn, mml] = max(rawDataMid(:,2));
    [botMaxLearn, bml] = max(rawDataBot(:,2));
    scatter(rawDataTop(tml,1),topMaxLearn,100,'k.');
    scatter(rawDataMid(mml,1),midMaxLearn,100,'k.');
    scatter(rawDataBot(bml,1),botMaxLearn,100,'k.');
    %xline(mean([topMaxLearn, midMaxLearn, botMaxLearn]),'-.','color','#7E2F8E');
    xline(mean([rawDataTop(tml,1), rawDataMid(mml,1), rawDataBot(bml,1)]),'-.','color','#7E2F8E');
    disp(mean([rawDataTop(tml,1), rawDataMid(mml,1), rawDataBot(bml,1)]));
end

xline(2000,'-.','color','#D95319');

hold off
xlabel("Time (s)");
ylabel("Current (mA)");
xlim([0 timeCutoff]);
title(strcat('Average Current Over Time, with a',{' '},num2str(window),' Second Window'));
if maxLearn
    legend(["" "Top" "" "Middle" "" "Bottom" "Top Best Fit" "Middle Best Fit" "Bottom Best Fit"]);
else
    legend(["" "Top" "" "Middle" "" "Bottom"]);
end

waitbar(1,f,'Done');
close(f);

end