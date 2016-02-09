function lines = ReadLines(fname)
fid = fopen(fname);
data = textscan(fid, '%s');
lines = data{1};
clear data;
fclose(fid);
