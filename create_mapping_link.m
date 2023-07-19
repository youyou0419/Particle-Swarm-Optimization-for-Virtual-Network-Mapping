function [map_path,map_path_status] = create_mapping_link(connectivity_status,network_request,pso_particles,partical_fitness,map_path_status,population_size,index)
%为生成的粒子映射方案生成链路映射方案，使用广度优先搜索算法
global UAV_lianjie_matrix;
for i=1:population_size
    if partical_fitness(i,1)==0
    if map_path_status(i,1)==0
        linshi_lujing=[];
        linshi_lujing=pso_particles(i,1);
        for j=1:(network_request{1,3}(index,1)-1)%共有j条边
            if connectivity_status(i,j)==0 
                a=[];
               a=bfs(UAV_lianjie_matrix,pso_particles(i,j),pso_particles(i,j+1));
if isempty(a)%之前出现了重新生成粒子的位置时，一个映射方案产生了重复的映射位置，在update_particle已进行更改
    1
end
               a(1)=[];

               linshi_lujing=[linshi_lujing a];
              
            else
               linshi_lujing=[linshi_lujing pso_particles(i,j+1)];
            end
        end  
    end
    end
      map_path{i,1}=linshi_lujing;
      map_path_status(i,1)=1;
end
end

