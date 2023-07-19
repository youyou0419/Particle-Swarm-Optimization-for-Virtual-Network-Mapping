%% 写函数必备四行代码
clear;
%用来清空工作区内存
clc;
%用来清空命令行窗口
close all;
%关闭所有的figure（图像）
clear global;
%清空所有全局变量
%% 定义全局变量 可以在调用子函数时不被删除的内存名称
global  real_time_computing_resources real_time_bandwidth_resources real_time_task_status network_request UAV_node UAV_lianjie_matrix request_deployment_scheme ;
%% 生成一个无人机网络拓扑
UAV_node=27;
%无人机网络中的无人机数目
UAV_node_zuobiao=[  0.27,0.4;0.72,0.8;0.25,0.6;
                    0.7,0.2;0.6,0.3;0.795,0.52;
                    0.3, 0.31;0.32,0.5;0.3,0.7;
                    0.4,0.2;0.4,0.39;0.4,0.6;
                    0.4,0.8;0.5,0.3;0.56,0.7;
                    0.6,0.42;0.6,0.2; 0.6,0.6;
                    0.6,0.8;0.76,0.3;0.7,0.7;
                    0.8,0.4;0.7,0.5;0.75,0.6;
                    0.4,0.72;0.48,0.45;0.5,0.2;];
%手动标出了节点的位置，UAV_node_zuobiao是一个27×2的矩阵，共有27行，每一行代表一加无人机，第一列是纵坐标，第二列是横坐标
UAV_lianjie_matrix = zeros(UAV_node);
%初始化无人机节点之间的连接矩阵，是一个27×27的矩阵
max_distance=0.2;
%设置最大距离，超过最大距离的节点之间不连通，由此来生成无人机节点之间的链路
for i=1:UAV_node
    for j=i+1:UAV_node
        distance=pdist([UAV_node_zuobiao(i,:); UAV_node_zuobiao(j,:)], 'euclidean');
        if distance<max_distance
            UAV_lianjie_matrix(i,j)=1;
            UAV_lianjie_matrix(j,i)=1;    
        end
    end
end
%生成了无人机节点之间的连通性矩阵
%gplot( UAV_lianjie_matrix,UAV_node_zuobiao,'-o');
%画出无人机节点的网络拓扑图
%% 设置计算资源，带宽资源，时延大小
UAV_computing_resources=[];
for i=1:UAV_node
    UAV_computing_resources(i,:)=50+round(50*rand);
end
%为每个无人机节点进行了资源赋值50~100
UAV_band_resources=UAV_lianjie_matrix;
for i=1:UAV_node
    for j=i+1:UAV_node
        if UAV_band_resources(i,j)==1
               UAV_band_resources(i,j)=50+round(50*rand);
               UAV_band_resources(j,i)=UAV_band_resources(i,j);
        end
    end
end
%为每个链路进行了带宽资源的赋值50~100
% UAV_link_delay=UAV_lianjie_matrix;
% for i=1:UAV_node
%     for j=i+1:UAV_node
%         if UAV_link_delay(i,j)==1
%                UAV_link_delay(i,j)=round(100*pdist([UAV_node_zuobiao(i,:); UAV_node_zuobiao(j,:)], 'euclidean'));
%                UAV_link_delay(j,i)=UAV_link_delay(i,j);
%         end
%     end
% end
% %定义了链路上的时延
%% 设置虚拟网络请求 包括1.编号2.起始物理节点3.长度4.每个vnf请求的资源大小5.带宽约束6.任务持续时间7.任务到达时间8.任务结束时间9.最大时延要求
network_request={};


request_arrival_time=[];
lambda = 5; % 设置泊松分布的参数
num_values = 500; % 要生成的随机数的数量,共生成50个任务在1000个时间单位中
poisson_values = random('Poisson', lambda, 1, num_values); % 生成服从泊松分布的随机数
request_num=sum(poisson_values);
for i=1:num_values
    for j=1:poisson_values(i)
    request_arrival_time(end+1,1)=(i-1)*100+round(100*rand);
    end
end
request_arrival_time=sort(request_arrival_time,1);
%设置任务数量，设置任务到达时间
network_request{1,7}=request_arrival_time;


request_duration=200;
starting_ending_nodes=[];
for i=1:request_num
    starting_ending_nodes(i,:)=randperm(UAV_node,2); 
end
network_request{1,2}=starting_ending_nodes;
%设置了起始物理节点
for i=1:request_num
    request_length(i,:)=3+round(7*rand); 
end
network_request{1,3}=request_length;
%设置了任务长度，服从3~10的均匀分布
request_VNF_resources=[];
for i=1:request_num
    for j=1:request_length(i)
    request_VNF_resources(i,j)=15+round(10*rand); 
    end
end
network_request{1,4}=request_VNF_resources;
%设置了每个任务请求中共每个vnf所请求的计算资源大小5~15
for i=1:request_num
    request_bandwidth_resources(i,:)=5+round(10*rand); 
end
network_request{1,5}=request_bandwidth_resources;
%设置了每个任务请求中每个虚拟链路要求的带宽资源5~15
network_request{1,6}=request_duration;
%设置了每个任务的持续时间

request_index=[];
for i=1:request_num
    request_index(i,:)=i;
end
network_request{1,1}=request_index;
%对任务进行编号

request_end_time=request_arrival_time+request_duration;
network_request{1,8}=request_end_time;


%% 为服务请求设计时延要求 

request_max_delay=[];
for i=1:request_num
    request_max_delay(i,1)=20+round(5*rand);
end
network_request{1,9}=request_max_delay;

%% 将所用任务汇总，算了
request_total=zeros(request_num,9);
request_total(:,1)=request_index;


%% 开始执行任务 每次任务到达就进行一次粒子群运算时间到达后就释放空间
total_time=[];
t=0;
real_time_computing_resources=UAV_computing_resources;
%记录实时资源状态
real_time_bandwidth_resources=UAV_band_resources;
%记录实时带宽资源状态
request_deployment_scheme={};
request_deployment_scheme=cell(request_num,2);
%接收请求数量 拒绝请求数量，请求总数量
 temp_1=[];  temp_total=[];x_axis=[]; request_accept_ratio=[];
while   t~=(request_end_time(end,1)+1)
    
    index=[];
    index=find(request_arrival_time==t);
    if length(index)==1
       pso(index);
    end
    if length(index)>1%当映射长度大于
    for i=1:length(index)
        pso(index(i,1));
    end
    end
   %% 如果时间到达任务截止时间释放计算资源,带宽资源，重置实时计算资源,
if xor(1,isempty(find(t==request_end_time)))
    index_update=find(t==request_end_time);
    if length(index_update)==1
      [real_time_computing_resources]=resource_computing_release(request_deployment_scheme{index_update,1},real_time_computing_resources,network_request,index_update);
      [real_time_bandwidth_resources] = resource_bandwidth_release(real_time_bandwidth_resources,network_request{1,5}(index_update,1),request_deployment_scheme{index_update,2});
    end
    if length(index_update)>1
        for j=1:length(index_update)
      [real_time_computing_resources]=resource_computing_release(request_deployment_scheme{index_update(j,1),1},real_time_computing_resources,network_request,index_update(j,1));
      [real_time_bandwidth_resources] = resource_bandwidth_release(real_time_bandwidth_resources,network_request{1,5}(index_update(j,1),1),request_deployment_scheme{index_update(j,1),2});
        end
    end
      
end
%% 统计请求接受率
 for i=4:46
          if t==(1000*i)
              temp_1=length(find(real_time_task_status==1));
            
              temp_total=length(real_time_task_status);
              request_accept_ratio(1,end+1)=temp_1/temp_total;
              x_axis(1,end+1)=i;
          end
 end
              
t=t+1;
end
 1;
 %% 统计请求接收率
plot(x_axis,request_accept_ratio);
title('虚拟网络请求接受率');
xlabel('时间/1000时间单元');
ylabel('请求接受率');

    
 
 
   
        
          
 