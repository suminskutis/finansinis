function [r] = readData(file_name)


data = load(file_name);
y=floor(data(:,1)/10000);
m=floor(data(:,1)/100)-y*100;
d=floor(data(:,1)/1)-y*10000-m*100;
r.date = (datenum(y,m,d,0,0,0)');
r.open = data(:,3)';
r.high = data(:,4)';
r.low = data(:,5)';
r.close = data(:,6)';
r.volume = data(:,7)';
if size(data,2) >= 8
    r.openint = data(:,8)';
end

r.full_file_name = file_name;
r.file_name = get_file(file_name);

    