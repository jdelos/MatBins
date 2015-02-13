function [Y,varargout] = dftjs(x,t,fo,N,varargin)
%
% version 0.1 (05-12-2012)
% version 0.2 (14-01-2013) removed parfor, since it makes only very little 
%						   difference in speed.
% version 0.3 (13-02-2013) minor changes to help and added a function to
%						   to remove non-unique time instances. And a check
%						   for non monotonically increasing time.
% version 0.4 (14-06-2013) Added calculation of THD and HD, and auto
%						   trimming of data.
%
%          [Y,f,THD,HD,x,t] = DFTJS(x,t,fo,N,'zoh','trim') 
%          [Y,f,...]        = DFTJS(x,t,fo,N,...) 
%
% Calculates the Fourier coefficients of a signal with variable sampling
% intervals. 
%
% x(t) ---o Y(f)
%
% A piecewise linear approximation is used for continuous signals. 
% Compared to a fast Fourier transformation (FFT) this approach also
% works for signals that are sampled with a variable sample-rate. 
% The accuracy of this approximation highly depends on the simulation 
% step-size, A smaller simulation step size yields more accurate 
% results.
%
% OUTPUT:
% Y		: Data, complex vector, which aligns with f. 
% f		: Frequency [Hz], vector with frequency data.
% THD	: Total Harmonic Distortion, sqrt( sum(abs(Y(N>1).^2)) ) / Y(N==1)
% HD	: Harmonic Distortion, sqrt( sum(abs(Y(N>1).^2)) ) 
% x		: trimmed x data
% t		: trimmed t data
%
%
% INPUT:
% x  : Data, a vector with data-points which align with t. 
% t  : Time [s], a vector with unique increasing time points 
%	   (may be variable step-size).
% fo : 1st harmonic [Hz].
% N  : Harmonics, a vector (integers) with harmonics which are calculated.
%
% OPTIONAL:
% 'zoh'  : if set zero order hold is assumed, instead of time continuous.
% 'trim' : if set the data is trimmed to an interval [t(end)-1/fo t(end)]
%
% The time span (t(end)-t(1)) should be an exact multiple of 1/fo, and 
% ideally x(1) should be equal to x(end). Also care should be taken with
% the maximum step-size of the solver. When (2*max(N)*fo)^-1 is smaller 
% than maximum step-size of t the sampled data might be to coarse. 
%
% Since BLAS is used for the calculation of the individual Fourier 
% coefficients multiple cores are utilized on most machines and the speed
% of the algorithm is comparable to PLECS.
%
% calculating a DFT takes 'length(t)*length(N)' calculations, to compare an
% FFT takes length(t)*LOG2(length(t)) calculations (length(N)=length(t) for
% FFT). This algorithm is, therefore, more efficient than FFT when 
% length(N)<<length(t). When length(N) approaches length(t) FFT becomes 
% more efficient. 
%
% A Matlab function by TheBruceDickinson productions
% File written and Copyright (c) December 2012 by J.M. Schellekens
% e-mail: j.m.schellekens@tue.nl

%% Check inputs arguments
narginchk(4,6)
nargoutchk(0,6)

ZOH = 0;
if any(strcmpi(varargin,'zoh')); ZOH = 1; end

if any(strcmpi(varargin,'trim')) 
	T = find(t>=t(end)-1/fo);
	t = t(T);
	x = x(T);
end


%% FOR BACKWARD COMPATIBILITY
optargin = nargin - 4;
if optargin > 0
 if varargin{1}==1; 
    ZOH = 1;
    disp('Using ZOH instead of linear interpolation!, You are using the old input method use ''zoh'' instead');
 end
end 




%% Check data

if ~sum(size(x)==size(t)) || ~isvector(t) || ~isvector(x)
    error('x ant t should be vectors of the same size');
end

% Check time data
dift = diff(t); % dt vector
if any(dift<0)
	error('non monotonically incresing time, please check input data.')
end

% Check for non-unique time points
if any(dift==0) && ~ZOH
	disp('non-unique time points found and removed!');
	[t,It,~] = unique(t,'last');
	x = x(It);
end

% Check stepsize
if 1/(2*max(N)*fo) < max(dift)
    disp('Sampled data might be to coarse. Consider decreasing of the maximum step size.');
end

%%


%% The continuous time representation 
%   F[n] = 2/T*Int_0^T [f(t)e^(-j*w0*n*t)] dt
%
% is approximated with
%   F[n] = 2/T*Sum_m [ Int_{dT_m} [f_m(t)e^(-j*w0*n*t)] ]
% where dT_m is the time step made at simulation step step m, T is the 
% simulation time period, w0 is 2*pi*f0 and f_m(t) represents
%
% f_m(t) = a_m*t+b_m  for time continuous signals (linear interplation)
% f_m(t) = b_m        for ZOH 
%
% a[m]   = diff(x)/diff(t)
%
% b[m]   = x[m]-a[m]*t[m]
%

wo = 2*pi*fo ;
if ZOH
    a  = 0 ;
    b  = x(1:end-1);
else
    a  = diff(x)./dift ;
    %b  = x(1:end-1)-a.*t(1:end-1) ;
    b  = x(1:end-1) ; % time shifted the integral to t' = t-t(i) 
    % for better numerical stability, results in integration from 0 to
    % t(i+1)-t(i) which in turn equals time step made
    % old functions are commented and new functions are added
end


% for-loop used instead of BLAS to prevent problems with large t and N
for ii=1:length(N) 
    if N(ii) == 0
        Y(ii) = dtftavg(a,b,t,dift) ;
        f(ii) = fo*N(ii) ;
    else
        Y(ii) = dtftint(a,b,t,dift,wo,N(ii)) ;
        f(ii) = fo*N(ii) ;
    end
end


%% Determine THD and HD
THD = sqrt( sum( abs(Y(N>1)).^2 ) ) / abs(Y(N==1));
HD  = sqrt( sum( abs(Y(N>1)).^2 ) );


%% Output results
if (nargout-1)>=1; varargout{1} = f;   end
if (nargout-1)>=2; varargout{2} = THD; end
if (nargout-1)>=3; varargout{3} = HD;  end
if (nargout-1)>=4; varargout{4} = x;   end
if (nargout-1)>=5; varargout{5} = t;   end


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% ------------------------- SUB-ROUTINES FROM HERE ------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

%% Determine average 
% The integral int((a[m]*t+b[m]),t)
%
% results in
%   (a[m]*t^2)/2 + b[m]*t
% Now the integral becomes
%
%   (1/2*a[m]*t[m+1]^2 + b[m]*t[m+1] - (1/2*a[m]*t[m]^2 + b[m]*t[m] 
%
% OLD METHOD NUMERICAL POOR
% y =   ( 1/2*a.*t(2:end).^2 + b.*t(2:end) ) ...
%     - ( 1/2*a.*t(1:end-1).^2 + b.*t(1:end-1) ) ;

function y = dtftavg(a,b,t,dift)

y =   1/2*a.*dift.^2 + b.*dift ; % for better numerical stability

y = 1/(t(end)-t(1))*sum(y) ;


%% Determine fouries coefficient
%
% F[n] = 2/T*Sum_m [ Int_{dT_m} [f_m(t)e^(-j*w0*n*t)] ]
%
% The integral int((a[m]*t+b[m])*exp(-i*n*w0*t),t)
%
% results in
%   (a[m] + i*n*w0*(b[m] + a[m]*t)) * 1/(n^2*w0^2) * exp(-i*n*w0*t)
% Now the integral becomes
%
%   (a[m] + i*n*w0*(b[m] + a[m]*t[m+1])) * 1/(n^2*w0^2) * exp(-i*n*w0*t[m+1])
% - (a[m] + i*n*w0*(b[m] + a[m]*t[m])) * 1/(n^2*w0^2) * exp(-i*n*w0*t[m]) 
%
% OLD METHOD NUMERICAL POOR
% y =   (a + 1i*n*wo*(b + a.*t(2:end))) .* 1/(n^2*wo^2).*exp(-1i*n*wo*t(2:end)) ...
%     - (a + 1i*n*wo*(b + a.*t(1:end-1))) .* 1/(n^2*wo^2).*exp(-1i*n*wo*t(1:end-1)) ;

function y = dtftint(a,b,t,dift,wo,n)

y = 1/(n^2*wo^2)*exp(-1i*n*wo*t(1:end-1)).*( ...
      (a + 1i*n*wo*(b + a.*dift)).*exp(-1i*n*wo*dift) - (a + 1i*n*wo*b) ...
    ); % for better numerical stability

y = 2/(t(end)-t(1))*sum(y) ;

