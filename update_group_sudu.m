function  [v_3] = update_group_sudu(pso_particles,best_gruop_weizhi,population_size)
%SUDU_GROUP_UPDATE 此处显示有关此函数的摘要
%   此处显示详细说明
x=[];
for i=1:population_size
    x(i,:)=double((pso_particles(i,:)==best_gruop_weizhi));
end
v_3=double(x);
end