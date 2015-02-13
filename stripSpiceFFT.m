%fin='H:\data\ltspice\llc\RE_emi\HB_lev2_FS_ctr_dmfilt.txt'; % name of file where raw FFT data is stored from Spice
fin='H:\data\ltspice\llc\LLC_generalcct2.txt'; % name of file where raw FFT data is stored from Spice
%fout='H:\data\ltspice\llc\RE_emi\HB_lev2_FS_ctr_dmfilt_stripped.txt'; % name of file where stripped data should be stored
fout='H:\data\ltspice\llc\LLC_generalcct2_stripped.txt'; % name of file where stripped data should be stored

fin=fopen(fin);
fout=fopen(fout,'w');

while ~feof(fin)
    s=fgetl(fin);
    s=regexprep(s,'\t',' ');
    s=strrep(s,'(','');
    s=strrep(s,')','');
    s=strrep(s,'dB,',' ');
    s=strrep(s,'°','');
    fprintf(fout,'%s\n',s);
end
fclose(fin);
fclose(fout);
