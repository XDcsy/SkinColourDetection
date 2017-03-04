
function[] = train()
    global skinPixels, nonskinPixels, numTable, SPM, quantizationTable;
    skinPixels = 0;
    nonskinPixels = 0;
    numTable(2, 1:32, 1:32, 1:32) = 0;
    SPM(1:32, 1:32, 1:32) = 0;
    for i = 1 : 256
        quantizationTable(i) = floor((i-1)/8) + 1;
    end

    files = dir('*_skin.jpg');
    skinPixels = skinPixels + recordPixels(files, 1);
    files = dir('*_nonskin.jpg');
    nonskinPixels = skinPixels + recordPixels(files, 2);

    creatSPM();
end

function[pixelNum] = recordPixels(files, n)  %n==1:skin n==2:nonskin
    global numTable;
    for i = 1 : length(files)
        s = files(i).name;
        img = imread(s);
        colourPixels = img(:,:,1) ~= 0 & img(:,:,2) ~= 0 & img(:,:,3) ~= 0;
        [x,y] = size(colourPixels);
        img = changeQuantizationLevel(img, x, y);
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
end

function[] = creatSPM()
    global numTable, SPM, skinPixels, nonskinPixels;
    Pskin = skinPixels/(skinPixels + nonskinPixels);
    Pnonskin = nonskinPixels/(skinPixels + nonskinPixels);
    for R = 1 : 32
        for G = 1 : 32
            for B = 1 : 32
                Pcskin = numTable(1, R, G, B)/skinskinPixels;
                Pcnonskin = numTable(2, R, G, B)/nonskinskinPixels;
                SPM(R, G, B) = (Pcskin*Pskin) / (Pcnonskin/Pnonskin);
            end
        end
    end
end

function[img] = changeQuantizationLevel(img, x, y)
    global quantizationTable;
    for i = 1:x
        for j = 1:y
            img(i,j,1) = quantizationTable(img(i,j,1));
            img(i,j,2) = quantizationTable(img(i,j,2));
            img(i,j,3) = quantizationTable(img(i,j,3));
        end
    end
end
