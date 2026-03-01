clc
clear
close all

img = imread("..\data\frames\Frame 0.png");
img_gray = rgb2gray(img);

[N,M] = size(img_gray);

%% -------- FAST --------
W = 3;
threshold = 20;
score_map = zeros(N,M);

for i = 1+W:N-W
    for j = 1+W:M-W
        score_map(i,j) = fast(img_gray,i,j,threshold);
    end
end

%% -------- NMS --------
nms = zeros(N,M);

for i = 2:N-1
    for j = 2:M-1
        local = score_map(i-1:i+1, j-1:j+1);
        if score_map(i,j) == max(local(:)) && score_map(i,j) > 0
            nms(i,j) = score_map(i,j);
        end
    end
end

%% -------- Top-K --------
K = 500;

[y,x,v] = find(nms);
[~,idx] = sort(v,'descend');
idx = idx(1:min(K,length(idx)));

x = x(idx);
y = y(idx);

%% -------- Orientation + BRIEF --------
patch_radius = 16;
num_bits = 256;

pattern = randi([-15 15], num_bits, 4);

descriptors = zeros(length(x), num_bits);
orientations = zeros(length(x),1);

valid = true(length(x),1);

for k = 1:length(x)

    xi = x(k);
    yi = y(k);

    if xi-patch_radius < 1 || xi+patch_radius > M || ...
       yi-patch_radius < 1 || yi+patch_radius > N
        valid(k) = false;
        continue
    end

    theta = compute_orientation(img_gray, xi, yi);
    orientations(k) = theta;

    descriptors(k,:) = compute_brief(img_gray, xi, yi, theta, pattern);
end

x = x(valid);
y = y(valid);
descriptors = descriptors(valid,:);
orientations = orientations(valid);

%% -------- Visualization --------
figure
imshow(img)
hold on
plot(x,y,'r.')
title('ORB keypoints')