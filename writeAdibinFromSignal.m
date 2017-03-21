function writeAdibinFromSignal(fileName, fs, dateVec, chanTitle, UnitsName, signal)
%%%This function creates an .adibin file from signal in Matlab format.
%Input:
%fileName -- the file name of the .adibin file (need to end with
%'.adibin');
%fs -- sampling frequency;
%dateVec -- a 1*6 vector that specifies year, month, day, hour, minute,
%second;
%chanTitle -- title of each channel;
%UnitsName -- name of unit for signal in each channel;
%signal -- the signal data.
%
%Notes: channel title and units name should be converted to ASCII and 32*1
%vectors by adding zeros.
%Number of rows in signal is the number of channels.
%Number of columns in signal is the number samples.

%Sample period in seconds
ts = 1/fs;

%Get year, month, day, hour, minute, second from dateVec
Y = dateVec(1);
MO = dateVec(2);
D = dateVec(3);
H = dateVec(4);
MI = dateVec(5);
S = dateVec(6);

%Number of channels
iChan = size(signal, 1);

%Number of samples
lenSmp = size(signal, 2);

%Data Format
DataFormatStr = 'float';

%data = scale * (sample + offset)
scale = ones(1, iChan);
offset = zeros(1, iChan);

%Not used in current version
RangeHigh = ones(1, iChan);
RangeLow = zeros(1, iChan);

fid = fopen(fileName,'w');
    if ( fid ~= -1 )
        fwrite(fid, 'CFWB', 'uchar');
        fwrite(fid, 1, 'long'); %version = 1
        fwrite(fid, ts, 'double');
        fwrite(fid, Y, 'long');
        fwrite(fid, MO, 'long');
        fwrite(fid, D, 'long');
        fwrite(fid, H, 'long');
        fwrite(fid, MI, 'long');
        fwrite(fid, S, 'double');
        fwrite(fid, 0, 'double'); %pre-trigger time = 0
        fwrite(fid, iChan, 'long');
        fwrite(fid, lenSmp, 'long');
        fwrite(fid, 0, 'long'); %TimeChannel = 0
        fwrite(fid, 2, 'long'); %DataFormat = 2 ('float')
        
        for i=1:iChan
            fwrite(fid, chanTitle{i}, 'char'); %Channel title
            fwrite(fid, UnitsName{i}, 'char'); %Units name
            fwrite(fid, scale(i), 'double'); %scale
            fwrite(fid, offset(i), 'double'); %offset
            fwrite(fid, RangeHigh(i), 'double'); %Range high
            fwrite(fid, RangeLow(i), 'double'); %Range low
        end

%         for n=1:lemSmp
%             for i=1:iChan
%                 fwrite(fid,signal(i, n),DataFormatStr);
%             end
%         end
        
        fwrite(fid, signal(:), DataFormatStr);
        
        fclose(fid);
    end