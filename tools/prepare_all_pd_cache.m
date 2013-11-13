function all_pd_cache = prepare_all_pd_cache(trainx, I)
D = size(trainx, 2);
 
all_pd_cache = arrayfun(@(d) struct('rn', (dist(trainx(I,d),trainx(:,d))).^2, ...
                                    'rr', (dist(trainx(I,d),trainx(I,d))).^2), 1:D);

end

 