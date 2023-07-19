function [ partical_fitness] = fitness_update_delay(partical_fitness,population_size,network_request,index,map_path)
%检查映射方案的时延约束，用链路的长度当做时延，
for i=1:population_size
    if partical_fitness(i,:)~=inf
        if length(map_path{i,1})>network_request{1,9}(index,1)
             partical_fitness(i,:)=inf;
        end
    end
end
end

