function data = windowAverage(rawData,windowSize)

f = waitbar(0,'Averaging Data');

rawData = sortrows(rawData);

data = [];
length = size(rawData,1);

%fill inital partial window areas
% index = find(rawData>(rawData(1,1)+windowSize), 1, 'first');
% for i = 1:index-1
%     subset = rawData(1:i,:);
%     average = [mean([subset(1,1),subset(end,1)]),mean(subset(:,2)),std(subset(:,2))];
%     data = [data;average];
% end

%fill whole window areas
for i = 1:length
    waitbar(i/length,f,'Averaging Data');
    timestamp = rawData(i,1);
    index = find(rawData>(timestamp+windowSize), 1, 'first');
    if isempty(index)
        break
    end

    subset = rawData(i:index,:);
    stdErr = std(subset(:,2),0,1,"omitnan")./sqrt(size(subset(:,2),1));
    %time, mean, stanard deviation, number of samples, standard error
    average = [mean([subset(1,1),subset(end,1)]),mean(subset(:,2)),std(subset(:,2)),size(subset(:,2),1),stdErr];
    data = [data;average];
end

close(f);

end