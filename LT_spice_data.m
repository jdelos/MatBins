function [ result ] = LT_spice_data(filename,s)
%% [ result ] = LT_spice_data(filename,s)
% Reads LT_spice_data files and returns data with an structure containing a
% the field with the name of the original variables
% For STEP files each variable has one vairable for a column   
% filename - Valid file name 
% s - Setp file, S = 1 YES, S = 0 NO

%% Header size
if s 
    head_ln=2;
else
    head_ln=1;
end

%% Read file data
d=importdata(filename,'\t',head_ln);

%% Get header with variables names
% header = char(d.textdata{1});

%% Parse the string and create variable list
% var_list = textscan(header,'%s');
var_list = d.textdata;
n_vars = length(var_list); %Number of imput variables


%% Assing results to fields
for i=1:n_vars
    %result = setfield(result,var_list{i},d.data(:,i));
    varname=regexprep(var_list{i},'\W','_'); %remove not allowed characters
    varname=regexprep(varname,'_+$',''); %remove all the ending characters
    eval(['result.' varname '= d.data(:,i);']);
end


end

