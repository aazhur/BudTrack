function varargout = BudTrack_mv3(varargin)
% BUDTRACK_MV3 MATLAB code for BudTrack_mv3.fig
%      BUDTRACK_MV3, by itself, creates a new BUDTRACK_MV3 or raises the existing
%      singleton*.
%
%      H = BUDTRACK_MV3 returns the handle to a new BUDTRACK_MV3 or the handle to
%      the existing singleton*.
%
%      BUDTRACK_MV3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BUDTRACK_MV3.M with the given input arguments.
%
%      BUDTRACK_MV3('Property','Value',...) creates a new BUDTRACK_MV3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BudTrack_mv3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BudTrack_mv3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BudTrack_mv3

% Last Modified by GUIDE v2.5 06-Nov-2016 16:37:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BudTrack_mv3_OpeningFcn, ...
                   'gui_OutputFcn',  @BudTrack_mv3_OutputFcn, ...
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


% --- Executes just before BudTrack_mv3 is made visible.
function BudTrack_mv3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BudTrack_mv3 (see VARARGIN)

% Choose default command line output for BudTrack_mv3
handles.output = hObject;

set(handles.copyright,'String',['  ' char(169) ' Denis Tsygankov '],'ForegroundColor',[.6 .6 .6]);

handles.time = 1;
handles.ang1 = 0;
handles.ang2 = 0;
handles.lev1 = 0.5;
handles.lev2 = 0.5;
handles.isdone = 0;

set(handles.slider_angle1, 'SliderStep',[1/180 5/180]);
set(handles.slider_angle1, 'Min', -90);
set(handles.slider_angle1, 'Max', 90);

set(handles.slider_angle2, 'SliderStep',[1/180 5/180]);
set(handles.slider_angle2, 'Min', -90);
set(handles.slider_angle2, 'Max', 90);


handles.lis_sld_time = addlistener(handles.slider_time,'Value','PostSet',@(src, event)SwitchImage(hObject, src, event));
handles.lis_sld_angle1 = addlistener(handles.slider_angle1,'Value','PostSet',@(src, event)SwitchAngle1(hObject, src, event));
handles.lis_sld_angle2 = addlistener(handles.slider_angle2,'Value','PostSet',@(src, event)SwitchAngle2(hObject, src, event));

handles.lis_sld_level1 = addlistener(handles.slider_level1,'Value','PostSet',@(src, event)SwitchLevel1(hObject, src, event));
handles.lis_sld_level2 = addlistener(handles.slider_level2,'Value','PostSet',@(src, event)SwitchLevel2(hObject, src, event));

try
    handles.lis_sld_time.Enabled = 0;
    handles.isnewversion = 1;
catch
    try
        set(handles.lis_sld_time, 'Enable', 'off');
        handles.isnewversion = 0;
    catch
        errordlg('This GUI is not compatible with your MATLAB version. Please contact Denis Tsygankov','Compatibility Problem','modal');
    end
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BudTrack_mv3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BudTrack_mv3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Menu ----------------------------------------------------------------

function menu_file_Callback(hObject, eventdata, handles)

function menu_import_Callback(hObject, eventdata, handles)

    [filename,pathname,filterindex] = uigetfile('*.tif','Choose a Tiff-file','MultiSelect','off'); 

    if filename~=0
        
        try
            delete(handles.line1); 
        end
        try
            delete(handles.line2);   
        end
        try
            delete(handles.line3);   
        end
        try
            delete(handles.L1);   
        end
        try
            delete(handles.L2);   
        end
        
        set(handles.text_filename,'String',filename);
        
        handles.ang1 = 0;
        handles.ang2 = 0;
        handles.lev1 = 0.5;
        handles.lev2 = 0.5;
        handles.time = 1;
        handles.isdone = 0;
        
        set(handles.pushbutton_update1, 'Enable', 'off');
        set(handles.pushbutton_update2, 'Enable', 'off');
        set(handles.pushbutton_update3, 'Enable', 'off');
        set(handles.pushbutton_reset, 'Enable', 'off');
        set(handles.pushbutton_save, 'Enable', 'off');
                
        set(handles.text_time,'String',' ');
        set(handles.text_angle1,'String',' ');
        set(handles.text_angle2,'String',' ');
        set(handles.text_level1,'String',' ');
        set(handles.text_level2,'String',' ');
        
        
        axes(handles.axes_3D_view);
        cla reset; 
        set(handles.axes_3D_view,'Box','on','XTick',[],'YTick',[],'Visible','on');
        
        axes(handles.axes_XY_view);
        cla reset; 
        set(handles.axes_XY_view,'Box','on','XTick',[],'YTick',[],'Visible','on');
        
        axes(handles.axes_XZ_view);
        cla reset; 
        set(handles.axes_XZ_view,'Box','on','XTick',[],'YTick',[],'Visible','on');
        
        axes(handles.axes_kymograph);
        cla reset; 
        set(handles.axes_kymograph,'Box','on','XTick',[],'YTick',[],'Visible','on');
        
        set(handles.slider_time, 'Enable', 'off');
        if handles.isnewversion
            handles.lis_sld_time.Enabled = 0;
        else
            set(handles.lis_sld_time, 'Enable', 'off');
        end
        set(handles.slider_time, 'Value', 1);
        
        set(handles.slider_angle1, 'Enable', 'off');
        if handles.isnewversion
            handles.lis_sld_angle1.Enabled = 0;
        else
            set(handles.lis_sld_angle1, 'Enable', 'off');
        end
        set(handles.slider_angle1, 'Value', 0);
        
        set(handles.slider_angle2, 'Enable', 'off');
        if handles.isnewversion
            handles.lis_sld_angle2.Enabled = 0;
        else
            set(handles.lis_sld_angle2, 'Enable', 'off');
        end
        set(handles.slider_angle2, 'Value', 0);
        
        set(handles.slider_level1, 'Enable', 'off');
        if handles.isnewversion
            handles.lis_sld_level1.Enabled = 0;
        else
            set(handles.lis_sld_level1, 'Enable', 'off');
        end
        set(handles.slider_level1, 'Value', 0.5);
        
        set(handles.slider_angle2, 'Enable', 'off');
        if handles.isnewversion
            handles.lis_sld_level2.Enabled = 0;
        else
            set(handles.lis_sld_level2, 'Enable', 'off');
        end
        set(handles.slider_level2, 'Value', 0.5);

        info = imfinfo([pathname filename]);    
        NUM = numel(info);      
        
        IMo = cell(1,NUM);
        IMo{1} = double(imread([pathname filename],1));
        Isize = size(IMo{1},1);
        Jsize = size(IMo{1},2);
        HST = zeros(Isize*Jsize,NUM);
        HST(:,1) = IMo{1}(:);
        
        wb = waitbar(0,'Finding a threshold for segmentation...','WindowStyle','modal');
        for f = 2:NUM
            waitbar(f/NUM);
            IMo{f} = double(imread([pathname filename],f));
            HST(:,f) = IMo{f}(:);
        end
        close(wb);
        level=graythresh(uint8(HST));
        Thresh=level*255;
   
        %figure;
        %hist(HST(:),150);
        %return;

        set(handles.text_tip,'String','Tip: enter the requested information');
        prompt = {'Enter the number of z-slices in this image file:','Enter the z step size:','Change the default threshold as needed'};
        dlg_title = ['Z-stack Info for ' filename];
        num_lines = [1 50];
        def = {'15','3',num2str(Thresh)};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        if isempty(answer)
            set(handles.text_filename,'String',' ');
            set(handles.text_tip,'String','Tip: Import TIFF image using ( File -> Import ) in the menu');
            return;
        else
            SLC = str2double(answer{1});
            Zscale = str2double(answer{2});
            Thresh = str2double(answer{3});
            
            handles.ZS = Zscale;
            handles.TH = Thresh;
        end
        

        if isnumeric(SLC) && SLC>0 && mod(NUM,SLC)==0
            FRM = NUM/SLC;
        else       
            errordlg('The number of z-slices and time frames do not add up','Wrong number of z-slices','modal');
            return;
        end

        if ~isnumeric(Zscale) || Zscale<1
            errordlg('You have to enter a meaningful value for z step size > 1.','Wrong value of z step size','modal');
            return;
        end

        if ~isnumeric(Thresh) || Thresh<0
            errordlg('You have to enter a meaningful threshold  >= 0.','Wrong value of a threshold','modal');
            return;
        end
        
        rXY = 0.5*sqrt(Isize^2 + Jsize^2);

        VOL = cell(1,FRM);  
        Lfc = cell(1,FRM); 
        Lvr = cell(1,FRM); 

        Zsize = round(Zscale*(SLC+1)-1);
        [Xq,Yq,Zq] = meshgrid(1:(Jsize+2),1:(Isize+2),linspace(1,SLC+2,Zsize+2));
        
        wb = waitbar(0,'Processing 3D surface...','WindowStyle','modal');
        set(handles.text_tip,'String','Tip: wait');
        for f = 1:FRM     
            vol = zeros(Isize+2,Jsize+2,SLC+2);
            for s = 1:SLC
                %IM = double(imread([pathname filename],SLC*(f-1)+s));
                IM = IMo{SLC*(f-1)+s};
                IM(IM<Thresh)=0;            
                %vol(2:(Isize+1),2:(Jsize+1),s+1) = imfill(IM); 
                vol(2:(Isize+1),2:(Jsize+1),s+1) = IM;
            end
            if Zscale > 1
                %vol = interp3(vol,Xq,Yq,Zq,'cubic');
                vol = interp3(vol,Xq,Yq,Zq,'linear');
            end
            [Lfc{f},Lvr{f}]=isosurface(vol,0.5);
            %ptch = isosurface(vol,0.5);
            %[Lfc{f},Lvr{f}]=reducepatch(ptch,0.5);
            VOL{f}=vol;
            waitbar(f/FRM);
        end
        close(wb);
        
        m = (max([Isize,Jsize,Zsize])+1)/2;
        xc = (Jsize+3)/2;
        yc = (Isize+3)/2;
        zc = (Zsize+3)/2;
        
        handles.Isize = Isize;
        handles.Jsize = Jsize;
        handles.Zsize = Zsize;
        handles.rXY = rXY;
        
        handles.VOL = VOL;
        handles.Lfc = Lfc;
        handles.Lvr = Lvr;
        handles.aspect = [1 1 1];
        handles.XYview = [0,90];
        handles.XZview = [0,0];
        
        handles.VOL1 = VOL;
        handles.Lfc1 = Lfc;
        handles.Lvr1 = Lvr;
        handles.aspect1 = [1 1 1];
        
        handles.VOL2 = VOL;
        handles.Lfc2 = Lfc;
        handles.Lvr2 = Lvr;
        handles.aspect2 = [1 1 1];
        handles.XYview2 = [0,90];
        handles.XZview2 = [0,0];
        
        handles.VOL3 = VOL;
        handles.Lfc3 = Lfc;
        handles.Lvr3 = Lvr;
        
        handles.Zscale = Zscale;
        handles.FRM = FRM;
        
        set(handles.text_time,'String',['time: ' num2str(1) '/' num2str(FRM)]);
        set(handles.text_angle1,'String','Yaw angle: 0');
        set(handles.text_angle2,'String','Pitch angle: 0');
        set(handles.text_level1,'String','Green line height: 0.5');
        set(handles.text_level2,'String','Blue line height: 0.5');
        
        axes(handles.axes_3D_view);
        set(handles.axes_3D_view,'YLim',[yc-m,yc+m],'XLim',[xc-m,xc+m],'ZLim',[zc-m zc+m]);
        set(handles.axes_3D_view,'Box','on','XTick',[],'YTick',[],'ZTick',[]);
        cla;
        patch('Vertices', Lvr{1}, 'Faces', Lfc{1}, 'FaceVertexCData', 0.5*ones(size(Lvr{1})),'FaceColor','red','EdgeColor','none','FaceAlpha',1.0);
        daspect(handles.aspect);
        view([40,25]); 
        camlight 
        lighting gouraud
        
        axes(handles.axes_XY_view);
        set(handles.axes_XY_view,'YLim',[yc-m,yc+m],'XLim',[xc-m,xc+m],'ZLim',[zc-m zc+m]);
        set(handles.axes_XY_view,'Box','off','XTick',[],'YTick',[],'ZTick',[]);
        cla;
        patch('Vertices', Lvr{1}, 'Faces', Lfc{1}, 'FaceVertexCData', 0.5*ones(size(Lvr{1})),'FaceColor','red','EdgeColor','none','FaceAlpha',1.0);
        daspect(handles.aspect);
        view(handles.XYview); 
        camlight 
        lighting gouraud
                        
        axes(handles.axes_XZ_view);
        set(handles.axes_XZ_view,'YLim',[yc-m,yc+m],'XLim',[xc-m,xc+m],'ZLim',[zc-m zc+m]);
        set(handles.axes_XZ_view,'Box','off','XTick',[],'YTick',[],'ZTick',[]);
        cla;
        patch('Vertices', Lvr{1}, 'Faces', Lfc{1}, 'FaceVertexCData', 0.5*ones(size(Lvr{1})),'FaceColor','red','EdgeColor','none','FaceAlpha',1.0);
        daspect(handles.aspect);
        view(handles.XZview); 
        camlight 
        lighting gouraud
        
        posXY = get(handles.axes_XY_view,'Position');
        posXZ = get(handles.axes_XZ_view,'Position');
        
        handles.line1 = annotation('line',[posXY(1)+0.0*posXY(3) posXY(1)+1.0*posXY(3)],...
                                          [posXY(2)+0.5*posXY(4) posXY(2)+0.5*posXY(4)],'Color','g','LineWidth',2);
        handles.line2 = annotation('line',[posXZ(1)+0.0*posXZ(3) posXZ(1)+1.0*posXZ(3)],...
                                          [posXZ(2)+0.5*posXZ(4) posXZ(2)+0.5*posXZ(4)],'Color','c','LineWidth',2);
        
        set(handles.slider_time, 'SliderStep',[1/(FRM-1) 5/(FRM-1)]);
        set(handles.slider_time, 'Min', 1);
        set(handles.slider_time, 'Max', FRM);
        set(handles.slider_time, 'Enable', 'on');
        if handles.isnewversion
            handles.lis_sld_time.Enabled = 1;
        else
            set(handles.lis_sld_time, 'Enable', 'on');
        end
        set(handles.slider_angle1, 'Enable', 'on');
        if handles.isnewversion
            handles.lis_sld_angle1.Enabled = 1;
        else
            set(handles.lis_sld_angle1, 'Enable', 'on');
        end
        set(handles.pushbutton_update1, 'Enable', 'on');
        
        set(handles.text_tip,'String','Tip: Adjust yaw angle to align bud emergence along the green line (use horizontal sliders, then accept)');
        
        guidata(hObject, handles);
        
    end

% -------------------------------------------------------------------------


% --- Function for Listeners ----------------------------------------------

function SwitchImage(hObject, src, event)

    handles = guidata(hObject);
    
    if handles.isnewversion
        f = round(event.AffectedObject.Value);
    else
        f = round(event.NewValue);
    end
    FRM = handles.FRM;
           
    set(handles.text_time,'String',['time: ' num2str(f) '/' num2str(FRM)]);
    
    if handles.isdone
        try
            delete(handles.line3); 
        end

        posKYM = get(handles.axes_kymograph,'Position');
        handles.line3 = annotation('line',[posKYM(1)+f*posKYM(3)/FRM posKYM(1)+f*posKYM(3)/FRM],...
                                          [posKYM(2)+0.0*posKYM(4) posKYM(2)+1.0*posKYM(4)],'Color','w','LineWidth',2);
    end
    
    axes(handles.axes_3D_view);
    [az,el]=view;    
    cla;
    patch('Vertices', handles.Lvr1{f}, 'Faces', handles.Lfc1{f}, 'FaceVertexCData', 0.5*ones(size(handles.Lvr1{f})),'FaceColor','red','EdgeColor','none','FaceAlpha',1.0);
    daspect(handles.aspect1);
    view([az,el]); 
    camlight 
    lighting gouraud
    
    axes(handles.axes_XY_view);
    cla;
    patch('Vertices', handles.Lvr2{f}, 'Faces', handles.Lfc2{f}, 'FaceVertexCData', 0.5*ones(size(handles.Lvr2{f})),'FaceColor','red','EdgeColor','none','FaceAlpha',1.0);
    daspect(handles.aspect2);
    view(handles.XYview2); 
    camlight 
    lighting gouraud
    
    axes(handles.axes_XZ_view);
    cla;
    patch('Vertices', handles.Lvr3{f}, 'Faces', handles.Lfc3{f}, 'FaceVertexCData', 0.5*ones(size(handles.Lvr3{f})),'FaceColor','red','EdgeColor','none','FaceAlpha',1.0);
    daspect(handles.aspect2);
    view(handles.XZview2); 
    camlight 
    lighting gouraud
    
    uistack(handles.line1,'top');
    uistack(handles.line2,'top');
    
    handles.time = f;
    
    guidata(hObject, handles);

function SwitchAngle1(hObject, src, event)

    handles = guidata(hObject);
    
    if handles.isnewversion
        ang1 = round(event.AffectedObject.Value);
    else
        ang1 = round(event.NewValue);
    end
    set(handles.text_angle1,'String',['Yaw angle: ' num2str(ang1)]);
       
    handles.XYview2(1) = -ang1;
    handles.XZview2(1) = -ang1;
    
    axes(handles.axes_XY_view);
    view(handles.XYview2);
    
    axes(handles.axes_XZ_view);
    view(handles.XZview2);
    
    uistack(handles.line1,'top');
    uistack(handles.line2,'top');
    
    handles.ang1 = ang1;
    
    guidata(hObject, handles);
    
function SwitchAngle2(hObject, src, event)

    handles = guidata(hObject);
    
    if handles.isnewversion
        ang2 = round(event.AffectedObject.Value);
    else
        ang2 = round(event.NewValue);
    end
    set(handles.text_angle2,'String',['Pitch angle: ' num2str(ang2)]);
    
    handles.XYview2(1) =  ang2;
    handles.XZview2(1) = -ang2;
    
    axes(handles.axes_XY_view);
    view(handles.XYview2);  
    
    axes(handles.axes_XZ_view);
    view(handles.XZview2);
    
    uistack(handles.line1,'top');
    uistack(handles.line2,'top');
    
    handles.ang2 = ang2;
    
    guidata(hObject, handles);    
    
function SwitchLevel1(hObject, src, event)

    handles = guidata(hObject);
    
    try
        delete(handles.line1); 
    end

    if handles.isnewversion
        lev1 = event.AffectedObject.Value;
    else
        lev1 = event.NewValue;
    end
    posXY = get(handles.axes_XY_view,'Position');
    handles.line1 = annotation('line',[posXY(1)+0.00*posXY(3) posXY(1)+1.00*posXY(3)],...
                                      [posXY(2)+lev1*posXY(4) posXY(2)+lev1*posXY(4)],'Color','g','LineWidth',2);
                                      
    set(handles.text_level1,'String',['Green line height: ' num2str(lev1,'%.2f')]);
    handles.lev1 = lev1;
    
    guidata(hObject, handles);

function SwitchLevel2(hObject, src, event)

    handles = guidata(hObject);
    
    try
        delete(handles.line2); 
    end
    
    if handles.isnewversion
        lev2 = event.AffectedObject.Value;
    else
        lev2 = event.NewValue;
    end
    posXZ = get(handles.axes_XZ_view,'Position');
    handles.line2 = annotation('line',[posXZ(1)+0.00*posXZ(3) posXZ(1)+1.00*posXZ(3)],...
                                      [posXZ(2)+lev2*posXZ(4) posXZ(2)+lev2*posXZ(4)],'Color','c','LineWidth',2);
                                      
    set(handles.text_level2,'String',['Blue line height: ' num2str(lev2,'%.2f')]);
    handles.lev2 = lev2;
    
    guidata(hObject, handles);
    
% -------------------------------------------------------------------------


% --- Buttons -------------------------------------------------------------

function pushbutton_update1_Callback(hObject, eventdata, handles)

    set(handles.pushbutton_update1, 'Enable', 'off');

    VOL = handles.VOL2;
    [~,~,Zsize1] = size(VOL{1});
    
    FRM = handles.FRM;
    ang1 = handles.ang1;
    VOL1 = cell(1,FRM);  
    Lfc1 = cell(1,FRM); 
    Lvr1 = cell(1,FRM);
    VOL2 = cell(1,FRM);  
    Lfc2 = cell(1,FRM); 
    Lvr2 = cell(1,FRM);
    VOL3 = cell(1,FRM);  
    Lfc3 = cell(1,FRM); 
    Lvr3 = cell(1,FRM);
            
    wb = waitbar(0,'Updating...','WindowStyle','modal');
    set(handles.text_tip,'String','Tip: wait');
       
    for f = 1:FRM             
        vol = VOL{f};
        IM = vol(:,:,1);
        if ang1 == 0
            IM2 = IM;
        else
            IM2 = round(imrotate(IM,-ang1,'loose','bilinear'));
        end
        Isize1 = size(IM2,1);
        Jsize1 = size(IM2,2);
        vol1 = zeros(Isize1,Jsize1,Zsize1);
        vol1(:,:,1) = IM2;
        vol2 = zeros(Zsize1,Jsize1,Isize1);
        vol2(1,:,:) = IM2';
        vol3 = zeros(Zsize1,Jsize1,Isize1);
        vol3(1,:,:) = fliplr(IM2');
        for s = 2:Zsize1
            IM = vol(:,:,s);
            if ang1 == 0
                IM2 = IM;
            else
                IM2 = round(imrotate(IM,-ang1,'loose','bilinear'));
            end
            vol1(:,:,s) = IM2;   
            vol2(s,:,:) = IM2';            
            vol3(s,:,:) = fliplr(IM2');            
        end
        vol2 = flipud(vol2);
        [Lfc1{f},Lvr1{f}]=isosurface(vol1,0.5);
        [Lfc2{f},Lvr2{f}]=isosurface(vol2,0.5);
        [Lfc3{f},Lvr3{f}]=isosurface(vol3,0.5);
        VOL1{f}=vol1;
        VOL2{f}=vol2;
        VOL3{f}=vol3;
        waitbar(f/FRM);
    end
    close(wb)
     
    %handles.ang1 = 0;
    handles.VOL1 = VOL1;
    handles.Lfc1 = Lfc1;
    handles.Lvr1 = Lvr1;
    handles.VOL2 = VOL2;
    handles.Lfc2 = Lfc2;
    handles.Lvr2 = Lvr2;
    handles.VOL3 = VOL3;
    handles.Lfc3 = Lfc3;
    handles.Lvr3 = Lvr3;
    handles.aspect2 = [1 1 1];
    handles.XYview2 = [0,0];
    handles.XZview2 = [0,90];
     
    f = handles.time;
    
    m = (max([Isize1,Jsize1,Zsize1])-1)/2;
    xc = (Jsize1+1)/2;
    yc = (Isize1+1)/2;
    zc = (Zsize1+1)/2;
    
    axes(handles.axes_3D_view);
    set(handles.axes_3D_view,'YLim',[yc-m,yc+m],'XLim',[xc-m,xc+m],'ZLim',[zc-m zc+m]);
    set(handles.axes_3D_view,'Box','on','XTick',[],'YTick',[],'ZTick',[]);
    [az,el]=view;    
    cla;
    patch('Vertices', handles.Lvr1{f}, 'Faces', handles.Lfc1{f}, 'FaceVertexCData', 0.5*ones(size(handles.Lvr1{f})),'FaceColor','red','EdgeColor','none','FaceAlpha',1.0);
    daspect(handles.aspect1);
    view([az+ang1,el]);    
    camlight 
    lighting gouraud
    
    axes(handles.axes_XY_view);
    set(handles.axes_XY_view,'ZLim',[yc-m,yc+m],'XLim',[xc-m,xc+m],'YLim',[zc-m zc+m]);
    set(handles.axes_XY_view,'Box','off','XTick',[],'YTick',[],'ZTick',[]);
    cla;
    patch('Vertices', handles.Lvr2{f}, 'Faces', handles.Lfc2{f}, 'FaceVertexCData', 0.5*ones(size(handles.Lvr2{f})),'FaceColor','red','EdgeColor','none','FaceAlpha',1.0);
    daspect(handles.aspect2);
    view(handles.XYview2);    
    camlight 
    lighting gouraud
    hold on;
    
    axes(handles.axes_XZ_view);
    set(handles.axes_XZ_view,'ZLim',[yc-m,yc+m],'XLim',[xc-m,xc+m],'YLim',[zc-m zc+m]);
    set(handles.axes_XZ_view,'Box','off','XTick',[],'YTick',[],'ZTick',[]);
    cla;
    patch('Vertices', handles.Lvr3{f}, 'Faces', handles.Lfc3{f}, 'FaceVertexCData', 0.5*ones(size(handles.Lvr3{f})),'FaceColor','red','EdgeColor','none','FaceAlpha',1.0);
    daspect(handles.aspect2);
    view(handles.XZview2); 
    camlight 
    lighting gouraud
        
    set(handles.slider_angle1, 'Enable', 'off');
    if handles.isnewversion
        handles.lis_sld_angle1.Enabled = 0;
    else
        set(handles.lis_sld_angle1, 'Enable', 'off');
    end
    set(handles.slider_angle1, 'Value', 0);
    
    set(handles.slider_angle2, 'Enable', 'on');
    if handles.isnewversion
        handles.lis_sld_angle2.Enabled = 1;
    else
        set(handles.lis_sld_angle2, 'Enable', 'on');
    end
    set(handles.pushbutton_update2, 'Enable', 'on');
    set(handles.pushbutton_reset, 'Enable', 'on');
    
    set(handles.text_tip,'String','Tip: Adjust pitch angle to align bud emergence along the blue line (use horizontal sliders, then accept)');
    
    guidata(hObject, handles);

function pushbutton_update2_Callback(hObject, eventdata, handles)

    set(handles.pushbutton_update2, 'Enable', 'off');

    VOL = handles.VOL3;
    [~,~,Zsize2] = size(VOL{1});
    
    FRM = handles.FRM;
    ang2 = handles.ang2;
    VOL1 = cell(1,FRM);  
    Lfc1 = cell(1,FRM); 
    Lvr1 = cell(1,FRM);
    VOL2 = cell(1,FRM);  
    Lfc2 = cell(1,FRM); 
    Lvr2 = cell(1,FRM);
    VOL3 = cell(1,FRM);  
    Lfc3 = cell(1,FRM); 
    Lvr3 = cell(1,FRM);
           
    wb = waitbar(0,'Updating...','WindowStyle','modal');
    set(handles.text_tip,'String','Tip: wait');
    for f = 1:FRM             
        vol = VOL{f};
        IM = vol(:,:,1);
        if ang2 == 0
            IM2 = IM;
        else
            IM2 = round(imrotate(IM,-ang2,'loose','bilinear'));
        end
        Isize2 = size(IM2,1);
        Jsize2 = size(IM2,2);
        vol3 = zeros(Zsize2,Jsize2,Isize2);
        vol3(1,:,:) = IM2';
        for s = 2:Zsize2
            IM = vol(:,:,s);
            if ang2 == 0
                IM2 = IM;
            else
                IM2 = round(imrotate(IM,-ang2,'loose','bilinear'));
            end
            vol3(s,:,:) = IM2';            
        end
        vol3 = flipud(vol3);
        [Lfc3{f},Lvr3{f}]=isosurface(vol3,0.5);
        Lfc1{f} = Lfc3{f};
        Lfc2{f} = Lfc3{f};
        Lvr1{f} = Lvr3{f};
        Lvr2{f} = Lvr3{f};
        
        VOL1{f}=vol3;
        VOL2{f}=vol3;
        VOL3{f}=vol3;
        waitbar(f/FRM);
    end
    close(wb)
           
    %handles.ang2 = 0;
    handles.VOL1 = VOL1;
    handles.Lfc1 = Lfc1;
    handles.Lvr1 = Lvr1;
    handles.VOL2 = VOL2;
    handles.Lfc2 = Lfc2;
    handles.Lvr2 = Lvr2;
    handles.VOL3 = VOL3;
    handles.Lfc3 = Lfc3;
    handles.Lvr3 = Lvr3;
    handles.aspect2 = [1 1 1];
    handles.XYview2 = [0,90];
    handles.XZview2 = [0,0];
     
    f = handles.time;
    
    m = (max([Isize2,Jsize2,Zsize2])-1)/2;
    xc = (Jsize2+1)/2;
    yc = (Isize2+1)/2;
    zc = (Zsize2+1)/2;
    
    axes(handles.axes_3D_view);
    set(handles.axes_3D_view,'ZLim',[yc-m,yc+m],'XLim',[xc-m,xc+m],'YLim',[zc-m zc+m]);
    set(handles.axes_3D_view,'Box','on','XTick',[],'YTick',[],'ZTick',[]);
    [az,el]=view;    
    cla;
    patch('Vertices', handles.Lvr1{f}, 'Faces', handles.Lfc1{f}, 'FaceVertexCData', 0.5*ones(size(handles.Lvr1{f})),'FaceColor','red','EdgeColor','none','FaceAlpha',1.0);
    daspect(handles.aspect1);
    view([az,el+ang2]);    
    camlight 
    lighting gouraud
    
    axes(handles.axes_XY_view);
    set(handles.axes_XY_view,'ZLim',[yc-m,yc+m],'XLim',[xc-m,xc+m],'YLim',[zc-m zc+m]);
    set(handles.axes_XY_view,'Box','off','XTick',[],'YTick',[],'ZTick',[]);
    cla;
    patch('Vertices', handles.Lvr2{f}, 'Faces', handles.Lfc2{f}, 'FaceVertexCData', 0.5*ones(size(handles.Lvr2{f})),'FaceColor','red','EdgeColor','none','FaceAlpha',1.0);
    daspect(handles.aspect2);
    view(handles.XYview2);    
    camlight 
    lighting gouraud
    hold on;
    
    axes(handles.axes_XZ_view);
    set(handles.axes_XZ_view,'ZLim',[yc-m,yc+m],'XLim',[xc-m,xc+m],'YLim',[zc-m zc+m]);
    set(handles.axes_XZ_view,'Box','off','XTick',[],'YTick',[],'ZTick',[]);
    cla;
    patch('Vertices', handles.Lvr3{f}, 'Faces', handles.Lfc3{f}, 'FaceVertexCData', 0.5*ones(size(handles.Lvr3{f})),'FaceColor','red','EdgeColor','none','FaceAlpha',1.0);
    daspect(handles.aspect2);
    view(handles.XZview2); 
    camlight 
    lighting gouraud
        
    set(handles.slider_angle2, 'Enable', 'off');
    if handles.isnewversion
        handles.lis_sld_angle2.Enabled = 0;
    else
        set(handles.lis_sld_angle2, 'Enable', 'off');
    end
    set(handles.slider_angle2, 'Value', 0);
    
    set(handles.slider_level1, 'Enable', 'on');
    if handles.isnewversion
        handles.lis_sld_level1.Enabled = 1;
    else
        set(handles.lis_sld_level1, 'Enable', 'on');
    end
    set(handles.slider_level2, 'Enable', 'on');
    if handles.isnewversion
        handles.lis_sld_level2.Enabled = 1;
    else
        set(handles.lis_sld_level2, 'Enable', 'on');
    end
    set(handles.pushbutton_update3, 'Enable', 'on');
    
    set(handles.text_tip,'String','Tip: Adjust green and blue line heights to pass through the bud center (use vertical sliders, then accept)');
    
    guidata(hObject, handles);

function pushbutton_update3_Callback(hObject, eventdata, handles)

    VOL = handles.VOL3;
    FRM = handles.FRM;
    [Isize,Jsize,Zsize] = size(VOL{1});
    
    m = (max([Isize,Jsize,Zsize])-1)/2;
    xc = (Jsize+1)/2;
    yc = (Isize+1)/2;
    zc = (Zsize+1)/2;
    
    KYM = zeros(Jsize,FRM);
    
    lev1 = round(yc-m+2*m*handles.lev1);
    lev2 = round(zc-m+2*m*handles.lev2);
    
    if lev1>=1 && lev1<=Isize && lev2>=1 && lev2<=Zsize 

        for f = 1:FRM
            vol = VOL{f};
            SL = squeeze(vol(:,:,lev2));
            KYM(:,f) = SL(lev1,:)';
        end
    end
    
    f = handles.time;
    
    axes(handles.axes_kymograph);
    cla;
    imagesc(KYM);
    axis xy;
    axis off;
    
    handles.KYMO = KYM;
    
    try
        delete(handles.L1);
    end
    try
        delete(handles.L2);
    end
    try
        delete(handles.line3);
    end
    handles.L1 = imline(handles.axes_kymograph,[0.1*FRM 0.3*FRM],[0.9*Jsize 0.9*Jsize]);
    setColor(handles.L1,[1 0 0]);
    handles.L2 = imline(handles.axes_kymograph,[0.1*FRM 0.3*FRM],[0.8*Jsize 0.8*Jsize]);
    setColor(handles.L2,[1 0 0]);
    
    posKYM = get(handles.axes_kymograph,'Position');
    handles.line3 = annotation('line',[posKYM(1)+f*posKYM(3)/FRM posKYM(1)+f*posKYM(3)/FRM],...
                                      [posKYM(2)+0.0*posKYM(4) posKYM(2)+1.0*posKYM(4)],'Color','w','LineWidth',2);
       
    handles.isdone = 1;
    set(handles.text_tip,'String','Tip: Use the draggable red lines to fit manually kymograph slope before and after bud emergence');
    
    set(handles.pushbutton_save,'Enable','on');
    
    guidata(hObject, handles);
    
function pushbutton_reset_Callback(hObject, eventdata, handles)

    set(handles.pushbutton_update1, 'Enable', 'on');
    set(handles.pushbutton_update2, 'Enable', 'off');
    set(handles.pushbutton_update3, 'Enable', 'off');
    set(handles.pushbutton_save,'Enable','off');
    set(handles.pushbutton_reset, 'Enable', 'off');

    axes(handles.axes_kymograph);
    cla reset; 
    set(handles.axes_kymograph,'Box','on','XTick',[],'YTick',[],'Visible','on');
        
    handles.ang1 = 0;
    handles.ang2 = 0;
    handles.lev1 = 0.5;
    handles.lev2 = 0.5;
    handles.isdone = 0;
    
    set(handles.text_angle1,'String','Yaw angle: 0');
    set(handles.text_angle2,'String','Pitch angle: 0');
    set(handles.text_level1,'String','Green line height: 0.5');
    set(handles.text_level2,'String','Blue line height: 0.5');
    
    set(handles.slider_angle1, 'Enable', 'on');
    if handles.isnewversion
        handles.lis_sld_angle1.Enabled = 1;
    else
        set(handles.lis_sld_angle1, 'Enable', 'on');
    end
    set(handles.slider_angle1, 'Value', 0);

    set(handles.slider_angle2, 'Enable', 'off');
    if handles.isnewversion
        handles.lis_sld_angle2.Enabled = 0;
    else
        set(handles.lis_sld_angle2, 'Enable', 'off');
    end
    set(handles.slider_angle2, 'Value', 0);

    set(handles.slider_level1, 'Enable', 'off');
    if handles.isnewversion
        handles.lis_sld_level1.Enabled = 0;
    else
        set(handles.lis_sld_level1, 'Enable', 'off');
    end
    set(handles.slider_level1, 'Value', 0.5);

    set(handles.slider_angle2, 'Enable', 'off');
    if handles.isnewversion
        handles.lis_sld_level2.Enabled = 0;
    else
        set(handles.lis_sld_level2, 'Enable', 'off');
    end
    set(handles.slider_level2, 'Value', 0.5);
    
    try
        delete(handles.line1); 
    end
    try
        delete(handles.line2);   
    end
    try
        delete(handles.line3);   
    end
    try
        delete(handles.L1);   
    end
    try
        delete(handles.L2);   
    end
        
    VOL = handles.VOL;
    Lfc = handles.Lfc;
    Lvr = handles.Lvr;
    handles.aspect = [1 1 1];
    handles.XYview = [0,90];
    handles.XZview = [0,0];

    handles.VOL1 = VOL;
    handles.Lfc1 = Lfc;
    handles.Lvr1 = Lvr;
    handles.aspect1 = [1 1 1];

    handles.VOL2 = VOL;
    handles.Lfc2 = Lfc;
    handles.Lvr2 = Lvr;
    handles.aspect2 = [1 1 1];
    handles.XYview2 = [0,90];
    handles.XZview2 = [0,0];

    handles.VOL3 = VOL;
    handles.Lfc3 = Lfc;
    handles.Lvr3 = Lvr;
    
    [Isize,Jsize,Zsize] = size(VOL{1});
    
    m = (max([Isize,Jsize,Zsize])-1)/2;
    xc = (Jsize+1)/2;
    yc = (Isize+1)/2;
    zc = (Zsize+1)/2;
    
    f = handles.time;
    
    axes(handles.axes_3D_view);
    set(handles.axes_3D_view,'YLim',[yc-m,yc+m],'XLim',[xc-m,xc+m],'ZLim',[zc-m zc+m]);
    set(handles.axes_3D_view,'Box','on','XTick',[],'YTick',[],'ZTick',[]);
    cla;
    patch('Vertices', Lvr{f}, 'Faces', Lfc{f}, 'FaceVertexCData', 0.5*ones(size(Lvr{f})),'FaceColor','red','EdgeColor','none','FaceAlpha',1.0);
    daspect(handles.aspect);
    view([40,25]); 
    camlight 
    lighting gouraud

    axes(handles.axes_XY_view);
    set(handles.axes_XY_view,'YLim',[yc-m,yc+m],'XLim',[xc-m,xc+m],'ZLim',[zc-m zc+m]);
    set(handles.axes_XY_view,'Box','off','XTick',[],'YTick',[],'ZTick',[]);
    cla;
    patch('Vertices', Lvr{f}, 'Faces', Lfc{f}, 'FaceVertexCData', 0.5*ones(size(Lvr{f})),'FaceColor','red','EdgeColor','none','FaceAlpha',1.0);
    daspect(handles.aspect);
    view(handles.XYview); 
    camlight 
    lighting gouraud
    
    axes(handles.axes_XZ_view);
    set(handles.axes_XZ_view,'YLim',[yc-m,yc+m],'XLim',[xc-m,xc+m],'ZLim',[zc-m zc+m]);
    set(handles.axes_XZ_view,'Box','off','XTick',[],'YTick',[],'ZTick',[]);
    cla;
    patch('Vertices', Lvr{1}, 'Faces', Lfc{1}, 'FaceVertexCData', 0.5*ones(size(Lvr{1})),'FaceColor','red','EdgeColor','none','FaceAlpha',1.0);
    daspect(handles.aspect);
    view(handles.XZview); 
    camlight 
    lighting gouraud

    posXY = get(handles.axes_XY_view,'Position');
    posXZ = get(handles.axes_XZ_view,'Position');

    handles.line1 = annotation('line',[posXY(1)+0.0*posXY(3) posXY(1)+1.0*posXY(3)],...
                                      [posXY(2)+0.5*posXY(4) posXY(2)+0.5*posXY(4)],'Color','g','LineWidth',2);
    handles.line2 = annotation('line',[posXZ(1)+0.0*posXZ(3) posXZ(1)+1.0*posXZ(3)],...
                                      [posXZ(2)+0.5*posXZ(4) posXZ(2)+0.5*posXZ(4)],'Color','c','LineWidth',2);


    set(handles.text_tip,'String','Tip: Adjust yaw angle to align bud emergence along the green line (use horizontal sliders, then accept)');
        
    guidata(hObject, handles);                              
 
function pushbutton_save_Callback(hObject, eventdata, handles)

    Lin1 = handles.L1;
    Lin2 = handles.L2;
    Fram = handles.time;
    Ang1 = handles.ang1;
    Ang2 = handles.ang2;
    Lev1 = handles.lev1;
    Lev2 = handles.lev2;
    Zscl = handles.ZS;
    Thsh = handles.TH;
    
    Pos1 = Lin1.getPosition();
    Pos2 = Lin2.getPosition();
    
    
    dlg_title = 'Save the results as a text file (the kymograph will be saved too)';
    [FileName,PathName,FilterIndex] = uiputfile('*.txt',dlg_title,'Result001');
    if FilterIndex
        %try
            fid = fopen([PathName FileName],'wt');
            fprintf(fid,'Parameters: z step size, threshold value, current time frame, yaw angle, pitch angle, green line height, blue line height, [x1,y1,x2,y2] of line 1, [x1,y1,x2,y2] of line 2 \n');
            fprintf(fid,' % 3.2f \t % 3.2f \t % 3.2f \t % 3.2f \t % 3.2f \t % 3.2f \t % 3.2f \t % 3.2f \t % 3.2f \t % 3.2f \t % 3.2f \t % 3.2f \t % 3.2f \t % 3.2f \t % 3.2f \n',...
                        Zscl,Thsh,Fram,Ang1,Ang2,Lev1,Lev2,Pos1(1,1),Pos1(1,2),Pos1(2,1),Pos1(2,2),Pos2(1,1),Pos2(1,2),Pos2(2,1),Pos2(2,2));
            fclose(fid);
            
            fig = figure('Visible','off');
            imagesc(handles.KYMO);
            hold on;
            plot([Pos1(1,1),Pos1(2,1)],[Pos1(1,2),Pos1(2,2)],'r');
            plot([Pos2(1,1),Pos2(2,1)],[Pos2(1,2),Pos2(2,2)],'r');
            plot([Fram,Fram],[1 size(handles.KYMO,2)],'w');
            axis xy;
            saveas(fig,[PathName FileName(1:(end-4)) '.png'],'png');
            close(fig);
            %imwrite(uint8(handles.KYMO),map,[PathName FileName(1:(end-4)) '.png'],'png');
        %end
        
    end
    

    


    
% -------------------------------------------------------------------------


% --- Sliders -------------------------------------------------------------

function slider_time_Callback(hObject, eventdata, handles)

function slider_time_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

function slider_angle1_Callback(hObject, eventdata, handles)

function slider_angle1_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

function slider_angle2_Callback(hObject, eventdata, handles)

function slider_angle2_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    
function slider_level1_Callback(hObject, eventdata, handles)

function slider_level1_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

function slider_level2_Callback(hObject, eventdata, handles)

function slider_level2_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    
% -------------------------------------------------------------------------

    
%function axes_XY_view_ButtonDownFcn(hObject, eventdata, handles)
    
