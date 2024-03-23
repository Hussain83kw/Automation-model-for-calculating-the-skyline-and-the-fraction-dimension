% Function 1: Read Image and Convert to Grayscale
A = imread(imagePath);
B = rgb2gray(A);

% Function 2: Extract Edges
K = edge(B, 'canny');

% Function 3: Convert Image to Double-Precision and Binarize
C = im2double(B);
D = double(K);
img_bw = imbinarize(B);

% Function 4: Extract Skyline
skyline = bwmorph(img_bw, 'thin', Inf);
skyline = im2uint8(skyline);

% Function 5: Extract Horizon
co = 150;
Margin = 3;
Edges = bwboundaries(img_bw);
SkyLine = zeros(size(img_bw));
Boundary = Edges{1};
SkyLine(sub2ind(size(SkyLine), Boundary(:,1), Boundary(:,2))) = 1;
SkyLine(1:Margin, :) = 0;
SkyLine(end-Margin+1:end, :) = 0;
SkyLine(:, 1:Margin) = 0;
SkyLine(:, end-Margin+1:end) = 0;
SkyLine(co, :) = 0;
SkyLine(:, co) = 0;
img_bw = imbinarize(SkyLine);

% Function 6: Compute Overall Fractal Dimension
[N, R] = boxcount(img_bw);
FD = -diff(log(N))./diff(log(R));

% Function 7: Compute Detailed Fractal Dimension
[boxCounts, boxSizes] = boxcount(A);
coefficients = polyfit(log(boxSizes), log(boxCounts), 1);
fractalDimension2 = coefficients(1);

% Function 8: Display Fractal Dimension Results in a Plot
figure;
plot(FD, 'LineWidth', 2);
xlabel('Number of Values');
ylabel('Fractal Dimension (FD)');
title('Fractal Dimension Plot');

% Function 9: Display Images in a Single Window
figure;
subplot(2,2,1);
imshow(A);
title('Original Image');
subplot(2,2,2);
imshow(B);
title('Grayscale Image');
subplot(2,2,3);
imshow(K);
title('Edge Detection Result');
subplot(2,2,4);
imshow(SkyLine);
title('Skyline Result');

% Automatic Classification of Skyline Complexity and Visual Pollution Level
if co >= 0 && co < 150
    complexity = 'Simple Complexity';
elseif co >= 150 && co < 200
    complexity = 'Moderate Complexity';
else
    complexity = 'High Complexity';
end

if fractalDimension2 >= 1 && fractalDimension2 <= 1.2
    visualPollution = 'Low Visual Pollution';
elseif fractalDimension2 > 1.2 && fractalDimension2 <= 1.5
    visualPollution = 'Moderate Visual Pollution';
else
    visualPollution = 'High Visual Pollution Level';
end

% Display Classification Results
disp(['Skyline Complexity Classification: ' complexity]);
disp(['Visual Pollution Level Classification: ' visualPollution]);
