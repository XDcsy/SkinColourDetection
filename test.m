function[] = test()
    global quantizationTable;
    quantizationTable = linspace(1,1,8);
	for i = 2 : 32
        quantizationTable = [quantizationTable, linspace(i,i,8)];
    end
	
	load SPM;
	files = dir('*.jpg');
	for i = 1 : length(files)
        s = files(i).name;
        img = imread(s);
		[x,y] = size(img(:,:,1));
		img = changeTo32Level(img, x, y);
		img = detect(img, SPM, x, y);
		imwrite(img, [num2str(i),'.jpg']);
	end
end
		
		

function[img] = changeTo32Level(img, x, y)
    global quantizationTable;
    for i = 1:x
        for j = 1:y
            img(i,j,1) = quantizationTable(img(i,j,1)+1);
            img(i,j,2) = quantizationTable(img(i,j,2)+1);
            img(i,j,3) = quantizationTable(img(i,j,3)+1);
        end
    end
end

function[img] = detect(img, SPM, x, y)
    for i = 1:x
        for j = 1:y
		    if SPM(img(i,j,1),img(i,j,2),img(i,j,3)) >= 0.8  %The threshold. Set it higher to be more exact but may cause more miss
			    img(i,j,1:3) = 255;
			else img(i,j,1:3) = 0;
            end
		end
	end
end
