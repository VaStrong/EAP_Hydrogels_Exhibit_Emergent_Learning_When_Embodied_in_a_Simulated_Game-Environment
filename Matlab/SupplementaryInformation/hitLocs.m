function hitLocs(CombinedTable)

    allData = CombinedTable{1};
    allData = [allData;CombinedTable{2}];
    allData = [allData;CombinedTable{3}];
    allData = [allData;CombinedTable{4}];
    allData = [allData;CombinedTable{5}];
    allData = [allData;CombinedTable{6}];
    allData = [allData;CombinedTable{7}];
    allData = [allData;CombinedTable{8}];
    allData = [allData;CombinedTable{9}];
    allData = [allData;CombinedTable{10}];
    allData = [allData;CombinedTable{11}];

    allData = sortrows(allData,1);

    topHits = allData(allData{:,2}=="top",:);
    topHits(:,4) = array2table((1:height(topHits))');
    midHits = allData(allData{:,2}=="mid",:);
    midHits(:,4) = array2table((1:height(midHits))');
    botHits = allData(allData{:,2}=="bot",:);
    botHits(:,4) = array2table((1:height(botHits))');
    topMidHits = allData(allData{:,2}=="topmid",:);
    topMidHits(:,4) = array2table((1:height(topMidHits))');
    botMidHits = allData(allData{:,2}=="midbot",:);
    botMidHits(:,4) = array2table((1:height(botMidHits))');


    figure;
    plot(topHits{:,1},topHits{:,4})
    topFreq= polyfit(topHits{:,1},topHits{:,4},1);
    hold on
    plot(midHits{:,1},midHits{:,4})
    midFreq = polyfit(midHits{:,1},midHits{:,4},1);
    plot(botHits{:,1},botHits{:,4})
    botFreq = polyfit(botHits{:,1},botHits{:,4},1);
    plot(topMidHits{:,1},topMidHits{:,4})
    topMidFreq = polyfit(topMidHits{:,1},topMidHits{:,4},1);
    plot(botMidHits{:,1},botMidHits{:,4})
    botMidFreq = polyfit(botMidHits{:,1},botMidHits{:,4},1);
    hold off
    xlabel("Time (s)");
    ylabel("Cumulative Number of Ball Hits");
    title("Ball Hit Position Over Time");
    perc = '%.2f';
    legend([strcat("Top - Frequency ",num2str(topFreq(1),perc)) ...
        strcat("Middle - Frequency ",num2str(midFreq(1),perc)) ...
        strcat("Bottom - Frequency ",num2str(botFreq(1),perc)) ...
        strcat("Top Middle - Frequency ",num2str(topMidFreq(1),perc)) ...
        strcat("Bottom Middle - Frequency ",num2str(botMidFreq(1),perc)) ...
        ], 'location', 'northwest');
    xlim([0 max(allData{:,1})+100]);
    xlim([0 3500]);


end