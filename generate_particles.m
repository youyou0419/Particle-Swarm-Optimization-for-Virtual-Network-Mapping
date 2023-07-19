%% 这个是用来生成随机的例子，针对一个任务生成5种粒子，粒子的第一个位置和最后一个位置都是任务设定好了的，中间剩下的虚拟vnf随机分配不同的位置
function y=generate_particles(index)
%重新选择的粒子不但不能和start_node、end_node重复，也不能和其他元素重复
global  network_request UAV_node;
    start_node=network_request{1,2}(index,1) ;
    end_node=network_request{1,2}(index,2);
 a=[];
    panduan1=1;
    panduan2=1;
    while xor(1,isempty(panduan2))||xor(1,isempty(panduan1))
       a=randperm(UAV_node,network_request{1,3}(index,:)-2);
       panduan1=find(a== start_node);
       panduan2=find(a== end_node);
    end
    y=[start_node a end_node];
end
    
    