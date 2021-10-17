function deepcheck()
tic
clear y Fs;
load squeez_Datase_edge.mat;
net=trainedNetwork_1;
sz=net.Layers(1).InputSize;
InputImage=imread('nok.png');
InputImage=InputImage(:,:,1:3);
imshow(InputImage);
rgbImage=InputImage;
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
drawnow;
% Get the dimensions of the image.  numberOfColorBands should be = 3.
[rows, columns, numberOfColorBands] = size(rgbImage);
%==========================================================================
% The first way to divide an image up into blocks is by using mat2cell().
blockSizeR = 34; % Rows in block.
blockSizeC = 12; % Columns in block.
% Figure out the size of each block in rows. 
% Most will be blockSizeR but there may be a remainder amount of less than that.
wholeBlockRows = floor(rows / blockSizeR);
blockVectorR = [blockSizeR * ones(1, wholeBlockRows), rem(rows, blockSizeR)];
% Figure out the size of each block in columns. 
wholeBlockCols = floor(columns / blockSizeC);
blockVectorC = [blockSizeC * ones(1, wholeBlockCols), rem(columns, blockSizeC)];
% Create the cell array, ca.  
% Each cell (except for the remainder cells at the end of the image)
% in the array contains a blockSizeR by blockSizeC by 3 color array.
% This line is where the image is actually divided up into blocks.
if numberOfColorBands > 1
  % It's a color image.
  ca = mat2cell(rgbImage, blockVectorR, blockVectorC, numberOfColorBands);
else
  ca = mat2cell(rgbImage, blockVectorR, blockVectorC);
end
% Now display all the blocks.
plotIndex = 1;
numPlotsR = size(ca, 1);
numPlotsC = size(ca, 2);
for r = 1 : numPlotsR
  for c = 1 : numPlotsC
       tic
   % fprintf('plotindex = %d,   c=%d, r=%d\n', plotIndex, c, r);
    % Specify the location for display of the image.
   % subplot(numPlotsR, numPlotsC, plotIndex);
    % Extract the numerical array out of the cell
    % just for tutorial purposes.
    rgbBlock = ca{r,c};
    rgbBlock=imresize(rgbBlock,sz(1:2));
    [labels,score]=classify(net, rgbBlock);
   % score(1)
   if score(1)>=0.65
       fprintf('score = %d,   label=%d', score(1), labels);
   end
   % imshow(rgbBlock); % Could call imshow(ca{r,c}) if you wanted to.
    %[rowsB, columnsB, numberOfColorBandsB] = size(rgbBlock);
    % Make the caption the block number.
    %caption = sprintf('Block #%d of %d\n%d rows by %d columns', ...
     % plotIndex, numPlotsR*numPlotsC, rowsB, columnsB);
    %title(caption);
   % drawnow;
    % Increment the subplot to the next location.
    plotIndex = plotIndex + 1;
  end
end
    toc
% Display the original image in the upper left.
subplot(4, 6, 1);
imshow(rgbImage);
title('Original Image');
end