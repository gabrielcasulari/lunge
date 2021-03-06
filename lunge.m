function lunge %%% -- INFO -- the function file name is what matters, so lets make this equal
    figObject = createMainFigure();

    %Create Navigation Axes
    navigationAxesObjects = createNavigationAxes(figObject);

    %Create Information Texts
    informationTextsObjects = createInformationTexts(navigationAxesObjects.informationAxesObject);

    %Create Menus
    createMenuObjects(figObject);


    createControlSideBar(figObject);
    handles.gui = guihandles(figObject);
    guidata(figObject, handles);
end


%%%%%%%%%%%% GUI RELATED FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function figObject = createMainFigure()
    %Get the screen size
    screenSize = get(0, 'ScreenSize');
    figObject = figure('Tag', 'mainFig',...
        'MenuBar', 'None',...
        'NumberTitle', 'Off',...
        'Name', 'New CT Processing V 0.0.1dev',...
        'units', 'normalized', ...
        'OuterPosition', [0 0.03 1 0.97], ... %%% -- INFO -- in my laptop I can not see the top of the window, only after manually risize. I think it is a problem with windows, anyway a chaged the dimensions, is ok in your screen?
        'Color', 'black',...
        'WindowScrollWheelFcn', @refreshSlicePosition,...
        'WindowButtonMotionFcn', @mouseMove);

end

function navigationAxesObjectStructure = createNavigationAxes(parentFigureObject)

    navigationAxesObjectStructure.navigationAxesObject = axes('Parent', parentFigureObject,...
      'Units', 'Normalized',...
      'Position', [0.16, 0.15, 0.6, 0.8],...
      'Color', 'black',...
      'XtickLabel', '',...
      'YtickLabel', '',...
      'Tag', 'navigationAxes');

  navigationAxesObjectStructure.informationAxesObject = axes('Parent', parentFigureObject,...
      'Units', 'Normalized',...
      'Position', [0.11, 0.08, 0.7, 0.9],...
      'XtickLabel', '',...
      'YtickLabel', '',...
      'Color', 'black');


end

function informationTextsObjectsStructure = createInformationTexts(parentAxesObject)

    informationTextsObjectsStructure.patientName = text(0.5, 0.98, 'Patient''s Name',...
        'Color', 'white',...
        'Fontsize', 12,...
        'Fontweight', 'bold',...
        'Tag', 'patientNameTag',...
        'HorizontalAlignment', 'center',...
        'Visible', 'Off');

    informationTextsObjectsStructure.slicePosition = text(0.01, 0.02, '1/-',...
        'Color', 'white',...
        'Fontsize', 12,...
        'Fontweight', 'bold',...
        'Visible', 'Off',...
        'Tag', 'slicePositionTag');

    informationTextsObjectsStructure.numberOfRows = text(0.01, 0.06, 'Image Size: -',...
        'Color', 'white',...
        'Fontsize', 12,...
        'Fontweight', 'bold',...
        'Visible', 'Off',...
        'Tag', 'numberOfRowsTag');


    informationTextsObjectsStructure.pixelValue = text(0.14, 0.02, 'Pixel Value = -',...
        'Color', 'white',...
        'Fontsize', 12,...
        'Fontweight', 'bold',...
        'Visible', 'Off',...
        'Tag', 'pixelValueTag');
end

function createMenuObjects(parentFigureObject)
    %Create Menu Objects


    %%%FILE MENU
    fileMenu = uimenu('Parent', parentFigureObject,...
        'Label', 'File');
    openGroup = uimenu('Parent', fileMenu, 'Label', 'Open');
    %Load Patient Menu
    uimenu('Parent', openGroup,...
        'Label', 'Open Patient',...
        'Acc', 'P',...
        'Callback', @openPatient);
    %Load Frame Menu
    uimenu('Parent', openGroup,...
        'Label', 'Open Frame',...
        'Acc', 'O',...
        'Callback', @openDicom);
    %Load Masks Menu
    uimenu('Parent', openGroup,...
        'Label', 'Open Masks',...
        'Acc', 'M',...
        'Enable', 'Off',...
        'Tag', 'openMaskMenu',...
        'Callback', @openMask);
    %Save data Menu
    uimenu('Parent', fileMenu,...
        'Label', 'Save Data',...
        'Enable', 'Off',...
        'Tag', 'saveDataMenu',...
        'Callback', @saveData);
    %Close Patient Menu
    uimenu('Parent', fileMenu,...
        'Label', 'Close Patient',...
        'Enable', 'Off',...
        'Tag', 'closePatientMenu',...
        'Callback', @closePatient);
    %Quit Menu
    uimenu('Parent', fileMenu,...
        'Label', 'Quit',...
        'Callback', '');

    %%%ANALYSIS MENU
    analysisMenu = uimenu('Parent', parentFigureObject,...
        'Label', 'Analysis');

    massAndVolume = uimenu('Parent', analysisMenu,...
        'Label', 'Mass and Volume',...        ..
        'Enable', 'Off',...
        'Tag', 'massAndVolumeCalculation');

    uimenu('Parent', massAndVolume,...
        'Label', 'Cranio-Caudal',...
        'Callback', @massAndVolumeCalculation);

    uimenu('Parent', massAndVolume,...
        'Label', 'Antero-Posterior',...
        'Callback', '');

    uimenu('Parent', massAndVolume,...
        'Label', 'Latero-Lateral',...
        'Callback', '');
    
    uimenu('Parent',analysisMenu,...
        'Enable', 'Off',...
        'Tag', 'p15Calculation',...
        'Callback', @p15Calculation,...
        'Label', 'P15');

    uimenu('Parent',analysisMenu,...
        'Enable', 'Off',...
        'Tag', 'toSUV',...
        'Callback', @toSUV,...
        'Label', 'PET to SUV');
    
    %%%PLUGINS MENU
    pluginsMenu = uimenu('Parent', parentFigureObject,...
        'Label', 'Plugins');

end

function createControlSideBar(parentFigureObject)
    mainPanel = uipanel('Parent', parentFigureObject,...
        'Units', 'Normalized',...
        'Position', [0.8, 0, 0.2, 1],...'
        'BackGroundColor', 'black',...
        'Visible', 'On',...
        'Tag', 'sideBarMainPanel');

     %Side Bar Sliders
     uicontrol('Parent', mainPanel,...
        'Style', 'Slider',...
        'Units', 'Normalized',...
        'Position', [0.1, 0.45, 0.1, 0.2],...
        'Tag', 'windowWidthSlider',...
        'Callback', @windowWidthCallback);

    uicontrol('Parent', mainPanel,...
        'Style', 'Slider',...
        'Units', 'Normalized',...
        'Position', [0.35, 0.45, 0.1, 0.2],...
        'Tag', 'windowCenterSlider',...
        'Callback', @windowCenterCallback);

     uicontrol('Parent',mainPanel,...
        'Style', 'Edit',...
        'Units', 'Normalized',...
        'Position', [0.12, 0.67, 0.11, 0.02],...
        'HorizontalAlignment', 'Center',...
        'String', '0',...
        'BackGroundColor', 'black',...
        'ForeGroundColor', 'white',...
        'Tag', 'windowWidthText',...
        'Callback', @windowWidthTextCallback);

     uicontrol('Parent',mainPanel,...
        'Style', 'Edit',...
        'Units', 'Normalized',...
        'Position', [0.37, 0.67, 0.11, 0.02],...
        'HorizontalAlignment', 'Center',...
        'String', '0',...
        'BackGroundColor', 'black',...
        'ForeGroundColor', 'white',...
        'Tag', 'windowCenterText',...
        'Callback', @windowCenterTextCallback);

    %Window Width and Center Buttons
    uicontrol('Parent', mainPanel,...
        'Units', 'Normalized',...
        'Position', [0.48, 0.45, 0.28, 0.06],...
        'String', 'Reset',...
        'Callback', @resetWindowWidthCenter);

    %HU Ranges textfields
    uicontrol('Parent', mainPanel,...
        'Units', 'Normalized', ...
        'Position', [0.3, 0.2, 0.45, 0.05],...
        'Style', 'Text',...
        'Backgroundcolor', 'black',...
        'Foregroundcolor', 'white',...
        'Fontsize', 13,...
        'Fontweight', 'bold',...
        'String', 'HU Ranges');

    uicontrol('Parent', mainPanel,...
        'Units', 'Normalized', ...
        'Position', [0.01 , 0.16, 0.45, 0.03],...
        'Style', 'Text',...
        'Backgroundcolor', 'black',...
        'Foregroundcolor', 'white',...
        'Fontsize', 11,...
        'HorizontalAlignment', 'left',...
        'String', 'Hyper Aerated:');

        uicontrol('Parent', mainPanel,...
        'Units', 'Normalized', ...
        'Position', [0.01 , 0.12, 0.5, 0.03],...
        'Style', 'Text',...
        'Backgroundcolor', 'black',...
        'Foregroundcolor', 'white',...
        'Fontsize', 11,...
        'HorizontalAlignment', 'left',...
        'String', 'Normally Aerated:');

    uicontrol('Parent', mainPanel,...
        'Units', 'Normalized', ...
        'Position', [0.01 , 0.08, 0.45, 0.03],...
        'Style', 'Text',...
        'Backgroundcolor', 'black',...
        'Foregroundcolor', 'white',...
        'Fontsize', 11,...
        'HorizontalAlignment', 'left',...
        'String', 'Poorly Aerated:');

    uicontrol('Parent', mainPanel,...
        'Units', 'Normalized', ...
        'Position', [0.01 , 0.04, 0.45, 0.03],...
        'Style', 'Text',...
        'Backgroundcolor', 'black',...
        'Foregroundcolor', 'white',...
        'Fontsize', 11,...
        'HorizontalAlignment', 'left',...
        'String', 'Non Aerated:');

    uicontrol('Parent', mainPanel,...
        'Units', 'Normalized',...
        'Position', [0.55, 0.16, 0.15, 0.03],...
        'Style', 'Edit',...
        'Tag', 'upperHyperValue',...
        'String', '-1000');

    uicontrol('Parent', mainPanel,...
        'Units', 'Normalized',...
        'Position', [0.75, 0.16, 0.15, 0.03],...
        'Style', 'Edit',...
        'Tag', 'lowerHyperValue',...
        'String', '-900');

    uicontrol('Parent', mainPanel,...
        'Units', 'Normalized',...
        'Position', [0.55, 0.12, 0.15, 0.03],...
        'Style', 'Edit',...
        'Tag', 'upperNormallyValue',...
        'String', '-900');

    uicontrol('Parent', mainPanel,...
        'Units', 'Normalized',...
        'Position', [0.75, 0.12, 0.15, 0.03],...
        'Style', 'Edit',...
        'Tag', 'lowerNormallyValue',...
        'String', '-500');

    uicontrol('Parent', mainPanel,...
        'Units', 'Normalized',...
        'Position', [0.55, 0.08, 0.15, 0.03],...
        'Style', 'Edit',...
        'Tag', 'upperPoorlyValue',...
        'String', '-500');

    uicontrol('Parent', mainPanel,...
        'Units', 'Normalized',...
        'Position', [0.75, 0.08, 0.15, 0.03],...
        'Style', 'Edit',...
        'Tag', 'lowerPoorlyValue',...
        'String', '-100');

    uicontrol('Parent', mainPanel,...
            'Units', 'Normalized',...
            'Position', [0.55, 0.04, 0.15, 0.03],...
            'Style', 'Edit',...
            'Tag', 'upperNonValue',...
            'String', '-100');

    uicontrol('Parent', mainPanel,...
            'Units', 'Normalized',...
            'Position', [0.75, 0.04, 0.15, 0.03],...
            'Style', 'Edit',...
            'Tag', 'lowerNonValue',...
            'String', '100');

    %Side Bar Slice Range
    uicontrol('Parent', mainPanel,...
         'Units', 'Normalized',...
         'Position', [0.3, 0.35, 0.4, 0.05],...
         'Style', 'Text',...
         'BackGroundColor', 'black',...
         'ForeGroundColor', 'white',...
         'FontSize', 13,...
         'FontWeight', 'bold',...
         'String', 'Slice Range');

    uicontrol('Parent', mainPanel,...
        'Units', 'Normalized',...
        'Position', [0.01, 0.33, 0.2, 0.025],...
        'Style', 'Text',...
        'String', 'From:',...
        'BackGroundColor', 'black',...
        'ForeGroundColor', 'white');

    uicontrol('Parent', mainPanel,...
        'Units', 'Normalized',...
        'Position', [0.4, 0.33, 0.2, 0.025],...
        'Style', 'Text',...
        'String', 'To:',...
        'BackGroundColor', 'black',...
        'ForeGroundColor', 'white');

    uicontrol('Parent', mainPanel,...
        'Units', 'Normalized',...
        'Position', [0.25, 0.33, 0.15, 0.025],...
        'Style', 'Edit',...
        'String', '1',....
        'Tag', 'sliceRangeFrom',...
        'Callback', @sliceRangeFromToCallback);

    uicontrol('Parent', mainPanel,...
        'Units', 'Normalized',...
        'Position', [0.6, 0.33, 0.15, 0.025],...
        'Style', 'Edit',...
        'String', '1',...
        'Tag', 'sliceRangeTo',...
        'Callback', @sliceRangeFromToCallback);
    
    % Overlay checkboxes
    uicontrol('Parent', mainPanel,...
        'Units', 'Normalized',...
        'Position', [0.1, 0.95, 0.8, 0.025],...
        'Style', 'CheckBox',...
        'String', 'Show Mask',...
        'FontSize', 13,...
        'BackGroundColor', 'black',...
        'ForeGroundColor', 'white',...
        'Enable','off',...
        'Tag', 'maskChk',...
        'Callback', @maskChkCallback);
    
    uicontrol('Parent', mainPanel,...
        'Units', 'Normalized',...
        'Position', [0.1, 0.92, 0.8, 0.025],...
        'Style', 'CheckBox',...
        'String', 'Show PET',...
        'FontSize', 13,...
        'BackGroundColor', 'black',...
        'ForeGroundColor', 'white',...
        'Enable','off',...
        'Tag', 'petChk',...
        'Callback', @petChkCallback);
end

%%%%%%%%%%%% GUI RELATED FUNCTIONS  - END %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function handles = displayCurrentDicom(handles, dicomImage, slicePosition)
    axes(handles.gui.navigationAxes)
    set(findobj(handles.gui.navigationAxes,'type','image'),'CData',dicomImage(:, :, slicePosition))
    set(handles.gui.navigationAxes, 'Clim', [handles.data.displayLow, handles.data.displayHigh]);
    colormap(gray)
end

function handles = createDisplayDicom(handles, dicomImage, slicePosition)
    axes(handles.gui.navigationAxes)
    set(handles.gui.navigationAxes,'nextPlot','replace')
    handles.gui.imagePlot = imagesc(dicomImage(:, :, slicePosition));
    set(handles.gui.navigationAxes, 'Clim', [handles.data.displayLow, handles.data.displayHigh]);
    colormap(gray)
end

function refreshPatientsInfo(handles, info)
   patientName = info.PatientName.FamilyName;
   %Check if Patient has Give Name
   if isfield(info.PatientName, 'GivenName')
       patientName = [info.PatientName.GivenName ' ' patientName];
   end
   set(handles.gui.patientNameTag, 'String', patientName)
   set(handles.gui.numberOfRowsTag, 'String', sprintf('Image Size: %d x %d', info.Rows, info.Columns));
   end

function refreshSlicePosition(hObject, eventdata)


slicePositionPlaceHolder = '%d/%d';

handles = guidata(hObject);

if isfield(handles, 'data')

    nSlices = size(handles.data.dicomImage, 3);

    currentSlicePosition = get(handles.gui.slicePositionTag, 'String');

    %Get the new slice position based on the displayed values using regexp
    newSlicePosition = getSlicePosition(currentSlicePosition,...
        eventdata.VerticalScrollCount);

    %Make sure that the slice number return to 1 if it is bigger than the
    %number of slices
    newSlicePosition = mod(newSlicePosition, nSlices);

    %Make sure that the slice number return to nSlices if it is smaller than the
    %number of slices
    if ~newSlicePosition && eventdata.VerticalScrollCount < 0
        newSlicePosition = nSlices;
    elseif ~newSlicePosition && eventdata.VerticalScrollCount >= 0 %%% -- INFO -- matlab has some hard time with the scroll of my laptop, in this case VerticalScrollCount == 0, it get an error latter in this function and this is error realy I need to restart matlab. I changed > to >=
        newSlicePosition = 1;
    end

    %Refresh slice position information.
    set(handles.gui.slicePositionTag, 'String',...
        sprintf(slicePositionPlaceHolder, newSlicePosition, nSlices));
    if handles.gui.petDisplay
        if isfield(handles.dataPET,'CT')
            handles = displayCurrentDicom(handles, handles.dataPET.CT, newSlicePosition);
        end
    else
        handles = displayCurrentDicom(handles, handles.data.dicomImage, newSlicePosition);
    end
    
    % refresh overlay if needed
    if get(handles.gui.maskChk,'value')
        if handles.gui.petDisplay
            refreshOverlay(handles.dataPET.masks,handles)
        else
            refreshOverlay(handles.data.masks,handles)
        end
    elseif get(handles.gui.petChk,'Value') && handles.gui.petDisplay
        refreshOverlay(handles.dataPET.dicomImage,handles)
    end

    %Refresh pixel value information.
    refreshPixelPositionInfo(handles, handles.gui.navigationAxes)

    guidata(hObject, handles)
end
end

function newSlicePosition = getSlicePosition(slicePositionString, direction)
    tempSlicePosition = regexp(slicePositionString, '/', 'split');

    if direction > 0
        newSlicePosition = str2double(tempSlicePosition(1)) + 1;
    else
        newSlicePosition = str2double(tempSlicePosition(1)) - 1;
    end
end

function openPatient(hObject, eventdata)

    handles = guidata(hObject);

    if isfield(handles, 'data')
        dirPath = uigetdir(handles.data.dicomImagePath, 'Select Patient''s Folder');
    else
        dirPath = uigetdir('Select Patient''s Folder');
    end

    if dirPath

        %Display Wait window
        figObj = createLogFrame();
        displayLog(figObj, sprintf('%s', 'Searching patient data files...'), 0)

        set(handles.gui.mainFig,'Pointer','watch'); drawnow('expose');

        % Look for available CT,mask and PET files
        [mask,ct,pet]=find_files(dirPath,{},[],[]);
        
        %Close log frame
        close(figObj)

        % Now load CT, mask and PET
        % TODO no data found case
        if ~isempty(ct)
           openDicom(hObject, [], fileparts(ct)) 
        end
        % TODO case with more than one possible mask
        if ~isempty(mask)
            [folder name ext] = fileparts(mask{1});
            openMask(hObject, [], [name ext], [folder filesep])
        end
        if ~isempty(pet)
            openDicom(hObject, [], fileparts(pet)) 
        end
            
        set(handles.gui.mainFig,'Pointer','arrow'); drawnow('expose');
    end
end

function openDicom(hObject, eventdata, dirPath)

    handles = guidata(hObject);

    if ~exist('dirPath','var')
        if isfield(handles, 'data')
            dirPath = uigetdir(handles.data.dicomImagePath, 'Select Patient''s Dicom Folder');
        else
            dirPath = uigetdir('Select Patient''s Dicom Folder');
        end
    end

    if dirPath

        %Display Wait window
        figObj = createLogFrame();
        displayLog(figObj, sprintf('%s', 'Loading Images...'), 0)


        set(handles.gui.mainFig,'Pointer','watch'); drawnow('expose');
        listOfFiles = dir(dirPath);

        %Try to open every file with dicomread. If possible use as a Dicom
        nFiles = length(listOfFiles);

        found = false;
        counter = 0;

        %Create a function to insert this piece of code.
        while ~found
            counter =  counter + 1;
            fileName = listOfFiles(counter).name;
            if ~strcmp(fileName, '.') && ~strcmp(fileName, '..')
                completeFileName = [dirPath filesep fileName];
                %Try to discover if files without extension are Dicom files
                try
                    info = dicominfo(completeFileName); %%% -- INFO -- I changed the info and handles.data.metadata, because I think this way makes more sense and I need to check is it is a PET image to know were to put the data
                    
                    handles.gui.petDisplay = strcmpi(info.Modality,'pt');
                    if handles.gui.petDisplay
                        % using the string field name we do not need to
                        % repeat this if in each instance
                        fieldname = 'dataPET';
                    else
                        fieldname = 'data';
                    end
                    
                    handles.(fieldname).metadata = dicom_read_header(completeFileName);
                    
                    %%% -- INFO -- I used a random dicom file I had and it
                    %%% didn't have the WindowCenter and WindowWidth
                    %%% infomation - I included the following lines to
                    %%% garantee
                    if ~isfield(info,'WindowWidth')
                        handles.data.metadata.WindowWidth = 1400; % 1400 is a common value used to visualize lung in CT
                    end
                    if ~isfield(info,'WindowCenter')
                        handles.data.metadata.WindowCenter = -600; % -600 is a common value used to visualize lung in CT
                    end

                    found = true;
                catch
                    %Do nothing
                    continue
                end

            end
        end

        dicomImage = single(dicom_read_volume(handles.(fieldname).metadata)); %% -- INFO -- for the PET data we can not use int, it will need more memory, but we need single for calculation too

        if strcmpi(handles.(fieldname).metadata.Manufacturer,'siemens')
            % Siemens data can have different slopes and intercepts for each
            % slice (at least in data from Pettsburg)
            handles.(fieldname).metadata.RescaleSlope = zeros([1,1,numel(handles.(fieldname).metadata.Filenames)]);
            handles.(fieldname).metadata.RescaleIntercept = zeros([1,1,numel(handles.(fieldname).metadata.Filenames)]);
            for idx = 1:numel(handles.(fieldname).metadata.Filenames)
                aux = dicominfo(handles.(fieldname).metadata.Filenames{idx});
                handles.(fieldname).metadata.RescaleSlope(idx) = single(aux.RescaleSlope);
                handles.(fieldname).metadata.RescaleIntercept(idx) = single(aux.RescaleIntercept);
            end
        end
        
        if isfield(info, 'RescaleSlope')
            dicomImage = bsxfun(@times,dicomImage,single(handles.(fieldname).metadata.RescaleSlope)); % bsxfun expandes the singleton dimension automaticaly
        end

        if isfield(info, 'RescaleIntercept')
            dicomImage = bsxfun(@plus,dicomImage,single(handles.(fieldname).metadata.RescaleIntercept));
        end

        % If a PET image was loaded maybe the user want to analyse PET and
        % CT together. For this CT must be converted to PET resolution.       
        if handles.gui.petDisplay && isfield(handles,'data')
            displayLog(figObj, sprintf('%s', 'Converting other data to PET resolution...'), 1)
            map = CTPET_CreateMap(handles.data.metadata,handles.dataPET.metadata);
            handles.dataPET.CT = CTPET_ApplyMap(handles.data.dicomImage,map);
            % if a mask also exist, it should be converted too
            if isfield(handles.data,'masks')
                handles.dataPET.masks = CTPET_ApplyMap(handles.data.masks,map);
            end
        end
        
        set(handles.gui.mainFig,'Pointer','arrow'); drawnow('expose');

        handles.(fieldname).dicomImage = dicomImage;

        %Set the Window Width and Window Center
        handles = calculateWindowWidthAndCenter(handles);

        configureSliders(handles)

        %Display First Slice
        cla(handles.gui.navigationAxes)
        if handles.gui.petDisplay
            if isfield(handles.dataPET,'CT')
                handles = createDisplayDicom(handles, handles.dataPET.CT, 1);
                set(handles.gui.petChk,'Enable','on')
            end
            set(handles.gui.toSUV,'Enable','on')
        else
            handles = createDisplayDicom(handles, dicomImage, 1);
            set(handles.gui.petChk,'Enable','off')
        end

        %Display Patients Information
        refreshPatientsInfo(handles, handles.(fieldname).metadata)

        %Update Interface Appearene
        hideShowImageInformation(handles, 'On')
        hideShowSideBar(handles, 'On')
        set(handles.gui.openMaskMenu, 'Enable', 'On')
        set(handles.gui.saveDataMenu, 'Enable', 'On')
        set(handles.gui.closePatientMenu, 'Enable', 'On')

        %Create a variable to store the Image folder. This way the Masks
        %could be easier located.
        handles.(fieldname).dicomImagePath = dirPath;

        % -- INFO -- This is redundant with createDisplayDicom
% %         set(handles.gui.navigationAxes, 'Clim',...
% %             [handles.data.displayLow, handles.data.displayHigh])

        % Create the saved field as true, because if the user just load
        % files the data should not be saved before close. Every data
        % processing function should change saved to false
        handles.saved = 1;
        
        guidata(hObject, handles)

        %Close log frame
        close(figObj)
    end
end

function openMask(hObject, eventdata, FileName, PathName)

handles = guidata(hObject);
if ~exist('FileName','var')
    [FileName PathName] = uigetfile('*.hdr;*.nrrd',...
        'Select the file containing the masks', handles.data.dicomImagePath);
end

if FileName

    %Display Wait window
    figObj = createLogFrame();
    displayLog(figObj, sprintf('%s', 'Loading Masks...'), 0)

    set(handles.gui.mainFig,'Pointer','watch'); drawnow('expose');
    
    handles = guidata(hObject);
    fileName = [PathName FileName];
    if strfind(FileName,'hdr')
        masks = analyze75read(fileName);
    else
        masks = nrrd_read(fileName);
    end
    
    % Masks created in 3D Slicer using CIP plugin are labeled, ask user
    % wich labels he wants to load
    if any(masks(:)>255);
        labels = unique(masks(:)); labels = labels(2:end); % exclude 0 fram list of labels
        list = interpretCIPCodes(labels);
        h=lungeDlg('msgbox',{'You opened a labeld mask file.';'Use the next window to choose structure you want to keep!'},'Instruction!!!','help','modal');
        %msgbox({'You opened a labeld mask file.';'Use the next window to choose structure you want to keep!'},'Instruction!!!','help','modal');
        uiwait(h);
        chosen = lungeDlg('listdlg','ListString',list,'Name','Structures to keep');
        %listdlg('ListString',list,'Name','Structures to keep');
        notchosen = 1:numel(labels);
        notchosen=notchosen(~ismember(notchosen,chosen));
        for each=notchosen
            masks(masks==labels(each))=0;
        end
    end
    
    % Mask is converted to logical to reduce memory size
    handles.data.masks = logical(masks);
    
    % If there is a PET image loaded and the mask is not of the same
    % size as PET, convert it
    if isfield(handles,'dataPET')
        if ~all(size(handles.dataPET.dicomImage) == size(masks))
            map = CTPET_CreateMap(handles.data.metadata,hnadles.dataPET.metadata);
            handles.dataPET.masks = CTPET_ApplyMap(handles.data.masks,map);
        end
    end

    set(handles.gui.mainFig,'Pointer','arrow'); drawnow('expose');
    
    guidata(hObject, handles)

    %UPDATE MENU
    set(handles.gui.massAndVolumeCalculation, 'Enable', 'On')
    set(handles.gui.p15Calculation, 'Enable', 'On')
    set(handles.gui.maskChk, 'Enable', 'On')

    %Close wait window
    close(figObj);

end

end

function saveData(hObject, eventdata)

    handles = guidata(hObject);

    if ~isfield(handles.data,'fileName')
        [filename, pathname] = uiputfile('*.mat', 'Chose filename');
        if isequal(filename,0) || isequal(pathname,0)
            return
        else
            handles.data.fileName = fullfile(pathname, filename);
        end
    end
    
    %Display Wait window
    figObj = createLogFrame();
    displayLog(figObj, sprintf('%s', 'Saving data...'), 0)
    
    data = handles.data;
    save(handles.data.fileName,'-struct','data')
    if isfield(handles,'dataPET')
        data = handles.dataPET;
        save(handles.data.fileName,'-struct','data','-append')
    end
    set(handles.gui.saveDataMenu,'Enable','Off')

    %Close wait window
    close(figObj);
    
    guidata(hObject,handles)
end

function closePatient(hObject, eventdata)   

    handles = guidata(hObject);
    
    set(handles.gui.mainFig,'Pointer','watch'); drawnow('expose');
    
    if ~handles.saved
        % Ask if want to save
        btn = lungeDlg('questdlg','You have unsaved data. Want to save before close this patient?','Save','yes','no', 'yes');
        %questdlg('You have unsaved data. Want to save before close this patient?','Save','yes','no', 'yes');
        
        if strcmp(btn,'yes')
            saveData(hObject)
        end    
    end
    handles = rmfield(handles,'data');
    if isfield(handles,'dataPET')
       handles = rmfield(handles,'dataPET');
    end
    
    % Hide patient information and DICOM display
    hideShowImageInformation(handles,'off')
    cla(handles.gui.navigationAxes)
    set(handles.gui.navigationAxes,'color','k')
       
    %UPDATE MENU
    set(handles.gui.massAndVolumeCalculation, 'Enable', 'Off')
    set(handles.gui.p15Calculation, 'Enable', 'Off')
    set(handles.gui.toSUV, 'Enable', 'Off')
    set(handles.gui.maskChk, 'Enable', 'Off')
    set(handles.gui.petChk, 'Enable', 'Off')
    set(handles.gui.openMaskMenu, 'Enable', 'Off')
    set(handles.gui.closePatientMenu, 'Enable', 'Off')
    set(handles.gui.saveDataMenu,'Enable','Off')
    
    set(handles.gui.mainFig,'Pointer','arrow'); drawnow('expose');
    
    guidata(hObject, handles)
end

function mouseMove(hObject, eventdata)
    handles = guidata(hObject);
    mainAxes = handles.gui.navigationAxes;
    refreshPixelPositionInfo(handles, mainAxes);
end

function refreshPixelPositionInfo(handles, mainAxes)

if isfield(handles, 'data')
    C = get(mainAxes,'currentpoint');

    xlim = get(mainAxes,'xlim');
    ylim = get(mainAxes,'ylim');

    row = round(C(1));
    col = round(C(1, 2));



    %Check if pointer is inside Navigation Axes.
    outX = ~any(diff([xlim(1) C(1,1) xlim(2)])<0);
    outY = ~any(diff([ylim(1) C(1,2) ylim(2)])<0);
    if outX && outY
        %Get the current Slice
        currentSlicePositionString = get(handles.gui.slicePositionTag, 'String');
        tempSlicePosition = regexp(currentSlicePositionString, '/', 'split');
        slicePosition = str2double(tempSlicePosition(1));

        currentSlice = handles.data.dicomImage(:, :, slicePosition);

        pixelValue = currentSlice(col, row);

        set(handles.gui.pixelValueTag, 'String', sprintf('Pixel Value = %.2f', double(pixelValue)))
    else
        set(handles.gui.pixelValueTag, 'String', sprintf('Pixel Value = -'))
    end

end
end

function windowWidthCallback(hObject, eventdata)
    handles = guidata(hObject);
    windowWidth = get(handles.gui.windowWidthSlider, 'Value');
    windowCenter = get(handles.gui.windowCenterSlider, 'Value');

    if isfield(handles,'data') %%% -- INFO -- if you try to use the sliders before load data there was an error. Other option is to start with disabled sliders
        set(handles.gui.windowWidthText, 'String',sprintf('%.2f', windowWidth));
        handles = calculateWindowWidthAndCenter(handles,...
            windowWidth, windowCenter);

        set(handles.gui.navigationAxes, 'Clim', [handles.data.displayLow handles.data.displayHigh])
    end
    guidata(hObject, handles);

end

function windowWidthTextCallback(hObject, eventdata)
    handles = guidata(hObject);
    windowWidth = str2double(get(hObject, 'String'));
    set(handles.gui.windowWidthSlider, 'Value',windowWidth);
    
    windowCenterCallback(hObject)
end

function windowCenterCallback(hObject, eventdata)
    handles = guidata(hObject);
    windowWidth = get(handles.gui.windowWidthSlider, 'Value');
    windowCenter = get(handles.gui.windowCenterSlider, 'Value');

    if isfield(handles,'data') %%% -- INFO -- if you try to use the sliders before load data there was an error. Other option is to start with disabled sliders
        set(handles.gui.windowCenterText, 'String',sprintf('%.2f', windowCenter));
        handles = calculateWindowWidthAndCenter(handles, windowWidth, windowCenter);

        set(handles.gui.navigationAxes, 'Clim', [handles.data.displayLow handles.data.displayHigh])
    end
    guidata(hObject, handles);

end

function windowCenterTextCallback(hObject, eventdata)
    handles = guidata(hObject);
    windowCenter = str2double(get(hObject, 'String'));
    set(handles.gui.windowCenterSlider, 'Value',windowCenter);
    
    windowCenterCallback(hObject)
end

function resetWindowWidthCenter(hObject, eventdata)
    handles = guidata(hObject);

    if isfield(handles,'data') %%% -- INFO -- if you try to use the button before load data there was an error. Other option is to start with disabled button
        windowWidth = handles.data.metadata.WindowWidth(1);
        windowCenter = handles.data.metadata.WindowCenter(1);

        handles = calculateWindowWidthAndCenter(handles, windowWidth, windowCenter);
        set(handles.gui.navigationAxes, 'Clim', ...
            [handles.data.displayLow, handles.data.displayHigh]);
        set(handles.gui.windowWidthSlider, 'Value', windowWidth);
        set(handles.gui.windowWidthText, 'String',sprintf('%.2f', windowWidth));
        set(handles.gui.windowCenterSlider, 'Value', windowCenter);
        set(handles.gui.windowCenterText, 'String',sprintf('%.2f', windowCenter));
    end
    guidata(hObject, handles)

end

function hideShowSideBar(handles, hideOrShow)
    set(handles.gui.sideBarMainPanel, 'Visible', hideOrShow)
end

function maskChkCallback(hObject, eventdata)
    handles = guidata(hObject);
    if get(hObject,'Value')
        set(handles.gui.petChk,'enable','off')
        if handles.gui.petDisplay
            handles.gui.overlayPlot = createOverlay(handles.dataPET.masks,handles);
        else
            handles.gui.overlayPlot = createOverlay(handles.data.masks,handles);
        end
    else
        if handles.gui.petDisplay
            set(handles.gui.petChk,'enable','on')
        end
        if ishandle(handles.gui.overlayPlot)
            set(handles.gui.overlayPlot,'visible','off')
        end
    end
    
    guidata(hObject,handles)
end

function petChkCallback(hObject, eventdata)
    handles = guidata(hObject);
    if get(hObject,'Value')
        if handles.gui.petDisplay
            set(handles.gui.maskChk,'enable','off')
            handles.gui.overlayPlot = createOverlay(handles.dataPET.dicomImage,handles);
        end
    else
        set(handles.gui.maskChk,'enable','on')
        if ishandle(handles.gui.overlayPlot)
            set(handles.gui.overlayPlot,'visible','off')
        end
    end
    
    guidata(hObject,handles)
end

function hideShowImageInformation(handles, hideOrShow)
    set(handles.gui.patientNameTag, 'Visible', hideOrShow)
    set(handles.gui.slicePositionTag, 'Visible', hideOrShow)
    set(handles.gui.numberOfRowsTag, 'Visible', hideOrShow)
    set(handles.gui.pixelValueTag, 'Visible', hideOrShow)
end

function sliceRangeFromToCallback(hObject, eventdata)
    handles = guidata(hObject);
    %totalNumberOfSlices = size(handles.data.lung, 3);
    totalNumberOfSlices = 10;
    fromRange = get(handles.gui.sliceRangeFrom, 'String');
    toRange = get(handles.gui.sliceRangeTo, 'String');
    try
        validateSliceRangeValues(handles, fromRange, toRange, totalNumberOfSlices)
    catch
        lungeDlg('errordlg','Some error ocurred in the Slice Range configuration!',...
        'SliceRangeError');
%         errordlg('Some error ocurred in the Slice Range configuration!',...
%         'SliceRangeError');
    end
end

function validateSliceRangeValues(handles, fromValue, toValue,...
    totalNumberOfSlices)

    charNumbers = '1234567890';
     if ~all(ismember(fromValue, charNumbers))
        set(handles.gui.sliceRangeFrom, 'String', '1');
        error('Slice range must be a positive integer', 'RangeError');
    elseif ~all(ismember(toValue, charNumbers))
        set(handles.gui.sliceRangeTo, 'String', num2str(totalNumberOfSlices))
        error('Slice range must be a positive integer', 'RangeError');
    elseif str2double(toValue) > totalNumberOfSlices
        set(handles.gui.sliceRangeTo, 'String', num2str(totalNumberOfSlices))
        error('Slice range could not be bigger than the number of slices!',...
         'RangeError');
    elseif str2double(fromValue) > str2double(toValue)
        set(handles.gui.sliceRangeTo, 'String', num2str(totalNumberOfSlices))
        set(handles.gui.sliceRangeFrom, 'String', '1');
        error('FROM range value can not be bigger than TO range value',...
             'RangeError');
     end
end

function overlayPlot = createOverlay(Img,handles)
    %Get the current Slice
    currentSlicePositionString = get(handles.gui.slicePositionTag, 'String');
    tempSlicePosition = regexp(currentSlicePositionString, '/', 'split');
    slicePosition = str2double(tempSlicePosition(1));
        
    set(handles.gui.navigationAxes,'NextPlot','add')
    if islogical(Img);
        C = contours(Img(:,:,slicePosition),1);
        C(:,C(1,:)==0.5)=nan;
        if isempty(C)
            C=zeros(2,1);
        end
        overlayPlot = plot(handles.gui.navigationAxes,C(1,:),C(2,:),'color','g','linewidth',2);
    else
        Img = Img(:,:,slicePosition);
        M=max(Img(:));
        if M
            Img = round(255*Img./M);
        end
        Img(Img<0) = 0;
        overlayPlot=imshow(label2rgb(Img,hot(256)),'Parent',handles.gui.navigationAxes);
        set(overlayPlot,'alphadata',0.2*ones(size(Img,2),size(Img,1)))
    end
end

function refreshOverlay(Img,handles)
    %Get the current Slice
    currentSlicePositionString = get(handles.gui.slicePositionTag, 'String');
    tempSlicePosition = regexp(currentSlicePositionString, '/', 'split');
    slicePosition = str2double(tempSlicePosition(1));
    
    if islogical(Img);
        C = contours(Img(:,:,slicePosition),1);
        C(:,C(1,:)==0.5)=nan;
        set(handles.gui.overlayPlot,'xdata',C(1,:),'ydata',C(2,:))
    else
        Img = Img(:,:,slicePosition);
        Img(Img<0) = 0;
        M=max(Img(:));
        if M
            Img = round(255*Img./M);
        end
        set(handles.gui.overlayPlot,'cdata',label2rgb(Img,hot(256)))
    end
end

function toSUV(hObject, eventdata)
    handles = guidata(hObject);
    
    set(handles.gui.mainFig,'Pointer','watch'); drawnow('expose');
    
    % Convert raw PET data to SUV
    handles.dataPET.imageRaw = handles.dataPET.dicomImage; % save raw data information
    handles.dataPET.metadata.Units_raw = handles.dataPET.metadata.Units; % save raw data units information
    injectionTime = str2sec(handles.dataPET.metadata.RadiopharmaceuticalInformationSequence.Item_1.RadiopharmaceuticalStartTime);
    injectionDose = handles.dataPET.metadata.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideTotalDose;
    injectionHalflife = handles.dataPET.metadata.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideHalfLife;
    patientWeight = handles.dataPET.metadata.PatientWeight*1000; % converted from kg to g
    
    imageStartTime = str2sec(handles.dataPET.metadata.AcquisitionTime)-injectionTime; % start of image aquisiton relative to ijection time
    frameDuration = handles.dataPET.metadata.ActualFrameDuration/1000; % converted from ms to s
    
    lambda = log(2)/injectionHalflife;
    decayCorrection = exp(lambda*imageStartTime)*lambda*frameDuration/...
        (1-exp(-lambda*frameDuration)); % convert image to injection time
    
    handles.dataPET.dicomImage = handles.dataPET.imageRaw*(decayCorrection*patientWeight/injectionDose); % PET data converted to SUV
    handles.dataPET.metadata.Units = 'SUV';

    % Update menu
    set(handles.gui.toSUV,'Enable','off')
    
    set(handles.gui.mainFig,'Pointer','arrow'); drawnow('expose');
    
    guidata(hObject, handles)
end

%%%%%%%%%%%%% ANALYSIS CALLBACKS %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function massAndVolumeCalculation(hObject, eventdata, showFig)

    %disply calculation log.
    figObj = createLogFrame();

    displayLog(figObj, sprintf('%s', 'Calculating Volume...'), 0)

    handles = guidata(hObject);

    lung = handles.data.dicomImage;
    masks = logical(handles.data.masks);
    metadata = handles.data.metadata;

    lungWithMask = applyMaskToLung(lung, masks);

    %Get HU range Values

    hyperRange = str2double(get(handles.gui.upperHyperValue, 'String'));
    hyperRange(2) = str2double(get(handles.gui.lowerHyperValue, 'String'));


    normallyRange = str2double(get(handles.gui.upperNormallyValue, 'String'));
    normallyRange(2) = str2double(get(handles.gui.lowerNormallyValue, 'String'));

    poorlyRange = str2double(get(handles.gui.upperPoorlyValue, 'String'));
    poorlyRange(2) = str2double(get(handles.gui.lowerPoorlyValue, 'String'));

    nonRange = str2double(get(handles.gui.upperNonValue, 'String'));
    nonRange(2) = str2double(get(handles.gui.lowerNonValue, 'String'));

    %%TODO: Validate and use slice range

    %Calculates the Volume.
    [hyperVolume, normallyVolume, poorlyVolume, nonVolume,...
        percentualHyperVolume, totalLungVolume, percentualNormallyVolume,...
        percentualPoorlyVolume, percentualNonVolume] =...
        volumeCalculation(lungWithMask, metadata,...
        hyperRange, normallyRange, poorlyRange, nonRange);

    %Calculate the Volume Slice by Slice.
    %Prealocate
    nSlices = size(lungWithMask, 3);

    hyperVolumePerSlice = zeros(1, nSlices);
    normallyVolumePerSlice = zeros(1, nSlices);
    poorlyVolumePerSlice = zeros(1, nSlices);
    nonVolumePerSlice = zeros(1, nSlices);
    totalSliceVolume = zeros(1, nSlices);
    percentualHyperVolumePerSlice = zeros(1, nSlices);
    percentualNormallyVolumePerSlice = zeros(1, nSlices);
    percentualPoorlyVolumePerSlice = zeros(1, nSlices);
    percentualNonVolumePerSlice = zeros(1, nSlices);


    for jSlice = 1:nSlices

        %Get the jth Slice.
        sliceWithMask = lungWithMask(:, :, jSlice);

        [hyperVolumePerSlice(jSlice), normallyVolumePerSlice(jSlice),...
            poorlyVolumePerSlice(jSlice), nonVolumePerSlice(jSlice),...
            totalSliceVolume(jSlice), percentualHyperVolumePerSlice(jSlice),...
            percentualNormallyVolumePerSlice(jSlice),...
            percentualPoorlyVolumePerSlice(jSlice),...
            percentualNonVolumePerSlice(jSlice)] = ...
            volumeCalculation(sliceWithMask, metadata,...
            hyperRange, normallyRange, poorlyRange, nonRange);

    end

    displayLog(figObj, sprintf('%s', 'Calculating Mass...'), 1)

    massMethodCalculation = 'Normal';

    %Calculate the Mass.
    [hyperMass, normallyMass, poorlyMass, nonMass,...
        percentualHyperMass, totalLungMass, percentualNormallyMass,...
        percentualPoorlyMass, percentualNonMass]  =...
        massCalculation(lungWithMask, metadata, hyperRange,...
        normallyRange, poorlyRange, nonRange, massMethodCalculation);


        %Calculate the Volume Slice by Slice.
    %Prealocate
    hyperMassPerSlice = zeros(1, nSlices);
    normallyMassPerSlice = zeros(1, nSlices);
    poorlyMassPerSlice = zeros(1, nSlices);
    nonMassPerSlice = zeros(1, nSlices);
    totalSliceMass = zeros(1, nSlices);
    percentualHyperMassPerSlice = zeros(1, nSlices);
    percentualNormallyMassPerSlice = zeros(1, nSlices);
    percentualPoorlyMassPerSlice = zeros(1, nSlices);
    percentualNonMassPerSlice = zeros(1, nSlices);

    for jSlice = 1:nSlices

        %Get the jth Slice.
        sliceWithMask = lungWithMask(:, :, jSlice);

        [hyperMassPerSlice(jSlice), normallyMassPerSlice(jSlice),...
            poorlyMassPerSlice(jSlice), nonMassPerSlice(jSlice),...
            totalSliceMass(jSlice), percentualHyperMassPerSlice(jSlice),...
            percentualNormallyMassPerSlice(jSlice),...
            percentualPoorlyMassPerSlice(jSlice),...
            percentualNonMassPerSlice(jSlice)] = ...
            massCalculation(sliceWithMask, metadata,...
            hyperRange, normallyRange, poorlyRange, nonRange, massMethodCalculation);
    end

    %Store the indices.
    %Volume
    massAndVolumeResults.totalLungVolume = totalLungVolume;
    massAndVolumeResults.hyperVolume = hyperVolume;
    massAndVolumeResults.poorlyVolume = poorlyVolume;
    massAndVolumeResults.normallyVolume = normallyVolume;
    massAndVolumeResults.nonVolume = nonVolume;
    massAndVolumeResults.percentualHyperVolume = percentualHyperVolume;
    massAndVolumeResults.percentualNormallyVolume = percentualNormallyVolume;
    massAndVolumeResults.percentualPoorlyVolume = percentualPoorlyVolume;
    massAndVolumeResults.percentualNonVolume = percentualNonVolume;
    massAndVolumeResults.hyperVolumePerSlice = hyperVolumePerSlice;
    massAndVolumeResults.normallyVolumePerSlice = normallyVolumePerSlice;
    massAndVolumeResults.poorlyVolumePerSlice = poorlyVolumePerSlice;
    massAndVolumeResults.nonVolumePerSlice = nonVolumePerSlice;
    massAndVolumeResults.percentualHyperVolumePerSlice = percentualHyperVolumePerSlice;
    massAndVolumeResults.percentualNormallyVolumePerSlice = percentualNormallyVolumePerSlice;
    massAndVolumeResults.percentualPoorlyVolumePerSlice = percentualPoorlyVolumePerSlice;
    massAndVolumeResults.percentualNonVolumePerSlice = percentualNonVolumePerSlice;

    %Mass
    massAndVolumeResults.totalLungMass = totalLungMass;
    massAndVolumeResults.hyperMass = hyperMass;
    massAndVolumeResults.poorlyMass = poorlyMass;
    massAndVolumeResults.normallyMass = normallyMass;
    massAndVolumeResults.nonMass = nonMass;
    massAndVolumeResults.percentualHyperMass = percentualHyperMass;
    massAndVolumeResults.percentualNormallyMass = percentualNormallyMass;
    massAndVolumeResults.percentualPoorlyMass = percentualPoorlyMass;
    massAndVolumeResults.percentualNonMass = percentualNonMass;
    massAndVolumeResults.hyperMassPerSlice = hyperMassPerSlice;
    massAndVolumeResults.normallyMassPerSlice = normallyMassPerSlice;
    massAndVolumeResults.poorlyMassPerSlice = poorlyMassPerSlice;
    massAndVolumeResults.nonMassPerSlice = nonMassPerSlice;
    massAndVolumeResults.percentualHyperMassPerSlice = percentualHyperMassPerSlice;
    massAndVolumeResults.percentualNormallyMassPerSlice = percentualNormallyMassPerSlice;
    massAndVolumeResults.percentualPoorlyMassPerSlice = percentualPoorlyMassPerSlice;
    massAndVolumeResults.percentualNonMassPerSlice = percentualNonMassPerSlice;


    %Close log frame.
    close(figObj)

    % Update menu
    set(handles.gui.saveDataMenu,'Enable','on')
    handles.saved = 0;
    
    handles.data.massAndVolumeResults = massAndVolumeResults;
    guidata(hObject,handles)
    
    % -- INFO -- additional variable show will facilitated the
    % implementation of batch processing, preventing the new figure pop-up
    if ~exist('show','var')
        massAndVolumeResultsFrame(massAndVolumeResults)
    end

end

function p15Calculation(hObject, eventdata)
    handles = guidata(hObject);

    metadata = handles.data.metadata;
    lung = handles.data.dicomImage;
    masks = handles.data.masks;

    p15ResultsFrame(lung, masks, metadata);
end

function lungWithMask = applyMaskToLung(lung, masks)
    lung(masks == 0) = 10000;
    
    % crop the image to the lung mask bouding box
    % x-y plane
    plane = sum(masks,3);
    lTop = find(sum(plane,2),1,'first');
    lBottom = find(sum(plane,2),1,'last')';
    lLeft = find(sum(plane,1),1,'first');
    lRight = find(sum(plane,1),1,'last');
    % z direction
    z = squeeze(any(any(masks,2),1));
    lBegin = find(z,1,'first');
    lEnd = find(z,1,'last');
    
    lungWithMask = double(lung(lTop:lBottom,lLeft:lRight,lBegin:lEnd));
end

function [hyperVolume, normallyVolume, poorlyVolume, nonVolume,...
    percentualHyperVolume, totalLungVolume, percentualNormallyVolume,...
    percentualPoorlyVolume, percentualNonVolume] =...
    volumeCalculation(lungWithMask, metadata, hyperRange, normallyRange,...
    poorlyRange, nonRange)

    voxelVolume = calculateVoxelVolume(metadata);

    if ~isnan(voxelVolume)
        hyperVolume = length(lungWithMask(lungWithMask >= hyperRange(1) &...
            lungWithMask < hyperRange(2))) * voxelVolume;

        normallyVolume = length(lungWithMask(lungWithMask >= normallyRange(1) &...
            lungWithMask < normallyRange(2))) * voxelVolume;

        poorlyVolume = length(lungWithMask(lungWithMask >= poorlyRange(1) &...
            lungWithMask < poorlyRange(2))) * voxelVolume;

        nonVolume = length(lungWithMask(lungWithMask >= nonRange(1) &...
            lungWithMask < nonRange(2))) * voxelVolume;

        totalLungVolume = hyperVolume + normallyVolume + poorlyVolume + ...
            nonVolume;

        %Percentual Volume Calculation.
        percentualHyperVolume = hyperVolume / totalLungVolume;
        percentualNormallyVolume = normallyVolume / totalLungVolume;
        percentualPoorlyVolume = poorlyVolume / totalLungVolume;
        percentualNonVolume = nonVolume / totalLungVolume;

    end


end

function [hyperMass, normallyMass, poorlyMass, nonMass,...
    percentualHyperMass, totalLungMass, percentualNormallyMass,...
    percentualPoorlyMass, percentualNonMass] =...
    massCalculation(lungWithMask, metadata,...
    hyperRange, normallyRange, poorlyRange, nonRange, equationToUse)

    voxelVolume = calculateVoxelVolume(metadata);

    if ~isnan(voxelVolume)

        %Choose between different equation to calculate mass.
        switch equationToUse
            case 'Normal'

        hyperMass = sum(1 - (lungWithMask(lungWithMask >= hyperRange(1) &...
            lungWithMask < hyperRange(2)) / -1000.0)) * voxelVolume;

        normallyMass = sum(1 - (lungWithMask(lungWithMask >= normallyRange(1) &...
            lungWithMask < normallyRange(2)) / -1000)) * voxelVolume;

        poorlyMass = sum(1 - (lungWithMask(lungWithMask >= poorlyRange(1) &...
            lungWithMask < poorlyRange(2)) / -1000)) * voxelVolume;

        nonMass = sum(1 - (lungWithMask(lungWithMask >= nonRange(1) &...
            lungWithMask < nonRange(2)) / -1000)) * voxelVolume;

        totalLungMass = hyperMass + normallyMass + poorlyMass + nonMass;

            case 'Simon'
        end

        %Percentual Volume Calculation.
        percentualHyperMass = hyperMass / totalLungMass;
        percentualNormallyMass = normallyMass / totalLungMass;
        percentualPoorlyMass = poorlyMass / totalLungMass;
        percentualNonMass = nonMass / totalLungMass;

    end


end

function voxelVolume = calculateVoxelVolume(metadata)

    voxelVolume = NaN;

    % -- INFO -- change the order of if conditions, the other one didn't
    % make sense
    if isfield(metadata,'SliceThickness')
        if isfield(metadata,'SpacingBetweenSlices')
            voxelVolume = (metadata.PixelSpacing(1) ^ 2 * metadata.SliceThickness * 0.001) *...
                (metadata.SpacingBetweenSlices / metadata.SliceThickness);
        else
            voxelVolume = (metadata.PixelSpacing(1) ^ 2 *...
                metadata.SliceThickness * 0.001);
        end
    end

end


function figObject = createLogFrame()
    %disply calculation log.
    figObject = figure('Units', 'Normalized',...
        'Position', [0.3, 0.4, 0.4, 0.2],...
        'Toolbar', 'None',...
        'Menubar', 'None',...
        'Color', 'black',...
        'Name', 'Log',...
        'NumberTitle', 'Off',...
        'WindowStyle', 'Modal',...
        'Resize', 'Off');
end

function displayLog(figObj, msg, clearAxes)
   if clearAxes
       cla
   else        ax = axes('Parent', figObj,...
            'Visible', 'Off');
        axes(ax)
    end

    text(0.5, 0.5, msg, 'Color', 'white', 'HorizontalAlignment', 'center',...
    'FontSize', 14)

    drawnow
end

function out = lungeDlg(fcn,varargin)
% This function is a wraper to all the bult-in dialog functions needed in
% this program. It sets appearance according to the program conventions and
% them call the correspondent function fcn

% get original values of the appearance defaults
% for uicontrols
uibc = get(0,'DefaultUIControlBackGroundColor');
uifc = get(0,'DefaultUIControlForeGroundColor');
uifs = get(0,'DefaultUIControlFontSize');
% for other figures
bc = get(0,'defaultFigureColor');
fc = get(0,'defaultTextColor');
% set new values
set(0,'DefaultUIControlBackGroundColor','k','DefaultUIControlForeGroundColor','w',...
    'DefaultUIControlFontSize',14)
set(0,'defaultFigureColor','k','defaultTextColor','w')
switch fcn
    case 'questdlg'
        if nargin-1 == 2
            out = questdlg(varargin{1},varargin{2});
        elseif nargin-1 == 5
            out = questdlg(varargin{1},varargin{2},varargin{3},...
                varargin{4},varargin{5});
        end
    case 'errordlg'
        errordlg(varargin{1},varargin{2})
    case 'listdlg'
        % matlab has a hard coded white background in the actual list of
        % the listdlg, so we need to use other color for text. It doesn't
        % resize correctly for a new fontsize, so this will not be changed
        set(0,'DefaultUIControlForeGroundColor','b','DefaultUIControlFontSize',uifs)
        out = listdlg(varargin{1},varargin{2},varargin{3},varargin{4});
    case 'msgbox'
        out = msgbox(varargin{1},varargin{2},varargin{3},varargin{4});
    case 'waitbar'
        % Attention waitbar need to be called from here, only when it is
        % created. To update use the normal function
        out = waitbar(varargin{1},varargin{2});
        % changing the color of the progress bar (only the current one is affected)
        set(findobj(out,'type','patch'),'facecolor','y','edgecolor','y')
end
% restore original default values
set(0,'DefaultUIControlBackGroundColor',uibc,'DefaultUIControlForeGroundColor',uifc,...
    'DefaultUIControlFontSize',uifs)
set(0,'defaultFigureColor',bc,'defaultTextColor',fc)
end

%%%%%%%%%%%%%%%%% MASS AND VOLUME CALCULATION %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function massAndVolumeResultsFrame(results)
    %Create main window
    screenSize = get(0, 'ScreenSize');
    figObject = figure('Tag', 'massAndVolumeFig',...
        'MenuBar', 'None',...
        'NumberTitle', 'Off',...
        'Name', 'Mass and Volume Results',...
        'Units','Normalized',...
        'Position', [0 0.03 1 0.93], ... %%% -- INFO -- in my laptop I can not see the top of the window, only after manually risize. I think it is a problem with windows, anyway a chaged the dimensions, is ok in your screen?
        'WindowButtonDownFcn', @exportAxesFigure,...
        'Tag', 'massAndVolumeFigure');

     hyperAxes = axes('Parent', figObject,...
        'Units', 'Normalized',...
        'Position', [0.1, 0.6, 0.3, 0.3],...
        'Tag', 'hyperAxes');

    normallyAxes = axes('Parent', figObject,...
        'Units', 'Normalized',...
        'Position', [0.6, 0.6, 0.3, 0.3] ,...
        'Tag', 'normallyAxes');

    poorlyAxes = axes('Parent', figObject,...
        'Units', 'Normalized',...
        'Position',[0.1, 0.2, 0.3, 0.3] ,...
        'Tag', 'poorlyAxes');

    nonAxes = axes('Parent', figObject,...
        'Units', 'Normalized',...
        'Position', [0.6, 0.2, 0.3, 0.3],...
        'Tag', 'nonAxes');

    uicontrol('Parent', figObject,...
        'Units', 'Normalized',...
        'Position', [0.45, 0.95, 0.13, 0.03],...
        'Style', 'Pop',...
        'Tag', 'avaiablePlots',...
        'String', {'Mass', 'Mass Percentual', 'Volume', 'Volume Percentual'})

    uicontrol('Parent', figObject,...
        'Units', 'Normalized',...
        'Position', [0.6, 0.95, 0.05, 0.03],...
        'String', 'Plot',...
        'Tag', 'changePlot',...
        'Callback', @plotNewResult);

    uicontrol('Parent', figObject,...
        'Units', 'Normalized',...
        'Position', [0.7, 0.95, 0.13, 0.03],...
        'Style', 'Pop',...
        'Tag', 'exportResults',...
        'String', {'.CSV', '.MAT'})

    uicontrol('Parent', figObject,...
        'Units', 'Normalized',...
        'Position', [0.85, 0.95, 0.05, 0.03],...
        'String', 'Export',...
        'Tag', 'changePlot',...
        'Callback', @massAndVolumeExportResults);

    resultsTable = uitable('Parent', figObject,...
        'Units', 'Normalized',...
        'Position', [0.1, 0.01, 0.8, 0.12],...
        'ColumnName', {'Total Lung Mass (g)', 'Mass Hyper Aerated (g)',...
        'Mass Normally Aerated (g)', 'Mass Poorly Aerated (g)',...
        'Mass Non Aerated (g)','Total Lung Volume (ml)', 'Volume Hyper Aerated (ml)',...
        'Volume Normally Aerated (ml)', 'Volume Poorly Aerated (ml)',...
        'Volume Non Aerated (ml)'},'Tag', 'massAndVolumeTable');

    uicontrol('Parent', figObject,...
        'Units', 'Normalized',...
        'Position', [0.45, 0.16, 0.1, 0.04],...
        'Style', 'Text',...
        'String', 'Double Click to Export Axes');

    %Initial Plots

    results.data{1} = results.hyperMassPerSlice;
    results.data{2} = results.poorlyMassPerSlice;
    results.data{3} = results.normallyMassPerSlice;
    results.data{4} = results.nonMassPerSlice;
    results.axes(1) = hyperAxes;
    results.axes(2) = poorlyAxes;
    results.axes(3) = normallyAxes;
    results.axes(4) = nonAxes;
    results.ylabel = 'Mass (g)';


    %Place results in the Uitable
    tableCells = cell(1, 18);
    tableCells{1} = results.totalLungMass;
    tableCells{2} = results.hyperMass;
    tableCells{3} = results.normallyMass;
    tableCells{4} = results.poorlyMass;
    tableCells{5} = results.nonMass;
    tableCells{6} = results.totalLungVolume;
    tableCells{7} = results.hyperVolume;
    tableCells{8} = results.normallyVolume;
    tableCells{9} = results.poorlyVolume;
    tableCells{10} = results.nonVolume;

    set(resultsTable, 'Data', tableCells);

    massAndVolumePlotResults(results)

    handles.massAndVolumeData = results;

    handles.massAndVolumeGui = guihandles(figObject);

    guidata(figObject, handles);
end


function plotNewResult(hObject, eventdata)
    handles = guidata(hObject);

    avaiablePlots = get(handles.massAndVolumeGui.avaiablePlots, 'String');
    plotIndex = get(handles.massAndVolumeGui.avaiablePlots, 'Value');

    results.axes(1) = handles.massAndVolumeData.axes(1);
    results.axes(2) = handles.massAndVolumeData.axes(2);
    results.axes(3) = handles.massAndVolumeData.axes(3);
    results.axes(4) = handles.massAndVolumeData.axes(4);

    switch avaiablePlots{plotIndex}
        case 'Mass'

            results.data{1}  = handles.massAndVolumeData.hyperMassPerSlice;
            results.data{2}  = handles.massAndVolumeData.poorlyMassPerSlice;
            results.data{3}  = handles.massAndVolumeData.normallyMassPerSlice;
            results.data{4}  = handles.massAndVolumeData.nonMassPerSlice;
            results.ylabel = 'Mass (g)';

        case 'Mass Percentual'

            %Prepare data to be plotted
            results.data{1}  = handles.massAndVolumeData.percentualHyperMassPerSlice;
            results.data{2}  = handles.massAndVolumeData.percentualPoorlyMassPerSlice;
            results.data{3}  = handles.massAndVolumeData.percentualNormallyMassPerSlice;
            results.data{4}  = handles.massAndVolumeData.percentualNonMassPerSlice;

            results.ylabel = 'Mass Percentual (%)';

        case 'Volume'
            results.data{1}  = handles.massAndVolumeData.hyperVolumePerSlice;
            results.data{2}  = handles.massAndVolumeData.poorlyVolumePerSlice;
            results.data{3}  = handles.massAndVolumeData.normallyVolumePerSlice;
            results.data{4}  = handles.massAndVolumeData.nonVolumePerSlice;
            results.ylabel = 'Volume (ml)';

        case 'Volume Percentual'
            results.data{1}  = handles.massAndVolumeData.percentualHyperVolumePerSlice;
            results.data{2}  = handles.massAndVolumeData.percentualPoorlyVolumePerSlice;
            results.data{3}  = handles.massAndVolumeData.percentualNormallyVolumePerSlice;
            results.data{4}  = handles.massAndVolumeData.percentualNonVolumePerSlice;
            results.ylabel = 'Volume Percentual (%)';

    end
    massAndVolumePlotResults(results)
end




function massAndVolumePlotResults(results)
    axes(results.axes(1))
    plot(results.data{1}, 'r-o','MarkerFaceColor', 'r')
    ylabel(results.ylabel)
    title('Hyper Aerated')
    axes(results.axes(2))
    plot(results.data{2}, '-o','MarkerFaceColor', 'b')
    ylabel(results.ylabel)
    title('Poorly Aerated')
    axes(results.axes(3))
    plot(results.data{3}, 'b-o','MarkerFaceColor', 'b')
    ylabel(results.ylabel)
    title('Normally Aerated')
    axes(results.axes(4))
    plot(results.data{4}, 'k-o','MarkerFaceColor', 'k')
    title('Non Aerated')
    ylabel(results.ylabel)

end

function massAndVolumeExportResults(hObject, eventdata)
    handles = guidata(hObject);
    exportOptions = get(handles.massAndVolumeGui.exportResults, 'String');
    exportIndex = get(handles.massAndVolumeGui.exportResults, 'Value');

    results = handles.massAndVolumeData;

    switch exportOptions{exportIndex}
        case '.CSV'
            massAndVolumeExportToCsv(results);
        case '.MAT'
            massAndVolumeExportToMat(results);
    end


end

function massAndVolumeExportToCsv(results)
    [fileName pathName] = uiputfile('results.csv');

    if fileName
        
        indicesNames = {'Total Lung Mass (g)', 'Hyper Aerated Mass (g)',...
            'Poorly Aerated Mass (g)', 'Normally Aerated Mass (g)',...
            'Non Aerated Mass (g)', 'Total Lung Volume (L)',...
            'Hyper Aerated Volume (L)', 'Poorly Aerated Volume (L)',...
            'Normally Aerated Volume (L)', 'Non Aerated  Volume (L)',...
            'Perc Hyper Mass (%)', 'Perc Poorly Mass (%)',...
            'Perc Normally Mass (%)', 'Perc Non Mass (%)',...
            'Perc Hyper Volume (%)', 'Perc Poorly Volume (%)',...
            'Perc Normally Volume (%)', 'Perc Non Volume (%)',...
            'Hyper Aerated Mass i (g)', 'Poorly Aerated Mass i (g)',...
            'Normally Aerated Mass i (g)', 'Non Aerated Mass i (g)',...
            'Hyper Aerated Volume i (L)', 'Poorly Aerated Volume i (L)',...
            'Normally Aerated Volume i (L)', 'Non Aerated Volume i (L)',...
            'Perc Hyper Aerated Mass i (%)', 'Perc Poorly Aerated Mass i (%)',...
            'Perc Normally Aerated Mass i (%)', 'Perc Non Aerated Mass i (%)',...
            'Perc Hyper Aerated Volume i (%)', 'Perc Poorly Aerated Volume i (%)',...
            'Perc Normally Aerated Volume i (%)', 'Perc Non Aerated Volume i (%)'};
            
        results = rmfield(results, 'data');
        results = rmfield(results, 'axes');
        results = rmfield(results, 'ylabel');

        fullFileName = [pathName fileName];
        fid = fopen(fullFileName, 'w');
        massAndVolumeBuildCsvFile(fid, indicesNames, results)
        fclose(fid);

    end


end

function massAndVolumeExportToMat(results)
    [fileName pathName] = uiputfile('results.mat');

    %Prepare data
    results = rmfield(results, 'data');
    results = rmfield(results, 'axes');
    results = rmfield(results, 'ylabel');


    if fileName
        fullFileName = [pathName fileName];
        save(fullFileName, 'results');

    end

end

function massAndVolumeBuildCsvFile(fid, indicesNames, results)
    fprintf(fid, '%s,', indicesNames{1});
    fprintf(fid,'%.2f\r\n', results.totalLungMass)
    
    fprintf(fid, '%s,', indicesNames{2});
    fprintf(fid, '%.2f\r\n', results.hyperMass);
    
    fprintf(fid, '%s,', indicesNames{3});
    fprintf(fid, '%.2f\r\n', results.poorlyMass);
    
    fprintf(fid, '%s,', indicesNames{4});
    fprintf(fid, '%.2f\r\n', results.normallyMass);
    
    fprintf(fid, '%s,', indicesNames{5});
    fprintf(fid, '%.2f\r\n', results.nonMass);
    
    fprintf(fid, '%s,', indicesNames{6});
    fprintf(fid,'%.2f\r\n', results.totalLungVolume);
    
    fprintf(fid, '%s,', indicesNames{7});
    fprintf(fid, '%.2f\r\n', results.hyperVolume);
    
    fprintf(fid, '%s,', indicesNames{8});
    fprintf(fid, '%.2f\r\n', results.poorlyVolume);
    
    fprintf(fid, '%s,', indicesNames{9});
    fprintf(fid, '%.2f\r\n', results.normallyVolume);
    
    fprintf(fid, '%s,', indicesNames{10});
    fprintf(fid, '%.2f\r\n', results.nonVolume);
    
    fprintf(fid, '%s,', indicesNames{11});
    fprintf(fid,'%.2f\r\n', results.percentualHyperMass);
    
    fprintf(fid, '%s,', indicesNames{12});
    fprintf(fid, '%.2f\r\n', results.percentualPoorlyMass);
    
    fprintf(fid, '%s,', indicesNames{13});
    fprintf(fid, '%.2f\r\n', results.percentualNormallyMass);
    
    fprintf(fid, '%s,', indicesNames{14});
    fprintf(fid, '%.2f\r\n', results.percentualNonMass);
    
    fprintf(fid, '%s,', indicesNames{15});
    fprintf(fid,'%.2f\r\n', results.percentualHyperVolume);
    
    fprintf(fid, '%s,', indicesNames{16});
    fprintf(fid, '%.2f\r\n', results.percentualPoorlyVolume);
    
    fprintf(fid, '%s,', indicesNames{17});
    fprintf(fid, '%.2f\r\n', results.percentualNormallyVolume);
    
    fprintf(fid, '%s,', indicesNames{18});
    fprintf(fid, '%.2f\r\n', results.percentualNonVolume);
    
    
    fprintf(fid, '%s,', indicesNames{19});
    writeArrayToCsvFile(fid, results.hyperMassPerSlice);
    
    fprintf(fid, '\r\n%s,', indicesNames{20})
    writeArrayToCsvFile(fid, results.poorlyMassPerSlice);
    
        
    fprintf(fid, '\r\n%s,', indicesNames{21});
    writeArrayToCsvFile(fid, results.normallyMassPerSlice);
    
    fprintf(fid, '\r\n%s,', indicesNames{22});
    writeArrayToCsvFile(fid, results.nonMassPerSlice);
    
    
    fprintf(fid, '\r\n%s,', indicesNames{23});
    writeArrayToCsvFile(fid, results.hyperVolumePerSlice);
    
    fprintf(fid, '\r\n%s,', indicesNames{24});
    writeArrayToCsvFile(fid, results.poorlyVolumePerSlice);
    
        
    fprintf(fid, '\r\n%s,', indicesNames{25});
    writeArrayToCsvFile(fid, results.normallyVolumePerSlice);
    
    fprintf(fid, '\r\n%s,', indicesNames{26});
    writeArrayToCsvFile(fid, results.nonVolumePerSlice);
    %TODO: some percentual indices are missing!
    
    fprintf(fid, '\r\n%s,', indicesNames{27});
    writeArrayToCsvFile(fid, results.percentualHyperMassPerSlice);
    
     fprintf(fid, '\r\n%s,', indicesNames{28});
    writeArrayToCsvFile(fid, results.percentualPoorlyMassPerSlice);
    
    fprintf(fid, '\r\n%s,', indicesNames{29})
    writeArrayToCsvFile(fid, results.percentualNormallyMassPerSlice);       

    
    fprintf(fid, '\r\n%s,', indicesNames{30});
    writeArrayToCsvFile(fid, results.percentualNonMassPerSlice);
    
    
    fprintf(fid, '\r\n%s,', indicesNames{31});
    writeArrayToCsvFile(fid, results.percentualHyperVolumePerSlice);
    
    fprintf(fid, '\r\n%s,', indicesNames{32});
    writeArrayToCsvFile(fid, results.percentualPoorlyVolumePerSlice);
    
        
    fprintf(fid, '\r\n%s,', indicesNames{33});
    writeArrayToCsvFile(fid, results.percentualNormallyVolumePerSlice);
    
    fprintf(fid, '\r\n%s,', indicesNames{34});
    writeArrayToCsvFile(fid, results.percentualNonVolumePerSlice);
    
    
    

end

function writeArrayToCsvFile(fid, indicesArray)
    for index = 1:length(indicesArray)
        fprintf(fid, '%.2f,', indicesArray(index));
    end
end

function exportAxesFigure(hObject, eventdata)
    handles = guidata(hObject);

    clickType = get(handles.massAndVolumeGui.massAndVolumeFigure, 'SelectionType');

    if strcmp(clickType, 'open')
        currentAxes = gca;

        currentAxesChildren = get(currentAxes, 'children');


        figObj = figure;
        ax = axes;
        copyobj(allchild(currentAxes), ax);



    end



end

%%%%%%%%%%%%%%%%% END MASS AND VOLUME CALCULATION %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%% P15 CALCULATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function p15ResultsFrame(lung, masks, metadata)

    voxelVolume = calculateVoxelVolume(metadata);

    lungWithMask = applyMaskToLung(lung, masks);
    [pXVolume, volumePercentual, huRange] = calculatePX(lungWithMask, metadata,...
        15, 'both', voxelVolume);


    %Create main window
    screenSize = get(0, 'ScreenSize');
    figObject = figure('MenuBar', 'None',...
        'NumberTitle', 'Off',...
        'Name', 'Mass and Volume Results',...
        'Units', 'Normalized',...
        'Position', [0 0.03 1 0.93], ... %%% -- INFO -- in my laptop I can not see the top of the window, only after manually risize. I think it is a problem with windows, anyway a chaged the dimensions, is ok in your screen?
        'Tag', 'p15Figure');

     p15MassAxes = axes('Parent', figObject,...
        'Units', 'Normalized',...
        'Position',[0.6, 0.4, 0.35, 0.45] ,...
        'Tag', 'p15MassAxes');    

    p15VolumeAxes = axes('Parent', figObject,...
        'Units', 'Normalized',...
        'Position', [0.1, 0.4, 0.35, 0.45] ,...
        'Tag', 'p15VolumeAxes');

    uicontrol('Parent', figObject,...
        'Units', 'Normalized',...
        'Position', [0.4, 0.3, 0.05, 0.02],...
        'Style', 'Pop',...
        'String', {'15', '5', '10', '20', '25', '30', '35'},...
        'Tag', 'p15MassPop',...
        'Callback', @p15VolumeChangePValue);

    uicontrol('Parent', figObject,...
        'Units', 'Normalized',...
        'Position', [0.1, 0.3, 0.10, 0.02],...
        'Style', 'Text',...
        'Tag', 'p15VolumeHuResults',...
        'HorizontalAlignment', 'left',...
        'String', 'P15 (hu) =');

    uicontrol('Parent', figObject,...
        'Units', 'Normalized',...
        'Position', [0.1, 0.26, 0.1, 0.02],...
        'Style', 'Text',...
        'HorizontalAlignment', 'left',...
        'Tag','volumeHuResults',...
        'String', 'Volume (ml) = ');

    uicontrol('Parent', figObject,...
        'Units', 'Normalized',...
        'Position', [0.1, 0.22, 0.1, 0.02],...
        'Style', 'Text',...
        'HorizontalAlignment', 'left',...
        'Tag','massHuResults',...
        'String', 'Mass (g) = ');

    uicontrol('Parent', figObject,...
        'Units', 'Normalized',...
        'Position', [0.1, 0.18, 0.1, 0.02],...
        'Style', 'Text',...
        'HorizontalAlignment', 'left',...
        'Tag','densityHuResults',...
        'String', 'Density (g/l) = ');

    uicontrol('Parent', figObject,...
        'Units', 'Normalized',...
        'Position', [0.6, 0.3, 0.05, 0.02],...
        'Style', 'Text',...
        'HorizontalAlignment', 'left',...
        'String', 'P15 (hu) =');

    uicontrol('Parent', figObject,...
        'Units', 'Normalized',...
        'Position', [0.6, 0.26, 0.065, 0.02],...
        'Style', 'Text',...
        'HorizontalAlignment', 'left',...
        'String', 'Volume (ml) = ');

    uicontrol('Parent', figObject,...
        'Units', 'Normalized',...
        'Position', [0.6, 0.22, 0.065, 0.02],...
        'Style', 'Text',...
        'HorizontalAlignment', 'left',...
        'String', 'Mass (g) = ');

    uicontrol('Parent', figObject,...
        'Units', 'Normalized',...
        'Position', [0.6, 0.18, 0.065, 0.02],...
        'Style', 'Text',...
        'HorizontalAlignment', 'left',...
        'String', 'Density (g/l) = ');


    axes(p15VolumeAxes)
    plot(huRange, volumePercentual)
    xlabel('Housfield  Units (HU)')
    ylabel('Cumulative Number of Voxels (%)')
    %Plot the corresponding value in the axes
    plotPXLines(p15VolumeAxes, huRange, volumePercentual, pXVolume, 15)
    
    axes(p15MassAxes)
    plot(huRange, volumePercentual)
    xlabel('Cumulative Mass (g)')
    ylabel('Cumulative Volume (%)')
    plotPXLines(p15MassAxes, huRange, volumePercentual, -850, 15)      

    
    handles.p15Data.voxelVolume = voxelVolume;
    handles.p15Data.lungWithMask = lungWithMask;
    handles.p15Data.pXVolume = pXVolume;
    handles.p15Data.volumePercentual = volumePercentual;
    handles.p15Data.huRange = huRange;
    
    handles.p15Gui = guihandles(figObject);
    handles.p15Gui.p15VolumeAxes = p15VolumeAxes;
    
    [volume, mass, density] = calculateVolumeMassAndDensityBasedOnPX(lungWithMask,...
        voxelVolume, pXVolume);
    
    setPXTextResults(handles, 15, pXVolume, volume, mass, density)
    
    
    guidata(figObject, handles);

 end

function plotPXLines(targetAxes, xData, yData, x, y)
    xLim = get(targetAxes, 'xlim');
    axes(targetAxes)
    cla
    plot(xData, yData)
    hold on
    plot([xLim(1), x], [y, y], 'k')
    plot([x, x], [0, y], 'k')
    xlabel('Housfield  Units (HU)')
    ylabel('Cumulative Number of Voxels (%)')
    hold off
end

function p15VolumeChangePValue(hObject, eventdata)
    handles = guidata(hObject);
    pValueIndex = get(handles.p15Gui.p15MassPop, 'Value');
    pValuesOptions = get(handles.p15Gui.p15MassPop, 'String');

    newPValue = str2double(pValuesOptions{pValueIndex});

    pXVolume = closerPXValue(handles.p15Data.volumePercentual,...
        handles.p15Data.huRange, newPValue);
    
    plotPXLines(handles.p15Gui.p15VolumeAxes, handles.p15Data.huRange,...
        handles.p15Data.volumePercentual, pXVolume, newPValue)
    
    [volume, mass, density] = calculateVolumeMassAndDensityBasedOnPX(handles.p15Data.lungWithMask,...
    handles.p15Data.voxelVolume, pXVolume);
    setPXTextResults(handles, newPValue, pXVolume, volume, mass, density)
end


function [pXVolume, percentualNumberOfVoxels, huRange] = calculatePX(lung,...
    metadata, X, typeOfCalc, voxelVolume)
    lung(lung > 100 | lung <= -1000) = [];
    
    if ~isnan(voxelVolume)
        switch typeOfCalc
            case 'both'
                huRange = -1000:100;
                lungTotalVoxels = length(lung);
                nClasses = length(huRange);
                massPerDensity = zeros(1, nClasses);
                percentualNumberOfVoxels = zeros(1, nClasses);
                volumePerDensity = zeros(1, nClasses);
                h = lungeDlg('waitbar',0, 'Calculating P15...');
                %waitbar(0, 'Calculating P15...');
                for hu = 1:nClasses
                    nVoxels = length(lung(lung == huRange(hu)));
                    percentualNumberOfVoxels(hu) = nVoxels / lungTotalVoxels;
                    volumePerDensity(hu) = nVoxels * voxelVolume;
                    %massPerDensity(counter);
                    lung(lung == huRange(hu)) = [];
                      waitbar(hu / nClasses);
                end
                close(h)
                percentualNumberOfVoxels = cumsum(percentualNumberOfVoxels) * 100;

                volumeCumulativeSum = cumsum(volumePerDensity);
                volumePercentual = volumeCumulativeSum /...
                    volumeCumulativeSum(end) * 100;

               pXVolume = closerPXValue(percentualNumberOfVoxels, huRange, 15);


            case 'mass'
            otherwise
        end
    end

end

function [volume, mass, density] = calculateVolumeMassAndDensityBasedOnPX(lung,...
    voxelVolume, pXValue)
    nVoxels = length(lung(lung >= -1000 & lung <= pXValue));
    volume = nVoxels * voxelVolume;
    mass = 10;
    density = mass / volume;
    
end

function setPXTextResults(handles, newPValue, pXVolume, volume, mass, density)
    newPStringFormat = 'P%d (hu) = %d';
    newVolumeStringFormat = 'Volume (L) = %.2f';
    newMassStringFormat = 'Mass (g) = %.2f';
    newDensityStringFormat = 'Density (g/L) = %.2f';
    
    set(handles.p15Gui.p15VolumeHuResults, 'String',...
        sprintf(newPStringFormat, newPValue, pXVolume));
    set(handles.p15Gui.volumeHuResults, 'String',...
        sprintf(newVolumeStringFormat, volume));
    set(handles.p15Gui.massHuResults, 'String',...
        sprintf(newMassStringFormat, mass));
    set(handles.p15Gui.densityHuResults, 'String',...
        sprintf(newDensityStringFormat, density));
end

function pXValue = closerPXValue(percentualIndice, huRange, newPValue)
    [void, pXPosition] = min(abs(percentualIndice -  newPValue)); %%% -- INFO -- changed ~ to void in the function output to be compatible with old matlab versions
    pXValue = huRange(pXPosition);
end


%%%%%%%%%%%%%%%%% END P15 CALCULATION %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%% USEFULL FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function names = interpretCIPCodes(labels)
    % Transform labels from a CIP generated mask in name of structures
    
    % convert labels to type
    types = bitshift(uint16(labels),-8);
    
    % convert lables to region
    regions = uint16(labels) - bitshift(types,8);
    
    % edit the next to variables to add or remove types and regions
    % see CIP code top complete list
    listTypes   = {[0, 1, 2, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48];... codes
                   {'Undefined','Normal Parenchyma','Airway','Trachea','Main Bronchus','Upper Lobe Bronchus',... name
                   'Airway Generation 3','Airway Generation 3','Airway Generation 4','Airway Generation 5','Airway Generation 6',... name
                   'Airway Generation 7','Airway Generation 8','Airway Generation 9','Airway Generation 10'}};% name
    listRegions = {[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14];... codes
                   {'','Whole Lung','Rigth Lung','Left Lung','Right Superior Lobe','Right Middle Lobe','Right Inferior Lobe',... name
                   'Left Superior Lobe','Left Middle Lobe','Left Inferior Lobe','Left Upper Third','Left Middle Third',... name
                   'Left Lower Third','Right Upper Third','Right Middle Third','Right Lower Third'}};% name
    
    names = cell(1,numel(labels));
    for idx=1:numel(labels)
        names{idx} = [char(listTypes{2}(listTypes{1}==types(idx))) ' - ' char(listRegions{2}(listRegions{1}==regions(idx)))];
    end
end

function [h,ct,pet]=find_files(folder,h,ct,pet)
% Recursively search for data files in patient folder and return a list of
% masks, ct and pet files
    list = dir(folder);

    d=list([list.isdir]);
    d={d.name};
    d=d(~strncmp(d,'.',1));
    list=list(~[list.isdir]);
    for i=1:length(list)
        [lixo,name,ext] = fileparts(list(i).name);
        if strcmp(ext,'.hdr') || strcmp(ext,'.nrrd')
            h{end+1} = fullfile(folder,[name ext]);
        elseif strncmp('0001',name,4) ||...
                (~isempty(strfind(name,'dcm')) && ~isempty(name)) ||...
                strcmp('.dcm',ext)
            file = fullfile(folder,[name ext]);
            info = dicominfo(file);
            switch lower(info.Modality)
                case 'ct'
                    ct = file;
                case 'pt'
                    pet = file;
            end
            break
        end
    end

    for i=1:numel(d)
        folder2 = fullfile(folder,d{i});
        [h,ct,pet] = find_files(folder2,h,ct,pet);
    end
end

function MapVectors = CTPET_CreateMap(ImgHeader_1,ImgHeader_2,crop)
% This function is a CT_Processing2 version of OV2_MakeMapVestors

% Summary of modifications:
%   - the inputs are now the image headers
%   - the mapvector struct is an output and is not saved in a mat file
%       - a lot of saving things were cutted out
%   - the slice Z dimension is defined by PixelDimensions and SpacingBetweenSlices

    % -- assign hiRes and lowRes labels -- NOTE: not all DICOM labels are consistent in PET and CT image: both PET and CT images have some specific DICOM labels
    if ImgHeader_1.PixelSpacing(1) < ImgHeader_2.PixelSpacing(1),
        hiRes_ImgHeader = ImgHeader_1;
        lowRes_ImgHeader = ImgHeader_2;
    else
        hiRes_ImgHeader = ImgHeader_2;
        lowRes_ImgHeader = ImgHeader_1;
    end
    if isfield(hiRes_ImgHeader,'NumberOfSlices')
        hiRes_ImgHeader.NumberOfSlices = double( hiRes_ImgHeader.NumberOfSlices);
    else
        hiRes_ImgHeader.NumberOfSlices = numel(hiRes_ImgHeader.Filenames);% get number of slices from dcm files inside the folder (note that it only works for aquisitions with one frame)
    end

    % -- convert type of DICOM parameter to MATLAB's default type 'double' UNLESS OV2_GetDicomInfo does the conversion in the future!!!
    if isfield(lowRes_ImgHeader,'NumberOfSlices')
        lowRes_ImgHeader.NumberOfSlices = double( lowRes_ImgHeader.NumberOfSlices);
    else
        lowRes_ImgHeader.NumberOfSlices = numel(lowRes_ImgHeader.Filenames);% get number of slices from dcm files inside the folder (note that it only works for aquisitions with one frame)
    end
    % consistent conservative style access for ALL numerical paramters of the structure: convert to double even if the parameter was converted before (unless OV2_GetDicomInfo is changed)

    % -- create mapping vectors
    % NOTES ABOUT DICOM
    % constants for accessing x, y and z in the ImagePositionPatient vector
    sel_x = 1;
    sel_y = 2;
    sel_z = 3;

    % if ~isfield(hiRes_ImgHeader,'SpacingBetweenSlices')
    % Always recalculate, because we must keep thw sign
        info1 = dicominfo(hiRes_ImgHeader.Filenames{1});
        info2 = dicominfo(hiRes_ImgHeader.Filenames{2});
        if isfield(hiRes_ImgHeader,'SliceLocation')
            hiRes_ImgHeader.SpacingBetweenSlices = info1.SliceLocation-info2.SliceLocation;
        else
            hiRes_ImgHeader.SpacingBetweenSlices = info1.ImagePositionPatient(sel_z)-info2.ImagePositionPatient(sel_z);
        end
    % end


    % if ~isfield(lowRes_ImgHeader,'SpacingBetweenSlices')
    % Always recalculate, because we must keep thw sign
        info1 = dicominfo(lowRes_ImgHeader.Filenames{1});
        info2 = dicominfo(lowRes_ImgHeader.Filenames{2});
        if isfield(lowRes_ImgHeader,'SliceLocation')
            lowRes_ImgHeader.SpacingBetweenSlices = info1.SliceLocation-info2.SliceLocation;
        else
            lowRes_ImgHeader.SpacingBetweenSlices = info1.ImagePositionPatient(sel_z)-info2.ImagePositionPatient(sel_z);
        end
    % end

    % -- make vector for z direction
    % start with z because it has the lowest number of steps and the largest vectorized voxel reduction per step
    % DICOM NOTE for z-axis: the slice location increases in negative direction
    % with an increase in the slice number
    if exist('crop','var')
        hiRes_len_z = crop(6) - crop(5) + 1;
    else
        hiRes_len_z = double( hiRes_ImgHeader.NumberOfSlices);
    end
    if isfield(hiRes_ImgHeader,'SliceLocation')
        hiRes_origin_z = double( hiRes_ImgHeader.SliceLocation); % get origin for z direction
    else
        hiRes_origin_z = double( hiRes_ImgHeader.ImagePositionPatient(sel_z)); % get origin for z direction
    end
    hiRes_SliceSpacing = round( double( hiRes_ImgHeader.SpacingBetweenSlices)*1e4)/1e4;%round( double( hiRes_ImgHeader.opt_SliceSpacing), 4); % get true voxel size for "spacefilling matrix" -- NOTE: slice thickness in the DICOM header is bigger so it would result in false mapping vectors!
    if exist('crop','var')
        hiRes_origin_z = hiRes_origin_z - (crop(5)+1) * hiRes_SliceSpacing;
    end
    hiRes_center_z = hiRes_origin_z - hiRes_SliceSpacing * (0:hiRes_len_z-1); % NOTE: length of vector = NumberOfSlices - 1   so that the last value is the upper bound of the last slice

    lowRes_len_z = double( lowRes_ImgHeader.NumberOfSlices);
    if isfield(lowRes_ImgHeader,'SliceLocation')
        lowRes_origin_z = double( lowRes_ImgHeader.SliceLocation); % get origin for z direction
    else
        lowRes_origin_z = double( lowRes_ImgHeader.ImagePositionPatient(sel_z)); % get origin for z direction
    end
    lowRes_SliceSpacing = round( double( lowRes_ImgHeader.SpacingBetweenSlices)*1e4)/1e4;%double( lowRes_ImgHeader.opt_SliceSpacing);
    lowRes_VoxelEdge_z = ( lowRes_origin_z + lowRes_SliceSpacing/2) - lowRes_SliceSpacing * (0:lowRes_len_z); % VoxelEdge(i) is the upper boundary of the voxel i and VoxelEdge(i+1) is the lower boundary because of direction the slice location vector

    if abs(hiRes_SliceSpacing) < abs(lowRes_SliceSpacing), % default mapping
        MapVectors.vox_map_z = zeros( 1, hiRes_len_z);
        for i = 1:lowRes_len_z,
            if sign(lowRes_SliceSpacing)>0
                MapVectors.vox_map_z( ( hiRes_center_z <= lowRes_VoxelEdge_z( i)) & ( hiRes_center_z > lowRes_VoxelEdge_z(i+1))) = i; % set slice ID of the low-res image in all hi-res voxels within the bounderies
            else
                MapVectors.vox_map_z( ( hiRes_center_z >= lowRes_VoxelEdge_z( i)) & ( hiRes_center_z < lowRes_VoxelEdge_z(i+1))) = i; % set slice ID of the low-res image in all hi-res voxels within the bounderies
            end
        end
    else
        hiRes_center_z_wEdges = hiRes_center_z( [1, 1:end, end]);
        hiRes_center_z_wEdges(1) = hiRes_center_z_wEdges(1) + ( hiRes_SliceSpacing / 2);
        hiRes_center_z_wEdges(end) = hiRes_center_z_wEdges(end) - ( hiRes_SliceSpacing / 2);
        lowRes_center_z = lowRes_origin_z - lowRes_SliceSpacing * (0:lowRes_len_z-1); % NOTE: length of vector = NumberOfSlices - 1   so that the last value is the upper bound of the last slice
        % NOTE 'interp1' using the method 'nearest' returns NaN for sample locations (lowRes_center_z) that are below
        % the lowest or above the highest reference location (hiRes_center_z). In order to use the voxel's edges rather
        % than their center points as cut off the edges are added at the ends of the hiRes_center_z vector.
        MapVectors.vox_map_z = interp1( hiRes_center_z_wEdges, [1, 1:hiRes_len_z, hiRes_len_z], lowRes_center_z, 'nearest');
    end

    MapVectors.hiRes_SliceSpacing=hiRes_SliceSpacing;
    MapVectors.lowRes_SliceSpacing=lowRes_SliceSpacing;

    % -- make vector for x direction
    if exist('crop','var')
        hiRes_len_x = crop(2) - crop(1) + 1;
    else
        hiRes_len_x = double( hiRes_ImgHeader.Columns);
    end
    hiRes_PixelSpacing = double( hiRes_ImgHeader.PixelSpacing);
    hiRes_origin_x = double( hiRes_ImgHeader.ImagePositionPatient( sel_x));
    if exist('crop','var')
        hiRes_origin_x = hiRes_origin_x + (crop(1)-1) * hiRes_PixelSpacing( sel_x);
    end
    hiRes_center_x = hiRes_origin_x + hiRes_PixelSpacing( sel_x) * (0:hiRes_len_x-1); % NOTE: length of vector = NumberOfSlices - 1   so that the last value is the upper bound of the last slice

    lowRes_len_x = double( lowRes_ImgHeader.Columns);
    lowRes_origin_x = double( lowRes_ImgHeader.ImagePositionPatient( sel_x));
    lowRes_PixelSpacing = double( lowRes_ImgHeader.PixelSpacing);
    lowRes_VoxelEdge_x = ( lowRes_origin_x - lowRes_PixelSpacing( sel_x) / 2) + lowRes_PixelSpacing( sel_x) * (0:lowRes_len_x); % VoxelEdge(i) is the upper boundary of the voxel i and VoxelEdge(i+1) is the lower boundary because of direction the slice location vector
    MapVectors.vox_map_x = zeros( 1, hiRes_len_x);
    for i = 1:lowRes_len_x,
        MapVectors.vox_map_x( ( hiRes_center_x >= lowRes_VoxelEdge_x( i)) & ( hiRes_center_x < lowRes_VoxelEdge_x(i+1))) = i; % set all hi-res voxels within the bounderies to the ID of the low-res image
    end

    % -- make vector for y direction
    if exist('crop','var')
        hiRes_len_y = crop(4) - crop(3) + 1;
    else
        hiRes_len_y = double( hiRes_ImgHeader.Rows);
    end
    hiRes_origin_y = double( hiRes_ImgHeader.ImagePositionPatient( sel_y));
    hiRes_PixelSpacing = double( hiRes_ImgHeader.PixelSpacing);
    if exist('crop')
        hiRes_origin_y = hiRes_origin_y + (crop(3)-1) * hiRes_PixelSpacing( sel_y);
    end
    hiRes_center_y = hiRes_origin_y + hiRes_PixelSpacing( sel_y) * (0:hiRes_len_y-1); % NOTE: length of vector = NumberOfSlices - 1   so that the last value is the upper bound of the last slice

    lowRes_len_y = double( lowRes_ImgHeader.Rows);
    lowRes_origin_y = double( lowRes_ImgHeader.ImagePositionPatient( sel_y));
    lowRes_PixelSpacing = double( lowRes_ImgHeader.PixelSpacing);
    lowRes_VoxelEdge_y = ( lowRes_origin_y - lowRes_PixelSpacing( sel_y) / 2) + lowRes_PixelSpacing( sel_y) * (0:lowRes_len_y); % VoxelEdge(i) is the upper boundary of the voxel i and VoxelEdge(i+1) is the lower boundary because of direction the slice location vector
    MapVectors.vox_map_y = zeros( 1, hiRes_len_y);
    for i = 1:lowRes_len_y,
        MapVectors.vox_map_y( ( hiRes_center_y >= lowRes_VoxelEdge_y( i)) & ( hiRes_center_y < lowRes_VoxelEdge_y(i+1))) = i; % set all hi-res voxels within the bounderies to the ID of the low-res image
    end

    MapVectors.hiRes_PixelSpacing=hiRes_PixelSpacing;
    MapVectors.lowRes_PixelSpacing=lowRes_PixelSpacing;

    MapVectors.hiRes_size = [ hiRes_len_y hiRes_len_x hiRes_len_z];
    MapVectors.lowRes_size = [ lowRes_len_y lowRes_len_x lowRes_len_z];

    MapVectors.hiRes_offset = [ hiRes_origin_x, hiRes_origin_y, hiRes_origin_z];
    MapVectors.lowRes_offset = [ lowRes_origin_x, lowRes_origin_y, lowRes_origin_z];
end

function lowRes_imdata = CTPET_ApplyMap(img,mapping)
% This function is a CT_Processing2 version of OV2_ConvRes

% Summary of modifications:
%  - only the case with two inputs and a output is used
%  - the OV2_images struct is not used here
%  - the initial pixel depth is skkiped (!!!)

    % ____MAIN____
    hiRes_imdata = img;

    % -- map voxels high res -> low res --
    % - z direction -
    lowRes_imdata = zeros( [mapping.hiRes_size(1:2) mapping.lowRes_size(3)]); % reduce one dimension at the time
    if abs(mapping.hiRes_SliceSpacing) < abs(mapping.lowRes_SliceSpacing), % default mapping
        for k = 1:mapping.lowRes_size(3),
            sel = mapping.vox_map_z == k;
            N = sum( sel);
            if N > 0,
                lowRes_imdata(:,:,k) = sum( hiRes_imdata(:,:, sel), 3) / sum( sel); end
        end
    else
        lowRes_imdata( :, :, ~isnan( mapping.vox_map_z)) = hiRes_imdata(:,:, mapping.vox_map_z( ~isnan( mapping.vox_map_z)));
    end

    % - x direction -
    hiRes_imdata = lowRes_imdata;
    lowRes_imdata = zeros( [mapping.hiRes_size(1) mapping.lowRes_size(2:3)]); % reduce one dimension at the time
    for k = 1:mapping.lowRes_size(2),
        sel = mapping.vox_map_x == k;
        N = sum( sel);
        if N > 0,
            lowRes_imdata(:,k,:) = sum( hiRes_imdata( :, sel, :), 2) / N; end
    end

    % - y direction -
    hiRes_imdata = lowRes_imdata;
    lowRes_imdata = zeros( [mapping.lowRes_size(1:3)]); % reduce one dimension at the time
    for k = 1:mapping.lowRes_size(1),
        sel = mapping.vox_map_y == k;
        N = sum( sel);
        if N > 0,
            lowRes_imdata(k,:,:) = sum( hiRes_imdata( sel, :, :), 1) / N; end
    end

    if isa( img, 'logical')
        lowRes_imdata = lowRes_imdata >= 0.5;
    end
end

function seconds = str2sec(str)
    % convert sting dates to seconds
    
    seconds = str2double(str(1:2))*3600 + ... hours
        str2double(str(2:4))*60 + ... minutes
        str2double(str(5:6)) + ... seconds
        str2double(['0' str(7:end)]); % fraction of seconds
end
%%%%%%%%%%%%%%%%% END USEFULL FUNTIONS %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%














%%%%%%%%% External Functions %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function voxelvolume = dicom_read_volume(info)
% function for reading volume of Dicom files
%
% volume = dicom_read_volume(file-header)
%
% examples:
% 1: info = dicom_read_header()
%    V = dicom_read_volume(info);
%    imshow(squeeze(V(:,:,round(end/2))),[]);
%
% 2: V = dicom_read_volume('volume.dcm');

voxelvolume=dicomread(info.Filenames{1});
nf=length(info.Filenames);
if(nf>1)
    % Initialize voxelvolume
    voxelvolume=zeros(info.Dimensions,class(voxelvolume));
    % Convert dicom images to voxel volume

    for i=1:nf
        I=dicomread(info.Filenames{i});
        if((size(I,3)*size(I,4))>1)
            voxelvolume=I; break;
        else
            voxelvolume(:,:,i)=I;
        end
    end
end

end

function handles = calculateWindowWidthAndCenter(handles,...
    windowWidth, windowCenter)

if nargin == 1
    %Get the Window Width and Window Center Information
    windowWidth = handles.data.metadata.WindowWidth(1);
    windowCenter = handles.data.metadata.WindowCenter(1);

    handles.data.minValueDicomImage = min(double(handles.data.dicomImage(:)));
  end

%Calculate the Window Width and Information parameters
handles.data.displayLow = max(windowCenter - 0.5 * windowWidth, handles.data.minValueDicomImage);
handles.data.displayHigh = max(windowCenter + 0.5 * windowWidth, handles.data.minValueDicomImage);

end

function configureSliders(handles)
dicomImage = handles.data.dicomImage;

windowWidth = handles.data.metadata.WindowWidth(1);
windowCenter = handles.data.metadata.WindowCenter(1);

%Width Configuration
ctRange = double(max(dicomImage(:)) - min(dicomImage(:)));
set(handles.gui.windowWidthSlider, 'Max', ctRange);
set(handles.gui.windowWidthSlider, 'Min', 1);
set(handles.gui.windowWidthSlider, 'Value', windowWidth);
set(handles.gui.windowWidthSlider, 'sliderstep', [5 10] / ctRange); %%% -- INFO -- change in steps of one is realy boring. Changed to 5 when using the arrows and 10 when clicking the bar
set(handles.gui.windowWidthText, 'String',sprintf('%.2f', windowWidth));

%Center Configuration
set(handles.gui.windowCenterSlider, 'Max', max(dicomImage(:)));
set(handles.gui.windowCenterSlider, 'Min', min(dicomImage(:)));
set(handles.gui.windowCenterSlider, 'Value', windowCenter);
set(handles.gui.windowCenterSlider, 'sliderstep', [5 10] / ctRange); %%% -- INFO -- change in steps of one is realy boring. Changed to 5 when using the arrows and 10 when clicking the bar
set(handles.gui.windowCenterText, 'String',sprintf('%.2f', windowCenter));
end


function info=dicom_read_header(filename)
% function for reading header of Dicom volume file
%
% info = dicom_read_header(filename);
%
% examples:
% 1,  info=dicom_read_header()
% 2,  info=dicom_read_header('volume.dcm');

% Check if function is called with folder name

% Read directory for Dicom File Series
datasets=dicom_folder_info(filename,false);
if(isempty(datasets))
    datasets=dicom_folder_info(filename,true);
end

if(length(datasets)>1)
    c=cell(1,length(datasets));
    for i=1:length(datasets)
        c{i}=datasets(i).Filenames{1};
    end
    id=choose_from_list(c,'Select a Dicom Dataset');
    datasets=datasets(id);
end

info=datasets.DicomInfo;
info.Filenames=datasets.Filenames;
info.PixelDimensions=datasets.Scales;
info.Dimensions=datasets.Sizes;
end

function datasets=dicom_folder_info(link,subfolders)
% Function DICOM_FOLDER_INFO gives information about all Dicom files
% in a certain folder (and subfolders), or of a certain dataset
%
% datasets=dicom_folder_info(link,subfolders)
%
% inputs,
%   link : A link to a folder like "C:\temp" or a link to the first
%           file of a dicom volume "C:\temp\01.dcm"
%   subfolders : Boolean if true (default) also look in sub-folders for
%           dicom files
%
% ouputs,
%   datasets : A struct with information about all dicom datasets in a
%            folder or of the selected dicom-dataset.
%              (Filenames are already sorted by InstanceNumber)
%
%
% Example output:
%  datasets=dicom_folder_info('D:\MedicalVolumeData',true);
%
%  datasets =  1x7 struct array with fields
%
%  datasets(1) =
%             Filenames: {24x1 cell}
%                 Sizes: [512 512 24]
%                Scales: [0.3320 0.3320 4.4992]
%             DicomInfo: [1x1 struct]
%     SeriesInstanceUID: '1.2.840.113619.2.176.2025'
%     SeriesDescription: 'AX.  FSE PD'
%            SeriesDate: '20070101'
%            SeriesTime: '120000.000000'
%              Modality: 'MR'
%
%  datasets(1).Filenames =
%   'D:\MedicalVolumeData\IM-0001-0001.dcm'
%   'D:\MedicalVolumeData\IM-0001-0002.dcm'
%   'D:\MedicalVolumeData\IM-0001-0003.dcm'
%
% Function is written by D.Kroon University of Twente (June 2010)

% If no Folder given, give folder selection dialog
if(nargin<1), link =  uigetdir(); end

% If no subfolders option defined set it to true
if(nargin<2), subfolders=true; end

% Check if the input is a file or a folder
if(isdir(link))
    dirname=link; filehash=[];
else
    dirname = fileparts(link);
    info=dicominfo(link);
    SeriesInstanceUID=0;
    if(isfield(info,'SeriesInstanceUID')), SeriesInstanceUID=info.SeriesInstanceUID; end
    filehash=string2hash([dirname SeriesInstanceUID]);
    subfolders=false;
end

% Make a structure to store all files and folders
dicomfilelist.Filename=cell(1,100000);
dicomfilelist.InstanceNumber=zeros(1,100000);
dicomfilelist.ImagePositionPatient=zeros(100000,3);
dicomfilelist.hash=zeros(1,100000);
nfiles=0;

% Get all dicomfiles in the current folder (and sub-folders)
[dicomfilelist,nfiles]=getdicomfilelist(dirname,dicomfilelist,nfiles,filehash,subfolders);
if(nfiles==0), datasets=[]; return; end

% Sort all dicom files based on a hash from dicom-series number and folder name
datasets=sortdicomfilelist(dicomfilelist,nfiles);

% Add Dicom information like scaling and size
datasets=AddDicomInformation(datasets);
end
function datasets=AddDicomInformation(datasets)
for i=1:length(datasets)
    Scales=[0 0 0];
    Sizes=[0 0 0];
    SeriesInstanceUID=0;
    SeriesDescription='';
    SeriesDate='';
    SeriesTime='';
    Modality='';
    info=dicominfo(datasets(i).Filenames{1});
    nf=length(datasets(i).Filenames);

    if(isfield(info,'SpacingBetweenSlices')), Scales(3)=info.SpacingBetweenSlices; end
    if(isfield(info,'PixelSpacing')), Scales(1:2)=info.PixelSpacing(1:2); end
    if(isfield(info,'ImagerPixelSpacing ')), Scales(1:2)=info.PixelSpacing(1:2); end
    if(isfield(info,'Rows')), Sizes(1)=info.Rows; end
    if(isfield(info,'Columns')), Sizes(2)=info.Columns; end
    if(isfield(info,'NumberOfFrames')), Sizes(3)=info.NumberOfFrames; end
    if(isfield(info,'SeriesInstanceUID')), SeriesInstanceUID=info.SeriesInstanceUID; end
    if(isfield(info,'SeriesDescription')), SeriesDescription=info.SeriesDescription; end
    if(isfield(info,'SeriesDate')),SeriesDate=info.SeriesDate; end
    if(isfield(info,'SeriesTime')),SeriesTime=info.SeriesTime; end
    if(isfield(info,'Modality')), Modality=info. Modality; end
    if(nf>1), Sizes(3)=nf; end
    if(nf>1)
        info1=dicominfo(datasets(i).Filenames{2});
        if(isfield(info1,'ImagePositionPatient'))
            dis=abs(info1.ImagePositionPatient(3)-info.ImagePositionPatient(3));
            if(dis>0), Scales(3)=dis; end
        end
    end
    datasets(i).Sizes=Sizes;
    datasets(i).Scales=Scales;
    datasets(i).DicomInfo=info;
    datasets(i).SeriesInstanceUID=SeriesInstanceUID;
    datasets(i).SeriesDescription=SeriesDescription;
    datasets(i).SeriesDate=SeriesDate;
    datasets(i).SeriesTime=SeriesTime;
    datasets(i).Modality= Modality;
end
end
function datasets=sortdicomfilelist(dicomfilelist,nfiles)
datasetids=unique(dicomfilelist.hash(1:nfiles));
ndatasets=length(datasetids);
for i=1:ndatasets
    h=find(dicomfilelist.hash(1:nfiles)==datasetids(i));
    InstanceNumbers=dicomfilelist.InstanceNumber(h);
    ImagePositionPatient=dicomfilelist.ImagePositionPatient(h,:);
    if(length(unique(InstanceNumbers))==length(InstanceNumbers))
        [temp ind]=sort(InstanceNumbers);
    else
        [temp ind]=sort(ImagePositionPatient(:,3));
    end
    h=h(ind);
    datasets(i).Filenames=cell(length(h),1);
    for j=1:length(h)
        datasets(i).Filenames{j}=dicomfilelist.Filename{h(j)};
    end
end
end

function [dicomfilelist nfiles]=getdicomfilelist(dirname,dicomfilelist,nfiles,filehash,subfolders)
% dirn=fullfile(dirname);
dirn=dirname;
if(~isempty(dirn)), filelist = dir(dirn); else filelist = dir; end

for i=1:length(filelist)
    fullfilename=fullfile(dirname,filelist(i).name);
    if((filelist(i).isdir))
        if((filelist(i).name(1)~='.')&&(subfolders))
            [dicomfilelist nfiles]=getdicomfilelist(fullfilename ,dicomfilelist,nfiles,filehash,subfolders);
        end
    else
        if(file_is_dicom(fullfilename))
            try info=dicominfo(fullfilename); catch me, info=[]; end
            if(~isempty(info))
                InstanceNumber=0;
                ImagePositionPatient=[0 0 0];
                SeriesInstanceUID=0;
                Filename=info.Filename;
                if(isfield(info,'InstanceNumber')), InstanceNumber=info.InstanceNumber; end
                if(isfield(info,'ImagePositionPatient')),ImagePositionPatient=info.ImagePositionPatient; end

                if(isfield(info,'SeriesInstanceUID')), SeriesInstanceUID=info.SeriesInstanceUID; end
                hash=string2hash([dirname SeriesInstanceUID]);
                if(isempty(filehash)||(filehash==hash))
                    nfiles=nfiles+1;
                    dicomfilelist.Filename{ nfiles}=Filename;
                    dicomfilelist.InstanceNumber( nfiles)=InstanceNumber;
                    dicomfilelist.ImagePositionPatient(nfiles,:)=ImagePositionPatient(:)';
                    dicomfilelist.hash( nfiles)=hash;
                end
            end
        end
    end
end
end

function isdicom=file_is_dicom(filename)
isdicom=false;
try
    fid = fopen(filename, 'r');
    status=fseek(fid,128,-1);
    if(status==0)
        tag = fread(fid, 4, 'uint8=>char')';
        isdicom=strcmpi(tag,'DICM');
    end
    fclose(fid);
catch me
end
end

function hash=string2hash(str,type)
% This function generates a hash value from a text string
%
% hash=string2hash(str,type);
%
% inputs,
%   str : The text string, or array with text strings.
% outputs,
%   hash : The hash value, integer value between 0 and 2^32-1
%   type : Type of has 'djb2' (default) or 'sdbm'
%
% From c-code on : http://www.cse.yorku.ca/~oz/hash.html
%
% djb2
%  this algorithm was first reported by dan bernstein many years ago
%  in comp.lang.c
%
% sdbm
%  this algorithm was created for sdbm (a public-domain reimplementation of
%  ndbm) database library. it was found to do well in scrambling bits,
%  causing better distribution of the keys and fewer splits. it also happens
%  to be a good general hashing function with good distribution.
%
% example,
%
%  hash=string2hash('hello world');
%  disp(hash);
%
% Function is written by D.Kroon University of Twente (June 2010)


% From string to double array
str=double(str);
if(nargin<2), type='djb2'; end
switch(type)
    case 'djb2'
        hash = 5381*ones(size(str,1),1);
        for i=1:size(str,2),
            hash = mod(hash * 33 + str(:,i), 2^32-1);
        end
    case 'sdbm'
        hash = zeros(size(str,1),1);
        for i=1:size(str,2),
            hash = mod(hash * 65599 + str(:,i), 2^32-1);
        end
    otherwise
        error('string_hash:inputs','unknown type');
end
end

function [id,name] = choose_from_list(varargin)
%
% example :
%
% c{1}='apple'
% c{2}='orange'
% c{3}='berries'
% [id,name]=choose_from_list(c,'Select a Fruit');
%

if(strcmp(varargin{1},'press'))
   handles=guihandles;
   id=get(handles.listbox1,'Value');
   setMyData(id);
   uiresume
   return
end

% listbox1 Position [12, 36 , 319, 226]
% pushbutton [16,12,69,22]
% figure position 520 528 348 273
handles.figure1=figure;
c=varargin{1};
set(handles.figure1,'tag','figure1','Position',[520 528 348 273],'MenuBar','none','name',varargin{2});
handles.listbox1=uicontrol('tag','listbox1','Style','listbox','Position',[12 36 319 226],'String', c);
handles.pushbutton1=uicontrol('tag','pushbutton1','Style','pushbutton','Position',[16 12 69 22],'String','Select','Callback','choose_from_list(''press'');');
uiwait(handles.figure1);
id=getMyData();
name=c{id};
close(handles.figure1);
end
function setMyData(data)
% Store data struct in figure
setappdata(gcf,'data3d',data);
end
function data=getMyData()
% Get data struct stored in figure
data=getappdata(gcf,'data3d');
end

function [X] = nrrd_read(filename)
% Modified from the below function (only X is outputed and cleaner is not used)
%NRRDREAD  Import NRRD imagery and metadata.
%   [X, META] = NRRDREAD(FILENAME) reads the image volume and associated
%   metadata from the NRRD-format file specified by FILENAME.
%
%   Current limitations/caveats:
%   * "Block" datatype is not supported.
%   * Only tested with "gzip" and "raw" file encodings.
%   * Very limited testing on actual files.
%   * I only spent a couple minutes reading the NRRD spec.
%
%   See the format specification online:
%   http://teem.sourceforge.net/nrrd/format.html

% Copyright 2012 The MathWorks, Inc.

try
    % Open file.
    fid = fopen(filename, 'rb');
    assert(fid > 0, 'Could not open file.');
%     cleaner = onCleanup(@() fclose(fid));

    % Magic line.
    theLine = fgetl(fid);
    assert(numel(theLine) >= 4, 'Bad signature in file.')
    assert(isequal(theLine(1:4), 'NRRD'), 'Bad signature in file.')

    % The general format of a NRRD file (with attached header) is:
    % 
    %     NRRD000X
    %     <field>: <desc>
    %     <field>: <desc>
    %     # <comment>
    %     ...
    %     <field>: <desc>
    %     <key>:=<value>
    %     <key>:=<value>
    %     <key>:=<value>
    %     # <comment>
    % 
    %     <data><data><data><data><data><data>...

    meta = struct([]);

    % Parse the file a line at a time.
    while (true)

      theLine = fgetl(fid);

      if (isempty(theLine) || feof(fid))
        % End of the header.
        break;
      end

      if (isequal(theLine(1), '#'))
          % Comment line.
          continue;
      end

      % "fieldname:= value" or "fieldname: value" or "fieldname:value"
      parsedLine = regexp(theLine, ':=?\s*', 'split','once');

      assert(numel(parsedLine) == 2, 'Parsing error')

      field = lower(parsedLine{1});
      value = parsedLine{2};

      field(isspace(field)) = '';
      meta(1).(field) = value;

    end

    datatype = getDatatype(meta.type);

    % Get the size of the data.
    assert(isfield(meta, 'sizes') && ...
           isfield(meta, 'dimension') && ...
           isfield(meta, 'encoding') && ...
           isfield(meta, 'endian'), ...
           'Missing required metadata fields.')

    dims = sscanf(meta.sizes, '%d');
    ndims = sscanf(meta.dimension, '%d');
    assert(numel(dims) == ndims);

    data = readData(fid, meta, datatype);
    data = adjustEndian(data, meta);

    % Reshape and get into MATLAB's order.
    X = reshape(data, dims');
    X = permute(X, [2 1 3]);
    
    fclose(fid);
catch err
    fclose(fid);
    rethrow(err)
end
end

function datatype = getDatatype(metaType)

% Determine the datatype
switch (metaType)
 case {'signed char', 'int8', 'int8_t'}
  datatype = 'int8';
  
 case {'uchar', 'unsigned char', 'uint8', 'uint8_t'}
  datatype = 'uint8';

 case {'short', 'short int', 'signed short', 'signed short int', ...
       'int16', 'int16_t'}
  datatype = 'int16';
  
 case {'ushort', 'unsigned short', 'unsigned short int', 'uint16', ...
       'uint16_t'}
  datatype = 'uint16';
  
 case {'int', 'signed int', 'int32', 'int32_t'}
  datatype = 'int32';
  
 case {'uint', 'unsigned int', 'uint32', 'uint32_t'}
  datatype = 'uint32';
  
 case {'longlong', 'long long', 'long long int', 'signed long long', ...
       'signed long long int', 'int64', 'int64_t'}
  datatype = 'int64';
  
 case {'ulonglong', 'unsigned long long', 'unsigned long long int', ...
       'uint64', 'uint64_t'}
  datatype = 'uint64';
  
 case {'float'}
  datatype = 'single';
  
 case {'double'}
  datatype = 'double';
  
 otherwise
  assert(false, 'Unknown datatype')
end
end


function data = readData(fidIn, meta, datatype)

switch (meta.encoding)
 case {'raw'}
  
  data = fread(fidIn, inf, [datatype '=>' datatype]);
  
 case {'gzip', 'gz'}

  tmpBase = tempname();
  tmpFile = [tmpBase '.gz'];
  fidTmp = fopen(tmpFile, 'wb');
  assert(fidTmp > 3, 'Could not open temporary file for GZIP decompression')
  
  tmp = fread(fidIn, inf, 'uint8=>uint8');
  fwrite(fidTmp, tmp, 'uint8');
  fclose(fidTmp);
  
  gunzip(tmpFile)
  
  fidTmp = fopen(tmpBase, 'rb');
%   cleaner = onCleanup(@() fclose(fidTmp));
  
  meta.encoding = 'raw';
  data = readData(fidTmp, meta, datatype);
  fclose(fidTmp)
  
 case {'txt', 'text', 'ascii'}
  
  data = fscanf(fidIn, '%f');
  data = cast(data, datatype);
  
 otherwise
  assert(false, 'Unsupported encoding')
end
end


function data = adjustEndian(data, meta)

[void,void,endian] = computer();

needToSwap = (isequal(endian, 'B') && isequal(lower(meta.endian), 'little')) || ...
             (isequal(endian, 'L') && isequal(lower(meta.endian), 'big'));
         
if (needToSwap)
    data = swapbytes(data);
end
end
