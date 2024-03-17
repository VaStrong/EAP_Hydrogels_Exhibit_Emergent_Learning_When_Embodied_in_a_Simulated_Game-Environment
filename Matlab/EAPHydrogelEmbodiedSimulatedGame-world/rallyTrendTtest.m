function Output = rallyTrendTtest(CombinedTable,average)
%% Set variables
MaxLearn = 1744;
window = 600;
timeCutoff = 2000;%3500;

%% Sort raw data
allData = [];
s = size(CombinedTable,2);
for i = 1 : s
    allData = [allData;extractRallys(CombinedTable{i})];
end

rawData = sortrows(allData);
if average == 1
    rawData = windowAverage(rawData,window);
end

%% perform t-test

%set after learning
setBcenter = MaxLearn;
setWindow = floor(timeCutoff - setBcenter)*2;%largest the dataset can be when centered on the max learning point
[val,pos1]=min(abs(rawData(:,1)-(setBcenter-setWindow/2)));
[val,pos2]=min(abs(rawData(:,1)-(setBcenter+setWindow/2)));
setB = rawData(pos1:pos2,2);

Bm = mean(setB);
Bs = Bm;
Bn = length(setB);

%set before learning
baseWindow = 1000; %limit of prelearning dataset 
[val,pos]=min(abs(rawData(:,1)-baseWindow));
setA = rawData(1:pos,2);
Apos2 = floor(length(setA)/Bn)*Bn;
setA = setA(1:Apos2,:);
pos = length(setA);
posa = 0;

setA = downsample(setA,length(setA)/Bn);
Am = mean(setA);
As = Am;
An = length(setA);

% welch t test calculation
T = abs(Am-Bm)/sqrt( ((As^2)/An) + ((Bs^2)/Bn) );
dof = An+Bn-2;

disp(strcat("Unlearned dataset spans 0 to ", num2str(rawData(pos,1)), " seconds, with ", num2str(An), " samples." ));
disp(strcat("Learned dataset spans ", num2str(rawData(pos1,1)), " to ", num2str(rawData(pos2,1)), " seconds, with ", num2str(Bn), " samples." ));

Output.posa = posa;
Output.pos = pos;
Output.pos1 = pos1;
Output.pos2 = pos2;
Output.setA = setA;
Output.setB = setB;

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
Z = (UStat - Mu - 0.5)/Su;
%p value for right side test using normal distribution of mean = 0 Std = 1
P = 1-normcdf(Z,0,1);

[p,h,stats] = ranksum(setB,setA,'tail','right','method','approximate');
[p2,h2,stats2] = ranksum(setA,setB,'tail','right','method','approximate');

disp(strcat("Pre learned rank sum: ", num2str(stats2.ranksum)));
disp(strcat("Post learned rank sum: ", num2str(stats.ranksum)));
disp(strcat("Z value: ", num2str(stats2.zval)));
disp(strcat("P value: ", num2str(p)));
disp(strcat("h value: ", num2str(h2)));

%An alpha of p < 0.05 was adopted to establish statistical significance, providing a 5% chance of a false positive error.
%https://www.ztable.net/
end