function stateHistogrames(paddleDataSep2, index)
    %index 14
    positions = 200:200:2000;
    psitionsNum = size(positions,2);
    windowSize = 300;
    
    if index == 0
        list = 1:size(paddleDataSep2,2);
    else
        list = index;
    end
    
    figure;
    lim = [];
    uniqList = [];
    variationList = [];

    minState = paddleDataSep2{1}(1,2);
    maxState = paddleDataSep2{1}(1,2);
    
    for j = list
        %figure;
        dataset = paddleDataSep2{j};
        T = dataset(:,1);
        padPos = dataset(:,2);
        minState = min(minState,min(padPos));
        maxState = max(maxState,max(padPos));
        for i = 1:psitionsNum
            subplot(round(psitionsNum/5),round(psitionsNum/2),i);
            index1 = find(T>(positions(i)-(windowSize/2)), 1, 'first');
            index2 = find(T>(positions(i)+(windowSize/2)), 1, 'first');
            window = padPos(index1:index2,:);
            if isempty(window)
                continue;
            end
            [GC,GR] = groupcounts(window);
            S = size(GR,1);
            uniqList(i,j) = S;
            variationList(i,j) = var(GC(GR~=0 & GR~=1000));
            %S = 20;
            lim = [lim sum(window(:) == mode(window))];
            hold on
            histogram(window,S,'EdgeAlpha',0,'FaceAlpha',0.08,'FaceColor','r','Normalization','probability');
            hold off
        end
    
    end
    for i = 1:psitionsNum
        subplot(round(psitionsNum/5),round(psitionsNum/2),i);
        ylim([0 0.1]); %paddle
        %ylim([0 0.35]); %ball
        ylabel("Probability")%"Number of Paddle Position State Occurrences")
        xlabel("Ball Position States ")
        title(strcat("t ="," ", num2str(positions(i))))
%         title({ strcat("t ="," ", num2str(positions(i))) ; ...
%             strcat("Mean Unique States ="," ",num2str(round(mean(uniqList(i,:))))) ; ...
%             strcat("Mean State Varience ="," ",num2str(mean(variationList(i,:))))});
        xlim([minState maxState]);
    end
end