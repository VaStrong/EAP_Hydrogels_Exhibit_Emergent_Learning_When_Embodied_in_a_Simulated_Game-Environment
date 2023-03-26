function ballDistPlotterRatio(ballDist_Paddle_Ratio, ind)

lables = ["Top" "Middle" "Bottom"];
c = '#D95319';

figure
t = tiledlayout(1,1);
ax1 = axes(t);

histogram(ballDist_Paddle_Ratio(:,2),'Normalization','probability','EdgeAlpha',0.5);
ylabel("Probability")
if ind == 3
    ylim([0,0.015]);
else
    ylim([0,0.025]);
end
xlabel("Y Coordinate (pixels)")

ax2 = axes(t);

histogram(ballDist_Paddle_Ratio(:,5),'Normalization','probability','FaceColor',c,'EdgeAlpha',0,'FaceAlpha',0.3);

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

if ind == 1
    title({"Distribution of Ball Position as Pixels and Regions,";"Where Paddle Never Misses"})
elseif ind == 2
    title({"Distribution of Ball Position as Pixels and Regions,";"Where Paddle Always Misses"})
elseif ind == 3
    title({"Distribution of Ball Position as Pixels and Regions,";"with Paddle at Maximum Learning Hit/Miss Ratio"})
end

disp("variance in position:")
[GC,GR] = groupcounts(ballDist_Paddle_Ratio(:,2));
disp(var(GC))
disp("variance in region:")
[GC,GR] = groupcounts(ballDist_Paddle_Ratio(:,5));
disp(var(GC))

end