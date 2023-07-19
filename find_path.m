function []=find_path(A,nodeNum)

A=  UAV_lianjie_matrix;          % 输入邻接矩阵
[m n]=size(A);
nodeNum=UAV_node;                       % 节点数
vflag=zeros(nodeNum,1);          % 初始化所有节点访问标志位
queue=[];                        % 遍历缓存队列，每次访问并丢弃队首
result=[];                       % 遍历结果
startNode=1;%unidrnd(nodenum);   % 从任意节点出发
queue=[queue;startNode];         % 更新遍历缓存队列
vflag(startNode)=1;              % 更新访问标志
result=[result;startNode];       % 更新遍历结果队列
% while isempty(queue)==false
while all(vflag)==0
    i=queue(1);
    queue(1)=[];
    for j=1:n
        if(A(i,j)>0&&vflag(j)==0&&i~=j)
            queue=[queue;j];
            vflag(j)=1;
            result=[result;j];
        end
    end
end