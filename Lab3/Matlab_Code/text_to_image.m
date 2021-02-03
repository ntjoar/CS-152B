function [ image_val ] = text_to_image(text_filename, w, h)
    I1 = dlmread(text_filename);

    % Change image ratios here
    image_val = uint8(reshape(I1, [w, h]));
    
    imshow(image_val);
    imwrite(image_val , 'filtered_image.jpeg');
end