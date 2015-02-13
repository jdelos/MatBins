% makeline.m straight line generator
%
%  line(x1, y1, x2, y2, ccode)
%
%  Draw straight line
%
function makeline(x1, y1, x2, y2, ccode)
global fid fidd linecolour linetype ofsx ofsy dalpha drad

plot([x1,x2],[y1,y2],ccode);

fprintf(fid,'%8.4f\t%8.4f\n', x1,y1);
fprintf(fid,'%8.4f\t%8.4f\n', x2,y2);

DXF_line(fidd,x1+ofsx,y1+ofsy,x2+ofsx,y2+ofsy,linecolour,linetype);

