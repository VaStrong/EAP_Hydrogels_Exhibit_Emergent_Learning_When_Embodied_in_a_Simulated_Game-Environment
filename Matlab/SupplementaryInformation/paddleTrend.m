function allData = paddleTrend(currentData,origTop,origMid,origBot)
f = waitbar(0,'Initalising');
%origTop = 0.89; %black
%origMid = 0.69; %brown
%origBot = 0.47; %red
upRangeC = 3;%0.75
lowRangeC = 0.75;%3
feildSize = 1000;

xData = [feildSize/6, (3*feildSize)/6, (5*feildSize)/6];

length = size(currentData,1);
for i = 1 : length
    waitbar(i/length,f,'Calculating Paddle Positions');

    curTop =  mapCurrent(currentData(i,7), origTop + upRangeC, origTop - lowRangeC);%black
    curMid =  mapCurrent(currentData(i,8), origMid + upRangeC, origMid - lowRangeC);%brown
    curBot =  mapCurrent(currentData(i,9), origBot + upRangeC, origBot - lowRangeC);%red

    yData = [curTop, curMid, curBot];

    ft = fittype( 'a*x^2+b*x+c', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = [0 0 0]; %[10 0.01 100];
    fitresult = fit( xData', yData', ft, opts );
    fitDataX = 0:1:1000;
    fitDataY = fitresult(fitDataX);
    [M,I] = max(fitDataY);

    %generate tag for stumulation
    %   1   2
    %   3   4
    %   5   6
    stimTag = 0;
    if currentData(i,1) == -1 %1 - front top
        stimTag = stimTag + 1;
    end
    if currentData(i,2) == -1 %4 - back middle
        stimTag = stimTag + 2;
    end
    if currentData(i,3) == -1 %5 - front bottom
        stimTag = stimTag + 4;
    end
    if currentData(i,4) == -1 %2 - back top
        stimTag = stimTag + 8;
    end
    if currentData(i,5) == -1 %3 - front middle
        stimTag = stimTag + 16;
    end
    if currentData(i,6) == -1 %6 - back bottom
        stimTag = stimTag + 32;
    end


    allData(i,1) = currentData(i,10)/1000;
    allData(i,2) = fitDataX(I);
    allData(i,3) = stimTag;

end

waitbar(1,f,'Done');
close(f);

end