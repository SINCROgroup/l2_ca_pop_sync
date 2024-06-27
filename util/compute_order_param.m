function order_param = compute_order_param(phases)

order_param = abs(sum(exp(1i*phases)) / length(phases));

end