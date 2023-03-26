function paddleTracking(allData)
    window = 600;
    timeCutoff = 2000;%1800; %3500;
    peakLeanring = 1519;
    
    allData1 = allData(allData(:,3)==1,:);
    allData2 = allData(allData(:,3)==2,:);
    allData3 = allData(allData(:,3)==4,:);
    allData4 = allData(allData(:,3)==8,:);
    allData5 = allData(allData(:,3)==16,:);
    allData6 = allData(allData(:,3)==32,:);


%     figure;
%     scatter(allData2(:,1),allData2(:,2),'.')
%     xlabel("Time (s)");
%     ylabel("Paddle Position (pixle)");
%     set(gca, 'YDir','reverse');
%     xlim([0 timeCutoff]);
%     return;
    
    data1 = windowAverage(allData1,window);
    data2 = windowAverage(allData2,window);
    data3 = windowAverage(allData3,window);
    data4 = windowAverage(allData4,window);
    data5 = windowAverage(allData5,window);
    data6 = windowAverage(allData6,window);
    
    figure;
%     plot(data1(:,1),data1(:,2))
%     hold on
%     plot(data2(:,1),data2(:,2))
%     plot(data3(:,1),data3(:,2))
%     plot(data4(:,1),data4(:,2))
%     plot(data5(:,1),data5(:,2))
%     plot(data6(:,1),data6(:,2))

    hold on
    colors = colororder;
    plotStdErr(data1,colors(1,:))
    plotStdErr(data2,colors(2,:))
    plotStdErr(data3,colors(3,:))
    plotStdErr(data4,colors(4,:))
    plotStdErr(data5,colors(5,:))
    plotStdErr(data6,colors(6,:))

    %xline(peakLeanring,'-.','color','#7E2F8E');%peak learning
    %xline(2000,'-.','color','#D95319');
    hold off

    xlabel("Time (s)");
    ylabel("Paddle Position (pixle)");
    title(["Paddle Position Over Time,", strcat('with a',{' '},num2str(window),' Second Window')]);
    legend(["" "Front Top" "" "Back Middle" "" "Front Bottom" "" "Back Top" "" "Front Middle" "" "Back Bottom"]);
    set(gca, 'YDir','reverse');
    xlim([0 timeCutoff]);

    figure;
    plot(data1(:,1),data1(:,3))
    hold on
    plot(data2(:,1),data2(:,3))
    plot(data3(:,1),data3(:,3))
    plot(data4(:,1),data4(:,3))
    plot(data5(:,1),data5(:,3))
    plot(data6(:,1),data6(:,3))

    ti1 = find(data1(:,1)>=timeCutoff,1,'first');
    ti2 = find(data2(:,1)>=timeCutoff,1,'first');
    ti3 = find(data3(:,1)>=timeCutoff,1,'first');
    ti4 = find(data4(:,1)>=timeCutoff,1,'first');
    ti5 = find(data5(:,1)>=timeCutoff,1,'first');
    ti6 = find(data6(:,1)>=timeCutoff,1,'first');

    [m1,i1] = min(data1(1:ti1,3));
    scatter(data1(i1,1),data1(i1,3),100,'k.');
    [m2,i2] = min(data2(1:ti2,3));
    scatter(data2(i2,1),data2(i2,3),100,'k.');
    [m3,i3] = min(data3(1:ti3,3));
    scatter(data3(i3,1),data3(i3,3),100,'k.');
    [m4,i4] = min(data4(1:ti4,3));
    scatter(data4(i4,1),data4(i4,3),100,'k.');
    [m5,i5] = min(data5(1:ti5,3));
    scatter(data5(i5,1),data5(i5,3),100,'k.');
    [m6,i6] = min(data6(1:ti6,3));
    scatter(data6(i6,1),data6(i6,3),100,'k.');

    xline(mean([data1(i1,1) data2(i2,1) data3(i3,1) data4(i4,1) data5(i5,1) data6(i6,1)]),'-.','color','#7E2F8E');%peak learning
    %xline(2000,'-.','color','#D95319');
    hold off

    xlabel("Time (s)");
    ylabel("Standard Deviation (pixles)");
    title(["Standard Deviation Over Time,", strcat('with a',{' '},num2str(window),' Second Window')]);
    legend(["Front Top" "Back Middle" "Front Bottom" "Back Top" "Front Middle" "Back Bottom"]);
    xlim([0 timeCutoff]);

end

function plotStdErr(dataWindowed,color)
    alp = 0.2;
    positions = dataWindowed(:,1);
    data = dataWindowed(:,2);
    error = dataWindowed(:,5);
    x2 = [positions', fliplr(positions')];
    inBetween = [(data-error)', fliplr((data+error)')];
    fill(x2, inBetween,color,'FaceAlpha',alp,'EdgeColor','none');
    plot(positions,data,'-','Color',color)
    disp(max(error));
end