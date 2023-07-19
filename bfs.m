function [path] = bfs(adj, s, t)
% adj 为节点连通性矩阵，s 和 t 分别为起点和终点的编号
adj(adj==0)=inf;
n = size(adj, 1);  % 获取节点个数

dist = inf(1, n);  % 到各个节点的距离
dist(s) = 0;       % 起点到自己的距离为0

prev = zeros(1, n);  % 记录最短路径中每个节点的前一个节点
visited = zeros(1, n);  % 记录每个节点是否已经被访问

queue = s;  % 队列中初始只有起点

while ~isempty(queue)
    u = queue(1);  % 取出队首节点
    queue(1) = [];  % 从队列中移除该节点
    visited(u) = 1;  % 标记该节点已被访问
    
    % 遍历与该节点相邻的节点
    for v = 1:n
        if adj(u, v) == 1 && ~visited(v)  % 如果相邻且未访问过
            dist(v) = dist(u) + 1;  % 更新到该节点的距离
            prev(v) = u;  % 记录该节点的前一个节点
            if v == t  % 如果找到终点，返回结果
                % 构造起点到终点的最短路径
                path = t;
                while path(1) ~= s
                    path = [prev(path(1)), path];
                end
                return
            else
                queue(end+1) = v;  % 将该节点加入队列尾部
            end
        end
    end
end

% 如果无法到达终点，返回空数组
path = [];
end
