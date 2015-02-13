function result =calc_nco(fname,varargin)

switch nargin
    case 1
        args=[];
    case 2
        args=varargin{1};
    otherwise
        error('Matlab:calc_nco:input_args','Wrong number of input arguments');
end

if isfield(args,'do_plots');
    do_plots=args.do_plots;
else
    do_plots=false;
end
if isfield(args,'hlines')
    hlines=args.hlines;
else
    hlines=1;
end
if isfield(args,'delim')
    delim=args.delim;
else
    delim=',';
end
if isfield(args,'numPts');
    numPts=args.numPts;
else
    numPts=201;
end
if isfield(args,'scalCds');
    scalCds=args.scalCds;
else
    scalCds=1;
end

d=importdata(fname,delim,hlines);

if isfield(args,'Vdsmin')
    Vdsmin=args.Vdsmin;
else
    Vdsmin=min(d.data(:,1));
end
if isfield(args,'Vdsmax')
    Vdsmax=args.Vdsmax;
else
    Vdsmax=max(d.data(:,1));
end

%% Remove dupplicate values in teh X-axis
[X, Ix] = unique(d.data(:,1));
Y = d.data(Ix,2);


Vdsinterp=linspace(Vdsmin,Vdsmax,numPts);
ndex=find(Vdsinterp>=min(X) & Vdsinterp<=max(X));
Cdsinterp(ndex)=interp1(X,Y,Vdsinterp(ndex));
ndex=find(Vdsinterp<min(X));
Cdsinterp(ndex)=Y(1);
ndex=find(Vdsinterp>max(X));
Cdsinterp(ndex)=Y(end);

Qinterp=cumtrapz(Vdsinterp,Cdsinterp);
Ec=trapz(Qinterp,Vdsinterp);
Ecstar=trapz(Vdsinterp,Qinterp);
nco=Ecstar/Ec;
CeqC=2*Ec/max(Vdsinterp)^2;
CeqHB = CeqC*(1+nco);
CeqCstar=2*Ecstar/max(Vdsinterp)^2;

if do_plots
    figure
    semilogy(d.data(:,1),d.data(:,2)*scalCds,'ro',Vdsinterp,Cdsinterp*scalCds,'k-',Vdsinterp,CeqC*ones(size(Vdsinterp)),'k--');
    xlabel('V_{DS} (V)');
    ylabel('C_{DS} (pF)');
    title(sprintf('C_{eqC}=%g',CeqC));
    hold on
    figure
    plot(Vdsinterp,Qinterp*1e-3,'k-',[Vdsmin Vdsmax],[max(Qinterp) max(Qinterp)]*1e-3,'k--');
    xlabel('V_{DS} (V)');
    ylabel('Q (nC)');
    title(sprintf('n_{co}=%g',nco));
    hold on
    
end

result.nco = nco;
result.CeqHB = CeqHB;
result.CeqC = CeqC;
result.CeqCstar = CeqCstar;

end