function  [pso_velocity] = update_sudu(pso_velocity,v_2,v_3,population_size,changdu);
%UPDATE_SUDU 此处显示有关此函数的摘要
%   此处显示详细说明
p1=0.1;
p2=0.2;
p3=0.7;
for i=1:population_size
    for j=2:(changdu-1)
        a=rand;
        if  p1<a<(p1+p2)
            pso_velocity(i,j)=v_2(i,j);
        end
        if  a>(p1+p2)
            pso_velocity(i,j)=v_3(i,j);
        end
    end
end
end
            







