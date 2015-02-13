% DXF File Generation Package for MATLAB
% (Compatible with MATLAB 5.0, full and student editions)
%
% James Trevelyan, August 2000
%
% Call DXF_start to commence DXF output file and use the file pointer returned
% when calling any other DXF function. Use DXF_end to finish the DXF file.  Type
% 'help <function name>' (in MATLAB) for information on functions.  Type 
% 'help dxf' to see this file.
%
% Graphics entities can be created in any order and the direction of each (i.e. which
% end is the start point) is immaterial.  However, careful programming is needed to 
% ensure that start and end points of connected entities excatly coincide, particularly
% for arcs and partial ellipses.  The normal accuracy of calculation in MATLAB is sufficient.
%
% DXF_start   -  open and start DXF file
% DXF_end     -  close DXF file
% DXF_line    -  straight line
% DXF_poly    -  polyline (series of straight lines)
% DXF_text    -  text
% DXF_arc     -  arc
% DXF_circle  -  circle
% DXF_ellipse -  ellipse (or part ellipse)
% DXF_spline  -  B-spline curve (see function makespline supplied with demo)
%
% Note:  These functions use the file 'DXFhead.dxf' and 'DXFtail.dxf'.  
%        Therefore, these files, or copies, must be in the working
%        directory.  These files were obtained by creating a non-dimensioned simple 
%        profile with a CAD program (actually SolidEdge) and saving it as a DXF file.
%        'DXFhead.dxf' is all sections up to the 'entities' section containing the 
%        graphics objects.  'DXFtail.dxf' is the tail of the file after the entities.
%
%        DXF_lint.m, DXF_pinc.m are internal functions
%        unitscale, dxfhandle are internal global variables
%
%  ========================================================================================
%
% Reading DXF File with SolidEdge
%
% When reading the DXF file into SolidEdge for the first time, it is essential to establish
% a SEACAD.INI file which stores default colours and line styles etc.  The most important
% setting is the input units (inch or mm) which determine scaling.  To do this, select
% the 'Options' button on the file open dialogue, and follow instructions.  You should
% create a new SEACAD.INI file in the working directory at the end of the process.  One
% has been supplied with this package.
%
% Once the file has been selected, you will be asked to select a template.  Use NORMAL.DFT
% as planar DXF files only make sense in the drafting environment.
%
% Any number of profiles can be selected in the draft environment and copied and pasted into
% a profile construction window in the part environment.  However, it is important to paste 
% these profiles into a 'sketch' profile.  The profiles cannot be used directly for a
% protrusion, for example.  If this is done, there may be an error: "highlighted profile
% elements not connected".
%
% If using this package to create several adjacent parts, it is best to create each part
% with a separate DXF file, but retain in each file lines and circles to locate key points
% for the other parts, relative to each other.  If interlocking parts are drawn with the
% one DXF file, solid making operations in SolidEdge can fail.
%
%  ========================================================================================
%
%  Demonstration program.  This program draws a plastic clock spring using circles, arcs and
%  a logarithmic spiral function.  This function shows how to create a B-spline curve to
%  produce a smooth approximation for any smooth mathematical curve.  See web page for
%  more details:  http://www.mech.uwa.edu.au/jpt/matlab-dxf/
%
%  Note that the demonstration program also creates a plain text data file containing the 
%  coordinates of points along the splines, arcs, circles etc.
%
%  spring1.m  -     demonstration program to generate a clock spring
%  arc.m, circle.m  construct arcs and circles
%  reverse.m -      reverses sequence of vector (back to front)
%  spiral.m -       demonstrates use of 'makespline' function to construct an arithmetic
%                   spiral curve.
%  makespline.m -   function for approximating a mathematically defined
%                   profile presented as a series of points along the profile
%                   using a B-Spline curve - creates SPLINE entry in DXF file. 
%  makearcs.m -     function for approximating a mathematically defined 
%                   profile presented as a series of points along the profile
%                   using a number of circular arcs to a given precision. Useful
%                   in cases where the target NC machine or post-processor does
%                   not accept spline curves.
%  endslope.m -     find approximate tangent at ends of curve
%  dist.m -         distance between two points
%  vangle.m -       vector angle function (radians)
%  fitarc.m -       fit arc to three points (radians)
%
%  global variables shared by these functions:
%
%  fid:             file handle for output for data points representing profile
%  fidd:            DXF file handle
%  linecolour, 
%  linetype:        settings for line colour and style
%  ofsx,ofsy:       offset value for all output
%  dalpha, drad:    angular error and radial error tolerance for profiles
%  ifspline:        0 if no splines allowed
%  ========================================================================================
%
%  Other files supplied:
%
%
%  al_u04_c.htm: reference info on DXF files
%  al_u05_c.htm: reference info on DXF files
%  dxf_toc.htm:  reference info on DXF files (from the web)
%
%  spring.par:     solid edge part file made from spring.dxf
%  spring.jpg:     picture of solid model
%  Seacad.ini:     AutoCAD translation configuration file for SolidEdge
%  gear-assy.jpg:  picture of involute gears also generated with DXF package
%                  (code available on special request)
%