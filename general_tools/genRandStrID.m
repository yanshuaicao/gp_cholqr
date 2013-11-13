function randStrID = genRandStrID()
% rs = rng;
% rng(rem(now,1e-6));
randStrID = sprintf('%lu',round(1e9*rand(1)));
% rng(rs);
end