%KSVO Kernel Support Vector Optimizer
%
%   [V,J,T,REG] = KSVO(K,Y,C,R)
%
% INPUT
%   K   Kernel or a square similarity matrix
%   Y   Label list consisting of -1/+1
%   C   Scalar for weighting the errors (optional; default: 1)
%   R   Parameter: -1,0,1,2
%       -1 or 'flip',   Changes the kernel by flipping negative eigenvalues to
%          positive
%        0 or '',       Uses the kernel as it is
%        1 or 'reg',    Checks positive definiteness and regularizes the kernel by
%          adding the minimal constant in the form of 10^i to the diagonal
%        2 or 'lamreg', Checks positive definiteness and regularizes the kernel by
%          adding the minimal constant to the diagonal (equal to the magnitude of
%          the smallest negative eigenvalue)
%       (optional; default: 0, do not change the kernel)
%
% OUTPUT
%   V   Vector of weights for the support vectors
%   J   Index vector pointing to the support vectors
%   T   Transformation matrix for the test kernel; to be used in testing
%   REG Regularization parameter added to the diagonal, if used (R=1,2); a vector
%       of eigenvalues of K (R=-1), or -1 if not checked (R=0)
%
% DESCRIPTION
% A low level routine that optimizes the set of support vectors for a two-class
% classification problem based on the kernel or similarity matrix K. KSVO is called
% directly from KSVC. The labels Y should indicate the two classes by +1 and -1.
% Optimization is done by a quadratic programming. If available, the QLD function
% is used for a positive definite kernel, otherwise an appropriate Matlab routine.
%
% SEE ALSO
% KSVC, SVC, SVO

% Copyright: Elzbieta Pekalska, Robert P.W. Duin, ela.pekalska@googlemail.com
% Based on SVC.M by D.M.J. Tax, D. de Ridder and R.P.W. Duin
% Faculty EWI, Delft University of Technology and
% School of Computer Science, University of Manchester


function [v,J,T,reg,err] = ksvo(K,y,C,r)
prtrace(mfilename);

if (nargin < 4),
  r = 0;      % Default: the kernel is used as provided
end
if (nargin < 3)
  prwarning(3,'Third parameter not specified, assuming 1.');
  C = 1;
end

if all(r ~= [-1,0,1,2]),
  error('Wrong parameter R.');
end

err  = 0;
v    = [];     % Weights of the SVM
J    = [];     % Index of support vectors
reg = -1;      % Regularization on the diagonal or a list of eigenvalues, if used; -1, if not checked
vmin = 1e-9;   % Accuracy to determine when an object becomes the support object
iacc = -14;    % Accuracy of 10^i to determine whether the kernel is pd or not
T    = [];     % Matrix to transform the test kernel if r = -1

% Set up variables for the optimization.
n  = size(K,1);
Ky = (y*y').*K;
f  = -ones(1,n);
A  = y';
b  = 0;
lb = zeros(n,1);
ub = repmat(C,n,1);
p  = rand(n,1);


if r ~= 0,
  % Find whether the kernel is positive definite.
  i = -20;
  while (pd_check (Ky + (10.0^i) * eye(n)) == 0)
    i = i + 1;
  end

  if r == 1,
    if i > iacc,  % if i is smaller, then the regularization is within numerical accuracy
      prwarning(1,'K is not positive definite. The diagonal is regularized by 10.0^(%d)',i);
    end

    % Make the kernel positive definite by adding a constant to the diagonal.
    reg = 10.0^i;
    Ky  = Ky + (10.0^(i)) * eye(n);

  elseif r == 2,
    L = preig(Ky);
    L = diag(real(L));
    I = find(L < 0);
    if ~isempty(I),
      % Make the kernel positive definite by adding a constant to the diagonal.
      reg = -1.001*min(L(I));
      Ky  = Ky + reg * eye(n);
      pow = round(log10(reg));
      if pow >= 0
        prwarning(1,['K is not positive definite. The diagonal is regularized by %' num2str(pow) '.2f'],reg);
      elseif pow > iacc,
        prwarning(1,['K is not positive definite. The diagonal is regularized by %0.3g'], reg);
      else
        ;
      end
    else
      reg = 0;
    end

  else   % r = -1,
    % reverse the negative eigenvalues of the kernel K
    if i >= iacc,
      [Q,L] = preig(K);
      Q     = real(Q);
      L     = diag(real(L));
      reg   = L;
      if all(L >= 0),
        T = [];
      else
        K   = Q*diag(abs(L))*Q';
        Ky  = (y*y').*K;
        T   = Q* diag(sign(L)) *Q';   % transformation matrix for the test kernel
      end
    else
      % if i < iacc, then the regularization is within numerical accuracy, so apply it
      Ky    = Ky + (10.0^(i)) * eye(n);
    end
  end
end


% Minimization procedure
% QP  minimizes:   0.5 x'*Ky*x + f'x
% subject to:      Ax <= b
%

done = 0;
if r ~= 0 & (exist('qld') == 3)
  prwarning(5,'QLD routine is used.')
  v = qld (Ky, f, -A, b, lb, ub, p, 2);
  done = 1;
end

if r == 0 | ~done,
  if (exist('quadprog') == 2)
    prwarning(5,'Matlab QUADPROG is used.')
    opt = optimset;
    opt.Diagnostics = 'off';
    opt.LargeScale  = 'off';
    opt.Display     = 'off';
    opt.MaxIter     = 500;
    v = quadprog(Ky, f, [], [], A, b, lb, ub,[],opt);
  else
    error(5,'KSVC requires Matlab 6.x')
  end
end



% Compute the square pseudo-norm of the weights in the corresponding
% Hilbert/Krein space. If it is negative (which may happen for a highly
% indefinite kernel), then the SVM is not proper.

vnorm = v'*Ky*v;
if vnorm < 0 | abs(vnorm) < 10^iacc,
  prwarning(1,'SVM: ||w||^2_PE < 0. The SVM is not properly defined. Pseudo-Fisher is computed instead.');
  err = 1;
  v   = prpinv([K ones(n,1)])*y;
  J   = [1:n]';
  return;
end


% Find all support vectors SVs.
J = find(v > vmin);

% First find the SVs on the boundary
I  = find((v > vmin) & (v < C-vmin));
Ip = find(y(I) ==  1);
Im = find(y(I) == -1);

if (isempty(v) | isempty(Ip) | isempty(Im))
  prwarning(1,'Quadratic Optimization failed. Pseudo-Fisher is computed instead.');
  err = 1;
  v   = prpinv([K ones(n,1)])*y;
  J   = [1:n]';
  return;
end


v = y.*v;

% Find the output for the SVs:
out = y(I)-(K(I,J)*v(J));
b   = mean(out);
v   = [v(J); b];
return;
