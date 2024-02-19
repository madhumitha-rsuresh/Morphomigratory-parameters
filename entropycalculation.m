% Excel file and sheet access
cd ('D:\IISc_stuffs\Project files_Data analysis\Part 5 - Metric\Aurox\OVCAR3_Aurox_2hrsevery2mins\on collagen_2hrsevery2mins\Collagen_1mgml_20.12.23_Aurox_2hrsevery2mins_set1\crop1')
excelFile = 'output_parameters_001.xlsx';
sheetName = 'object6';

% Specify the range to include header row
dataRange = 'A:W';  % Adjust this based on your actual range

% Read the table with correct headers
resultTable = readtable(excelFile, 'Sheet', sheetName, 'Range', dataRange);

% OBTAINING HISTOGRAM & GENERATING A TABLE
% Create a new table with appropriate variable names
entropyTable = table();

% Specify the number of bins
numBins = 5;
entropyTable.numberofbins(1,1) = numBins;

% Create a histogram and normalize by the total number of data points
figure;
t = tiledlayout(2, 3, 'TileSpacing', 'compact');

% Display the histogram
binEdges1 = linspace(-180, 180, numBins+1);
xlabel(t,'Values');
ylabel(t,'Count');
title(t,'Histogram');

ax1 = nexttile;
[counts, binEdges] = histcounts(resultTable.disp_angle, binEdges1);
histogram(ax1, resultTable.disp_angle, binEdges1, 'Normalization','count');
title(ax1, 'Disp. vector angle')

% Calculate the total number of data points
totalDataPoints = sum(counts);

% Calculate the probability density function (PDF)
probabilityDensity = counts ./ (totalDataPoints);

% Apply the transformation p(ln p)
transformedProbabilities = -(probabilityDensity .* log2(probabilityDensity + eps));

%entropy
Entropy = round(sum((transformedProbabilities)/-log2(1/numBins)),2);
entropyTable.Displacementvectorangle_entropy(1,1) = Entropy;
txt = {'Entropy:', Entropy};
text('Units', 'normalized', 'Position', [0.90, 0.85], 'String', txt, 'HorizontalAlignment', 'right');

% MA dynamics
ax2 = nexttile;
binEdges2 = linspace(-30, 30, numBins+1);
[counts, binEdges] = histcounts(resultTable.MAdynamics, binEdges2);
histogram(resultTable.MAdynamics, binEdges, 'Normalization','count');
title(ax2, 'MA dynamics')

% Calculate the total number of data points
totalDataPoints = sum(counts);

% Calculate the probability density function (PDF)
probabilityDensity = counts ./ (totalDataPoints);

% Apply the transformation p(ln p)
transformedProbabilities = -(probabilityDensity .* log2(probabilityDensity + eps));

%entropy
Entropy = round(sum(transformedProbabilities/-log2(1/numBins)),2);
entropyTable.MAdynamics_entropy(1,1) = Entropy;
txt = {'Entropy:', Entropy};
text('Units', 'normalized', 'Position', [0.90, 0.85], 'String', txt, 'HorizontalAlignment', 'right');

% MA and displacement vector angle
ax3 = nexttile;
binEdges3 = linspace(0, 90, numBins+1);
[counts, binEdges] = histcounts(resultTable.MA_disp_angle, binEdges3);
histogram(resultTable.MA_disp_angle, binEdges, 'Normalization','count');
title(ax3, 'MA and Disp.vector angle')

% Calculate the total number of data points
totalDataPoints = sum(counts);

% Calculate the probability density function (PDF)
probabilityDensity = counts ./ (totalDataPoints);

% Apply the transformation p(ln p)
transformedProbabilities = -(probabilityDensity .* log2(probabilityDensity + eps));

%entropy
Entropy = round(sum(transformedProbabilities/-log2(1/numBins)),2);
entropyTable.MA_disp_angle_entropy(1,1) = Entropy;
txt = {'Entropy:', Entropy};
text('Units', 'normalized', 'Position', [0.90, 0.85], 'String', txt, 'HorizontalAlignment', 'right');

% Turning angle
ax4 = nexttile;
binEdges4 = linspace(0, 180, numBins+1);
[counts, binEdges] = histcounts(resultTable.turningangle, binEdges4);
histogram(resultTable.turningangle, binEdges, 'Normalization','count');
title(ax4, 'Turning angle')

% Calculate the total number of data points
totalDataPoints = sum(counts);

% Calculate the probability density function (PDF)
probabilityDensity = counts ./ (totalDataPoints);

% Apply the transformation p(ln p)
transformedProbabilities = -(probabilityDensity .* log2(probabilityDensity + eps));

% entropy
Entropy = round(sum(transformedProbabilities/-log2(1/numBins)),2);
entropyTable.turningangle_entropy(1,1) = Entropy;
txt = {'Entropy:', Entropy};
text('Units', 'normalized', 'Position', [0.90, 0.85], 'String', txt, 'HorizontalAlignment', 'right');

% Elongation
ax5 = nexttile;
binEdges5 = linspace(0, 1, numBins+1);
[counts, binEdges] = histcounts(resultTable.elongation, binEdges5);
histogram(resultTable.elongation, binEdges, 'Normalization','count');
title(ax5, 'Elongation')

% Calculate the total number of data points
totalDataPoints = sum(counts);

% Calculate the probability density function (PDF)
probabilityDensity = counts ./ (totalDataPoints);

% Apply the transformation p(ln p)
transformedProbabilities = -(probabilityDensity .* log2(probabilityDensity + eps));

%entropy
Entropy = round(sum(transformedProbabilities/-log2(1/numBins)),2);
entropyTable.elongationdynamics_entropy(1,1) = Entropy;
txt = {'Entropy:', Entropy};
text('Units', 'normalized', 'Position', [0.90, 0.85], 'String', txt, 'HorizontalAlignment', 'right')

% Velocity
ax6 = nexttile;
binEdges6 = linspace(0, 2, numBins+1);
[counts, binEdges] = histcounts(resultTable.velocity, binEdges6);
histogram(resultTable.velocity, binEdges, 'Normalization','count');
title(ax6, 'Velocity')

% Calculate the total number of data points
totalDataPoints = sum(counts);

% Calculate the probability density function (PDF)
probabilityDensity = counts ./ (totalDataPoints);

% Apply the transformation p(ln p)
transformedProbabilities = -(probabilityDensity .* log2(probabilityDensity + eps));

%entropy
Entropy = round(sum(transformedProbabilities/-log2(1/numBins)),2);
entropyTable.velocitydynamics_entropy(1,1) = Entropy;
txt = {'Entropy:', Entropy};
text('Units', 'normalized', 'Position', [0.90, 0.85], 'String', txt, 'HorizontalAlignment', 'right')

% Display the resulting table
%disp(entropyTable);

% Specify the Excel file name
outputExcelFile = 'entropy_table_001.xlsx';

% Specify the sheet name
sheetName = 'object7';

% Write the table to Excel
writetable(entropyTable, outputExcelFile, 'Sheet', sheetName);

% Set the figure to fullscreen mode
set(gcf, 'Units', 'normalized', 'OuterPosition', [0, 0, 1, 1]);

% Specify the folder where you want to save the figures
plotfolder = 'D:\IISc_stuffs\Project files_Data analysis\Part 5 - Metric\Aurox\OVCAR3_Aurox_2hrsevery2mins\on collagen_2hrsevery2mins\Collagen_1mgml_20.12.23_Aurox_2hrsevery2mins_set1\crop1\plots_new';  % Replace with the actual path

% Save the figure inside the specified folder
saveas(gcf, fullfile(plotfolder, 'entropyplot_object_06.png'));

% Close the figure
close(gcf);