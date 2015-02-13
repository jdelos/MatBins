function varargout = LTspiceGUI(varargin)
% LTSPICEGUI MATLAB code for LTspiceGUI.fig
%      LTSPICEGUI, by itself, creates a new LTSPICEGUI or raises the existing
%      singleton*.
%
%      H = LTSPICEGUI returns the handle to a new LTSPICEGUI or the handle to
%      the existing singleton*.
%
%      LTSPICEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LTSPICEGUI.M with the given input arguments.
%
%      LTSPICEGUI('Property','Value',...) creates a new LTSPICEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LTspiceGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LTspiceGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LTspiceGUI

% Last Modified by GUIDE v2.5 23-Oct-2013 17:31:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LTspiceGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @LTspiceGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


% End initialization code - DO NOT EDIT


% --- Executes just before LTspiceGUI is made visible.
function LTspiceGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LTspiceGUI (see VARARGIN)

% Choose default command line output for LTspiceGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LTspiceGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LTspiceGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in openfile.
function openfile_Callback(hObject, eventdata, handles)
% hObject    handle to openfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Open the RAW filter
[FileName,PathName] = uigetfile('*.raw','Select LTspice Simulation file');
if FileName
% Load variable list from RAW data
disp(['Reading variables names from file: ' FileName]);
Data = LTspice2Matlab([ PathName FileName],1);
var_type = Data.variable_type_list;
idx_volt = strcmp(var_type,'voltage');
volt_lst=Data.variable_name_list(idx_volt);
current_lst=Data.variable_name_list( ~idx_volt);

set(handles.nvar_text,'String', num2str(Data.num_variables));
set(handles.volt_list,'String',volt_lst);
set(handles.cur_list,'String',current_lst);
set(handles.npnt_text,'String',num2str(Data.num_data_pnts));


%Process simulation steps based on time data
t=Data.time_vect;
Nsteps = sum(diff(t)<0)+1;
set(handles.steps_tex,'String',num2str(Nsteps)); %Display number of steps

if Nsteps > 1
    step_idx = [1 find(diff(t)<0)+1 length(t)+1] ; %Get the steps indexs
else
    step_idx = 0;
end


%Show file name
set(handles.name_text,'String',FileName);



% Store new handels
handles.FilePath = [ PathName FileName];
handles.curr_offset = sum(idx_volt);
handles.var_name = Data.variable_name_list; 

handles.volt_names = volt_lst;
handles.volt_idxs = 1:length(volt_lst);
handles.volt_idxs_shown = handles.volt_idxs;

handles.curret_names = current_lst;
handles.curret_idxs = (1:length(current_lst))+length(volt_lst);
handles.curret_idxs_shown = handles.curret_idxs;
handles.step_idx = step_idx;
guidata(hObject,handles);
end





% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over openfile.
function openfile_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to openfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 

 
% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot.
function plot_Callback(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[time,v_data,i_data,v_names,i_names] = load_raw(handles);

col_list = {'b','g','m','c','k','r','-.b','-.g','-.m','-.c','-.k','-.r',...
    '--b','--g','--m','--c','--k','--r'};

step_idx = handles.step_idx;

if ~isempty(v_data)
    figure
    if get(handles.nest_cbox,'Value') == get(handles.nest_cbox,'Max')
        subplot(2,1,1)
    end
    
    
    
    if isscalar(step_idx)
        
        plot(time,v_data);
        xlabel('time [S]')
        ylabel('volts')
        legend(v_names);
    else
        ic=1;
        lg = [];
        
        for j=1:length(step_idx)-1
            in_idx=step_idx(j);
            end_idx=step_idx(j+1)-1;
            plot(time(:,in_idx:end_idx),v_data(:,in_idx:end_idx),col_list{ic});
            hold on
            if ic == length(col_list)
                ic = 1;
            else
                ic = 1 + ic;
            end
            lg = [lg  strcat(v_names,['_' num2str(j) ] ) ] ;
            
        end
        legend(lg);
    end
end

if ~isempty(i_data)
    if get(handles.nest_cbox,'Value') == get(handles.nest_cbox,'Max')
        subplot(2,1,2)
    else
        figure
    end
    
    if isscalar(step_idx)
        plot(time,i_data);
        xlabel('time [S]')
        ylabel('current')
        legend(i_names);
    else
        ic=1;
        lg = [];
        for j=1:length(step_idx)-1
            in_idx=step_idx(j);
            end_idx=step_idx(j+1)-1;
            plot(time(:,in_idx:end_idx),i_data(:,in_idx:end_idx),col_list{ic});
            hold on
            if ic == length(col_list)
                ic = 1;
            else
                ic = 1 + ic;
            end
            lg = [lg  strcat(i_names,['_' num2str(j) ] ) ] ;
        end
         legend(lg);
    end
    
end



function  [idx, n_volt, n_cur]  = selected(handles)
%
% handles   strucutre with handels and user data
%
% idx       returns the index of the selected signals correpsonding to the Data
%           structure
% n_volt    number of current signals selected 
% n_cur     number of current signals selected 

idx_v = handles.volt_idxs_shown(get(handles.volt_list,'Value'));
idx_c = handles.curret_idxs_shown(get(handles.cur_list,'Value'));
n_volt = length(idx_v);
n_cur = length(idx_c);
idx = [ idx_v idx_c ];


function [time, v_data,i_data, v_names,i_names] = load_raw(handles)
%Loads the selected signals from the RAW document
[index_selected, n_volt , n_current ] = selected(handles);
list_entries = handles.var_name; %Get name variable lst

v_data = [];
i_data = [];
v_names = [];
i_names = [];


if (length(index_selected) > 25) || (length(index_selected) < 1)
    errordlg('You must select at least 1 and at most 25 variables','Incorrect Selection','modal')
else
   disp('Extracting data! Be patient!');
   Data = LTspice2Matlab(handles.FilePath,index_selected);
   time = Data.time_vect;
   
   if n_volt
    v_data = Data.variable_mat(1:n_volt,:);
    v_names = list_entries(index_selected(1:n_volt));
   end
   
   if n_current
    i_data = Data.variable_mat(end-(n_current-1):end,:);
    i_names = list_entries(index_selected(end-(n_current-1)));
   end
   
end

% --- Executes on selection change in volt_list.
function volt_list_Callback(hObject, eventdata, handles)
% hObject    handle to volt_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns volt_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from volt_list


% --- Executes during object creation, after setting all properties.
function volt_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volt_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cur_list.
function cur_list_Callback(hObject, eventdata, handles)
% hObject    handle to cur_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cur_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cur_list


% --- Executes during object creation, after setting all properties.
function cur_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cur_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in exp_button.
function exp_button_Callback(hObject, eventdata, handles)
% hObject    handle to exp_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Loads the selected signals from the RAW document
[index_selected] = selected(handles);

list_entries = handles.var_name; %Get name variable lst
n_sel = length(index_selected);
vars=list_entries(index_selected);
step_idx = handles.step_idx;


if (n_sel> 25) || (n_sel< 1)
    errordlg('You must select at least 1 and at most 25 variables','Incorrect Selection','modal');
else
    Data = LTspice2Matlab(handles.FilePath,index_selected);
    if isscalar(step_idx)
        
        assignin('base','time',Data.time_vect);
        for i=1:n_sel
            cData = Data.variable_mat(i,:);
            valid_idx  = ~isnan(cData); 
            x.Time = Data.time_vect(valid_idx);
            x.Data = cData(valid_idx);
            assignin('base',...
                regexprep(regexprep(vars{i},{'[(:]','+','-'},{'_','p','n'}),'[)]','')...
            ,x);
        end
    else
      for j=1:length(step_idx)-1
            in_idx=step_idx(j);
            end_idx=step_idx(j+1)-1;
            assignin('base',['time_' num2str(j)],...
                Data.time_vect(in_idx:end_idx));
             for i=1:n_sel
             cTime = Data.time_vect(in_idx:end_idx);     
             cData = Data.variable_mat(i,in_idx:end_idx);
             x.Time = cTime(valid_idx);
             x.Data = cData(valid_idx);
             valid_idx  = ~isnan(cData); 
             assignin('base',...
                regexprep(regexprep(vars{i},{'[(:]','+','-'},{'_','p','n'}),'[)]','')...
            ,x);
            end
      end
        
    end
    
end
    


% --- Executes on button press in nest_cbox.
function nest_cbox_Callback(hObject, eventdata, handles)
% hObject    handle to nest_cbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of nest_cbox


% --- Executes on button press in stats_push.
function stats_push_Callback(hObject, eventdata, handles)
% hObject    handle to stats_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[index_selected] = selected(handles);
list_entries = handles.var_name; %Get name variable lst

n_sel = length(index_selected);
var_names = list_entries(index_selected);

stats=zeros(n_sel,2);
step_idx = handles.step_idx;

if (n_sel> 25) || (n_sel< 1)
    errordlg('You must select at least 1 and at most 25 variables','Incorrect Selection','modal');
else
    disp('Loading data .... be patient!')
    Data = LTspice2Matlab(handles.FilePath,index_selected);
    if isscalar(step_idx)
        time = Data.time_vect;
        for i=1:n_sel
            valid_idx  = ~isnan(Data.variable_mat(i,:));
            stats(i,1) = trapz(time(valid_idx),Data.variable_mat(i,valid_idx))/(time(end)-time(1)); %Average value
            stats(i,2) = sqrt(trapz(time(valid_idx),Data.variable_mat(i,valid_idx).^2)/(time(end)-time(1))); %RMS
        end
        caption = {'Average', 'RMS'};
        
        f = figure('Name','Signal Statistics','Position',...
            [25 25 325 325],'MenuBar','none',...
            'NumberTitle','off');
        
        %Create Table
        
        t = uitable('Units','normalized','Position',...
            [0.05 0.05 0.95 0.95],...
            'ColumnName',caption,...
            'RowName',var_names);
        
        set(t,'ColumnWidth',{100});
        set(t,'ColumnFormat',{'shortEng', 'shortEng'});
        set(t,'Data',stats );
    else
        N_steps= length(step_idx)-1;
        stats=zeros(n_sel,2*N_steps);
         caption = [];
        for j=1:length(step_idx)-1
            in_idx=step_idx(j);
            end_idx=step_idx(j+1)-1;
            
            time = Data.time_vect(in_idx:end_idx);
           
            for i=1:n_sel
                cData = Data.variable_mat(i,in_idx:end_idx);
                valid_idx  = ~isnan(cData);
                stats(i,2*j-1) = trapz(time,...
                    cData(valid_idx)/(time(end)-time(1))); %Average value
                stats(i,2*j) = sqrt(trapz(time,...
                    cData(valid_idx).^2)/(time(end)-time(1))); %RMS
                
            end
            caption = [caption {['Avg ' num2str(j)], ['RMS '  num2str(j)]}];
        end
        
        f = figure('Name','Signal Statistics','Position',...
            [25 25 325 325],'MenuBar','none',...
            'NumberTitle','off');
        
        %Create Table
        
        t = uitable('Units','normalized','Position',...
            [0.05 0.05 0.95 0.95],...
            'ColumnName',caption,...
            'RowName',var_names);
        
        set(t,'ColumnWidth',{100});
        set(t,'ColumnFormat',{'shortEng', 'shortEng'});
        set(t,'Data',stats );
        
        
        
    end
    
    
end


% --- Executes on button press in Vclear_pb.
function Vclear_pb_Callback(hObject, eventdata, handles)
% hObject    handle to Vclear_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.volt_list,'Values',[])

% --- Executes on button press in iclear_pb.
function iclear_pb_Callback(hObject, eventdata, handles)
% hObject    handle to iclear_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.cur_list,'Values',[])


% --------------------------------------------------------------------
function freq_Callback(hObject, eventdata, handles)
% hObject    handle to freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[idx, n_volt, n_cur] = selected(handles);
switch handles.rclik_sender
    case 'vlist'
        index_selected = idx(n_volt);
        n_vars=n_volt;
    case 'ilist'
        index_selected = idx(n_volt+n_cur);
        n_vars=n_cur;
end
       
list_entries = handles.var_name; %Get name variable lst
var_names = list_entries(index_selected);

if (n_vars~= 1)
    errordlg('You must select only 1 signal.','Incorrect Selection','modal');
else
    disp('Loading data .... be patient!')
    Data = LTspice2Matlab(handles.FilePath,index_selected);
    time = Data.time_vect;
    valid_idx = ~isnan(Data.variable_mat);
    freq_avg(time(valid_idx),Data.variable_mat(valid_idx),var_names);
end

function freq_avg(time,data,var_name)

    T=time(end)-time(1);
    avg = (max(data)-min(data))/2;
    PWM = (data > avg);
    favg = sum(diff(PWM)==1)/T;
    msg = sprintf('Average Frequency = %s Hz\nIntegration period = %ss\n',...
        num2strEng(favg),num2strEng(T));
    msgbox(msg,...
        [  char(var_name)  ]);

% --------------------------------------------------------------------


% --------------------------------------------------------------------
function i_frec_Callback(hObject, eventdata, handles)
% hObject    handle to i_frec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_current = get(handles.cur_list,'Value');
index_selected = [ index_current+handles.curr_offset];
list_entries = handles.var_name; %Get name variable lst
var_names = list_entries(index_selected);

if (length(index_selected)~= 1)
    errordlg('You must select only 1 signal.','Incorrect Selection','modal');
else
    disp('Loading data .... be patient!')
    Data = LTspice2Matlab(handles.FilePath,index_selected);
    valid_idx = ~isnan(Data.variable_mat);
    freq_avg(time(valid_idx),Data.variable_mat(valid_idx),var_names);
end

% --------------------------------------------------------------------
function ilist_contextmenu_Callback(hObject, eventdata, handles)
% hObject    handle to ilist_contextmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over volt_list.
function volt_list_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to volt_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.rclik_sender='vlist';
guidata(hObject,handles)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over cur_list.
function cur_list_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to cur_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.rclik_sender='ilist';
guidata(hObject,handles)


% --------------------------------------------------------------------
function list_contextmenu_Callback(hObject, eventdata, handles)
% hObject    handle to list_contextmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function srch_text_Callback(hObject, eventdata, handles)
% hObject    handle to srch_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of srch_text as text
%        str2double(get(hObject,'String')) returns contents of srch_text as a double
if isempty(get(hObject,'String'))
    set(hObject,'String','Search...');
    set(handles.volt_list,'String',handles.volt_names);
    handles.volt_idxs_shown =  handles.volt_idxs;

else
    if  ~isempty(get(handles.name_text,'String'))
        vlst_names = handles.volt_names;
        volt_idx = handles.volt_idxs;
        key = get(hObject,'String');
        match_idx = ~cellfun(@isempty,regexpi(vlst_names,key));
        set(handles.volt_list,'String',vlst_names(match_idx));
        handles.volt_idxs_shown = volt_idx(match_idx);
        
    end

end
guidata(hObject,handles);






% --- Executes on key press with focus on srch_text and none of its controls.
function srch_text_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to srch_text (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
% if (handles.src_end)
%  set(hObject,'String','');
%  handles.src_end=0;
% end



% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over srch_text.
function srch_text_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to srch_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject,'String','Search...');
set(handles.volt_list,'String',handles.volt_names);
handles.volt_idxs_shown =  handles.volt_idxs;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function srch_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to srch_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function search2_Callback(hObject, eventdata, handles)
% hObject    handle to search2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of search2 as text
%        str2double(get(hObject,'String')) returns contents of search2 as a double
if isempty(get(hObject,'String'))
    set(hObject,'String','Search...');
    
    set(handles.cur_list,'String',handles.curret_names);
    handles.cur_idxs_shown =  handles.curret_idxs;

else
    if  ~isempty(get(handles.name_text,'String'))
        names = handles.curret_names;
        idx = handles.curret_idxs;
        key = get(hObject,'String');
        match_idx = ~cellfun(@isempty,regexpi(names,key));
        set(handles.cur_list,'String',names(match_idx));
        handles.curret_idxs_shown = idx(match_idx);
        
    end

end
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function search2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to search2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over search2.
function search2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to search2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('ButtonDwn ')
set(hObject,'String','Search...');
set(handles.cur_list,'String',handles.curret_names);
handles.cur_idxs_shown =  handles.curret_idxs;
guidata(hObject,handles);


% --- Executes on key press with focus on stats_push and none of its controls.
function stats_push_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to stats_push (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_mult.
function push_mult_Callback(hObject, eventdata, handles)
% hObject    handle to push_mult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[index_selected] = selected(handles);
list_entries = handles.var_name; %Get name variable lst

if length(index_selected)
    errordlg('You must select only 1 signal.','Incorrect Selection','modal');
else
    
end
    
