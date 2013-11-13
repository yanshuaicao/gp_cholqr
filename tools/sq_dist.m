% sq_dist - a function to compute a matrix of all pairwise squared distances
% between two sets of vectors, stored in the columns of the two matrices, a
% (of size D by n) and b (of size D by m). If only a single argument is given
% or the second matrix is empty, the missing matrix is taken to be identical
% to the first.
%
% Usage: C = sq_dist(a, b)
%    or: C = sq_dist(a)  or equiv.: C = sq_dist(a, [])
%
% Where a is of size Dxn, b is of size Dxm (or empty), C is of size nxm.
%
% Copyright (c) by Carl Edward Rasmussen and Hannes Nickisch, 2010-12-13.

function C = sq_dist(a, b)

if nargin<1  || nargin>3 || nargout>1, error('Wrong number of arguments.'); end

[n,D] = size(a);

% Computation of a^2 - 2*a*b + b^2 is less stable than (a-b)^2 because numerical
% precision can be lost when both a and b have very large absolute value and the
% same sign. For that reason, we subtract the mean from the data beforehand to
% stabilise the computations. This is OK because the squared error is
% independent of the mean.
if nargin==1                                                     % subtract mean
  mu = mean(a,1);
  a = bsxfun(@minus,a,mu);
  b = a; m = n;
else
  [m,d] = size(b);
  if d ~= D, error('Error: column lengths must agree.'); end
  mu = (m/(n+m))*mean(b,1) + (n/(n+m))*mean(a,1);
  
  a = bsxfun(@minus,a,mu); 
  b = bsxfun(@minus,b,mu); 
end

                                  % compute squared distances
C = bsxfun(@plus,sum(a.*a,2),bsxfun(@minus,sum(b.*b,2).',2*a*b.'));

C = max(C,0);          % numerical noise can cause C to negative i.e. C > -1e-14