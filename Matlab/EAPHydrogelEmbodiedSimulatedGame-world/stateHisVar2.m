function stateHisVar2(paddleDataSep2, ballDataSep3, index)
    %index 14
    line = {'--', '-.', ':'};
    positions = 100:20:2000;
    psitionsNum = size(positions,2);
    windowSize = 200;
    
    if index == 0
        listPad = 1:size(paddleDataSep2,2);
        listBal = 1:size(ballDataSep3,2);
    else
        listPad = index;
        listBal = index;
    end
    
    limPad = [];
    uniqListPad = [];
    variationListPad = [];

    %-----------------paddle dataset calculation
    
    for j = listPad
        datasetpad = paddleDataSep2{j};
        T = datasetpad(:,1);
        padPos = datasetpad(:,2);
        for i = 1:psitionsNum
            index1 = find(T>(positions(i)-(windowSize/2)), 1, 'first');
            index2 = find(T>(positions(i)+(windowSize/2)), 1, 'first');
            window = padPos(index1:index2,:);
            if isempty(window)
                continue;
            end
            [GC,GR] = groupcounts(window);
            S = size(GR,1);
            uniqListPad(i,j) = S;
            variationListPad(i,j) = var(GC(GR~=0 & GR~=1000));
            %S = 20;
            limPad = [limPad sum(window(:) == mode(window))];
        end
    
    end
    uniqListPad(uniqListPad==0) = NaN;
    variationListPad(variationListPad==0) = NaN;

    %-----------------ball dataset calculation

    limBal = [];
    uniqListBal = [];
    variationListBal = [];
    
    for j = listBal
        datasetpad = ballDataSep3{j};
        T = datasetpad(:,1);
        balPos = datasetpad(:,2);
        for i = 1:psitionsNum
            index1 = find(T>(positions(i)-(windowSize/2)), 1, 'first');
            index2 = find(T>(positions(i)+(windowSize/2)), 1, 'first');
            window = balPos(index1:index2,:);
            if isempty(window)
                continue;
            end
            [GC,GR] = groupcounts(window);
            S = size(GR,1);
            uniqListBal(i,j) = S;
            variationListBal(i,j) = var(GC(GR~=0 & GR~=1000));
            %S = 20;
            limBal = [limBal sum(window(:) == mode(window))];
        end
    
    end
    uniqListBal(uniqListBal==0) = NaN;
    variationListBal(variationListBal==0) = NaN;

    fig = figure;
    hold on
    alp = 0.2;
    color1 = [0, 0.4470, 0.7410];
    color2 = [0.8500, 0.3250, 0.0980];
    color3 = [0.9290, 0.6940, 0.1250];


    %--------------------------unique states
    dataTot = zeros(size(uniqListPad,1),size(uniqListPad,2));
    for i = 1:size(uniqListPad,2)
        a = min(uniqListPad(:,i));
        b = max(uniqListPad(:,i));
        dataTot(:,i) = ((uniqListPad(:,i)-a)/(b-a));
    end
    uniqListdata = mean(dataTot,2,'omitnan');        
    uniqListErr = std(dataTot,0,2,"omitnan")./sqrt(size(dataTot,2));

    x2 = [positions, fliplr(positions)];
    inBetween = [(uniqListdata-uniqListErr)', fliplr((uniqListdata+uniqListErr)')];
    fill(x2, inBetween,color1,'FaceAlpha',alp,'EdgeColor','none');
    plot(positions,uniqListdata,'-','Color',color1);

    %errorbar(positions,uniqListdata,uniqListErr);
    ylabel("Number of Unique States")
    ylim([0,1])
    
    %-------------------------state variance
    yyaxis right
    dataTot = zeros(size(variationListPad,1),size(variationListPad,2));
    for i = 1:size(variationListPad,2)
        a = min(variationListPad(:,i));
        b = max(variationListPad(:,i));
        dataTot(:,i) = ((variationListPad(:,i)-a)/(b-a));
    end
    variationListData = mean(dataTot,2,'omitnan');
    variationListErr = std(dataTot,0,2,"omitnan")./sqrt(size(dataTot,2));

    x2 = [positions, fliplr(positions)];
    inBetween = [(variationListData-variationListErr)', fliplr((variationListData+variationListErr)')];
    fill(x2, inBetween,color2,'FaceAlpha',alp,'EdgeColor','none');
    plot(positions,variationListData,'-','Color',color2)
    %errorbar(positions,variationListData,variationListErr)

    %ball
    dataTot = zeros(size(variationListBal,1),size(variationListBal,2));
    for i = 1:size(variationListBal,2)
        a = min(variationListBal(:,i));
        b = max(variationListBal(:,i));
        dataTot(:,i) = ((variationListBal(:,i)-a)/(b-a));
    end
    variationListData = mean(dataTot,2,'omitnan');
    variationListErr = std(dataTot,0,2,"omitnan")./sqrt(size(dataTot,2));

    x2 = [positions, fliplr(positions)];
    inBetween = [(variationListData-variationListErr)', fliplr((variationListData+variationListErr)')];
    fill(x2, inBetween,color3,'FaceAlpha',alp,'EdgeColor','none');
    plot(positions,variationListData,'-','Color',color3)


    ylabel("State Frequency Variance")
    ylim([0,1])

    xlabel("Time (s)")
    title({"Mean Normalised Number of Unique Position States and their";"Mean Frequency Variance Over Time For Paddel and Ball"})

    legend('',"Paddle - Number of Unique States",'',"Paddle - State Frequency Variance",'',"Ball - State Frequency Variance")
    %set(fig,'defaultAxesColorOrder',[color1; color2;color2;color2;color2;color2]);
    set(gca, 'YColor','k')

    %xlim([min(positions),max(positions)])
end