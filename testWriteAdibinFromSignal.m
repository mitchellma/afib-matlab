%This script tests function "writeAdibinFromSignal" which creates an
%.adibin file from signal in Matlab format.

fileName = 'test.adibin';
fs = 360;
dateVec = [2000, 1, 1, 0, 0, 0];

%channel title and units name should be converted to ASCII and 32*1
%vectors by adding zeros
chanTitle{1} = [double('MCAFV')'; zeros(32-length('MCAFV'), 1)];
UnitsName{1} = [double('cm/s')'; zeros(32-length('cm/s'), 1)];

%load the signal
load('MCAfv.mat')

writeAdibinFromSignal(fileName, fs, dateVec, chanTitle, UnitsName, signal);