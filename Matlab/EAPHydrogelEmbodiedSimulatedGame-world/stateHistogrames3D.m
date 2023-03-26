function stateHistogrames3D(paddleDataSep2, index)
    %index 14
    positions = 100:20:2000;
    psitionsNum = size(positions,2);
    windowSize = 200;
    
    if index == 0
        list = 1:size(paddleDataSep2,2);
    else
        list = index;
    end
    
    uniqList = [];

    for j = list
        dataset = paddleDataSep2{j};
        padPos = dataset(:,2);
        uniqList = [uniqList;unique(padPos)];
    end
    uniqList = unique(uniqList);
    uniqList = uniqList(uniqList~=0 & uniqList~=1000);
    
    data = [];
    for i = 1:psitionsNum
        dataInt = [];
        for j = list
            dataset = paddleDataSep2{j};
            T = dataset(:,1);
            padPos = dataset(:,2);
            index1 = find(T>(positions(i)-(windowSize/2)), 1, 'first');
            index2 = find(T>(positions(i)+(windowSize/2)), 1, 'first');
            window = padPos(index1:index2,:);
            for n = 1:size(uniqList,1)
                dataInt(n,j) = sum(window == uniqList(n))/size(padPos,1);
            end
        end
        data = [data, mean(dataInt,2)];
    end

    figure;
    colormap('turbo')
    %data = smoothdata(data,1,'movmedian',5);
    pcolor(positions,uniqList,data);
    %surf(positions,uniqList,data);
    shading interp

    hcb = colorbar;
    colorTitleHandle = get(hcb,'Title');
    titleString = {'Probability';''};
    set(colorTitleHandle ,'String',titleString);

    ylabel("Paddle Position States (pixels)")%"Number of Paddle Position State Occurrences")
    xlabel("Time (seconds)")
    title({'Mean Distribution of Paddle States';'Between Samples Over Time'})

    curtick = get(gca, 'yTick');
    yticks(unique(round(curtick)));


end