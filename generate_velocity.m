%% 初始化速度变量，1表示节点不用重新选择，0表示节点需要重新选择
function y=generate_velocity(index)
global  network_request UAV_node;
    start_node=1;
    end_node=1;
    a=[];
    a= randi([0 1],1,network_request{1,3}(index,:)-2);
    y=[start_node a end_node];
end
    