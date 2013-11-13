function plotExactAndApproxCosts(delta_cost_true, delta_ycost_true, delta_ccost_true, delta_vcost_true,...
                                 deltaNmll, deltaJY, deltaJC, deltaJV, ...
                                 k, n,  fignum)
LINE_WIDTH = 4;
MARKERSIZE = 8;
one2n = 1:n;
[~,o_delta_cost_true]=sort(delta_cost_true);
o_delta_cost_true(o_delta_cost_true) = one2n;

[~,o_delta_ycost_true]=sort(delta_ycost_true);
o_delta_ycost_true(o_delta_ycost_true) = one2n;

[~,o_delta_ccost_true]=sort(delta_ccost_true);
o_delta_ccost_true(o_delta_ccost_true) = one2n;

[~,o_delta_cost] = sort(deltaNmll);
o_delta_cost(o_delta_cost) = one2n;

[~,o_delta_ycost] = sort(deltaJY);
o_delta_ycost(o_delta_ycost) = one2n;

[~,o_delta_ccost] = sort(deltaJC);
o_delta_ccost(o_delta_ccost) = one2n;

 if ~isempty(delta_vcost_true) && ~isempty(deltaJV)
      [~, o_delta_vcost_true] = sort(delta_vcost_true);
      o_delta_vcost_true(o_delta_vcost_true) = one2n;
     
      [~, o_delta_vcost] = sort(deltaJV);
      o_delta_vcost(o_delta_vcost) = one2n;
 end
if ~isempty(delta_vcost_true) && ~isempty(deltaJV)
    
    figure(fignum);
    subplot(4,4,1);
    bar(k:n,delta_cost_true(k:end),'LineWidth',LINE_WIDTH); title('exact cost reduction');
    v1 = ylim;
    xlim([k n])
    subplot(4,4,2);
    bar(k:n,delta_ycost_true(k:end),'LineWidth',LINE_WIDTH); title('exact ycost reduction');
    v2 =  ylim;
    xlim([k n])
    subplot(4,4,3);
    bar(k:n,delta_ccost_true(k:end),'LineWidth',LINE_WIDTH); title('exact ccost reduction');
    v3 =  ylim;
    xlim([k n])
    subplot(4,4,4);
    bar(k:n, delta_vcost_true(k:end),'LineWidth',LINE_WIDTH); title('exact vcost reduction');
    v4 =  ylim;
    xlim([k n])

    subplot(4,4,5);
    bar(k:n,deltaNmll(k:end),'LineWidth',LINE_WIDTH); title('approx cost reduction');
    ylim(v1);
    xlim([k n])
    subplot(4,4,6);
    bar(k:n,deltaJY(k:end),'LineWidth',LINE_WIDTH); title('approx ycost reduction');
    ylim(v2);
    xlim([k n])
    subplot(4,4,7);
    bar(k:n,deltaJC(k:end),'LineWidth',LINE_WIDTH); title('approx ccost reduction');
    ylim(v3);
    xlim([k n])
    subplot(4,4,8);
    bar(k:n,deltaJV(k:end),'LineWidth',LINE_WIDTH); title('approx vcost reduction');
    ylim(v4);
    xlim([k n])

    subplot(4,4,9);
    scatter(delta_cost_true(k:end), deltaNmll(k:end)); title('cost reduction: approx vs exact');
    axis equal;
    subplot(4,4,10);
    scatter(delta_ycost_true(k:end) , deltaJY(k:end)); title('ycost reduction: approx vs exact');
    axis equal;
    subplot(4,4,11);
    scatter(delta_ccost_true(k:end) , deltaJC(k:end)); title('ccost reduction: approx vs exact');
    axis equal;
    subplot(4,4,12);
    scatter(delta_vcost_true(k:end) , deltaJV(k:end)); title('vcost reduction: approx vs exact');
    axis equal;

    subplot(4,4,13);
    scatter(o_delta_cost_true(k:end),o_delta_cost(k:end)); title('OR cost reduction: approx vs exact');
    axis equal;
    subplot(4,4,14);
    scatter(o_delta_ycost_true(k:end) , o_delta_ycost(k:end)); title('OR ycost reduction: approx vs exact');
    axis equal;
    subplot(4,4,15);
    scatter(o_delta_ccost_true(k:end) , o_delta_ccost(k:end)); title('OR ccost reduction: approx vs exact');
    axis equal;
    subplot(4,4,16);
    scatter(o_delta_vcost_true(k:end) , o_delta_vcost(k:end)); title('OR vcost reduction: approx vs exact');
    axis equal;
    
else
    
    figure(fignum);
    subplot(4,3,1);
    bar(k:n,delta_cost_true(k:end),'LineWidth',LINE_WIDTH); title('exact cost reduction');
    v1 = ylim;
    xlim([k n])
    subplot(4,3,2);
    bar(k:n,delta_ycost_true(k:end),'LineWidth',LINE_WIDTH); title('exact ycost reduction');
    v2 =  ylim;
    xlim([k n])
    subplot(4,3,3);
    bar(k:n,delta_ccost_true(k:end),'LineWidth',LINE_WIDTH); title('exact ccost reduction');
    v3 =  ylim;
    xlim([k n])

    subplot(4,3,4);
    bar(k:n,deltaNmll(k:end),'LineWidth',LINE_WIDTH); title('approx cost reduction');
    ylim(v1);
    xlim([k n])
    subplot(4,3,5);
    bar(k:n,deltaJY(k:end),'LineWidth',LINE_WIDTH); title('approx ycost reduction');
    ylim(v2);
    xlim([k n])
    subplot(4,3,6);
    bar(k:n,deltaJC(k:end),'LineWidth',LINE_WIDTH); title('approx ccost reduction');
    ylim(v3);
    xlim([k n])

    subplot(4,3,7);
    scatter(delta_cost_true(k:end), deltaNmll(k:end)); title('cost reduction: approx vs exact');
    axis equal;
    subplot(4,3,8);
    scatter(delta_ycost_true(k:end) , deltaJY(k:end)); title('ycost reduction: approx vs exact');
    axis equal;
    subplot(4,3,9);
    scatter(delta_ccost_true(k:end) , deltaJC(k:end)); title('ccost reduction: approx vs exact');
    axis equal;

    subplot(4,3,10);
    scatter(o_delta_cost_true(k:end),o_delta_cost(k:end)); title('OR cost reduction: approx vs exact');
    axis equal;
    subplot(4,3,11);
    scatter(o_delta_ycost_true(k:end) , o_delta_ycost(k:end)); title('OR ycost reduction: approx vs exact');
    axis equal;
    subplot(4,3,12);
    scatter(o_delta_ccost_true(k:end) , o_delta_ccost(k:end)); title('OR ccost reduction: approx vs exact');
    axis equal;
end
%     subplot(6,3,13:15);
%     m = size(achievedRankHist,1);
%     for e = 1:epoch
%         plot((e-1)*m + (1:k),achievedRankHist(1:k,epoch),'o','LineWidth',LINE_WIDTH,'MarkerSize',MARKERSIZE); hold on
%     end
%     hold off
%     axis([1 m*epoch 0 n])
%     title('rank of selected pivot among all possible choices')
    
%     subplot(6,3,16:18);
%     for e = 1:epoch
%         if isstruct(relAchievement)
%             maxAchievement  = relAchievement.maxAchievement;
%             actualAchievement = relAchievement.actualAchievement;
%             
%             h = stem(((e-1)*m + (1:k)).',[maxAchievement(1:k,epoch) actualAchievement(1:k,epoch)],'fill','--', ...
%                 'LineWidth',1); hold on
%            
%             set(h(1),'MarkerFaceColor','red','Marker','square')
%             set(h(2),'MarkerFaceColor','blue')
%             if k > 2
%                 mv_so_far = maxAchievement(1:k,epoch);
%                 mv_so_far = mv_so_far(~isnan(mv_so_far));
%                 yyl = quantile(mv_so_far,[.05 .95]);
%                 if all(isfinite(yyl))
%                     ylim(quantile(mv_so_far,[.05 .95]));
%                 end
%             end
%         else
%             bar((e-1)*m + (1:k),relAchievement(1:k,epoch),'LineWidth',LINE_WIDTH); hold on
%         end
%     end
%     hold off
%     xlim([1 m*epoch])
%     title('relative achievement')
