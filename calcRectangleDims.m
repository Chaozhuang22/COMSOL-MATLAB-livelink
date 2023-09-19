function geometrySpecs = calcRectangleDims(edgeLength, aspectRatio, position)
    area = edgeLength^2; % Calculate the area of the rectangle

    % Preallocate memory for the output cell array for efficiency
    geometrySpecs = cell(numel(aspectRatio)*numel(position), 3);
    counter = 1; % Index counter for filling the output cell array

    % Iterate over each aspect ratio
    for i = 1:numel(aspectRatio)
        % Calculate the length and width for the current aspect ratio
        length = sqrt(area*aspectRatio(i));
        width = area/length;

        % Iterate over each position
        for j = 1:numel(position)
            % Save the calculated length, width, and current position to the output matrix
            % Convert the numeric values to strings and append the units
            geometrySpecs(counter, :) = {strcat(num2str(length), ' [um]'), strcat(num2str(width), ' [um]'), num2str(position(j))};
            counter = counter + 1;
        end
    end
end
