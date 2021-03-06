function [R, t] = get_extrinsics(node, params, imgUndistorted, newOrigin, worldPoints)
    [imagePoints, boardSize] = detectCheckerboardPoints(imgUndistorted);
    imagePoints = imagePoints + newOrigin;
    [R, t] = extrinsics(imagePoints, worldPoints, params);
end
