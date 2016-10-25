function r = get_path(s)
%gets path only from full file location

idx = find(s=='\',1,'last');

if isempty(idx)
    r = s;
    return
end;

r = s(idx+1:end);
