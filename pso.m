function y=pso(index)
global  real_time_computing_resources real_time_bandwidth_resources real_time_task_status network_request UAV_node UAV_lianjie_matrix request_deployment_scheme ;
%% 设置初始参数
population_size=5;
%设置种群数量
maximum_iterations=20;
%设置最大迭代次数
%% 初始化粒子群 每个任务的起始节点与终节点确定了，任务长度也有
pso_particles=[];
for i=1:population_size
         pso_particles(i,:)=generate_particles(index);
         while length(pso_particles(i,:))~=length(unique(pso_particles(i,:)))%这里其实不用做调整，因为本来是用randperm函数就不会生成重复的元素
                 pso_particles(i,:)=generate_particles(index);  
            end
end
%% 初始化速度参数，代表决策变量，是二进制变量，1表示用再次选择，0表示需要从底层节点再次选择
pso_velocity=[];
for i=1:population_size
    pso_velocity(i,:)=generate_velocity(index);
end
%% 计算所有粒子的适应度
%% 计算端节点是否符合资源 不满足条件直接拒绝请求
yuanjiedian_index=network_request{1,2}(index,1);
duanjiedian_index=network_request{1,2}(index,2);
yuanjiedian_keyongziyuan=real_time_computing_resources(yuanjiedian_index);
duanjiedian_keyongziyuan=real_time_computing_resources(duanjiedian_index);
yuanjiedian_qingqiuziyuan=network_request{1,4}(index,1);
duanjiedian_qingqiuziyuan=network_request{1,4}(index,network_request{1,3}(index,1));
if  yuanjiedian_keyongziyuan <yuanjiedian_qingqiuziyuan
    real_time_task_status(index,1)=0;
    return;
end
if  duanjiedian_keyongziyuan<duanjiedian_qingqiuziyuan
    real_time_task_status(index,1)=0;
    return;
end     
%% 判断除了源和端节点以外的映射节点是否满足计算资源约束 如果不满足将该粒子的适应度记为无穷
partical_fitness=[];
for i=1:population_size
    for j=2:(network_request{1,3}(index,1)-1)
        if real_time_computing_resources(pso_particles(i,j))<network_request{1,4}(index,j)
            partical_fitness(i,1)=inf;
        end
        partical_fitness(i,1)=0;
    end
end
%% 用最短路径法为粒子找映射路径
%% 先比较当前粒子的映射方案是否满足连通性,满足连通性，直接将pso_particles添加到映射路径，不满足在下一节为其寻找最短路径
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
%% 为不满足完整路径的粒子，使用粒子群算法为其查找完整路径
for i=1:population_size
     linshi_lujing=[];
    if partical_fitness(i,1)==0
    if map_path_status(i,1)==0
        linshi_lujing=[];
        linshi_lujing=pso_particles(i,1);
        for j=1:(network_request{1,3}(index,1)-1)%共有j条边
            if connectivity_status(i,j)==0
                a=[];
               a=bfs(UAV_lianjie_matrix,pso_particles(i,j),pso_particles(i,j+1));
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
%% 检查带宽资源约束 如果带宽链路上的带宽资源小于请求的带宽资源，适应度设置为无穷
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
%% 检查时延约束，如果总时延超过了要求的时延，拒绝任务，任务时延为方便，设置成路径长度
for i=1:population_size
    if partical_fitness(i,:)~=inf
        if length(map_path{i,1})>network_request{1,9}(index,1)
             partical_fitness(i,:)=inf;
        end
    end
end
%% 对满足要求的粒子，计算其适应度
for i=1:population_size
    if partical_fitness(i,:)~=inf
        partical_fitness(i,:)=(length(map_path{i,1})-1)*request_bandwidth_source;
    end
end
%% 记录全局最优粒子位置和个体粒子最优位置 初试化阶段
best_person_weizhi=[];
best_person_fitness=[];
best_gruop_weizhi=[];
best_gruop_fitness=[];
best_map_path=[];
[best_person_weizhi,best_person_fitness,best_gruop_weizhi,best_gruop_fitness,best_map_path] = intial_best(pso_particles,partical_fitness,population_size,map_path);
%% 完成种群的初试化，下面开始进行迭代，选择最优的映射方案
counter=0;
while counter<maximum_iterations
    %% 对满足约束的粒子进行位置更新、速度跟新,无所谓反正后面还要对不满足条件的粒子进行重新生成
    %% 对速度进行更新
    %% 种群最优与粒子群的减法
      v_3=[];
     [v_3] = update_group_sudu(pso_particles,best_gruop_weizhi,population_size);
    %% 个体最优与粒子群减法
       v_2=[];
      [v_2] = update_person_sudu(pso_particles,best_person_weizhi);
    %% 总的速度更新函数
    [pso_velocity] = update_sudu(pso_velocity,v_2,v_3,population_size,network_request{1,3}(index));
    %% 对位置进行更新,都进行跟新，对于不满足条件的跟新后重新选取和不跟新直接选取没什么区别
    [pso_particles] = update_particle(pso_particles,pso_velocity,population_size,network_request,index,UAV_node);
    %% 对不满足条件的粒子重新生成粒子的位置和速度参数,不但要避免出现重新生成源节点和端节点的情况，还要避免出现多个vnf映射在一个节点上的情况
    for i=1:population_size
        if partical_fitness==inf
            pso_particles(i,:)=generate_particles(index);  
            while length(pso_particles(i,:))~=length(unique(pso_particles(i,:)))
                 pso_particles(i,:)=generate_particles(index);  
            end
            pso_velocity(i,:)=generate_velocity(index);
        end
    end
     %% 计算粒子的适应度，更新种群最优，和个体最优
     %% 判断除了源端节点其余节点的资源约束，返回种群适应度，
     [partical_fitness] = fitness_update_computing(pso_particles,partical_fitness,network_request,index,population_size);
     %% 判断不使用bfs算法生成路径，看原始的粒子映射方案是否有粒子满足映射vnf的节点间可以直接练成一条通路，有满足的添加至路径映射方案map_path
     [connectivity_status,map_path,map_path_status] = judge_direct_link(pso_particles,partical_fitness,population_size,network_request,index);
     %% 为不满足直接连通的粒子方案，使用广度优先搜索算法，为其生成路径映射方案
     map_path_status(map_path_status==1)=0;
     [map_path,map_path_status] = create_mapping_link(connectivity_status,network_request,pso_particles,partical_fitness,map_path_status,population_size,index);
      %% 判断链路带宽资源约束，明早来创建这个函数，返回用来更新fitness，不满足的设置为inf，问题出在上上一步没有跟新connectivity_status，这样有的节点之间就没有使用路径搜索，导致节点不相连
    [partical_fitness] = fitness_update_bandwidth(map_path,partical_fitness,network_request,index,population_size);
      %% 检查时延约束，如果不符合，将适应度设置为inf
      [ partical_fitness] = fitness_update_delay(partical_fitness,population_size,network_request,index,map_path);
      %% 对满足约束的粒子，计算其适应度，即为映射方案占用带宽资源情况
      [partical_fitness] = fitness_update_particle(population_size,partical_fitness,map_path,request_bandwidth_source);
      %% 更新全局最优和个体最优位置和适应度,并记录最优路径
      [best_gruop_weizhi,best_gruop_fitness,best_person_weizhi,best_person_fitness,best_map_path] = update_best(best_gruop_weizhi,best_gruop_fitness,best_person_weizhi,best_person_fitness,population_size,partical_fitness,pso_particles,map_path,best_map_path);
%% 控制迭代次数

counter=counter+1;

end

      %% 返回任务映射方案，返回任务执行状态，更新实时节点容量，更新实时带宽资源,重新求一下最优映射方案的路径
       %   综上已经成功输出了映射方案，如果最优适应度为无穷，那么视作拒绝任务请求，如果适应度不为inf则表示接受该服务请求，

        %% 更新任务状态
        if best_gruop_fitness~=inf
            real_time_task_status(index,1)=1;
          
            request_deployment_scheme{index,1}=best_gruop_weizhi;
              request_deployment_scheme{index,2}=best_map_path;
        else 
            real_time_task_status(index,1)=0;
              request_deployment_scheme{index,1}=[];
              request_deployment_scheme{index,2}=[];
        end
        %% 更新实时计算资源
        if real_time_task_status(index,1)==1
       real_time_computing_resources=resource_computing_update(best_gruop_weizhi,real_time_computing_resources,network_request,index);
        end
        %% 更新实时带宽资源
        if real_time_task_status(index,1)==1
       [real_time_bandwidth_resources] = resource_bandwidth_update(real_time_bandwidth_resources,request_bandwidth_source,best_map_path);
        end
        
        
            
            
       
       
       
       
       
end

