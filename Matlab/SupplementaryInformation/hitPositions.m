function hitPositions(CombinedTablePlus)
    
    s = size(CombinedTablePlus,2);
    if s ~= size(CombinedTablePlus,2)
        disp("not enough defult values in array")
        return
    end

    topHit = 0;
    midHit = 0;
    botHit = 0;

    topMiss = 0;
    midMiss = 0;
    botMiss = 0;

    for i = 1 : s
        hitData = CombinedTablePlus{i};

        topHit = topHit + sum(hitData{:,2} == "top" & hitData{:,3} > 0);
        midHit = midHit + sum(hitData{:,2} == "mid" & hitData{:,3} > 0);
        botHit = botHit + sum(hitData{:,2} == "bot" & hitData{:,3} > 0);

        topMiss = topMiss + sum(hitData{:,2} == "top" & hitData{:,3} == 0);
        midMiss = midMiss + sum(hitData{:,2} == "mid" & hitData{:,3} == 0);
        botMiss = botMiss + sum(hitData{:,2} == "bot" & hitData{:,3} == 0);
    end
    
    lables = ["Top" "Middle" "Bottom"];
    pieHit = [topHit midHit botHit];
    pieMiss = [topMiss midMiss botMiss];
    pieBoth = [topHit+topMiss midHit+midMiss botHit+botMiss];

    figure;
    subplot(3,1,1);
    pie(pieHit);
    title("Distribution of Hits")
    legend(lables);
    subplot(3,1,2);
    pie(pieMiss);
    title("Distribution of Misses")
    subplot(3,1,3);
    pie(pieBoth);
    title("Combined Distribution of Hits and Misses")

    colormap([  0 0 1;
                0 1 0;
                1 0 0;
             ])
end