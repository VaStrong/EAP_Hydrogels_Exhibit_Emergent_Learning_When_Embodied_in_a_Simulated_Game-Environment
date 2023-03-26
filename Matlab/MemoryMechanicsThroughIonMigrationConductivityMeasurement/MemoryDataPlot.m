

figure;
%plot(memoryData(:,1),memoryData(:,2));
hold on
plot((memoryData(2011:end,1)-memoryData(2011,1))/1000,(memoryData(2011:end,3)*-1)+2);
%plot(memoryData(:,1),memoryData(:,4));
hold off
xlabel("Time (s)");
ylabel("Current (mA)");
title("Current Draw Over Time With Select Stimulation");
%legend(["Top" "Middle" "Bottom"]);