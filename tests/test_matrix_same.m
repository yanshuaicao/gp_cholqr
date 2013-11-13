function [has_err, has_warn] = test_matrix_same(M_candidate, ...
                                                M_true, ...
                                                M_name, ...
                                                verbose,...
                                                err_threshold, ...
                                                warning_threshold)
                                            

if nargin < 6
    warning_threshold = 1e-10;
end

if nargin < 5
    err_threshold = 1e-6;
end

if nargin < 4
    verbose = true;
end

has_err = false;
has_warn = false;

try 
    M_diff = max(max(abs(M_true - M_candidate)));
catch err
    if strcmp(err.identifier,'MATLAB:dimagree')
        has_err = true;
        if verbose
            fprintf('Error: dimensionality of matrix (%s) is different from the actual one\n', M_name);
        end
    else
        rethrow(err);
    end
    has_err = true;
    return
end

if M_diff > err_threshold
    if verbose
        fprintf('Error: %s incorrect\n', M_name);
    end
    has_err = true;
elseif M_diff > warning_threshold
    if verbose
        fprintf('Warnings: %s inaccurate\n', M_name);
    end
    has_warn = true;
end

end