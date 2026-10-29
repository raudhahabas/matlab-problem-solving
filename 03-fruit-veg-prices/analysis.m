%% UK fruit & vegetable price analysis
% Run this script from its own folder: >> analysis
% Figures are written to figures/.

format compact
T = readtable(fullfile('data', 'fruitandvegprices.csv'), 'TextType', 'string');
if ~isdatetime(T.date)
    T.date = datetime(T.date, 'InputFormat', 'yyyy-MM-dd');
end
fprintf('Loaded %d price records from %s to %s\n\n', height(T), ...
        string(min(T.date)), string(max(T.date)));

%% 1. Distinct items, and varieties of four chosen items
all_items = unique(T.item);
fprintf('%d distinct items:\n%s\n\n', numel(all_items), strjoin(all_items, ', '));

items_to_check = ["cabbage", "brussels_sprouts", "capsicum", "celeriac"];
for itemname = items_to_check
    v = unique(T.variety(T.item == itemname));
    fprintf('%-17s %d varieties: %s\n', itemname, numel(v), strjoin(v, ', '));
end

%% 2. Mean price of each cabbage variety
Tcabbage = T(T.item == "cabbage", :);
meanprice = groupsummary(Tcabbage, "variety", ["mean", "std"], "price");
meanprice = sortrows(meanprice, "mean_price");

fprintf('\nCabbage varieties by mean price:\n');
for k = 1:height(meanprice)
    fprintf('  %-22s mean £%.5f   std £%.3f   (n = %d)\n', meanprice.variety(k), ...
        meanprice.mean_price(k), meanprice.std_price(k), meanprice.GroupCount(k));
end

%% 3. Box plot comparing the spread of cabbage prices
fig = new_figure();
boxchart(categorical(strrep(Tcabbage.variety, '_', ' ')), Tcabbage.price, ...
         'MarkerStyle', '+');
title('Price Variation for Cabbage Varieties');
xlabel('Cabbage Variety');
ylabel('Price (£ per unit)');
grid on;
exportgraphics(fig, fullfile('figures', 'cabbage_boxplot.png'), 'Resolution', 150);

%% 4. Time series and seasonality of the cheapest variety
smallestvariety = meanprice.variety(1); % lowest mean price (white)
Tsmall = sortrows(Tcabbage(Tcabbage.variety == smallestvariety, :), "date");

fig = new_figure('Position', [100 100 900 380]);
plot(Tsmall.date, Tsmall.price, '-o', 'MarkerSize', 3, 'LineWidth', 1.2);
title("Weekly Price of Cabbage (" + smallestvariety + ")");
xlabel('Date');
ylabel('Price (£ per unit)');
grid on;
exportgraphics(fig, fullfile('figures', 'white_cabbage_timeseries.png'), 'Resolution', 150);

% Average price for each calendar month, pooled over all years,
% to check whether the mid-year peaks repeat every year
monthly = groupsummary(Tsmall, "date", "monthofyear", "mean", "price");
fig = new_figure();
bar(double(string(monthly.monthofyear_date)), monthly.mean_price);
xticks(1:12);
xticklabels({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'});
title("Average Price of Cabbage (" + smallestvariety + ") by Month");
ylabel('Mean price (£ per unit)');
grid on;
exportgraphics(fig, fullfile('figures', 'white_cabbage_by_month.png'), 'Resolution', 150);

[~, peak] = max(monthly.mean_price);
fprintf('\n%s cabbage is most expensive in month %s on average\n', ...
        smallestvariety, string(monthly.monthofyear_date(peak)));

%% 5. Correlation between white cabbage and celeriac prices
cab = table(Tsmall.date, Tsmall.price, 'VariableNames', {'Date', 'CabPrice'});
Tceleriac = T(T.item == "celeriac", :);
cel = table(Tceleriac.date, Tceleriac.price, 'VariableNames', {'Date', 'CelPrice'});

% align the dates by using inner join (keep only weeks with both prices)
IJ = innerjoin(cab, cel, 'Keys', 'Date');

R = corrcoef(IJ.CabPrice, IJ.CelPrice);
fprintf('\nCorrelation (white cabbage vs celeriac, %d matched dates): r = %.5f\n', ...
        height(IJ), R(1, 2));

fig = new_figure();
scatter(IJ.CabPrice, IJ.CelPrice, 14, 'filled', 'MarkerFaceAlpha', 0.6);
grid on;
xlabel('White cabbage price (£)');
ylabel('Celeriac price (£)');
title(sprintf('White Cabbage vs Celeriac Prices (r = %.2f)', R(1, 2)));
exportgraphics(fig, fullfile('figures', 'cabbage_vs_celeriac.png'), 'Resolution', 150);

%% Local functions
function fig = new_figure(varargin)
    % White-background figure, even when MATLAB is set to a dark theme
    fig = figure('Color', 'w', varargin{:});
    if ~isMATLABReleaseOlderThan("R2025a")
        theme(fig, "light");
    end
end
