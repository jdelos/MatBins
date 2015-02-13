function newtops = permute_topologies (topologies1, topologies2)
%   newtops = permute_topologies(topologies1, topologies2)
%       topologies1, topologies2: column vectors of either topology
%           structures or [{'Topology Name'} {ratio}] pairs
%
%   For two vectors of topologies, returns a vector of topologies
%   consisting of every permutation of topologies in the first vector
%   connected in series (cascaded) with the topologies in the second
%   vector.
%
%   Created 10/08, Last modified: 4/15/09
%   Copyright 2008-2009, Mike Seeman, UC Berkeley
%   May be freely used and modified but never sold.  The original author
%   must be cited in all derivative work.

newtops = [];

for m=1:size(topologies1,1),
    for n=1:size(topologies2,1),
        % returns an (n*m) vector of topology structures
        top1 = topologies1(m,:);
        top2 = topologies2(n,:);
        if ((size(top1,2) == 1) & (size(top2,2) == 1)),
            newtops = [newtops; cascade_topologies(top1, 1, top2, 1)];
        elseif ((size(top1,2) == 2) & (size(top2,2) == 1)),
            newtops = [newtops; cascade_topologies(cell2mat(top1(1)), ...
                    cell2mat(top1(2)), top2, 1)];
        elseif ((size(top1,2) == 1) & (size(top2,2) == 2)),
            newtops = [newtops; cascade_topologies(top1, 1, ...
                    cell2mat(top2(1)), cell2mat(top2(2)))];
        elseif ((size(top1,2) == 2) & (size(top2,2) == 2)),
            newtops = [newtops; cascade_topologies(cell2mat(top1(1)), ...
                    cell2mat(top1(2)), cell2mat(top2(1)), ...
                    cell2mat(top2(2)))];
        end
    end
end

% ------------------ Helper: cascade_topologies
function newtop = cascade_topologies(topology1, ratio1, topology2, ratio2)
% cascade_topologies: Combine two topologies into a single topology where
% the two topologies are cascaded in a series fashion where topology1
% interfaces with the input and topology2 interfaces with the output

if (ischar(topology1)),
    topology1 = generate_topology(topology1, ratio1);
end

if (ischar(topology2)),
    topology2 = generate_topology(topology2, ratio2);
end

ratio1 = topology1.ratio;
ratio2 = topology2.ratio;

% scale topology2.v* by ratio1, scale topology1.a* by ratio2
newtop.topName = strcat(topology1.topName, ' -> ', topology2.topName);
newtop.ac = [topology1.ac.*ratio2 topology2.ac];
newtop.ar = [topology1.ar.*ratio2 topology2.ar];
newtop.vc = [topology1.vc topology2.vc.*ratio1];
newtop.vcb = [topology1.vcb topology2.vcb.*ratio1];
newtop.vr = [topology1.vr topology2.vr.*ratio1];
newtop.vrb = [topology1.vrb topology2.vrb.*ratio1];
newtop.ratio = topology1.ratio*topology2.ratio;
newtop.Mssl = 2*newtop.ratio^2/(newtop.ac*newtop.vc')^2;
newtop.Mfsl = newtop.ratio^2/(2*(newtop.ar*newtop.vr')^2);