function connected = check_connection(node1, node2)
global UAV_lianjie_matrix;
% A: 连通性矩阵
% node1, node2: 节点编号
% connected: 返回值，如果节点相连则为1，否则为0

if UAV_lianjie_matrix(node1, node2) == 1 || UAV_lianjie_matrix(node2, node1) == 1
    connected = 1;
else
    connected = 0;
end
