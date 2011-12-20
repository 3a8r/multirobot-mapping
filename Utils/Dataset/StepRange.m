function ind=StepRange(step, dim)
% Returns the indices for a given step.
%
% Return the indices of the elements for a given step. The indexes take
% into account the step and the dimensionality of the stimated poses.
   
  ind=(step-1)*dim+(1:dim);