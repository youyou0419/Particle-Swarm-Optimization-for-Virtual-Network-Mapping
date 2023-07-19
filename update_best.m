function [best_gruop_weizhi,best_gruop_fitness,best_person_weizhi,best_person_fitness,best_map_path] = update_best(best_gruop_weizhi,best_gruop_fitness,best_person_weizhi,best_person_fitness,population_size,partical_fitness,pso_particles,map_path,best_map_path)
%适应度跟新全局最优粒子和全局最优适应度，个体最优粒子群和个体最优适应度

%% 更新最优全局位置和适应度
for i=1:population_size
    if partical_fitness(i,1)<best_gruop_fitness
        best_gruop_fitness=partical_fitness(i,1);
        best_gruop_weizhi=pso_particles(i,:);
        best_map_path=map_path{i,:};
    end
end
%% 更新最优适应度个体位置和适应度
for i=1:population_size
    if partical_fitness(i,1)<best_person_fitness(i,1)
        best_person_fitness(i,1)=partical_fitness(i,1);
        best_person_weizhi(i,:)=pso_particles(i,:);
    end
end





end

