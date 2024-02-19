% Excel file and sheet access
cd ('D:\IISc_stuffs\Project files_Data analysis\Part 5 - Metric\Aurox\OVCAR3_Aurox_2hrsevery2mins\on collagen_2hrsevery2mins\Collagen_1mgml_20.12.23_Aurox_2hrsevery2mins_set1\crop1')
excelFile = 'output_parameters_001.xlsx';
sheetName = 'object6';

% Specify the range to include header row
dataRange = 'A:W';  % Adjust this based on your actual range

% Read the table with correct headers
resultTable = readtable(excelFile, 'Sheet', sheetName, 'Range', dataRange);

% Plots
figure;
t = tiledlayout(2, 3, 'TileSpacing', 'compact');

% Create displacaement vector plot
ax1 = nexttile;
h1 = plot(resultTable.Time, resultTable.disp_angle, '-o');
ylim([-180,180]);
ylabel('Disp. vector Angle');
xlabel('Time (min)');
title('Disp. vector Angle distribution');

% Create MA dynamics plot
ax2 = nexttile;
h2 = plot(resultTable.Time, resultTable.MAdynamics,'-o');
ylim([-50,50]);
ylabel('Angle');
xlabel('Time (min)');
title('MA Dynamics distribution');

% Create MA and displacament vector plot
ax3 = nexttile;
h3 = plot(resultTable.Time, resultTable.MA_disp_angle, '-o');
ylim([0,90]);
ylabel('MA and disp. angle');
xlabel('Time (min)');
title('MA and Disp. vector angle distribution');

% Create Turning angle plot
ax4 = nexttile;
h4 = plot(resultTable.Time, resultTable.turningangle, '-o');
ylim([0,180]);
ylabel('Turning angle');
xlabel('Time (min)');
title('Turning angle distribution');

% Create elongation plot
ax5 = nexttile;
h5 = plot(resultTable.Time, resultTable.elongation, '-o');
ylim([0,1]);
ylabel('Elongation');
xlabel('Time (min)');
title('Elongation distribution');

% Create velocity plot
ax6 = nexttile;
h6 = plot(resultTable.Time, resultTable.velocity, '-o');
ylim([0,3]);
ylabel('Velocity');
xlabel('Time (min)');
title('Velocity distribution');

% % Create shape index plot
% ax7 = nexttile;
% h7 = plot(resultTable.Time, resultTable.shapeindex, '-o');
% ylim(ax7,[0,1]);
% ylabel('Shape index');
% xlabel('Time');
% title('Shapeindex distribution');

% Set the figure to fullscreen mode
set(gcf, 'Units', 'normalized', 'OuterPosition', [0, 0, 1, 1]);

% Specify the folder where you want to save the figures
plotfolder = 'D:\IISc_stuffs\Project files_Data analysis\Part 5 - Metric\Aurox\OVCAR3_Aurox_2hrsevery2mins\on collagen_2hrsevery2mins\Collagen_1mgml_20.12.23_Aurox_2hrsevery2mins_set1\crop1\plots_new';  % Replace with the actual path

% Save the figure inside the specified folder
saveas(gcf, fullfile(plotfolder, 'parameterplot_object_06.png'));

% Close the figure
close(gcf);
