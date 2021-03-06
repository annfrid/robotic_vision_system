function [cameraParams, worldPoints] = get_intrinsics(node, folder, checkerboardSize, squareSize)
    calib_imgs = load_imgs(folder);
    
    %Detect checkerboard corners in images
    [imgPoints, boardSize] = detectCheckerboardPoints(calib_imgs);
    if ~isequal(boardSize, checkerboardSize)
        error("Detected board size not correct. Detected: %dx%d, expected: %dx%d. Calibration data not representative.", ...
            boardSize(1), boardSize(2), checkerboardSize(1), checkerboardSize(2))
    end
    
    %Generate the world coordinates of the checkerboard corners in the
    %pattern-centric coordinate system, with the upper-left corner at (0,0)
    worldPoints = generateCheckerboardPoints(boardSize, squareSize);

    %Calibrate camera
    I = imread(calib_imgs{1});
    imgSize = [size(I, 1), size(I, 2)];
    cameraParams = estimateCameraParameters(imgPoints, worldPoints, 'ImageSize', imgSize);
    
    %% Figures
    %Evaluate calibration accuracy
%     figure(1); showReprojectionErrors(cameraParams);
%     title('Reprojection Errors');
%     
%     %Visualize camera extrinsics
%     figure(2);
%     showExtrinsics(cameraParams);
%     drawnow;
% 
%     %Plot detected and reprojected points
%     figure(3); 
%     imshow(calib_imgs{1}); 
%     hold on;
%     plot(imgPoints(:,1,1), imgPoints(:,2,1),'go');
%     plot(cameraParams.ReprojectedPoints(:,1,1),cameraParams.ReprojectedPoints(:,2,1),'r+');
%     legend('Detected Points','Reprojected Points');
%     hold off;
end

function imgArray = load_imgs(folder)
    %Number of images in directory
    numImgs = numel(dir(fullfile(folder, '*.png')));
    %Create cell array for holding calibration images
    imgArray = cell(1, numImgs);
    for i = 1:numImgs
        imgArray{i} = fullfile(folder, sprintf('image%d.png', i));
    end
end