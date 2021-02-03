function [ noise_image ] = add_noise( image , black, white , range, w, h)

    % Detailed explanation goes here
    g_image = rgb2gray(image);
    imwrite(g_image , 'grey_image.jpeg');
    
    [ y , x ] = size(g_image);
    random_value = randi([0 range], y , x);
    noise_image = g_image;

    for i = 1 : y
        for j = 1 : x
            if ( random_value(i , j) <= black )
                noise_image(i , j) = 0;
            end
            if ( random_value(i , j) >= white )
                noise_image (i , j) = range;
            end
        end
    end

    nn_image = noise_image';
    n_image = nn_image(:)';
    
    figure(1); imshow(noise_image);
    imwrite(noise_image , 'noisy_image.jpeg');
    
    % Change ratio size here
    nn_image = reshape(n_image , [1, w*h]); 
    dlmwrite('noisy_image.text' , nn_image);
end