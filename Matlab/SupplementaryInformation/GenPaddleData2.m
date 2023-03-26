function PaddleData = GenPaddleData2(CombinedTable,Defults)

f = waitbar(0,'Initalising');
PaddleData = [];
s = size(CombinedTable,2);
if s ~= size(CombinedTable,2)
    disp("not enough defult values in array")
    return
end

for i = 1 : s
    waitbar(i/s,f,'Generating Paddle Location Data');
    currentData = CombinedTable{i};
    temp = paddleTrend(currentData,Defults(i,1),Defults(i,2),Defults(i,3));
    PaddleData = [PaddleData ; temp];
end

waitbar(1,f,'Done');
close(f);
end