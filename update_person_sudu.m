function [v_2] = update_person_sudu(pso_particles,best_person_weizhi)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
x=[];
    x=(pso_particles==best_person_weizhi);
v_2=double(x);
end

