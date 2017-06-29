# afib-matlab

## Converting E4 zip files to .adibin LabChart files

* Use `afibWriteAdibinFromSignal.m` as the main matlab function.  It relies on fucntions in `catpad.m` and `writeAdibinFromSignal.m`, so make sure that those are on the matlab path.

* In order to convert E4 zips to LabChart files, first unzip the E4 zip files

* Place unzipped E4 files in a folder, and change `inputPath` and `filePath` in matlab function to point to this folder

* Create a directory for the converted adibin to go in and change `outputPath` to point to this folder

* To convert the E4 unzipped folders to adibin files, run the matlab function in matlab.
