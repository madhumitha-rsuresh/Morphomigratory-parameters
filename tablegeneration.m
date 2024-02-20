% Excel file and sheet accewss
cd ('D:\IISc_stuffs\Project files_Data analysis\Part 5 - Metric\Aurox\OVCAR3_Aurox_2hrsevery2mins\on collagen_2hrsevery2mins\Collagen_1mgml_20.12.23_Aurox_2hrsevery2mins_set1\crop1')
excelFile = 'Results_001_working.xlsx';
sheetName = 'object1';

% Read the entire table from the specified sheet
data = readtable(excelFile, 'Sheet', sheetName, 'ReadVariableNames', false, 'Range', 'A:Z', 'HeaderLines', 1);

% Columns and Rows to be extracted
columnsToExtract = [2:9,13];
rowstoExtract = 1:size(data,1);

% Read the specified columns into a table
dataTable = readtable(excelFile, 'Sheet', sheetName, 'ReadVariableNames', ...
            false, 'Range', 'A:Z', 'HeaderLines', 1);
selectedTable = dataTable(rowstoExtract, columnsToExtract);

% Custom column headers
customHeaders = {'Time', 'Area', 'CentroidX', 'CentroidY', 'Perimeter', 'MajorAxis', 'MinorAxis', 'MajorAxisangle', 'Solidity'};

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
differenceColumns2 = diff(extractedTable{:, columnsToDiff2}, 1, 1); % ( (n+1)th - (n)th row)

% Add NaN for the 1st row since there's no (n-1)th row for diff1
% and add NaN to the last row since there is no (n+1)th row for diff2
differenceColumns1 = [NaN(1, numel(columnsToDiff1)); differenceColumns1];
differenceColumns2 = [differenceColumns2; NaN(1, numel(columnsToDiff2))];

% Add the differences as new columns to the original table
diffColumnNames1 = strcat('DiffCol', arrayfun(@num2str, columnsToDiff1, 'UniformOutput', false));
extractedTable(:, diffColumnNames1) = array2table(differenceColumns1);
diffColumnNames2 = strcat('DiffColNext', arrayfun(@num2str, columnsToDiff2, 'UniformOutput', false));
extractedTable(:, diffColumnNames2) = array2table(differenceColumns2);

% Custom column headers
customHeaders = {'Time', 'Area', 'CentroidX', 'CentroidY', 'Perimeter', 'MajorAxis', 'MinorAxis', 'MajorAxisangle', ...
    'mjX', 'mjY', 'pdx', 'pdy', 'MAdynamics', 'sdx', 'sdy'};

% Creating a new table with custom headers for the difference columns 
% (p - previous (n-1) && s - successive (n+1))
resultTable = table(extractedTable{:, 1}, extractedTable{:, 2}, extractedTable{:, 3}, extractedTable{:, 4}, ...
    extractedTable{:, 5}, extractedTable{:, 6}, extractedTable{:, 7}, extractedTable{:, 8}, extractedTable{:, 9}, extractedTable{:, 10}, extractedTable{:, 11}, extractedTable{:, 12}, extractedTable{:, 13}, extractedTable{:, 14} differenceColumns2(:, 1), differenceColumns2(:, 2), 'VariableNames', customHeaders);

for i = 1:(height(resultTable))
    resultTable.d2p(i) = sqrt((resultTable.pdx(i)^2)+(resultTable.pdy(i)^2));
    resultTable.disp_angle(i) = atan2d(resultTable.pdy(i),resultTable.pdx(i));
    sdotproduct = (resultTable.mjX(i)*resultTable.sdx(i))+(resultTable.mjY(i)*resultTable.sdy(i));
    sdisplacementvectormagnitude = sqrt((resultTable.sdx(i)*resultTable.sdx(i))+(resultTable.sdy(i)*resultTable.sdy(i)));
    resultTable.MA_disp_angle(i) = acosd(sdotproduct/(sdisplacementvectormagnitude*resultTable.MajorAxis(i)));
    if resultTable.MA_disp_angle(i)>90
        resultTable.MA_disp_angle(i) = 180 - resultTable.MA_disp_angle(i); %to get acute angle
    end
    resultTable.MA_disp_angle(i) = resultTable.MA_disp_angle(i); 
end

for i = 2:(height(resultTable))   
    dotproductpdxpdy = (resultTable.pdx(i-1)*resultTable.pdx(i) + resultTable.pdy(i-1)*resultTable.pdy(i));
    resultTable.turningangle(i-1) = acosd((dotproductpdxpdy) / (resultTable.d2p(i-1) * resultTable.d2p(i)));
    resultTable.velocity(i-1) = resultTable.d2p(i-1) / (resultTable.Time(i) - resultTable.Time(i-1));
    resultTable.elongation(i-1) = 1 - (resultTable.MinorAxis(i-1) / resultTable.MajorAxis(i-1));
    resultTable.shapeindex(i-1) = (resultTable.Perimeter(i-1)^2) / (4 * pi * resultTable.Area(i-1));
end

% average and sum calculation
subdata = resultTable(:,[9,17,21]);
resultTable.meanvelocity = NaN(height(resultTable), 1);
resultTable.meand2p = NaN(height(resultTable), 1);
resultTable.accumulateddistance = NaN(height(resultTable), 1);
resultTable.meansolidity = NaN(height(resultTable), 1);
resultTable.meanvelocity(1,1) = mean(subdata{:,3},'omitnan');
resultTable.meand2p(1,1) = mean(subdata{:,2},'omitnan');
resultTable.accumulateddistance(1,1) = sum(subdata{:,2},'omitnan');
resultTable.meansolidity(1,1) = mean(subdata{:,3});

% Display the resulting table
%disp(resultTable);

% Specify the Excel file name
 outputExcelFile = 'output_parameters_001.xlsx';

% Specify the sheet name
sheetName = 'object1';

% Write the table to Excel
writetable(resultTable, outputExcelFile, 'Sheet', sheetName);
