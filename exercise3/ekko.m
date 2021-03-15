function y = ekko (x, Fs, del, atten, num_of_echoes)

    n = length(x);
    c = zeros(1,n);
    c(1) = 1;
    delay_in_seconds = del;
    delay_by_samples = round(delay_in_seconds*Fs);
    shorten_interval_by = 0.9;
    curr_delay = 0;
    
    for i=1:num_of_echoes
        curr_delay = curr_delay + delay_by_samples;
        c(curr_delay) = atten^i;
        delay_by_samples = round(delay_by_samples*shorten_interval_by);
    end
    
    y = conv(x,c);
    
end

