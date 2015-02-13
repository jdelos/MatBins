function stats_table( var_names, stats )
% Presents a form with the statistical results

f = figure('Visible','off');

col_name = char('Average','RMS'); 

%Construct table 
htable = uicontrol('Style','uitable','ColumnName',col_name,...
    'RowName',char(var_names),'Data',stats);

set([f,htable]);
set(f,'Visible','on');

end

