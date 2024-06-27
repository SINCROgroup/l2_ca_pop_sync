function y = triang_fun(x)

if abs(x) >= 1
    y = 0;
else
    y = 1 - abs(x);
end