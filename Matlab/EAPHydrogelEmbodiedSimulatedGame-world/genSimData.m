function simData = genSimData(CombinedCurrentPlus,defults)
    %using "current_data_mutual_info_3.mat" "CombinedCurrentPlus" and "Defults"
    f = waitbar(0,'Initalising');
    simData = [];
    s = size(CombinedCurrentPlus,2);
    if s ~= size(CombinedCurrentPlus,2)
        disp("not enough defult values in array")
        return
    end
    for i = 1 : s
        waitbar(i/s,f,'Generating Paddle Current Data');
        currentData = CombinedCurrentPlus{i};
        length = size(currentData,1);
        stims = currentData(:,[1,2,3,4,5,6]);
        stims(stims==-1)=1;
        stims = bin2dec(num2str(stims));
        
        upRangeC = 3;%0.75
        lowRangeC = 0.75;%3
        curTop =  mapCurrent(currentData(:, 7), defults(i,1) + upRangeC, defults(i,1) - lowRangeC);%black
        curMid =  mapCurrent(currentData(:, 8), defults(i,2) + upRangeC, defults(i,2) - lowRangeC);%brown
        curBot =  mapCurrent(currentData(:, 9), defults(i,3) + upRangeC, defults(i,3) - lowRangeC);%red

        %temp = [currentData(:, 10)/1000, stims, currentData(:, [7,8,9]), ones(length,1)*defults(i,1), ones(length,1)*defults(i,2), ones(length,1)*defults(i,3)];
        temp = [currentData(:, 10)/1000, stims, curTop, curMid, curBot, ones(length,1)*i];

        simData = [simData ; temp];
    end
    
%     s = size(simData,1);
%     for i = 1 : s
%         waitbar(i/s,f,'Generating Paddle Location Data');
%         simData(i,7) = getPaddlePos(simData(i,[3,4,5]), 1000);
%     end

    simData = sortrows(simData,1);
    simData = sortrows(simData,2);
    
    waitbar(1,f,'Done');
    close(f);

end

function pos = getPaddlePos(currentData, height)%origTop origMid origBot

    xData = [height/6, (3*height)/6, (5*height)/6];

    curTop =  currentData(1);%black
    curMid =  currentData(2);%brown
    curBot =  currentData(3);%red
    
    yData = [curTop, curMid, curBot];

    ft = fittype( 'a*x^2+b*x+c', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = [0 0 0]; %[10 0.01 100];
    fitresult = fit( xData', yData', ft, opts );
    fitDataX = 0:1:1000;
    fitDataY = fitresult(fitDataX);
    [M,I] = max(fitDataY);
    pos = I;
end