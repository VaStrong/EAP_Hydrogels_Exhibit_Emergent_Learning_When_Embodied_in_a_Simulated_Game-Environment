function data = extractAces(table)

length = size(table,1);
data = [];
maxAce = 0;
for i= 1:length
    rally = table{i,3};
    if rally == 0
        maxAce = maxAce + 1;
    end
    if i == length || table{i+1,3} > 0
        time = table{i,1};
        temp = [time, maxAce];
        data = [data;temp];
        maxAce = 0;
    end
end

end