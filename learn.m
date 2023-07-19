clear;
clc;

p1 = 0.1; % 매쪽1
p2 = 0.9; % 매쪽2
a = [1 0 0 1 1];
b = [1 0 1 0 1];
c = (rand(size(a)) < p1) .* a + (rand(size(b)) < p2) .* b;