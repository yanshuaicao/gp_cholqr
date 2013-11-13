function v = flatten_cells(c)
    v = flatten_cells_helper(c,[]);
end

function vc = flatten_cells_helper(c,vc)
    if iscell(c)
        for i = 1:length(c)
            vc = [vc; reshape(flatten_cells_helper(c{i},[]),[],1)];
        end
    else
        vc = [vc; reshape(c,[],1)];
    end
end
