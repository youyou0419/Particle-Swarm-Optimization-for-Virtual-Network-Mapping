function [connectivity_status,map_path,map_path_status] = judge_direct_link(pso_particles,partical_fitness,population_size,network_request,index)
%connectivity_status很重要，因为如果嵌入了vnf的节点直接相连，那么就不能使用最短路径进行搜索了，问题出在这里
%   判断当前的映射方案中，不使用搜索路径算法，在所有映射了vnf的节点是否可以满足流量守恒，如果满足则将其添加到map_path中
map_path={};
map_path_status=[];%1表示粒子已经有了路径映射方案，0表示粒子还未有路径映射方案
connectivity_status=[];
for i=1:population_size%选中一个粒子
    if partical_fitness(i,1)==0%映射方案的节点满足资源约束
       for j=1:(network_request{1,3}(index,1)-1)%共有j条边
           connectivity_status(i,j)=check_connection(pso_particles(i,j),pso_particles(i,j+1));
       end
       if all(connectivity_status(i,:) == 1)%如果有满足条件的直接作为映射链路
           map_path{i,1}=pso_particles(i,:);
           map_path_status(i,1)=1;
       else
           map_path_status(i,1)=0;
       end
    
    end
end
end

