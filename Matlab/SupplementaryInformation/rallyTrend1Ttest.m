function [setA,setB,trendData] = rallyTrend1Ttest(CombinedTable)

allData = [];
s = size(CombinedTable,2);
for i = 1 : s
    allData = [allData;extractRallys(CombinedTable{i})];
end

rawData = sortrows(allData);

window = 600;
timeCutoff = 2000;%3500;


%% polt data with window average ansh show sample ranges
figure;

data = windowAverage(rawData,window);
data = data(data(:,1)<=timeCutoff,:);
trendData=data;
rawData = rawData(rawData(:,1)<=timeCutoff,:);
fitresult = polyfit(data(:,1), data(:,2),4);
timeGap = window/2:timeCutoff;

subplot(1,3,1)
plot(data(:,1),data(:,2),'b')
hold on
plot(timeGap, polyval(fitresult, timeGap),'b--');
temp = real(roots(polyder(fitresult)));
temp = temp(temp<timeCutoff&temp>(window/2));
[NU,loc] = max(polyval(fitresult, temp));
MaxLearn = temp(loc);
%disp(MaxLearn);

scatter(MaxLearn,polyval(fitresult, MaxLearn),100,'k.');
%xline(MaxLearn,'-.','color','#7E2F8E');

xlabel("Time (s)");
ylabel("Rally Length");
title(strcat('Rally Lengths Over Time, with a',{' '},num2str(window),' Second Window'));
xlim([0 timeCutoff]);
ylim([0 6]);

%% plot raw data as scatter points with ranges
subplot(1,3,2)
scatter(rawData(:,1),rawData(:,2))
title('Rally Lengths Over Time');
xlabel("Time (s)");
ylabel("Rally Length");
xlim([0 timeCutoff]);

%% perform t-test

%set after learning
setBcenter = MaxLearn;
setWindow = floor(timeCutoff - setBcenter)*2;%largest the dataset can be when centered on the max learning point
[val,pos1]=min(abs(rawData(:,1)-(setBcenter-setWindow/2)));%pos1 = find(rawData(:,1)>=(setBcenter-setWindow/2), 1, 'first');
[val,pos2]=min(abs(rawData(:,1)-(setBcenter+setWindow/2)));%pos2 = find(rawData(:,1)>=(setBcenter+setWindow/2), 1, 'first');
setB = rawData(pos1:pos2,2);
%setB = rawData(size(rawData,1)-(pos2-pos1):size(rawData,1),2);
Bm = mean(setB);
Bs = Bm;%std(setB);
Bn = length(setB);
%var(setB)

%set before learning
baseWindow = 1000; %limit of prelearning dataset 
[val,pos]=min(abs(rawData(:,1)-baseWindow));%pos = find(rawData(:,1)>=baseWindow, 1, 'first');
setA = rawData(1:pos,2);
setA = setA(1:floor(length(setA)/Bn)*Bn,:);
pos = length(setA);
%setA=reshape(setA,Bn,[]);
%setA = mean(setA,2);
setA = downsample(setA,length(setA)/Bn);
Am = mean(setA);
As = Am;%std(setA);
An = length(setA);
%var(setA)

% welch t test calculation
T = abs(Am-Bm)/sqrt( ((As^2)/An) + ((Bs^2)/Bn) );
dof = An+Bn-2;

%disp(T)
%disp(dof)

%% Mann-Withney-Wilcoxon calculation
%independent variables so using sum rank method
rank = [setA , ones(An,1) ; setB , zeros(Bn,1)];
rank = sortrows(rank,1);
rank = [rank,(1:1:size(rank,1))'];

lastRank = [];
indexes = [];
tieScor = [];
for i = 1:size(rank,1)
    if rank(i,1) == lastRank
        indexes = [indexes i];
    else
        lastRank = rank(i,1);
        rank(indexes,3) = sum(indexes)/length(indexes);
        tieScor = [tieScor length(indexes)];
        indexes = i;
    end
end

rankStat = sum((tieScor.^3-tieScor));
tScore = rankStat/((An+Bn)*(An+Bn-1));
Mu = (An*Bn)/2;
Su = sqrt( ((An*Bn)/12)*(An+Bn+1 - tScore) );

%need to adjust for ties in ranks, for each set of ties give average rank
[rank, rankStat] = tiedrank([setA ; setB]);
rank = [[setA , ones(An,1); setB, zeros(Bn,1)] , rank];

ASum = (rank(:,2)==1).*rank(:,3);
ASum = sum(ASum,1);
AUStat = ASum - ((An*(An-1))/2);

BSum = (rank(:,2)==0).*rank(:,3);
BSum = sum(BSum,1);
BUStat = BSum - ((Bn*(Bn-1))/2);

SumStat = min([ASum, BSum]);
UStat = min([AUStat, BUStat]);

%samples are larger than 50 so critical limit theroim allows z to follow normal distribution
%https://en.wikipedia.org/wiki/Mann%E2%80%93Whitney_U_test
%Mu = An*(An + Bn + 1)/2;
%tScore = (2*rankStat)/((An+Bn)*(An+Bn-1));
%Su = sqrt(An*Bn*((An + Bn + 1) - tScore)/12);

%-0.5 is continuity correction for right tailed test
%Z = (SumStat - Mu - 0.5)/Su;
Z = (UStat - Mu - 0.5)/Su;
%p value for right side test using normal distribution of mean = 0 Std = 1
P = 1-normcdf(Z,0,1);

[p,h,stats] = ranksum(setB,setA,'tail','right','method','approximate');

disp(p)
disp(P)
disp(stats)
disp(Z)
%An alpha of p < 0.05 was adopted to establish statistical significance, providing a 5% chance of a false positive error.

%% put in range for datasets into plots

subplot(1,3,1)
hold on
xline(0,'-.','color','#D95319');
xline(rawData(pos,1),'-.','color','#D95319');
xline(rawData(pos1,1),'-.','color','#7E2F8E');
xline(rawData(pos2,1),'-.','color','#7E2F8E');

subplot(1,3,2)
hold on
xline(0,'-.','color','#D95319');
xline(rawData(pos,1),'-.','color','#D95319');
xline(rawData(pos1,1),'-.','color','#7E2F8E');
xline(rawData(pos2,1),'-.','color','#7E2F8E');

%% plot distributions of samples
XGrid = 0:0.5:max([setA ;setB]);
LegHandles = []; LegText = {};

figure; %subplot(1,3,3)
%histogram(setA,'FaceColor','#D95319')
[CdfF,CdfX] = ecdf(setA,'Function','cdf');  % compute empirical cdf
BinInfo.rule = 1;
[~,BinEdge] = internal.stats.histbins(setA,[],[],BinInfo,CdfF,CdfX);
[BinHeight,BinCenter] = ecdfhist(CdfF,CdfX,'edges',BinEdge);
hLine = bar(BinCenter,BinHeight,'hist');
set(hLine,'FaceColor','#D95319','FaceAlpha',0.2,'EdgeColor','#D95319', 'LineStyle','-', 'LineWidth',1);
LegHandles(end+1) = hLine;
LegText{end+1} = 'Dataset Before Learning';
hold on
%histogram(setB,'FaceColor','#7E2F8E')
[CdfF,CdfX] = ecdf(setB,'Function','cdf');  % compute empirical cdf
BinInfo.rule = 1;
[~,BinEdge] = internal.stats.histbins(setB,[],[],BinInfo,CdfF,CdfX);
[BinHeight,BinCenter] = ecdfhist(CdfF,CdfX,'edges',BinEdge);
hLine = bar(BinCenter,BinHeight,'hist');
set(hLine,'FaceColor','#7E2F8E','FaceAlpha',0.2,'EdgeColor','#7E2F8E', 'LineStyle','-', 'LineWidth',1);
LegHandles(end+1) = hLine;
LegText{end+1} = 'Dataset After Learning';

pdA = fitdist(setA, 'exponential');
YPlotA = pdf(pdA,XGrid);
hLine = plot(XGrid,YPlotA,'Color',"#FF0000", 'LineWidth',1.2);
LegHandles(end+1) = hLine;
LegText{end+1} = 'Distribution Before Learning';
pdB = fitdist(setB, 'exponential');
YPlotB = pdf(pdB,XGrid);
hLine = plot(XGrid,YPlotB,'Color',"#0000FF", 'LineWidth',1.2);
LegHandles(end+1) = hLine;
LegText{end+1} = 'Distribution After Learning';

% Create legend from accumulated handles and labels
hLegend = legend(LegHandles,LegText,'Orientation', 'vertical', 'FontSize', 9, 'Location', 'northeast');
set(hLegend,'Interpreter','none');
title('Distribution of Rally Lengths Before and After Learning');
xlabel('Rally Length');
ylabel('Density')

%% figures for manuscript

figure
plot(data(:,1),data(:,2),'b');
hold on
plot(timeGap, polyval(fitresult, timeGap),'b--');
scatter(MaxLearn,polyval(fitresult, MaxLearn),100,'k.');
%xline(0,'-.','color','#D95319');
xline(rawData(pos,1),'-.','color','#D95319');
xline(rawData(pos1,1),'-.','color','#7E2F8E');
%xline(rawData(pos2,1),'-.','color','#7E2F8E');
xlabel("Time (s)");
ylabel("Rally Length");
title(strcat('Rally Lengths Over Time, with a',{' '},num2str(window),' Second Window'));
legend(["Averaged Rally Length" "Best Fit Line"], 'location', 'northwest');
xlim([0 timeCutoff]);
ylim([0 6]);
end