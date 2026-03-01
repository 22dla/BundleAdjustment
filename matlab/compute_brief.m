function desc = compute_brief(img, x, y, theta, pattern)

    R = [cos(theta) -sin(theta);
         sin(theta)  cos(theta)];

    desc = zeros(1,size(pattern,1));

    for k = 1:size(pattern,1)

        p1 = R * pattern(k,1:2)';
        p2 = R * pattern(k,3:4)';

        x1 = round(x + p1(1));
        y1 = round(y + p1(2));
        x2 = round(x + p2(1));
        y2 = round(y + p2(2));

        if img(y1,x1) < img(y2,x2)
            desc(k) = 1;
        end
    end
end