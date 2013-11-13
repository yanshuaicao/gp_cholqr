function [P, G, DD, varargout] = cholOneStep(   new_pivot , ...
                                                kk,...
                                                trainx,...
                                                K, ...
                                                P, ...
                                                G, ...
                                                DD, ...
                                                noise_var,...
                                                varargin)
                                      
%Chol factorize with pivot new_pivot, at position kk, and factorize the new col to 
%obtain new column for Q and R via classical Graham-Schmidt
assert(all(DD >= 0));
% assert(size(info_R,1) == size(info_R,2));
n = numel(P);

%first pivot relevant quantities to kk 
 
P([kk new_pivot]) = P([new_pivot kk]);

for i = 1:length(varargin)
    varargout{i} = varargin{i};
    if ~isempty(varargout{i})
        if isvector(varargout{i})
            varargout{i}([kk new_pivot]) = varargout{i}([new_pivot kk]);
        else
            if size(varargout{i},1) > size(varargout{i},2)
                varargout{i}([kk new_pivot],:) = varargout{i}([new_pivot kk],:);
            else
                varargout{i}(1, [kk new_pivot]) = varargout{i}(2, [new_pivot kk]);
            end
        end
    end
end

DD([kk new_pivot]) = DD([new_pivot kk]);
G([kk new_pivot], 1:kk-1) = G([new_pivot kk], 1:kk-1);

% compute new Cholesky column
 
assert(DD(kk) > 0);
G(kk, kk) = sqrt(DD(kk));
newKcol = K(P(kk+1:n), P(kk), trainx);
G(kk+1:n, kk) =  (1 / G(kk, kk)) * (newKcol - G(kk+1:n, 1:kk-1)*(G(kk, 1:kk-1)).');

if ~isempty(noise_var)
    G(n+kk, kk) = sqrt(noise_var);
end

% update diagonal
DD(kk+1:n) =  DD(kk+1:n) - G(kk+1:n, kk).^2;
DD(kk) = 0;

DD = safeGuardPosValues(DD);
assert(all(DD >= 0));
end
