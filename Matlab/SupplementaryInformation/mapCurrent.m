function temp = mapCurrent(current,maxC,minC)
    %UNTITLED3 Summary of this function goes here
    %   Detailed explanation goes here
    temp =  ((current - minC) / (maxC-minC));
    if temp > 1
        temp = 1;
    elseif temp < 0
        temp = 0;
    end
end