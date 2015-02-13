function APEC_print(fdata)

path = 'L:\Matlab\APEC14\MEAS_BOARD_2\'
Data = processDicksonBoardII(fdata,path);

optBig.FontSize     = 12;
optBig.LegendSize   = 12;
optBig.LineWidth    = 1;
optBig.LabelSize    = 12;
optBig.sMarkerSize   = 6;
optBig.xMarkerSize   = 8;
optBig.bx           = [0.1 0.1];
optBig.by           = [0.1 0.0];
optBig.mx           = 0.1;
optBig.my           = 0.1;
optBig.sze          = [10 20];
optBig.Nticks       = 10;
optBig.Rtick        = 1;
optBig.LabelHigh    = 1.05;
optBig.UnitAxis     = '' 
optBig.mfragHeader  = 'C:\matlabfrag\mfragPDFheaderIEEE.tex';
optBig.LablePostL   = [-.027 1.0535]
optBig.LablePostR   = [ 0.901 1.0535]
% optBig.LablePostL   = [0.1 0.96];
% optBig.LablePostR   = [0.9 1.08];
optBig.XLabelSize    = 12;
plotRscc(Data,0,[],optBig);   

end