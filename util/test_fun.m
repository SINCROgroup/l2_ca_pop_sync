function y = test_fun(x)
    if abs(x) >= 1
        y = 0;
    else
        y = exp(1 - 1/(1-abs(x)^2));
    end
end