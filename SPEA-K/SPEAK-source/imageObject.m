classdef imageObject < handle
    properties
        word 
        file
    end
    
    methods
        function imObj = imageObject(imPath, word)
            tmp = strsplit(word,'.');
            imObj.word = tmp{1};
           
            %imObj.file = strcat(imPath, word);
            imObj.file = fullfile(imPath, word);
        end
    end
end