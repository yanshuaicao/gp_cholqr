function [gradf Hf] = computeFiniteDiff(func,x,dx,type,fx)
% computeFiniteDiff: Compute finite differences of a function about point.
%
% [gradf Hf] = computeFiniteDiff(func,x,dx,type)
%
% Input Parameters:
%  func   - Function to compute finite differences.
%           Must be of the form: f = func(x)
%  x      - Point about which to compute finite difference
%  dx     - (Optional) Step-size to use for finite differences.
%                      Defaults to sqrt(max(eps,eps(x))).
%  type   - (Optional) 0 for central differences (default), 
%                      1 for forward differences, or
%                     -1 for backward differences.
%  fx     - (Optional) The value of func(x).
%
% Output Parameters:
%  gradf  - Finite-difference estimate of the gradient.
%  Hf     - Finite-difference estimate of the diagonal of the Hessian. If this 
%           output is requested the type (see above) is assumed to be 0
%           regardless of value passed in.
%
    if nargin < 5 || isempty(fx)
        fx = feval(func,x);
    end
    if nargin < 4
        type = 0;
    end
    if nargin < 3 || isempty(dx)
        dx = reshape(sqrt(max(eps,eps(x(:)))),size(x));
%         dx = sqrt(max(eps(x(:))))*ones(size(x));
    elseif any(~isfinite(dx))
        dx(~isfinite(dx)) = reshape(sqrt(max(eps,eps(x(~isfinite(dx))))),sum(~isfinite(dx)),1);
    end
    n = numel(x);

    if numel(dx) == 1
        dx = dx*ones(size(x));
    end

    if n ~= numel(dx)
        error('computeFiniteDiff:BadSizes','The size of dx does not match the size of x');
    end

    gradf = zeros([numel(fx) n]);
    if nargout > 1
        Hf = zeros([numel(fx) n]);
    end
    if type == 0 || nargout > 1
        for i = 1:n
            if dx(i) ~= 0
                nx1 = x;
                nx1(i) = x(i) + dx(i);
                nx2 = x;
                nx2(i) = x(i) - dx(i);

                fnx1 = feval(func,nx1);
                fnx2 = feval(func,nx2);

                gradf(:,i) = 0.5*((fnx1(:) - fnx2(:))/dx(i));
                if nargout > 1
                    Hf(:,i) = (fnx1(:) - 2*fx(:) + fnx2(:))/(dx(i).^2);
                end
            end
        end
    else
        if type < 0
            dx = -dx;
        end
        for i = 1:n
            if dx(i) ~= 0
                nx1 = x;
                nx1(i) = x(i) + dx(i);

                fnx1 = feval(func,nx1);

                gradf(:,i) = (fnx1(:) - fx(:))/dx(i);
            end
        end
    end
end
