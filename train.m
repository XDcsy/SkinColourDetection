
function[] = train()
    global skinPixels nonskinPixels numTable SPM quantizationTable;
    skinPixels = 0;
    nonskinPixels = 0;
    numTable(2, 1:32, 1:32, 1:32) = 0;
    SPM(1:32, 1:32, 1:32) = 0;
    quantizationTable = linspace(1,1,8);
	for i = 2 : 32
        quantizationTable = [quantizationTable, linspace(i,i,8)];
    end

    files = dir('*_skin.tif');
	for i = 1 : length(files)
        s = files(i).name;
        img = imread(s);
		skinPixels = skinPixels + recordPixels(img, 1);
	end
	
    files = dir('*_nonskin.tif');
	for i = 1 : length(files)
        s = files(i).name;
        img = imread(s);
        nonskinPixels = nonskinPixels + recordPixels(img, 2);
	end

    creatSPM();
	save SPM SPM;
end

function[pixelNum] = recordPixels(img, n)  %n==1:skin n==2:nonskin
    global numTable;
    colourPixels = img(:,:,4) ~= 0;
    [x,y] = size(colourPixels);
    img = changeTo32Level(img, x, y);
    pixelNum = sum(sum(colourPixels));
    for j = 1:x
        for k = 1:y
            if colourPixels(j,k) ~= 0
                R = img(j,k,1);
                G = img(j,k,2);
                B = img(j,k,3);
                numTable(n, R, G, B) = numTable(n, R, G, B) + 1;
            end
        end
    end
end

function[] = creatSPM()
    global numTable SPM skinPixels nonskinPixels;
    Pskin = skinPixels/(skinPixels + nonskinPixels);
    Pnonskin = nonskinPixels/(skinPixels + nonskinPixels);
    for R = 1 : 32
        for G = 1 : 32
            for B = 1 : 32
                Pcskin = numTable(1, R, G, B)/skinPixels;
                Pcnonskin = numTable(2, R, G, B)/nonskinPixels;
                p1 = Pcskin*Pskin;
				p2 = Pcnonskin/Pnonskin;
				if p1~=0 && p2~=0
				    SPM(R, G, B) = p1 / p2;
				end
            end
        end
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
