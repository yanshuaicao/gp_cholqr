function newID = genUniqueIDStr()
thisfilepath = mfilename('fullpath');
thisdir = fileparts(thisfilepath);
DB_FILE = sprintf('%s/.uniqueID_db.mat',thisdir);
if ~exist(DB_FILE,'file')
    warning('first time running? or db got deteled?');
    newID = genRandStrID();
    IDs(1).id = newID;
    IDs(1).datetime = now();
else
    load(DB_FILE);
    N = length(IDs);
    
    isUnique = false;
    while ~isUnique
        newID = genRandStrID();
        dupFound = false;
        for i = 1:N
            if strcmp(IDs(i).id,newID)
                dupFound = true;
                break;
            end
        end
        if ~dupFound
            isUnique = true;
        end
    end
    IDs(end+1).id = newID;
    IDs(end).datetime = now();
end
save(DB_FILE,'IDs');

end