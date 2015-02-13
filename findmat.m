function [ix varargout] = findmat(data,search,NULL)
%FINDMAT searches a matrix for a smaller matrix.  Use char or numeric data.      
% IND = FINDMAT(DATA, PATTERN) Returns the absolute indicies into DATA of
%   where PATTERN begins.
% [I J ...] = FINDMAT(DATA, PATTERN) Returns subscript arrays of where
%   PATTERN begins.
% ... = FINDMAT(DATA, PATTERN, NULL) Use a differnt value for NULL as a
%   wild character in PATTERN.
%
%
% Author: Justin Griffiths
% Version: 2
% Company: Eaton Co.
% Date: 8/16/06

%Allow the user to specify a wildcard character
if exist('NULL','var')
    c = search == NULL;
else
    c = [];
end

%Convert the data to a double for easy finding
data = double(data);
search = double(search);

%Use a common NULL value for all searches
NULL = NaN;
%Set the search wildcards if any to NULL
search(c) = NULL;

%Initialize searchTable
searchTable = zeros(numel(data),numel(search));

%Get some dimensions on the data and search pattern
siz = size(search);
dsize = size(data);
dsizelen = length(dsize);
dim = length(siz);

%Set up all the selecting and circshift commands that will be needed
ss = cell(dsizelen,dsizelen,2);
for i = 1:dsizelen
    for j = 1:dsizelen
        if i ~= j
            ss{j,i,1} = 1:dsize(j);
            ss{j,i,2} = ss{j,i,1};
        else
            ss{j,i,1} = dsize(j);
            ss{j,i,2} = mod(1:dsize(j),dsize(j))+1;
        end
    end
end

%Start Massaging data into a form that is easy to search
idx = 1;
[searchTable idx] = shiftData(searchTable,idx,dim,siz,data,ss,NULL);

%Create a truth table. Note this might be better vectorized using repmat
truthTable = ones(size(searchTable));
loop = 1:numel(search);
for i = loop(~isnan(search(:)))
    truthTable(:,i) = double(searchTable(:,i) == search(i));
end

%Perform search on truthTable.  For a success the entire row must be true.
ix = find(all(truthTable,2));

%If there are more than one output argument then get the subscripts
if nargout>1
    varargout= cell(1,nargout-1);
    [ix varargout{:}] = ind2sub(dsize,ix);
end

%% shiftData
%Massage the data into a searchTable that in each column has every data
%point of the original data except just shifted a little
%
% data = [1 2 3;
%         4 5 6];
% search = [1 2;
%           4 5];
%
% searchTable will look like this
% [1  4   2   5;
%  4 NaN  5  NaN;
%  2  5   3   6;
%  5 NaN  6  NaN;
%  3  6  NaN NaN;
%  6 NaN NaN NaN]
%
% The numbers depend on size(search)
function [searchTable idx] = shiftData(searchTable,idx,dim,siz,data,ss,NULL)
%This function is a recursive function.  It rotates rows then a column then
%rotates the rows again, repeat until all columns are rotated then rotate
%the next dimension, continue until every permutation of rotations of the
%search is done.  If you are trying to understand what is going on I
%suggest you step through and into each function looking at how the data
%variable changes

if dim ~= 1
    [searchTable idx] = shiftData(searchTable,idx,dim-1,siz,data,ss,NULL);
    data = data(ss{:,dim,2});
    data(ss{:,dim,1}) = NULL;
else
    searchTable(:,idx) = data(:);
    idx = idx +1;
end
for i = 2:siz(dim)
    if dim ~= 1
        [searchTable idx] = shiftData(searchTable,idx,dim-1,siz,data,ss,NULL);
        data = data(ss{:,dim,2});
        data(ss{:,dim,1}) = NULL;
    else
        data = data(ss{:,dim,2});
        data(ss{:,dim,1}) = NULL;
        searchTable(:,idx) = data(:);
        idx = idx +1;
    end
end
    