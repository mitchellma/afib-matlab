addpath('C:\cygwin64\home\mma\E4Data\');

inputPath = 'C:\cygwin64\home\mma\E4Data\device_data\';

d = dir(inputPath);
isub = [d(:).isdir]; %# returns logical vector
inputDirArray = {d(isub).name}';
inputDirArray(ismember(inputDirArray,{'.','..'})) = [];

for i=1:numel(inputDirArray)
    generatePSD(char(inputDirArray(i)));
end

function generatePSD(dir)
    filePath = strcat('C:\cygwin64\home\mma\E4Data\device_data\', dir,'\');
    
    bvpArray = csvread(strcat(filePath, 'BVP.csv'));
        timeStamp = bvpArray(1,1);
        t = datetime(timeStamp , 'ConvertFrom','posixtime');
        dateVec = datevec(t);
        Fs = bvpArray(2,1);

    x = bvpArray(3:end, 1);
    N = length(x);
    
    xdft = fft(x);
    xdft = xdft(1:N/2+1);
    psdx = (1/(Fs*N)) * abs(xdft).^2;
    psdx(2:end-1) = 2*psdx(2:end-1);
    freq = 0:Fs/length(x):Fs/2;

    plot(freq,10*log10(psdx))
    grid on
    title('Periodogram Using FFT')
    xlabel('Frequency (Hz)')
    ylabel('Power/Frequency (dB/Hz)')

end