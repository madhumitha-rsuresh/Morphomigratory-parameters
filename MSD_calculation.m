% Excel file and sheet access
cd('D:\008')
inputexcelfile = 'Results_008_working.xlsx';

% Get the sheet names from the input Excel file
sheetNames = sheetnames(inputexcelfile);

% Loop over each sheet
for s = 2:length(sheetNames)
   
    % Read data from the current sheet
    data = readtable(inputexcelfile, 'Sheet', sheetNames{s}, 'ReadVariableNames', false, 'Range', 'A:Z', 'HeaderLines', 1);
    
    % Check if the sheet has at least 91 rows
    if height(data) < 91
        disp(['Skipping sheet ' sheetNames{s} ' because it does not have 91 rows.']);
        continue;  % Skip to the next sheet
    end
    
    % Extract columns
    time = data{:, 2};      % Time column
    x = data{:, 4};         % X coordinate
    y = -data{:, 5};        % Y coordinate
    majoraxis = data{:, 7}; % Major axis
    minoraxis = data{:, 8}; % Minor axis
    
    % Step sizes in minutes
    step_sizes = (2:2:60);
    
    % Convert step sizes to row intervals (assuming 2-minute intervals in data)
    time_interval = 2; % Minutes between each row
    
    % Initialize arrays to store mean squared velocities and displacements for each step size
    mean_squared_velocities = zeros(length(step_sizes), 1);
    mean_squared_displacements = zeros(length(step_sizes), 1);
    root_mean_squared_GTA = zeros(length(step_sizes), 1);
    root_mean_squared_RTA = zeros(length(step_sizes), 1);
    root_mean_squared_elongation = zeros(length(step_sizes), 1);
    
    for k = 1:length(step_sizes)
        step_size = step_sizes(k);
        row_interval = step_size / time_interval;
    
        % Initialize arrays to store squared velocities and displacements for the current starting point
        squared_velocities = [];
        squared_displacements = [];
        squared_GTA = [];
        squared_RTA = [];
        squared_elongation = [];
            
        % Loop over each data point to calculate velocity, displacement, and their square
        for i = 1:(length(time) - row_interval)
            % Calculate displacement
            dx = x(i + row_interval) - x(i);
            dy = y(i + row_interval) - y(i);
            displacement = sqrt(dx^2 + dy^2);
            GTA = atan2d(dy, dx);
                
            % Calculate velocity
            velocity = displacement / step_size;  % step_size is the current step size
                
            % Calculate elongation
            elongation = 1 - (minoraxis(i) / majoraxis(i));
                
            % Store squared velocity, displacement, GTA, and elongation
            squared_velocities(end + 1) = velocity^2; 
            squared_displacements(end + 1) = displacement^2;
            squared_GTA(end + 1) = GTA^2;
            squared_elongation(end + 1) = elongation^2;
        end

        % Calculate RTA
        for j = 1:(length(time) - 2*row_interval)
            dx1 = x(j + row_interval) - x(j);
            dy1 = y(j + row_interval) - y(j);
            dx2 = x(j + 2 * row_interval) - x(j + row_interval);
            dy2 = y(j + 2 * row_interval) - y(j + row_interval);
            
            dot_product = dx1 * dx2 + dy1 * dy2;
            magnitude1 = sqrt(dx1^2 + dy1^2);
            magnitude2 = sqrt(dx2^2 + dy2^2);
            RTA = acosd(dot_product / (magnitude1 * magnitude2));
            
            squared_RTA(end + 1) = RTA^2;
        end

        % Calculate mean squared values and RMS for GTA, RTA, and elongation
        if ~isempty(squared_velocities)
            mean_squared_velocities(k) = mean(squared_velocities);
            mean_squared_displacements(k) = mean(squared_displacements);
            root_mean_squared_GTA(k) = sqrt(mean(squared_GTA));
            root_mean_squared_RTA(k) = sqrt(mean(squared_RTA));
            root_mean_squared_elongation(k) = sqrt(mean(squared_elongation));
        else
            mean_squared_velocities(k) = NaN;  % Handle cases where no velocities are calculated
            mean_squared_displacements(k) = NaN;  % Handle cases where no displacements are calculated
            root_mean_squared_GTA(k) = NaN;
            root_mean_squared_RTA(k) = NaN;
            root_mean_squared_elongation(k) = NaN;
        end
    end
    
    % Prepare data for writing to Excel
    output_data = table(step_sizes', mean_squared_displacements, mean_squared_velocities, root_mean_squared_GTA, root_mean_squared_RTA, root_mean_squared_elongation, ...
        'VariableNames', {'Step_Size_Minutes', 'MSD', 'MSV', 'RMS(GTA)', 'RMS(RTA)', 'RMS(Elongation)'});

    % Specify output Excel file name
    outputexcelfile = 'MSV_MSD_008.xlsx';

    % Write the table to Excel
    outputSheetName = sheetNames{s};
    writetable(output_data, outputexcelfile, 'Sheet', outputSheetName);
end
