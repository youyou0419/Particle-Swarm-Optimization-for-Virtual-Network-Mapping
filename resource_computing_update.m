function real_time_computing_resources=resource_computing_update(best_gruop_weizhi, real_time_computing_resources,network_request,index)
%用来更新实时计算资源
for i=1:length(best_gruop_weizhi)
    real_time_computing_resources(best_gruop_weizhi(1,i),1)=real_time_computing_resources(best_gruop_weizhi(1,i),1)-network_request{1, 4}(index,i);
end




end

