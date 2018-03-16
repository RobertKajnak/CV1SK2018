image1 = 'left.jpg';
image2 = 'right.jpg';

figure('name','Aligning left.jpg with right.jpg');
stitched = stitch(image2,image1);
imshow(stitched);

figure('name','Aligning right.jpg with left.jpg');
stitched = stitch(image1,image2);
imshow(stitched);