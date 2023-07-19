clear;
space_time=100;
t=space_time;
counter=1;
index_0(:,6)=0;
totle_r=50;
while sum(index_0(:,6)==0)>0
    c_end=max(random('poisson',5)-1,1);
    index_0(counter:min(counter+c_end-1,totle_r),6)=t;
    counter=counter+c_end;
    t=t+space_time;
end
