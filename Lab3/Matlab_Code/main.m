white = 255;
black = 0;
range = 255;
width = 410;
height = 361;
% Change this for different images
image = imread('sample.bmp');

add_noise(image, black, white, range, width, height);

text_to_image('filtered_image.text', width, height);