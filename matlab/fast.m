clc
clear
close all

img = imread("..\data\frames\Frame 0.png");
img_gray = rgb2gray(img);

% figure, imshow(img)
% figure, imshow(img_gray)

[N, M] = size(img_gray);

W = 3;

threshold = 20;
score_map = zeros(N,M);

for i = 1+W:N-W
    for j = 1+W:M-W
        score_map(i,j) = check_fast(img_gray,i,j,20);
    end
end

nms = zeros(N,M);

for i = 2:N-1
    for j = 2:M-1
        local = score_map(i-1:i+1, j-1:j+1);
        if score_map(i,j) == max(local(:)) && score_map(i,j) > 0
            nms(i,j) = score_map(i,j);
        end
    end
end

figure
imshow(img)
hold on
K = 500;

[y,x,v] = find(nms);
[~,idx] = sort(v,'descend');

idx = idx(1:min(K,length(idx)));

x = x(idx);
y = y(idx);

plot(x, y, 'r.')
title('FAST corners')

function score = check_fast(img, i, j, t)
    Ip = double(img(i,j));
    circle = [
        -3  0;
        -3  1;
        -2  2;
        -1  3;
         0  3;
         1  3;
         2  2;
         3  1;
         3  0;
         3 -1;
         2 -2;
         1 -3;
         0 -3;
        -1 -3;
        -2 -2;
        -3 -1;
    ];

    values = zeros(1,16);

    for k = 1:16
        values(k) = double(img(i + circle(k,1), ...
                               j + circle(k,2)));
    end

    diff = values - Ip;

    brighter = diff > t;
    darker   = diff < -t;

    brighter = [brighter brighter];
    darker   = [darker darker];
    diff2    = [diff diff];

    score = 0;

    for k = 1:16
        if sum(brighter(k:k+8)) == 9
            s = min(diff2(k:k+8));
            score = max(score, s);
        end
        if sum(darker(k:k+8)) == 9
            s = min(abs(diff2(k:k+8)));
            score = max(score, s);
        end
    end
end
