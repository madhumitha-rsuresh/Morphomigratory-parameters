% Excel file and sheet access
cd ('D:\008') %change directory accordingly
inputexcelfile = 'Results_008_working.xlsx'; % change excel sheet file accordingly

% Get the sheet names from the input Excel file
sheetNames = sheetnames(inputexcelfile);

% Loop over each sheet 
for s = 2:length(sheetNames) % start from 2nd sheet, skipping the main raw sheet
   
    % Read data from the current sheet
    data = xlsread(inputexcelfile, sheetNames{s});
    
    % Read the entire table from the specified sheet
    data = readtable(inputexcelfile, 'Sheet', sheetNames(s), 'ReadVariableNames', false, 'Range', 'A:Z', 'HeaderLines', 1);
    
    % Columns and Rows to be extracted
    columnsToExtract = [2:9,13];
    rowstoExtract = 1:size(data,1);
    
    % Read the specified columns into a table
    dataTable = readtable(inputexcelfile, 'Sheet', sheetNames(s), 'ReadVariableNames', false, 'Range', 'A:Z', 'HeaderLines', 1);
    selectedTable = dataTable(rowstoExtract, columnsToExtract);

    % Custom column headers
    customHeaders = {'Time', 'Area', 'CentroidX', 'CentroidY', 'Perimeter', 'MajorAxis', 'MinorAxis', 'MajorAxisangle','Solidity'};

    % Creating a new table with custom headers for the difference columns
    extractedTable = table(selectedTable{:, 1}, selectedTable{:, 2}, selectedTable{:, 3}, -abs(selectedTable{:, 4}), selectedTable{:, 5}, selectedTable{:, 6}, selectedTable{:, 7}, selectedTable{:, 8}, selectedTable{:, 9}, 'VariableNames', customHeaders);

    % ITERATION
    for row = 1:size(extractedTable, 1)
    
        % majoraxis, centroid coordinates 
        majoraxislength = extractedTable.MajorAxis(row);
        CentroidX = extractedTable.CentroidX(row);
        CentroidY = extractedTable.CentroidY(row);
        Mjangle = extractedTable.MajorAxisangle(row);

        % majoraxis endpoints
        mjX1 = CentroidX - (0.5*majoraxislength*cosd(Mjangle));
        mjY1 = CentroidY - (0.5*majoraxislength*sind(Mjangle));
        mjX2 = CentroidX + (0.5*majoraxislength*cosd(Mjangle));
        mjY2 = CentroidY + (0.5*majoraxislength*sind(Mjangle));

        % Majoraxis line vector (direction not important)
        mjX = mjX2 - mjX1;
        mjY = mjY2 - mjY1;
        extractedTable.mjX(row) = mjX;
        extractedTable.mjY(row) = mjY;
    end

    % OBTAINING DISPLACEMENT VECTOR
    % Specify the columns for which you want to calculate differences
    columnsToDiff1 = [3, 4, 8];
    columnsToDiff2 = [3, 4];

    % Calculate differences for the specified columns
    differenceColumns1 = diff(extractedTable{:, columnsToDiff1}); %( nth - (n-1)th row)

    % Add NaN for the 1st row since there's no (n-1)th row for diff1
    differenceColumns1 = [NaN(1, numel(columnsToDiff1)); differenceColumns1];

    % Add the differences as new columns to the original table
    diffColumnNames1 = strcat('DiffCol', arrayfun(@num2str, columnsToDiff1, 'UniformOutput', false));
    extractedTable(:, diffColumnNames1) = array2table(differenceColumns1);

    % Custom column headers
    customHeaders = {'Time', 'Area', 'CentroidX', 'CentroidY', 'Perimeter', 'MajorAxis', 'MinorAxis', 'MajorAxisangle', 'Solidity', ...
    'mjX', 'mjY', 'pdx', 'pdy', 'MAdynamics'};

    % Creating a new table with custom headers for the difference columns 
    % (p - previous (n-1) && s - successive (n+1))
    resultTable = table(extractedTable{:, 1}, extractedTable{:, 2}, extractedTable{:, 3}, extractedTable{:, 4}, ...
        extractedTable{:, 5}, extractedTable{:, 6}, extractedTable{:, 7}, extractedTable{:, 8}, extractedTable{:, 9}, extractedTable{:, 10}, extractedTable{:, 11}, extractedTable{:, 12}, extractedTable{:, 13}, extractedTable{:, 14}, 'VariableNames', customHeaders);

    % Create column names for the new variables
    newColumnNames = {'d2p', 'GTA', 'uMM', 'RTA', 'velocity', 'elongation', 'shapeindex', 'meanvelocity', 'meand2p', 'accumulateddistance', 'euclideandistance', 'persistenceratio', 'meansolidity', 'meanelongation', 'varelongation', 'meanshapeindex', 'maxvelocity', 'meanuMM'};

    % Add NaN columns with the specified names
    resultTable{:, newColumnNames} = NaN(height(resultTable), numel(newColumnNames));

    for i = 2:(height(resultTable)-1)
        resultTable.d2p(i) = sqrt((resultTable.pdx(i)^2)+(resultTable.pdy(i)^2));
        resultTable.GTA(i) = atan2d(resultTable.pdy(i),resultTable.pdx(i));
        pdotproduct = (resultTable.mjX(i)*resultTable.pdx(i+1))+(resultTable.mjY(i)*resultTable.pdy(i+1));
        pdisplacementvectormagnitude = sqrt((resultTable.pdx(i+1)*resultTable.pdx(i+1))+(resultTable.pdy(i+1)*resultTable.pdy(i+1)));
        resultTable.uMM(i) = acosd(pdotproduct/(pdisplacementvectormagnitude*resultTable.MajorAxis(i)));
        if resultTable.uMM(i)>90
            resultTable.uMM(i) = 180 - resultTable.uMM(i); %to get acute angle
        end
        resultTable.uMM(i) = resultTable.uMM(i); 
    end
    
    for i = 2:(height(resultTable)-1)
        dotproductdxdy = ((resultTable.pdx(i)*resultTable.pdx(i+1)) + (resultTable.pdy(i)*resultTable.pdy(i+1)));
        resultTable.RTA(i) = acosd((dotproductdxdy) / (resultTable.d2p(i) * resultTable.d2p(i+1)));
        resultTable.velocity(i) = resultTable.d2p(i) / (resultTable.Time(i) - resultTable.Time(i-1));
        resultTable.elongation(i) = 1 - (resultTable.MinorAxis(i) / resultTable.MajorAxis(i));
        resultTable.shapeindex(i) = (4 * pi * resultTable.Area(i))/(resultTable.Perimeter(i)^2);
    end

    % average and sum calculation
    coordinates = [resultTable.CentroidX,resultTable.CentroidY];
    distances = pdist(coordinates);
    resultTable.euclideandistance(1,1) = round(mean(distances),2);
    resultTable.meanvelocity(1,1) = round(mean(resultTable{:,19},'omitnan'),2);
    resultTable.meand2p(1,1) = round(mean(resultTable{:,15},'omitnan'),2);
    resultTable.accumulateddistance(1,1) = round(sum(resultTable{:,15},'omitnan'),2);
    resultTable.persistenceratio(1,1) = round((resultTable.euclideandistance(1,1)/resultTable.accumulateddistance(1,1)),2);
    resultTable.meansolidity(1,1) = round(mean(resultTable{:,9}),2);
    resultTable.meanelongation(1,1) = round(mean(resultTable{:,20},'omitnan'),2);
    resultTable.varelongation(1,1) = round(var(resultTable{:,20},'omitnan'),3);
    resultTable.meanshapeindex(1,1) = round(mean(resultTable{:,21},'omitnan'),2);
    resultTable.maxvelocity(1,1) = round(max(resultTable{:,19}),2);
    resultTable.meanuMM(1,1) = round(mean(resultTable{:,17}),2);

    % Display the resulting table
    %disp(resultTable);

    % Specify the Excel file name
    outputexcelfile = 'output_parameters_008_new.xlsx'; %change accordingly
    
    %Write the table to Excel
    outputSheetName = ['', sheetNames{s}];
    writetable(resultTable, outputexcelfile, 'Sheet', outputSheetName);
end
