function paddleRandDistPlot(paddleRandomDist)
lables = ["Top" "Middle" "Bottom"];
c = '#D95319';

figure
t = tiledlayout(1,1);
ax1 = axes(t);

nBins = size(unique(paddleRandomDist(:,1)),1);
histogram(paddleRandomDist(:,1),nBins,'EdgeAlpha',0,'Normalization','probability','EdgeAlpha',0.5);
ylabel("Probability")
ylim([0,0.006]);
xlabel("Y Coordinate (pixels)")
%ax1.YScale = 'log';

ax2 = axes(t);

histogram(paddleRandomDist(:,2),'Normalization','probability','FaceColor',c,'EdgeAlpha',0,'FaceAlpha',0.3);

ax2.XAxisLocation = 'top';
ax2.YAxisLocation = 'right';

ylabel("Probability")
xlabel("Vertical Regions")
ylim([0,0.4]);
%ax2 = axes('Position',[0.1 0.1 0.8 0.001],'Color','none');
%ax2.XTick = lables;
L = ax2.XLim;
ax2.XTick = linspace(L(1),L(2),length(lables)+2);
xticklabels(["",lables]);

ax2.Color = 'none';
ax2.XColor = c;
ax2.YColor = c;
ax1.Box = 'off';
ax2.Box = 'off';

%title({"Distribution of Paddle";"in Regions with Random Motion"})
title({"Distribution of Paddle Position as Pixels and";"Regions, with Random Current Driven Motion"})

end