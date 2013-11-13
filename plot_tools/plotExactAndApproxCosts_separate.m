function plotExactAndApproxCosts_separate(base_name, delta_cost_true, delta_ycost_true, delta_ccost_true, delta_vcost_true,...
                                 deltaNmll, deltaJY, deltaJC, deltaJV, ...
                                 k, n)
% LINE_WIDTH = 4;
% MARKERSIZE = 8;
one2n = 1:n;
[~,o_delta_cost_true]=sort(delta_cost_true,'descend');
o_delta_cost_true(o_delta_cost_true) = one2n;

[~,o_delta_ycost_true]=sort(delta_ycost_true,'descend');
o_delta_ycost_true(o_delta_ycost_true) = one2n;

[~,o_delta_ccost_true]=sort(delta_ccost_true,'descend');
o_delta_ccost_true(o_delta_ccost_true) = one2n;

[~,o_delta_cost] = sort(deltaNmll,'descend');
o_delta_cost(o_delta_cost) = one2n;

[~,o_delta_ycost] = sort(deltaJY,'descend');
o_delta_ycost(o_delta_ycost) = one2n;

[~,o_delta_ccost] = sort(deltaJC,'descend');
o_delta_ccost(o_delta_ccost) = one2n;

 if ~isempty(delta_vcost_true) && ~isempty(deltaJV)
      [~, o_delta_vcost_true] = sort(delta_vcost_true,'descend');
      o_delta_vcost_true(o_delta_vcost_true) = one2n;
     
      [~, o_delta_vcost] = sort(deltaJV,'descend');
      o_delta_vcost(o_delta_vcost) = one2n;
 end
 
 
    
% h = figure(1);
% bar(k:n,delta_cost_true(k:end)); 
% v1 = ylim;
% xlim([k n]); 
% name = strrep('exact cost reduction',' ','-');
% print_and_save(h, [base_name name]);
% 
% 
% h = figure(1);
% bar(k:n,delta_ycost_true(k:end)); 
% v2 =  ylim;
% xlim([k n]); 
% name = strrep('exact ycost reduction',' ','-');
% print_and_save(h, [base_name name]);
% 
% h = figure(1);
% bar(k:n,delta_ccost_true(k:end)); 
% v3 =  ylim;
% xlim([k n]); 
% name = strrep('exact ccost reduction',' ','-');
% print_and_save(h, [base_name name]);
%  
% h = figure(1);
% bar(k:n, delta_vcost_true(k:end)); 
% v4 =  ylim;
% xlim([k n]); 
% name = strrep('exact vcost reduction',' ','-');
% print_and_save(h, [base_name name]);
% 
% h = figure(1);
% bar(k:n,deltaNmll(k:end)); 
% ylim(v1);
% xlim([k n])
% name = strrep('approx cost reduction',' ','-');
% print_and_save(h, [base_name name]);
% 
% h = figure(1);
% bar(k:n,deltaJY(k:end)); 
% ylim(v2);
% xlim([k n]); 
% name = strrep('approx ycost reduction',' ','-');
% print_and_save(h, [base_name name]);
% 
% h = figure(1);
% bar(k:n,deltaJC(k:end)); 
% ylim(v3);
% xlim([k n]); 
% name = strrep('approx ccost reduction',' ','-');
% print_and_save(h, [base_name name]);
% 
% h = figure(1);
% bar(k:n,deltaJV(k:end)); 
% ylim(v4);
% xlim([k n]); 
% name = strrep('approx vcost reduction',' ','-');
% print_and_save(h, [base_name name]);
FF = 25;
h = figure(1);
scatter(delta_cost_true(k:end), deltaNmll(k:end)); 
%axis square; 
ylim(xlim());
set(gca,'ytick',get(gca,'xtick'));
xlabel('exact total reduction','Fontsize',FF)
ylabel('approx total reduction','Fontsize',FF)
name = strrep('cost reduction approx vs exact',' ','-');
print_and_save(h, [base_name name]);

% h = figure(1);
% scatter(delta_ycost_true(k:end) , deltaJY(k:end)); 
% axis equal; 
% strrep('ycost reduction approx vs exact',' ','-');
% print_and_save(h, [base_name name]);
% 
% h = figure(1);
% scatter(delta_ccost_true(k:end) , deltaJC(k:end)); 
% axis equal; 
% name = strrep('ccost reduction approx vs exact',' ','-');
% print_and_save(h, [base_name name]);
%  
% h = figure(1);
% scatter(delta_vcost_true(k:end) , deltaJV(k:end)); 
% axis equal; 
% name = strrep('vcost reduction approx vs exact',' ','-');
% print_and_save(h, [base_name name]);

h = figure(1);
scatter(o_delta_cost_true(k:end),o_delta_cost(k:end)); 
%axis square; 
ylim(xlim()); 
set(gca,'ytick', 0:50:200);
set(gca,'xtick', 0:50:200);
xlabel('ranking exact total reduction','Fontsize',FF)
ylabel('ranking approx total reduction','Fontsize',FF)
 
name = strrep('OR cost reduction approx vs exact',' ','-');
print_and_save(h, [base_name name]);

% h = figure(1);
% scatter(o_delta_ycost_true(k:end) , o_delta_ycost(k:end)); 
% axis equal; 
% name = strrep('OR ycost reduction approx vs exact',' ','-');
% print_and_save(h, [base_name name]);
% 
% h = figure(1);
% scatter(o_delta_ccost_true(k:end) , o_delta_ccost(k:end)); 
% axis equal; 
% name = strrep('OR ccost reduction approx vs exact',' ','-');
% print_and_save(h, [base_name name]);
% 
% h = figure(1);
% scatter(o_delta_vcost_true(k:end) , o_delta_vcost(k:end)); 
% axis equal; 
% name = strrep('OR vcost reduction approx vs exact',' ','-');
% print_and_save(h, [base_name name]);

end

function print_and_save(h,name)
print(h,'-dpng', [name '.png']);
print(h,'-depsc','-r500', [name '.eps']);
saveas(h, [name '.fig'], 'fig');
end