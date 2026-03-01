function theta = compute_orientation(img, x, y)

    patch = double(img(y-8:y+8, x-8:x+8));
    [X,Y] = meshgrid(-8:8, -8:8);

    m10 = sum(sum(X .* patch));
    m01 = sum(sum(Y .* patch));

    theta = atan2(m01, m10);
end