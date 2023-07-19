function [partical_fitness] = fitness_update_computing(pso_particles,partical_fitness,network_request,index,population_size)
%FITNESS_UPDATE_COMPUTING 此处显示有关此函数的摘要
%   用来判断生成的粒子映射方案，中除了源节点和端节点以外的节点是否满足计算资源约束，如果不满足，适应度设置为无穷，满足适应度设置为0
global  real_time_computing_resources;
partical_fitness=[];
for i=1:population_size
    for j=2:(network_request{1,3}(index,1)-1)
        if real_time_computing_resources(pso_particles(i,j))<network_request{1,4}(index,j)
            partical_fitness(i,1)=inf;
        end
        partical_fitness(i,1)=0;
    end
end
end

