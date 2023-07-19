function [partical_fitness] = fitness_update_bandwidth(map_path,partical_fitness,network_request,index,population_size)
%用来判断粒子的链路映射方案是否满足链路资源映射条件，不满足，将适应度设置为inf
global real_time_bandwidth_resources;
request_bandwidth_source=network_request{1,5}(index,1);
for i=1:population_size
    if partical_fitness(i,:)~=inf
         test_link_source_path=[];
        test_link_source_path=map_path{i,1};
        for j=1:(length(test_link_source_path)-1)
            if real_time_bandwidth_resources(test_link_source_path(j), test_link_source_path(j+1))<request_bandwidth_source
                partical_fitness(i,:)=inf;
                break;
            end
        end
    end
end
end

