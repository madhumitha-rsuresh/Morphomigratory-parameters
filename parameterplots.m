% Excel file and sheet access
cd ('D:\008')
inputexcelfile = 'output_parameters_008_new.xlsx';

% Get the sheet names from the input Excel file
sheetNames = sheetnames(inputexcelfile);

% Loop over each sheet
for s = 1:length(sheetNames)
   
    % Read data from the current sheet
    data = xlsread(inputexcelfile, sheetNames{s});

    % Specify the range to include header row
    dataRange = 'A:V';  % Adjust this based on your actual range

    % Read the table with correct headers
    resultTable = readtable(inputexcelfile, 'Sheet', sheetNames(s), 'Range', dataRange);
    
    % PLOTS CONSTRUCTION
    figure;
    t = tiledlayout(3, 3, 'TileSpacing', 'compact');

    % Create GTA plot
    ax1 = nexttile;
    h1 = plot(resultTable.Time, resultTable.GTA, '-o');
    ylim([-180,180]);
    ylabel('GTA');
    xlabel('Time (min)');
    title('GTA distribution');
    
    % Create MA dynamics plot
    ax2 = nexttile;
    h2 = plot(resultTable.Time, resultTable.MAdynamics,'-o');
    ylim([-50,50]);
    ylabel('Angle');
    xlabel('Time (min)');
    title('MA Dynamics distribution');
    
    % Create MA and displacament vector (uMM angle) plot
    ax3 = nexttile;
    h3 = plot(resultTable.Time, resultTable.uMM, '-o');
    ylim([0,90]);
    ylabel('uMM angle');
    xlabel('Time (min)');
    title('uMM angle distribution');
    
    % Create Relative Turning angle plot
    ax4 = nexttile;
    h4 = plot(resultTable.Time, resultTable.RTA, '-o');
    ylim([0,180]);
    ylabel('RTA');
    xlabel('Time (min)');
    title('RTA distribution');
    
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
    
    % Create shape index plot
    ax7 = nexttile;
    h7 = plot(resultTable.Time, resultTable.shapeindex, '-o');
    ylim(ax7,[0,1]);
    ylabel('Shape index');
    xlabel('Time (min)');
    title('Shapeindex distribution');
    
    % Create solidity plot
    ax8 = nexttile;
    h8 = plot(resultTable.Time, resultTable.Solidity, '-o');
    ylim(ax8,[0,1]);
    ylabel('Solidity');
    xlabel('Time (min)');
    title('Solidity distribution');
    
    % Set the figure to fullscreen mode
    set(gcf, 'Units', 'normalized', 'OuterPosition', [0, 0, 1, 1]);
    
    % Specify the folder where you want to save the figures
    plotfolder = 'D:\008\plots';  % Replace with the actual path
    
    % Save the figure with the same name as the sheet
    figFilename = ['Plot_', sheetNames{s}, '.png'];  % Define figure filename
    saveas(gcf, fullfile(plotfolder, figFilename));  % Save the figure
    
    % Close the figure
    close(gcf);
end
