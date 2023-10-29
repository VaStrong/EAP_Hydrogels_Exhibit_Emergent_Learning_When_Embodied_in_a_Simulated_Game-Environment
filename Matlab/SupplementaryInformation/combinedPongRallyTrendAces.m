function combinedPongRallyTrendAces(CombinedTable)

window = 600;
timeCutoff = 2000;
alp = 0.2;

allData = [];
s = size(CombinedTable,2);
for i = 1 : s
    allData = [allData;extractAces(CombinedTable{i})];
end

rawData = sortrows(allData);
rawData = windowAverage(rawData,window);
rawData = rawData(rawData(:,1)<=timeCutoff,:);

%-----------------------------------------------------------------------------------Ace length

fitresult = polyfit(rawData(:,1), rawData(:,2),4);
timeGap = 600/2:timeCutoff;
hold on
color = [0.9290 0.6940 0.1250];
positions = rawData(:,1);
data = rawData(:,2);
error = rawData(:,5);
x2 = [positions', fliplr(positions')];
inBetween = [(data-error)', fliplr((data+error)')];
fill(x2, inBetween,color,'FaceAlpha',alp,'EdgeColor','none');
plot(positions,data,'-','color',color)
%disp(max(error));

plot(timeGap, polyval(fitresult, timeGap),'--','color',color);

temp = real(roots(polyder(fitresult)));
temp = temp(temp<timeCutoff&temp>(window/2));
[NU,loc] = min(polyval(fitresult, temp));
MaxLearn = temp(loc);
disp(MaxLearn);
scatter(MaxLearn,polyval(fitresult, MaxLearn),100,'k.');

hold off
ylabel("Ace Length");

% common lables

xlim([0 timeCutoff]);
xlabel("Time (s)");
title([strcat('Aces Over Time, with a',{' '},num2str(window),' Second Window')]);
legend(["Rally Aces"], 'location', 'northeast');

end