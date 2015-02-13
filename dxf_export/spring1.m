% Spiral spring generator
%
%

clear all;
global fid fidd linecolour linetype ofsx ofsy dalpha drad ifspline

figure(1);
clf;
hold on;
[fid,msg] = fopen('spiral.dat','wt');
if ( fid <= 0 | length(msg)>0 )
  if ( length(msg) > 0 )
    if ( strcmp(msg(1:5),'Sorry') == 1)
	    fprintf(1,'Output file spring.dat may already be open\n',msg);
		else
	    fprintf(1,'%s\n',msg);
		end
	end
  break
end


% Start DXF file output
% We call DXF_end to finish off the file at the end of the program
%
% 'circle.m', 'arc.m', and 'spiral.m' generate the graphics objects
%

[fidd,err] = DXF_start('spring.dxf',1.00);  % Unit scale is 1.00
if(err<0)break; end
ofsx = 100;
ofsy = 100;    % x, y, offsets for DXF data
dalpha = 5;    % allowable angle error degrees
drad = 0.1;    % radial error
ifspline = 0;   % no splines allowed

% Generate spiral spring cut-out in spring disc

  toolpath=0;     % set to 1 if toolpath desired as well

  linecolour=7;   %  For DXF file only
  linetype=1;
  
% Make outer circle of disc rad 'rmax'
  fprintf(fid,'%% Outer circle-------\n');
  rmax=45;  % diameter of outer circle defining spring disc
  circle(0,0, rmax, 'b-',1); 

% Make inner circle of disc rad '10'
  fprintf(fid,'%% Inner circle-------\n');
  circle(0,0, 10, 'b-',1); 

% Make spiral cut-out
  d2r = pi/180;

  turns1 = 2.1;    % number of main turns needed
  turns2 = 0.9;    % turns to final centre disc (must be <= 1)
                   % Note: actual turns = turns1 + turns2 - 1
  
  thickness = 3.5; % material thickness required
  cutter = 0.3;    % milling cutter diameter
  min_thick = 2.0; % min material thickness at edge
  clearance = 15.5;  % clearance for spring take-up

  cencolour=7;
  DXF_line(fidd, ofsx, ofsy-50, ofsx, ofsy+50, cencolour, 3); % centre lines
  DXF_line(fidd, ofsx-50, ofsy, ofsx+50, ofsy, cencolour, 3);
  textstr=sprintf('t:%4.1f, c:%4.1f, clear: %4.1f',thickness,cutter,clearance);
  DXF_text(fidd, ofsx+50, ofsy+50, cencolour, 3, 0, textstr);    % caption upper right

  r1 = rmax - min_thick - cutter/2
  r2 = r1 - (cutter+thickness)*turns1
  r3 = r2 - clearance - (thickness+cutter)*turns2 + cutter
  r4 = r3 + cutter + thickness
  r5 = r2 + thickness + cutter
  
  if ( toolpath ~= 0)
    
  % draw cutter path in green
  fprintf(fid,'%% Cutter path-------\n');
  linecolour=6;
  linetype=4;
  
% spiral between spring turns
  spiral(0,0, r1,r2, 0,turns1*360, 'g-',1);
% spiral in to centre disc
  spiral(0,0, r2,r3, turns1*360, (turns1+turns2)*360, 'g-', 1);
% cut back round centre disc
  spiral(0,0, r3,r4, (turns1+turns2)*360, (turns1+turns2-1)*360, 'g-', 1);
% climb back out
  spiral(0,0, r4,r5, (turns1+turns2-1)*360, (turns1-1)*360, 'g-', 1);

  end  % if ( toolpath
  
  
% now groove outline remaining
  fprintf(fid,'%% Groove outline-------\n');
  linecolour=5;
  linetype=1;
  
% arc around first cut
  arc(r1,0,180,360,cutter/2,'b-',1); 
% spiral outer of cut material
  l1=spiral(0,0, r1+cutter/2,r2+cutter/2, 0,turns1*360, 'b-',1);
% spiral in to centre disc
  l2=spiral(0,0, r2+cutter/2,r3+cutter/2, turns1*360, (turns1+turns2)*360, 'b-', 1);
% arc around cutter stop
  last_ang = rem( turns1+turns2, 1)*360.0; % last angle  
  arc(r3*cos(last_ang*d2r), r3*sin(last_ang*d2r), ...
      last_ang,last_ang+180, cutter/2, 'b-',1); 
% cut back round centre disc
  spiral(0,0, r3-cutter/2,r4-cutter/2, (turns1+turns2)*360, (turns1+turns2-1)*360, ...
       'b-', 1);
% climb back out
  l2a=spiral(0,0, r4-cutter/2,r5-cutter/2, (turns1+turns2-1)*360, (turns1-1)*360, ...
       'b-', 1);
% spiral inner of cut material
  l1a=spiral(0,0, r1-cutter/2,r5-cutter/2, 0,(turns1-1)*360, 'b-',-1);

  fprintf(1,'Spring length: %5.0f mm\n', (l1a+l2a));  
  
  slength=(l1a+l2a);
  kwrap = (thickness+cutter/2)/(2*pi);
  r0=(r3+r4)/2;
  angle=(sqrt(r0^2+2*slength*kwrap)-r0)/kwrap;
  turnw=angle/(2*pi)-(turns1+turns2-1)-0.25;
  fprintf(1,'Estimated wrap limit: %4.1f turns\n',turnw);
  
axis equal;
hold off;
fclose(fid);

DXF_end(fidd);