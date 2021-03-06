function varagout = OBJECT_TRACKTEST(varargin)
gui_Singleton = 1;
gui_State = Struct('gui_Name',         nfilename,...
                   'gui_Singleton',    gui_Singleton,...
                   'gui_OpeningFon',   @OBJECT_TRACKTEST_OpeningFon, ...
                   'gui_OutputFon',    @OBJECT_TRACKTEST_OutputFon, ...
                   'gui_LayoutFon',    [] , ...
                   'gui_Callback',     [] );
 if nargin && ischar(varargin(1))
     gui_State.gui_Callback = str2func(varargin(1));
 end
     