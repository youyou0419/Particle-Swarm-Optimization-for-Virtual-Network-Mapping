function [pso_particles] = update_particle(pso_particles,pso_velocity,population_size,network_request,index,UAV_node)
%UPDATE_PARTICLE 此处显示有关此函数的摘要
%   此处显示详细说明
    start_node=network_request{1,2}(index,1) ;
    end_node=network_request{1,2}(index,2);
for i=1:population_size
    
    for j=2:(network_request{1,3}(index,1)-1)
        if pso_velocity(i,j)==0
           a=randi([1, UAV_node]);
           while a==end_node||a==start_node
                 a=randi([1, UAV_node]);
           end
           pso_particles(i,j)=a;
        end
    end
        while length(pso_particles(i,:))~=length(unique(pso_particles(i,:)))%如果重新生成的映射方案中出现了重复的位置，那么就再次重新生成，知道所有vnf映射的物理节点都不一样才可以
                for j=2:(network_request{1,3}(index,1)-1)
        if pso_velocity(i,j)==0
           a=randi([1, UAV_node]);
           while a==end_node||a==start_node
                 a=randi([1, UAV_node]);
           end
           pso_particles(i,j)=a;
        end
    end
            end
    
    
end
end
            





