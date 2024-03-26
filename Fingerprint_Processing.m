clc;
clear all;

% Specify the file URLs of the fingerprint images
imageURLs = {
    '/MATLAB Drive/FingerprintImages_Dataset/fingerprint1.jpeg',
    '/MATLAB Drive/FingerprintImages_Dataset/fingerprint2.jpeg',
    '/MATLAB Drive/FingerprintImages_Dataset/fingerprint3.jpg',
    '/MATLAB Drive/FingerprintImages_Dataset/fingerprint4.png',
    '/MATLAB Drive/FingerprintImages_Dataset/fingerprint5.jpeg',
    '/MATLAB Drive/FingerprintImages_Dataset/fingerprint6.jpg',
    '/MATLAB Drive/FingerprintImages_Dataset/fingerprint7.jpeg',
    '/MATLAB Drive/FingerprintImages_Dataset/fingerprint8.jpeg',
    '/MATLAB Drive/FingerprintImages_Dataset/fingerprint9.jpg',
    '/MATLAB Drive/FingerprintImages_Dataset/fingerprint10.jpeg'
};



% Loop through each image URL
for i = 1:numel(imageURLs)
    % Read the current image
    imageURL = imageURLs{i};
    image = imread(imageURL);
    
    % Convert the image to grayscale
    grayscale_image = rgb2gray(image);
    
    % Apply adaptive thresholding to separate foreground and background
    binary_image = imbinarize(grayscale_image);
    
    % Invert the binary image to make the background white and foreground black
    inverted_image = imcomplement(binary_image);
    
    % Remove small objects and fill holes in the inverted image
    filtered_image = bwareaopen(inverted_image, 100);
    filled_image = imfill(filtered_image, 'holes');
    
    % Multiply the filled image with the grayscale image to remove the background
    background_removed_image = grayscale_image .* uint8(filled_image);
    
    % Apply image enhancement techniques (e.g., contrast stretching, histogram equalization, unsharp masking)
    stretched_image = imadjust(background_removed_image, [0.3 0.7], []); % Contrast stretching
    enhanced_image = histeq(stretched_image); % Histogram equalization
    enhanced_image = imsharpen(stretched_image); % Unsharp masking
    
    % Display the original, background-removed, and enhanced images
    figure('Name', ['Image ', num2str(i)]);
    
    subplot(2, 2, 1);
    imshow(image);
    title('Original Image');
    
    subplot(2, 2, 2);
    imshow(background_removed_image);
    title('Background-Removed Image');
    
    subplot(2, 2, 3);
    imshow(enhanced_image);
    title('Enhanced Image');
    
    % Plot and display the histograms of the original and enhanced images
    subplot(2, 2, 4);
    hold on;
    imhist(stretched_image);
    imhist(enhanced_image);
    hold off;
    legend('Contrast-Stretched Image', 'Enhanced Image');
    title('Histograms');
end