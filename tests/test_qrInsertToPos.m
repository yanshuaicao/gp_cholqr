function test_qrInsertToPos()
    fprintf('Testing qrInsertToPos\n')
    num_test = 0;
    num_passed = 0;
    num_warn = 0;
    %%
    fprintf('============================ Test %d=============================\n',num_test+1);
    test_passed = true;
    n = 10;
    m = 5;
    j = 1;
    G = randn(n, m);
    newg = randn(n, 1);
    [Q, R] = qr(G, 0);
    negPivots = diag(R) < 0;
    Q(:, negPivots) = - Q(:, negPivots);
    R(negPivots, :) = - R(negPivots, :);
    newG = insertCol(G,newg,j);
    
    fprintf('n=%d; m=%d; j=%d \n', n, m, j);
    
    [Q_true, R_true] = qr(newG,0);
    Q_true(:, negPivots) = - Q_true(:, negPivots);
    R_true(negPivots, :) = - R_true(negPivots, :);
    
    [Q, R] = qrInsertToPos(Q,R,newg,j);
    [has_err,has_warn] = test_matrix_same(Q,Q_true,'Q');
    num_warn = num_warn + has_warn;
    test_passed = test_passed & ~has_err;
    [has_err,has_warn] = test_matrix_same(R,R_true,'R');
    test_passed = test_passed & ~has_err;
    num_warn = num_warn + has_warn;
    num_passed = num_passed + test_passed;
    num_test = num_test + 1;
%     fprintf('================================================================\n');
        %%
    fprintf('============================ Test %d=============================\n',num_test+1);
    test_passed = true;
    n = 10;
    m = 5;
    j = 6;
    G = randn(n, m);
    newg = randn(n, 1);
    [Q, R] = qr(G, 0);
    negPivots = diag(R) < 0;
    Q(:, negPivots) = - Q(:, negPivots);
    R(negPivots, :) = - R(negPivots, :);
    newG = insertCol(G,newg,j);
    
    fprintf('n=%d; m=%d; j=%d \n', n, m, j);
    
    [Q_true, R_true] = qr(newG,0);
    Q_true(:, negPivots) = - Q_true(:, negPivots);
    R_true(negPivots, :) = - R_true(negPivots, :);
    
    [Q, R] = qrInsertToPos(Q,R,newg,j);
    [has_err,has_warn] = test_matrix_same(Q,Q_true,'Q');
    num_warn = num_warn + has_warn;
    test_passed = test_passed & ~has_err;
    [has_err,has_warn] = test_matrix_same(R,R_true,'R');
    test_passed = test_passed & ~has_err;
    num_warn = num_warn + has_warn;
    num_passed = num_passed + test_passed;
    num_test = num_test + 1;
%     fprintf('================================================================\n');
%%
    fprintf('============================ Test %d=============================\n',num_test+1);
    test_passed = true;
    n = 10;
    m = 5;
    j = 3;
    G = randn(n, m);
    newg = randn(n, 1);
    [Q, R] = qr(G, 0);
    negPivots = diag(R) < 0;
    Q(:, negPivots) = - Q(:, negPivots);
    R(negPivots, :) = - R(negPivots, :);
    newG = insertCol(G,newg,j);
    
    fprintf('n=%d; m=%d; j=%d \n', n, m, j);
    
    [Q_true, R_true] = qr(newG,0);
    Q_true(:, negPivots) = - Q_true(:, negPivots);
    R_true(negPivots, :) = - R_true(negPivots, :);
    
    [Q, R] = qrInsertToPos(Q,R,newg,j);
    [has_err,has_warn] = test_matrix_same(Q,Q_true,'Q');
    num_warn = num_warn + has_warn;
    test_passed = test_passed & ~has_err;
    [has_err,has_warn] = test_matrix_same(R,R_true,'R');
    test_passed = test_passed & ~has_err;
    num_warn = num_warn + has_warn;
    num_passed = num_passed + test_passed;
    num_test = num_test + 1;
%     fprintf('================================================================\n');
    %%
    fprintf('============================ Test %d: profiling=============================\n',num_test+1);
    test_passed = true;
    n = 100000;
    m = 1000;
    j = 1;
    G = randn(n, m);
    newg = randn(n, 1);
    [Q, R] = qr(G, 0);
    negPivots = diag(R) < 0;
    Q(:, negPivots) = - Q(:, negPivots);
    R(negPivots, :) = - R(negPivots, :);
    newG = insertCol(G,newg,j);
    
    fprintf('n=%d; m=%d; j=%d \n', n, m, j);
    
    [Q_true, R_true] = qr(newG,0);
    Q_true(:, negPivots) = - Q_true(:, negPivots);
    R_true(negPivots, :) = - R_true(negPivots, :);
    profile on;
    [Q, R] = qrInsertToPos(Q,R,newg,j);
    profile viewer;
    [has_err,has_warn] = test_matrix_same(Q,Q_true,'Q');
    num_warn = num_warn + has_warn;
    test_passed = test_passed & ~has_err;
    [has_err,has_warn] = test_matrix_same(R,R_true,'R');
    test_passed = test_passed & ~has_err;
    num_warn = num_warn + has_warn;
    num_passed = num_passed + test_passed;
    num_test = num_test + 1;
    fprintf('================================================================\n');
    %% Summarize
    fprintf('Testing qrInsertToPos: %d out of %d passed; %d warnings\n',...
            num_passed, num_test, num_warn);
end

function G = insertCol(G,x,j)
    if j == 1
        G = [x G];
    elseif j == size(G,2)+1 || j == -1
        G = [G x];
    else
        G = [G(:,1:j-1) x G(:,j:end)];
    end
end