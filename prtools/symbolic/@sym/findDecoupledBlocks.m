function [eqsBlocks, varsBlocks] = findDecoupledBlocks(eqs, vars)
%FINDDECOUPLEDBLOCKS   Search for a block partitioning of 
%   equations to 'lower block triangular form'. For a square 
%   system of symbolic equations/expressions given in the 
%   vector eqs for the variables given in the vector vars,
%   the call
%
%   [eqsBlocks,varsBlocks] = findDecoupledBlocks(eqs, vars)
%
%   serves for identifying subsets ('blocks') of equations 
%   that can be used to define subsets of the variables.
%   The cell arrays eqsBlocks and varsBlocks contain vectors
%   of indices, each of type double, that define the blocks. 
%   The i-th block of equations consists of the equations 
%   eqs(eqsBlocks{i}). It involves only the variables in 
%   vars(varsBlocks{1:i}). 
%
%   The i-th block is the set of equations determining the 
%   variables in vars(varsBlocks{i}). The parameters in 
%   vars(varsBlocks{i}),...,vars(varsBlocks{i-1}) were 
%   determined recursively by the previous blocks of equations.
%
%   In particular, when at least two blocks are found, the 
%   first block eqs(eqsBlocks{1}) defines a decoupled subset 
%   of equations containing only the subset of variables 
%   given by the first block of variables vars(varsBlock{1}).
%
%   After you solved the first block of equations for the 
%   first block of variables, the second block of equations, 
%   given by eqs(eqsBlocks{2}), defines a decoupled subset 
%   of equations containing only the subset of variables 
%   given by the second block of variables vars(varsBlock{2})
%   plus the variables from the first block (which are known
%   at this time).
%
%   Thus, if a non-trivial block decomposition is possible,
%   you can split the solution process for a large system of 
%   equations involving a large number of variables into several
%   steps, where each step involves a smaller (sub-) system.
%
%   The number of blocks is given by length(eqsBlocks), which 
%   coincides with length(varsBlocks). If length(eqsBlocks) = 
%   length(varsBlocks) = 1, then no non-trivial block 
%   decomposition of the equations is possible.
%
%   Applying the permutations e = [eqsBlocks{:}] to the vector
%   eqs and v = [varsBlocks{:}] to the vector vars produces 
%   an incidence matrix INCIDENCEMATRIX(eqs(e),vars(v)) that 
%   has a block lower triangular sparsity pattern.
%
%   The implemented algorithm requires that for each variable
%   there is at least one 'matching' equation involving this 
%   variable that was not 'matched' to another variable. If 
%   the system does not satisfy this condition, then
%   FINDDECOUPLEDBLOCKS throws an error.
% 
%   In particular, length(eqs) must coincide with length(vars).
%  
%   Example:
%     Compute a lower triangular block decomposition of a 
%     symbolic system of differential algebraic equations
%     for the 'state variables' x1(t),x2(t),x3(t),x4(t). 
%     It contains constant symbolic parameters c1,c2,c3,c4 
%     and arbitrary symbolic functions f(t,x,y),g(t,x,y):
%
%     >> syms x1(t) x2(t) x3(t) x4(t) c1 c2 c3 c4 f(t,x,y) g(t,x,y);
%        eqs = [c1*diff(x1(t),t)+c2*diff(x3(t),t)==c3*f(t,x1(t),x3(t));...
%               c2*diff(x1(t),t)+c1*diff(x3(t),t)==c4*g(t,x3(t),x4(t));...
%               x1(t)==g(t,x1(t),x3(t)); ...
%               x2(t)==f(t,x3(t),x4(t))];
%        vars = [x1(t), x2(t), x3(t), x4(t)];
%        [eqsBlocks,varsBlocks] = findDecoupledBlocks(eqs, vars);
%
%     The block decomposition returns a block of 2 equations 
%
%     >> eqs(eqsBlocks{1})
%
%     c1*diff(x1(t), t)+c2*diff(x3(t),t)==c3*f(t,x1(t),x3(t))
%                                  x1(t)==g(t,x1(t),x3(t))
%
%     for the 2 variables
%
%     >> vars(varsBlocks{1})
%
%     [x1(t),x3(t)]
%
%     After you solve this block for the variables x1(t),x3(t),
%     you can solve the next block of equations
%
%     >> eqs(eqsBlocks{2})
%
%     c2*diff(x1(t),t)+c1*diff(x3(t),t)==c4*g(t,x3(t),x4(t))
%
%     for the variable
%
%     >> vars(varsBlocks{2})
%
%     x4(t)
%
%     Once x4(t) is determined, the final block of equations
%
%     >> eqs(eqsBlocks{3})
%
%     x2(t)==f(t,x3(t),x4(t))
%
%     defines the variable
%
%     >> vars(varsBlocks{3})
%
%     x2(t)
%
%     Permuting the equations 
%     >> eqs = eqs([eqsBlocks{:}])
%
%     c1*diff(x1(t),t)+c2*diff(x3(t),t)==c3*f(t,x1(t),x3(t))
%                                    x1(t)==g(t,x1(t),x3(t))
%     c2*diff(x1(t),t)+c1*diff(x3(t),t)==c4*g(t,x3(t),x4(t))
%                                    x2(t)==f(t,x3(t),x4(t))
%
%     and variables
%
%     >> vars = vars([varsBlocks{:}])
%
%     [x1(t),x3(t),x4(t),x2(t)]
%
%     produces a 'block lower triangular' system of equations
%     with three diagonal blocks of size 2x2,1x1, and 1x1:
%     >> incidenceMatrix(eqs, vars)
%
%     1     1     0     0
%     1     1     0     0
%     1     1     1     0
%     0     1     1     1
 
%   Copyright 2014 The MathWorks, Inc.

narginchk(2,2);
[eqs, vars] = checkDAEInput(eqs, vars);
blocks = feval(symengine, 'daetools::findDecoupledBlocks', eqs, vars);
blocks = num2cell(blocks);
eqsBlocks = cellfun(@double, num2cell(blocks{1}), 'Uniform', false);
varsBlocks = cellfun(@double, num2cell(blocks{2}), 'Uniform', false);
end
