%% standard start-up
clear all;
%close all;

set(0,'DefaultAxesFontSize',16);

%% simulation parameters
margin=3; % noise margin in dB
%fname='H:\data\ltspice\llc\RE_emi\HB_lev2_FS_ctr_dmfilt_stripped.txt'; % name of text file containing stripped FFT data
fname='H:\data\ltspice\llc\LLC_generalcct2_stripped.txt'; % name of text file containing stripped FFT data
Cmax=56e-9; % maximum desireable X-capacitor size (F)
Lmax=1e-3; % maximum desireable filter inductor size (H)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% No changes should be required below this line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% load CISPR-15 data
frange=[0.009 0.05 0.05 0.15 0.15 0.5 0.5 5 5 30];
quasipeak=[110 110 90 80 66 56 56 56 60 60];
average=[NaN NaN NaN NaN 56 46 46 46 50 50];

%% load simulation data
d=importdata(fname,' ');

%% compare unfiltered data to specification, and see if filtering is needed
spec=zeros(size(d.data(:,1)));
spec(d.data(:,1)<9e3)=inf;
spec(d.data(:,1)>=9e3 & d.data(:,1)<50e3)=110;
ndex=find(d.data(:,1)>=50e3 & d.data(:,1)<150e3);
spec(ndex)=(80-90)/log10(150e3/50e3)*log10(d.data(ndex,1)/50e3)+90;
ndex=find(d.data(:,1)>=150e3 & d.data(:,1)<500e3);
spec(ndex)=(56-66)/log10(500e3/150e3)*log10(d.data(ndex,1)/150e3)+66;
spec(d.data(:,1)>=500e3 & d.data(:,1)<=5e6)=56;
spec(d.data(:,1)>=5e6 & d.data(:,1)<=30e6)=60;
spec(d.data(:,1)>30e6)=inf;
if any(d.data(:,2)+margin>spec)
    filt_reqd=true;
    ndex=find(d.data(:,2)+margin-spec==max(d.data(:,2)+margin-spec));
    omegac=min(2*pi*d.data(ndex,1).*10.^((spec(ndex)-d.data(ndex,2)-margin)/40));
else
    filt_reqd=false;
end

%% calculate filter response and make plots
if filt_reqd
    incr=omegac/1000;
    omega=2*pi*d.data(:,1);
    Rlvec=(1i*omega*100e-6+10)*100./(1i*omega*100e-6+110);
    
    % calculate filter values assuming some capacitor size
    done2=false;
    omegac2=omegac+incr;
    while ~done2
        omegac2=omegac2-incr;
        if omegac2>0
            L2=1/(omegac2^2*Cmax);
            V2=d.data(:,2)+20*log10(abs(omegac2^2./(-omega.^2+1i*omega./(Rlvec*Cmax)+omegac2^2)));
            if all(V2+margin<spec)
                done2=true;
                figure(1);
                semilogx(frange,quasipeak,'k-',d.data(:,1)*1e-6,d.data(:,2),'r-',d.data(:,1)*1e-6,V2,'g-');
                axis([1e-3 1e2 -50 150]);
                xlabel('f (MHz)');
                ylabel('V_{mains} (dB(\muV))');
                legend('Specification','Unfiltered','Filtered','Location','Best');
                grid on;
                hold on;
                semilogx([omegac2 omegac2]*1e-6/2/pi,[-50 150],'b--');
                title('Maximal C_{filt}');
                hold off;
                fprintf(1,'Solution with maximal C is: C=%gF, L=%gH\n',Cmax,L2);
            end
        else
            done2=true;
            disp('Could not find revised maximal-C solution that passes.');
        end
    end
    
    % calculate filter values assuming some inductor size
    done3=false;
    omegac3=omegac+incr;
    while ~done3
        omegac3=omegac3-incr;
        if omegac3>0
            C3=1/(omegac3^2*Lmax);
            V3=d.data(:,2)+20*log10(abs(omegac3^2./(-omega.^2+omegac3^2.*(1i*omega*Lmax./Rlvec+1))));
            if all(V3+margin<spec)
                done3=true;
                figure(2);
                semilogx(frange,quasipeak,'k-',d.data(:,1)*1e-6,d.data(:,2),'r-',d.data(:,1)*1e-6,V3,'g-');
                axis([1e-3 1e2 -50 150]);
                xlabel('f (MHz)');
                ylabel('V_{mains} (dB(\muV))');
                legend('Specification','Unfiltered','Filtered','Location','Best');
                grid on;
                hold on;
                semilogx([omegac3 omegac3]*1e-6/2/pi,[-50 150],'b--');
                title('Maximal L_{filt}');
                hold off;
                fprintf(1,'Solution with maximal L is: C=%gF, L=%gH\n',C3,Lmax);
            end
        else
            done3=true;
            disp('Could not find revised maximal-C solution that passes.');
        end
    end
else
    figure(1);
    semilogx(frange,quasipeak,'k-',d.data(:,1)*1e-6,d.data(:,2),'g-');
    axis([1e-3 1e2 -50 150]);
    xlabel('f (MHz)');
    ylabel('V_{mains} (dB(\muV))');
    legend('Specification','Unfiltered','Location','Best');
    figure(2);
    semilogx(frange,quasipeak,'k-',d.data(:,1)*1e-6,d.data(:,2),'g-');
    axis([1e-3 1e2 -50 150]);
    xlabel('f (MHz)');
    ylabel('V_{mains} (dB(\muV))');
    legend('Specification','Unfiltered','Location','Best');
    disp('No differential EMI filter is required.');
end