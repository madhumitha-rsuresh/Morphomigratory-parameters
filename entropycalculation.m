% Excel file and sheet access
cd ('D:\IISc_stuffs\Project work\Project files_Data analysis\Part 1 - Metric\Epi\OVCAR3 Data\OVCAR3 - Stiffness\SET 1 - 14.05.2024\19.7kPa\008')
inputexcelfile = 'output_parameters_008_new.xlsx';

% Get the sheet names from the input Excel file
sheetNames = sheetnames(inputexcelfile);

% Loop over each sheet
for s = 1:length(sheetNames)
   
    % Read data from the current sheet
    data = xlsread(inputexcelfile, sheetNames{s});

    % Specify the range to include header row
    dataRange = 'A:AE';  % Adjust this based on your actual range

    % Read the table with correct headers
    resultTable = readtable(inputexcelfile, 'Sheet', sheetNames(s), 'Range', dataRange);

    % OBTAINING HISTOGRAM & GENERATING A TABLE
    % Create a new table with appropriate variable names
    entropyTable = table();
    customHeaders = {'meanvelocity', 'meand2p', 'accumulateddistance', 'euclideandistance', 'persistenceratio', 'meansolidity', 'meanelongation', 'varelongation', 'meanshapeindex', 'maxvelocity'};
    entropyTable = table(resultTable{1,22}, resultTable{1,23}, resultTable{1,24}, resultTable{1,25}, resultTable{1,26}, resultTable{1,27}, resultTable{1,28}, resultTable{1,29}, resultTable{1,30}, resultTable{1,31}, 'VariableNames', customHeaders); 
    
    % Specify the number of bins
    numBins = 5; entropyTable.numberofbins(1,1) = numBins;
    
    % Create a histogram and normalize by the total number of data points
    figure;
    t = tiledlayout(3, 3, 'TileSpacing', 'compact');
    
    % Display the histogram
    binEdges1 = linspace(-180, 180, numBins+1);
    xlabel(t,'Values');
    ylabel(t,'Count');
    title(t,'Histogram');
    
    % DISPLACEMENT VECTOR ANGLE
    ax1 = nexttile;
    [counts, binEdges] = histcounts(resultTable.GTA, binEdges1);
    histogram(ax1, resultTable.GTA, binEdges1, 'Normalization','count');
    title(ax1, 'GTA')
    
    % Calculate the total number of data points
    totalDataPoints = sum(counts);
    
    % Calculate the probability density function (PDF)
    probabilityDensity = counts ./ (totalDataPoints);
    
    % Apply the transformation p(ln p)
    transformedProbabilities = -(probabilityDensity .* log2(probabilityDensity + eps));
    
    %entropy
    Entropy = round(sum((transformedProbabilities)/-log2(1/numBins)),2);
    entropyTable.GTA_entropy(1,1) = Entropy;
    txt = {'Entropy:', Entropy};
    text('Units', 'normalized', 'Position', [0.90, 0.85], 'String', txt, 'HorizontalAlignment', 'right');
    
    % MA DYNAMICS
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
    
    % MA AND DISP. VECTOR ANGLE
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
    
    % TURNING ANGLE
    ax4 = nexttile;
    binEdges4 = linspace(0, 180, numBins+1);
    [counts, binEdges] = histcounts(resultTable.RTA, binEdges4);
    histogram(resultTable.RTA, binEdges, 'Normalization','count');
    title(ax4, 'Turning angle')
    
    % Calculate the total number of data points
    totalDataPoints = sum(counts);
    
    % Calculate the probability density function (PDF)
    probabilityDensity = counts ./ (totalDataPoints);
    
    % Apply the transformation p(ln p)
    transformedProbabilities = -(probabilityDensity .* log2(probabilityDensity + eps));
    
    % entropy
    Entropy = round(sum(transformedProbabilities/-log2(1/numBins)),2);
    entropyTable.RTA_entropy(1,1) = Entropy;
    txt = {'Entropy:', Entropy};
    text('Units', 'normalized', 'Position', [0.90, 0.85], 'String', txt, 'HorizontalAlignment', 'right');
    
    % ELONGATION
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

    % SHAPE INDEX
    ax6 = nexttile;
    binEdges6 = linspace(0, 1, numBins+1);
    [counts, binEdges] = histcounts(resultTable.shapeindex, binEdges6);
    histogram(resultTable.shapeindex, binEdges,'Normalization','count');
    title(ax6, 'Shape index')
    
    % Calculate the total number of data points
    totalDataPoints = sum(counts);
    
    % Calculate the probability density function (PDF)
    probabilityDensity = counts ./ (totalDataPoints);
    
    % Apply the transformation p(ln p)
    transformedProbabilities = -(probabilityDensity .* log2(probabilityDensity + eps));
    
    %entropy
    Entropy = round(sum(transformedProbabilities/-log2(1/numBins)),2);
    entropyTable.shapeindexdynamics_entropy(1,1) = Entropy;
    txt = {'Entropy:', Entropy};
    text('Units', 'normalized', 'Position', [0.90, 0.85], 'String', txt, 'HorizontalAlignment', 'right')
    
    % SOLIDITY
    ax7 = nexttile;
    binEdges7 = linspace(0, 1, numBins+1);
    [counts, binEdges] = histcounts(resultTable.Solidity, binEdges7);
    histogram(resultTable.Solidity, binEdges, 'Normalization','count');
    title(ax7, 'Solidity')
    
    % Calculate the total number of data points
    totalDataPoints = sum(counts);
    
    % Calculate the probability density function (PDF)
    probabilityDensity = counts ./ (totalDataPoints);
    
    % Apply the transformation p(ln p)
    transformedProbabilities = -(probabilityDensity .* log2(probabilityDensity + eps));
    
    %entropy
    Entropy = round(sum(transformedProbabilities/-log2(1/numBins)),2);
    entropyTable.soliditydynamics_entropy(1,1) = Entropy;
    txt = {'Entropy:', Entropy};
    text('Units', 'normalized', 'Position', [0.90, 0.85], 'String', txt, 'HorizontalAlignment', 'right')
    
    % VELOCITY
    ax8 = nexttile;
    binEdges8 = linspace(0, 2, numBins+1);
    [counts, binEdges] = histcounts(resultTable.velocity, binEdges8);
    histogram(resultTable.velocity, binEdges, 'Normalization','count');
    title(ax8, 'Velocity')
    
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
    %entropyTable.SheetName = repmat({sheetNames{s}}, height(outputexcelfile), 1);
    entropyTable.SheetName = sheetNames{s};
    outputexcelfile = 'entropy_table_008_new.xlsx'; %change output number file
    
    %Write the table to Excel
    writetable(entropyTable, outputexcelfile, "WriteMode","append");
    
    % Set the figure to fullscreen mode
    set(gcf, 'Units', 'normalized', 'OuterPosition', [0, 0, 1, 1]);
    
    % Specify the folder where you want to save the figures
    plotfolder = 'D:\IISc_stuffs\Project work\Project files_Data analysis\Part 1 - Metric\Epi\OVCAR3 Data\OVCAR3 - Stiffness\SET 1 - 14.05.2024\19.7kPa\008\plots';  % Replace with the actual path
    
    % Save the figure with the same name as the sheet
    figFilename = ['Entropy_', sheetNames{s}, '.png'];  % Define figure filename
    saveas(gcf, fullfile(plotfolder, figFilename));  % Save the figure
    
    % Close the figure
    close(gcf);
end
