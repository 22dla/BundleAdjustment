function score = fast(img, i, j, t)
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