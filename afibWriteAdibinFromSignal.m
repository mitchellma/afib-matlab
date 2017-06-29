%This script tests function "writeAdibinFromSignal" which creates an
%.adibin file from signal in Matlab format.

%change path to folder containing this function, and
%writeAdibinFromSignal.m and catpad.m
addpath('C:\cygwin64\home\mma\E4Data\');

%Change this path to the folder contain the unzipped E4 files
inputPath = 'C:\cygwin64\home\mma\E4Data\device_data\';

d = dir(inputPath);
isub = [d(:).isdir]; %# returns logical vector
inputDirArray = {d(isub).name}';
inputDirArray(ismember(inputDirArray,{'.','..'})) = [];

for i=1:numel(inputDirArray)
    generateAdibin(char(inputDirArray(i)));
end

function generateAdibin (dir)

    %Here is a path to an unzipped E4 folder within the folder of E4 data,
    %so change this to match input path
    filePath = strcat('C:\cygwin64\home\mma\E4Data\device_data\', dir,'\');

    %The path should be to a folder that you want to store the adibin files
    outputPath = strcat('C:\cygwin64\home\mma\E4Data\output_data\', dir);

    %The adibin created has the same name as the E4 unzipped folder
    outputFileName = strcat(outputPath, '.adibin');

    %An array is read from each E4 .csv to generate a channel in the
    %LabChart
    bvpArray = csvread(strcat(filePath, 'BVP.csv'));
        timeStamp = bvpArray(1,1);
        t = datetime(timeStamp , 'ConvertFrom','posixtime');
        dateVec = datevec(t);
        fs = bvpArray(2,1);
        dataBvpArray = bvpArray(3:end, 1);
    
    %these are used to upsample channels to match the bvp which has the
    %highest sample rate.
    sampleSize = length(dataBvpArray);
    halfSize = ceil(sampleSize/2);
    sixteenthSize = ceil(sampleSize/16);

    accelArray = csvread(strcat(filePath, 'ACC.csv'));
        if (accelArray(1,1) ~= timeStamp)
            fprintf('Recorded Time Mismatch');
        end
        
        accelArray = accelArray(3:end, :);
        
        if (length(accelArray) < halfSize)
            %Use padarray after license renewal and Image Processing
            %Toolbox is added
            %accelArray = padarray(accelArray, halfSize, 0, 'post');
            accelArray = cat(1, accelArray, zeros(halfSize - length(accelArray), 3));
        end
        
        dataAccelArrayX = interp(accelArray(:, 1), 2, 7, 0.6);
        dataAccelArrayY = interp(accelArray(:, 2), 2, 7, 0.6);
        dataAccelArrayZ = interp(accelArray(:, 3), 2, 7, 0.6);

    tempArray = csvread(strcat(filePath, 'TEMP.csv'));  
        if (tempArray(1,1) ~= timeStamp)
            fprintf('Recorded Time Mismatch');
        end
        
    tempArray = tempArray(3:end, 1);
    
        if (length(tempArray) < sixteenthSize)
            %tempArray = padarray(tempArray, sixteenthSize, 0, 'post');
            tempArray = cat(1, tempArray, zeros(sixteenthSize - length(tempArray), 1));
        end
        dataTempArray = interp(tempArray, 16, 7, 0.5);

    gsrArray = csvread(strcat(filePath, 'EDA.csv'));  
        if (gsrArray(1,1) ~= timeStamp)
            fprintf('Recorded Time Mismatch');
        end
        
    gsrArray = gsrArray(3:end, 1);
    
        if (length(gsrArray) < sixteenthSize)
            %gsrArray = padarray(gsrArray, sixteenthSize, 0, 'post');
            gsrArray = cat(1, gsrArray, zeros(sixteenthSize - length(gsrArray), 1));
        end
        dataGsrArray = interp(gsrArray, 16, 8, 0.6);

    concatArray = catpad(2, dataBvpArray, dataAccelArrayX(1:length(dataBvpArray),:), ...
        dataAccelArrayY(1:length(dataBvpArray),:), dataAccelArrayZ(1:length(dataBvpArray),:), ...
        dataTempArray(1:length(dataBvpArray),:), dataGsrArray(1:length(dataBvpArray),:));
    %concatArray = catpad(2, dataBvpArray, dataAccelArray, dataTempArray, dataGsrArray);
    
    %channel title and units name should be converted to ASCII and 32*1
    %vectors by adding zeros
    chanTitle{1} = [double('BloodVolPulse')'; zeros(32-length('BloodVolPulse'), 1)];
    UnitsName{1} = [double('')'; zeros(32-length(''), 1)];

    chanTitle{2} = [double('AccelX')'; zeros(32-length('AccelX'), 1)];
    UnitsName{2} = [double('1/64g')'; zeros(32-length('1/64g'), 1)];

    chanTitle{3} = [double('AccelY')'; zeros(32-length('AccelY'), 1)];
    UnitsName{3} = [double('1/64g')'; zeros(32-length('1/64g'), 1)];

    chanTitle{4} = [double('AccelZ')'; zeros(32-length('AccelZ'), 1)];
    UnitsName{4} = [double('1/64g')'; zeros(32-length('1/64g'), 1)];

    chanTitle{5} = [double('Temp')'; zeros(32-length('Temp'), 1)];
    UnitsName{5} = [double('°C')'; zeros(32-length('°C'), 1)];

    chanTitle{6} = [double('GalvSkinResp')'; zeros(32-length('GalvSkinResp'), 1)];
    UnitsName{6} = [double('?S')'; zeros(32-length('?S'), 1)];

    %load the signal
    signal=concatArray';
    
    %Write channel arrays to binary file at outputFileNamess
    writeAdibinFromSignal(outputFileName, fs, dateVec, chanTitle, UnitsName, signal);
    
end