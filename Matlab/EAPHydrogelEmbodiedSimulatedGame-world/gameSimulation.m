function result = gameSimulation(simData, vis)
    %CombinedSimTable = {result};
    global ballPos
    global direction

    f = waitbar(0,'Initalising');
    
    height = 1000;
    width = 1000;
    paddleLength = round(height/3);
    paddleWidth = round(width*0.015);
    paddleOffset = round(width*0.002);
    ballSize = round(height*0.03663793103);

    runtime = 2600;%4200; %run for 1 hour and 10 minuites
    
    score = 0;
    
    paddlePos = 0;
    ballPos = [0, 0];
    direction = [0, 0];
    reset(width, height);
    
    resultTime = [];
    resultPosition = [];
    resultScore = [];
    lastCurrent = [-1000,-1000,-1000];

    if vis
        F = figure;

    end
    
    loopFlag = true;
    scoreFlag = false;
    hitFlag = false;
    time = 0;%seconds
    while time < runtime

        waitbar(time/runtime,f,strcat('Running Pong T:',num2str(time)));

        %move ball with velocity
        ballPos = ballPos + direction;
        
        %Check if the ball is bouncing against any of the 4 walls:
        if ballPos(1) >= width-40 %right wall
            direction(1) = -abs(direction(1));
        elseif ballPos(1) <= 0 %missed by paddle, left wall
            score = 0;
    
            resultTime = [resultTime; time];
            resultPosition = [resultPosition; getVPos(ballPos,height,width,ballSize)];
            resultScore = [resultScore; score];
    
            scoreFlag = true;
            reset(width, height);
        end
        if ballPos(2) > height-40 %bottom wall
            direction(2) = -abs(direction(2));
        elseif ballPos(2) < 0 %top wall
            direction(2) = abs(direction(2));
        end
    
        %Detect collisions between the ball and the paddles
        if rectint([ballPos(1),ballPos(2),ballSize,ballSize],[paddleOffset,paddlePos,paddleWidth,paddleLength]) && ~hitFlag
            hitFlag = true;
            direction(1) = abs(direction(1));
            score = score + 1;
    
            resultTime = [resultTime; time];
            resultPosition = [resultPosition; getVPos(ballPos,height,width,ballSize)];
            resultScore = [resultScore; score];
    
            scoreFlag = true;
         elseif ~rectint([ballPos(1),ballPos(2),ballSize,ballSize],[paddleOffset,paddlePos,paddleWidth,paddleLength]) && hitFlag
            hitFlag = false;
        end
    
        %get region stim
        v = getVPos(ballPos,height,width,ballSize);
        h = getHPos(ballPos,height,width,ballSize);
        %top front, middle back, bottom front, top back, middle front, bottom back, encoded
        stim = zeros(1,6);
        if contains(v,"top")
            if contains(h,"front")
                stim(1) = 1; %top front
            end
            if contains(h,"back")
                stim(4) = 1; %top back
            end
        end
        if contains(v,"mid")
            if contains(h,"front")
                stim(5) = 1; %mid front
            end
            if contains(h,"back")
                stim(2) = 1; %mid back
            end
        end
        if contains(v,"bot")
            if contains(h,"front")
                stim(3) = 1; %bot front
            end
            if contains(h,"back")
                stim(6) = 1; %bot back
            end
        end

        stimEnc = bin2dec(num2str(stim));
        currentData = getCurrent(time, stimEnc, simData, lastCurrent);
        lastCurrent = currentData;
        paddlePos = getPaddlePos(currentData, height);
        if paddlePos > height-paddleLength
            paddlePos = height-paddleLength;
        end
    
        time = time + (1/60); %runs at 60 fps
        %disp(ballPos)

        if vis
            clf;
            title(strcat("Paddle: ", num2str(paddlePos), ", State: ", num2str(stimEnc)));
            line([width/2 width/2],[0 1000],'color','g');
            line([0 1000],[height/3 height/3],'color','g');
            line([0 1000],[2*height/3 2*height/3],'color','g');
            rectangle('Position',[ballPos(1), ballPos(2), ballSize, ballSize],'EdgeColor','r');
            axis([0 width 0 height]);
            hold on
            rectangle('Position',[paddleOffset, paddlePos, paddleWidth, paddleLength],'EdgeColor','b');
            drawnow;

        end
    end
    
    result = table(resultTime,resultPosition,resultScore,'VariableNames',["time","position","score"]);

    waitbar(1,f,'Done');
    close(f);

end

function reset(width, height)
    global ballPos
    global direction
    ballPos = [round(width/2), round(height/2)];
    direction = [randi([4 8]), (randi([1,8])*(2*randi([0,1])-1))];
end

function v = getVPos(pos,height,width,ballSize)
    v = "";
    ball = [pos(1),pos(2),ballSize,ballSize];
    if rectint(ball, [0,0,width,height/3])
        v = strcat(v,"top");
    end
    if rectint(ball, [0,height/3,width,height/3])
        v = strcat(v,"mid");
    end
    if rectint(ball, [0,2*height/3,width,height/3])
        v = strcat(v,"bot");
    end
end

function h = getHPos(pos,height,width,ballSize)
    h = "";
    ball = [pos(1),pos(2),ballSize,ballSize];
    if rectint(ball, [0,0,width/2,height])
        h = strcat(h,"front");
    end
    if rectint(ball, [width/2,0,width/2,height])
        h = strcat(h,"back");
    end

end

function stimTag = stim2tag(stim)
    %generate tag for stumulation
    %   1   2
    %   3   4
    %   5   6
    stimTag = 0;
    if stim(1) == 1 %1 - front top
        stimTag = stimTag + 1;
    end
    if stim(2) == 1 %4 - back middle
        stimTag = stimTag + 2;
    end
    if stim(3) == 1 %5 - front bottom
        stimTag = stimTag + 4;
    end
    if stim(4) == 1 %2 - back top
        stimTag = stimTag + 8;
    end
    if stim(5) == 1 %3 - front middle
        stimTag = stimTag + 16;
    end
    if stim(6) == 1 %6 - back bottom
        stimTag = stimTag + 32;
    end
end

function pos = getPaddlePos(currentData, height)%origTop origMid origBot

    xData = [height/6, (3*height)/6, (5*height)/6];

    curTop =  currentData(1);%black
    curMid =  currentData(2);%brown
    curBot =  currentData(3);%red
    
    % <-------------- this is where the current inputs can be swapped
    if 0 % randomly swap
        poss = [curTop, curMid, curBot;
                curTop, curBot, curMid;
                curMid, curTop, curBot;
                curMid, curBot, curTop;
                curBot, curMid, curTop;
                curBot, curTop, curMid];
        yData = poss(randi([1,6]),:);
    elseif 0 % all swapped main
        yData = [curMid, curBot, curTop];
    elseif 1 % all swapped secondary
        yData = [curBot, curTop, curMid];
    else % original
        yData = [curTop, curMid, curBot];
    end

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

% function currentData = getCurrent(time, stim, simData, lastCurrent)% Rev 1
%     avgChange = [0.0738, 0.0780, 0.0773];
%     window = 600;%seconds 1000 (time to go roound edge), 600 (smoothing window)
%     tmp1 = simData(simData(:,2)==stim,:);
%     tmp2 = tmp1( (tmp1(:,1)<(time+window/2) & tmp1(:,1)>(time-window/2)) ,:);
%     length = size(tmp2,1);
%     if (length == 0)
%         [ d, ix ] = min( abs( tmp1(:,1)-time ) );
%         currentData = tmp1(ix, [3,4,5]);
%     else
%         if lastCurrent(1) == -1000
%             currentData = tmp2(randi([1, length]), [3,4,5]);
%         else
%             counter = 0;
%             while 1
%                 currentData = tmp2(randi([1, length]), [3,4,5]);
%                 counter = counter+1;
%                 if prod(abs(currentData - lastCurrent) < avgChange, "all") || counter < 100
%                     break
%                 end
%             end
%         end
%     end
% end

% function currentData = getCurrent(time, stim, simData, lastCurrent)% Rev 2
%     avgChange = [0.0738, 0.0780, 0.0773];
%     window = 600;%seconds 1000 (time to go roound edge), 600 (smoothing window)
%     tmp1 = simData(simData(:,2)==stim,:);
%     [ d, ix ] = min( abs( tmp1(:,1)-time ) );
%     currentData = tmp1(ix, [3,4,5]);
% end

function currentData = getCurrent(time, stim, simData, lastCurrent)% Rev 3
    window = 600;%seconds 1000 (time to go roound edge), 600 (smoothing window)
    tmp1 = simData(simData(:,2)==stim,:);
    tmp2 = tmp1( (tmp1(:,1)<(time+window/2) & tmp1(:,1)>(time-window/2)) ,:);
    length = size(tmp2,1);
    if (length == 0)
        [ d, ix ] = min( abs( tmp1(:,1)-time ) );
        currentData = tmp1(ix, [3,4,5]);
    else
        m = mean(tmp2,1);
        currentData = m(:, [3,4,5]);
    end
end