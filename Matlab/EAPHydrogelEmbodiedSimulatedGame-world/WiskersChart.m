function WiskersChart(CombinedTablePlus, CombinedBaseTable, CombinedSimTable, CombinedBaseTableBlind)

%% rally lengths
disp("---------- Rally Lengths Unaveraged ----------");
disp("Unalalterd Feedback");
OutputRallyNorm = rallyTrendTtest(CombinedTablePlus,0);
disp("Impared Paddle");
OutputRallyBase = rallyTrendTtest(CombinedBaseTable,0);
disp("Impared Vision");
OutputRallySim = rallyTrendTtest(CombinedSimTable,0);
disp("Severed Vision");
OutputRallyBlind = rallyTrendTtest(CombinedBaseTableBlind,0);
disp("");
disp("");

disp("---------- Rally Lengths Averaged ----------");
disp("Unalalterd Feedback");
OutputRallyNormAverage = rallyTrendTtest(CombinedTablePlus,1);
disp("Impared Paddle");
OutputRallyBaseAverage = rallyTrendTtest(CombinedBaseTable,1);
disp("Impared Vision");
OutputRallySimAverage = rallyTrendTtest(CombinedSimTable,1);
disp("Severed Vision");
OutputRallyBlindAverage = rallyTrendTtest(CombinedBaseTableBlind,1);
disp("");
disp("");

%% Aces
disp("---------- Rally Aces Unaveraged ----------");
disp("Unalalterd Feedback");
OutputAcesNorm = acesTrendTtest(CombinedTablePlus,0);
disp("Impared Paddle");
OutputAcesBase = acesTrendTtest(CombinedBaseTable,0);
disp("Impared Vision");
OutputAcesSim = acesTrendTtest(CombinedSimTable,0);
disp("Severed Vision");
OutputAcesBlind = acesTrendTtest(CombinedBaseTableBlind,0);
disp("");
disp("");

disp("---------- Rally Aces Averaged ----------");
disp("Unalalterd Feedback");
OutputAcesNormAverage = acesTrendTtest(CombinedTablePlus,1);
disp("Impared Paddle");
OutputAcesBaseAverage = acesTrendTtest(CombinedBaseTable,1);
disp("Impared Vision");
OutputAcesSimAverage = acesTrendTtest(CombinedSimTable,1);
disp("Severed Vision");
OutputAcesBlindAverage = acesTrendTtest(CombinedBaseTableBlind,1);
disp("");
disp("");

%% figure

lab1 = {'Unaltered';'Feedback'};
lab2 = {'Impaired';' Sensing'};
lab3 = {'Impaired';'   Stim'};
lab4 = {'Severed';'   Stim'};
lables = {sprintf('%s\\newline%s',lab1{:}), sprintf('%s\\newline%s',lab2{:}), sprintf('%s\\newline%s',lab3{:}), sprintf('%s\\newline%s',lab4{:})};

fontSize = 8;
sizeOffset = 0.02;
size = [0.1 0.25-sizeOffset*2 0.74];

figure;
sgtitle('Comparison of Pre and Post Leanred Across Experimental Setups')

%% rally lengths unaveraged

subplot('Position',[0+sizeOffset size]);
dataARally = [OutputRallyNorm.setA; OutputRallyNorm.setB;
        OutputRallyBase.setA; OutputRallyBase.setB;
        OutputRallySim.setA; OutputRallySim.setB;
        OutputRallyBlind.setA; OutputRallyBlind.setB
        ];
dataBRally = [zeros(length(OutputRallyNorm.setA), 1); ones(length(OutputRallyNorm.setB), 1); 
        2*ones(length(OutputRallyBase.setA), 1); 3*ones(length(OutputRallyBase.setB), 1);
        4*ones(length(OutputRallySim.setA), 1); 5*ones(length(OutputRallySim.setB), 1);
        6*ones(length(OutputRallyBlind.setA), 1); 7*ones(length(OutputRallyBlind.setB), 1);
        ];
boxplot(dataARally,dataBRally,'Symbol','');
title({'Rally Lengths Unaveraged'});
ylabel('Rally Lengths');
ylim([-0.5,12])
yticks(0:1:12)

ax = gca;
ax.XTick = [1.5 3.5 5.5 7.5];
ax.TickLabelInterpreter = 'tex';
ax.XTickLabel = lables;
ax.XTickLabelRotation = 0;
ax.XAxis.FontSize = fontSize;

%set colors for pre learned and post learned
h = findobj(gca,'Tag','Box');
boxColor = [0.4667, 0.6745, 0.1882;
            0.8510, 0.3255, 0.0980];
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),boxColor(mod(j,2)+1,:),'FaceAlpha',.5);
end

legend('Learned', 'Unlearned');

%% rally lengths averaged

subplot('Position',[0.25+sizeOffset size]);
dataARally = [OutputRallyNormAverage.setA; OutputRallyNormAverage.setB;
        OutputRallyBaseAverage.setA; OutputRallyBaseAverage.setB;
        OutputRallySimAverage.setA; OutputRallySimAverage.setB;
        OutputRallyBlindAverage.setA; OutputRallyBlindAverage.setB
        ];
dataBRally = [zeros(length(OutputRallyNormAverage.setA), 1); ones(length(OutputRallyNormAverage.setB), 1); 
        2*ones(length(OutputRallyBaseAverage.setA), 1); 3*ones(length(OutputRallyBaseAverage.setB), 1);
        4*ones(length(OutputRallySimAverage.setA), 1); 5*ones(length(OutputRallySimAverage.setB), 1);
        6*ones(length(OutputRallyBlindAverage.setA), 1); 7*ones(length(OutputRallyBlindAverage.setB), 1);
        ];
boxplot(dataARally,dataBRally,'Symbol','');
title({'Rally Lengths Averaged' ; 'Using a 600 Second Window'});
ylabel('Rally Lengths');
ylim([-0.5,5.5])
yticks(0:1:6)

ax = gca;
ax.XTick = [1.5 3.5 5.5 7.5];
ax.TickLabelInterpreter = 'tex';
ax.XTickLabel = lables;
ax.XTickLabelRotation = 0;
ax.XAxis.FontSize = fontSize;

%set colors for pre learned and post learned
h = findobj(gca,'Tag','Box');
boxColor = [0.4667, 0.6745, 0.1882;
            0.8510, 0.3255, 0.0980];
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),boxColor(mod(j,2)+1,:),'FaceAlpha',.5);
end

legend('Learned', 'Unlearned');

%% rally aces unaveraged

subplot('Position',[0.5+sizeOffset size]);
dataAAces = [OutputAcesNorm.setA; OutputAcesNorm.setB;
        OutputAcesBase.setA; OutputAcesBase.setB;
        OutputAcesSim.setA; OutputAcesSim.setB;
        OutputAcesBlind.setA; OutputAcesBlind.setB
        ];
dataBAces = [zeros(length(OutputAcesNorm.setA), 1); ones(length(OutputAcesNorm.setB), 1); 
        2*ones(length(OutputAcesBase.setA), 1); 3*ones(length(OutputAcesBase.setB), 1);
        4*ones(length(OutputAcesSim.setA), 1); 5*ones(length(OutputAcesSim.setB), 1);
        6*ones(length(OutputAcesBlind.setA), 1); 7*ones(length(OutputAcesBlind.setB), 1);
        ];
boxplot(dataAAces,dataBAces,'Symbol','');
title({'Rally Aces Unaveraged'});
%xlabel('Experiment');
ylabel('Aces Lengths');
ylim([-0.5,20])
yticks(0:1:20)

ax = gca;
ax.XTick = [1.5 3.5 5.5 7.5];
ax.TickLabelInterpreter = 'tex';
ax.XTickLabel = lables;
ax.XTickLabelRotation = 0;
ax.XAxis.FontSize = fontSize;


%set colors for pre learned and post learned
h = findobj(gca,'Tag','Box');
boxColor = [0.4667, 0.6745, 0.1882;
            0.8510, 0.3255, 0.0980];
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),boxColor(mod(j,2)+1,:),'FaceAlpha',.5);
end

legend('Unlearned', 'Learned');

%% rally aces averaged

subplot('Position',[0.75+sizeOffset size]);
dataAAces = [OutputAcesNormAverage.setA; OutputAcesNormAverage.setB;
        OutputAcesBaseAverage.setA; OutputAcesBaseAverage.setB;
        OutputAcesSimAverage.setA; OutputAcesSimAverage.setB;
        OutputAcesBlindAverage.setA; OutputAcesBlindAverage.setB
        ];
dataBAces = [zeros(length(OutputAcesNormAverage.setA), 1); ones(length(OutputAcesNormAverage.setB), 1); 
        2*ones(length(OutputAcesBaseAverage.setA), 1); 3*ones(length(OutputAcesBaseAverage.setB), 1);
        4*ones(length(OutputAcesSimAverage.setA), 1); 5*ones(length(OutputAcesSimAverage.setB), 1);
        6*ones(length(OutputAcesBlindAverage.setA), 1); 7*ones(length(OutputAcesBlindAverage.setB), 1);
        ];
boxplot(dataAAces,dataBAces,'Symbol','');
title({'Rally Aces Averaged' ; 'Using a 600 Second Window'});
%xlabel('Experiment');
ylabel('Aces Lengths');
ylim([-0.5,8])
yticks(0:1:8)

ax = gca;
ax.XTick = [1.5 3.5 5.5 7.5];
ax.TickLabelInterpreter = 'tex';
ax.XTickLabel = lables;
ax.XTickLabelRotation = 0;
ax.XAxis.FontSize = fontSize;


%set colors for pre learned and post learned
h = findobj(gca,'Tag','Box');
boxColor = [0.4667, 0.6745, 0.1882;
            0.8510, 0.3255, 0.0980];
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),boxColor(mod(j,2)+1,:),'FaceAlpha',.5);
end

legend('Unlearned', 'Learned');

end