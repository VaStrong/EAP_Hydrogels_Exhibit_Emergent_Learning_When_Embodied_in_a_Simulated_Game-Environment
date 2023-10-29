function data = extractRallys(table)

length = size(table,1);
data = [];
maxRally = 0;
for i= 1:length
    rally = table{i,3};
    if rally > maxRally
        maxRally = rally;
    end
    if i == length || table{i+1,3} == 0
        time = table{i,1};
        temp = [time, maxRally];
        data = [data;temp];
        maxRally = 0;
    end
end

end