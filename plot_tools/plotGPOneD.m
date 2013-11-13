function h = plotGPOneD(X, Y, XX, yHatMean, yHatVar, ptOrder, fignum,...
                        titleStr, xSIS, ySIS, xSIS0, ySIS0, keepOn, xlim_vals, ylim_vals)

ps = get_plot_settings(2,1.2); 


if isstruct(fignum)
    h = figure(fignum.fignum);
    if isfield(fignum,'subplot')
        subplot(fignum.subplot{:});
    end
else
    h = figure(fignum);
end

plot(X,Y,'o','LineWidth',ps.LW,'MarkerSize',ps.MS/2);hold on;

if isempty(ptOrder)
   [~,ptOrder] = sort(XX);
end

plot(XX(ptOrder),yHatMean(ptOrder),'r-','LineWidth',ps.LW,'MarkerSize',ps.MS); hold on;
plot(XX(ptOrder),yHatMean(ptOrder)+2*sqrt(yHatVar(ptOrder)),'g-','LineWidth',ps.LW,'MarkerSize',ps.MS);hold on;
plot(XX(ptOrder),yHatMean(ptOrder)-2*sqrt(yHatVar(ptOrder)),'g-','LineWidth',ps.LW,'MarkerSize',ps.MS);

if nargin > 7
    title(titleStr)
end

if nargin > 8
    yl = ylim;
    plot(xSIS,(min(yl)+range(yl)/100)*ones(size(xSIS)),'c+',...
        'MarkerSize',ps.MS,'LineWidth',ps.LW );hold on;
    if ~isempty(ySIS) && ~(all(isnan(ySIS)))
        plot(xSIS,ySIS,'c+','MarkerSize',ps.MS,'LineWidth',ps.LW);hold on;
    end
end

if nargin > 10
    yl = ylim;
    plot(xSIS0,(max(yl)-range(yl)/100)*ones(size(xSIS0)),'k+',...
        'MarkerSize',ps.MS,'LineWidth',ps.LW );hold on;
    if ~isempty(ySIS0) && ~(all(isnan(ySIS0)))
        plot(xSIS0,ySIS0,'k+','MarkerSize',ps.MS,'LineWidth',ps.LW);hold on;
    end
end


if nargin < 13
    keepOn = false;
end

if exist('xlim_vals','var')  && ~isempty(xlim_vals)
    xlim(xlim_vals);
end

if exist('ylim_vals','var')  && ~isempty(ylim_vals)
    ylim(ylim_vals);
end



if keepOn
    hold on;
else
    hold off;
end
 

end