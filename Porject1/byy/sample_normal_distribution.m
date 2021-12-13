function sample = sample_normal_distribution(b)
    b = sqrt(b);
    total = 0;
    for i = 1:12
        total = total + normrnd(0,1);
    end
    sample = total * b * (1/6);
end
