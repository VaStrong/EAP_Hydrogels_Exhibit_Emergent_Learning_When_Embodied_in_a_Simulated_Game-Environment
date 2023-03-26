function data = extractHits(table,position)

data = [];

length = size(table,1);
counter = 1;
for i= 1:length
    if contains(string(table{i,2}),position)
        data(counter,1) = table{i,1};
        data(counter,2) = min(table{i,3},1);
        counter = counter + 1;
    end
end

end