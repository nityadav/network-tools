function Q=trimmean(Y,p,DIM)
% TRIMMEAN calculates the trimmed mean by removing the upper and lower
% (p/2)% samples. Missing values (encoded as NaN) are also removed. 
%
%  Q = trimmean(Y,p)
%  Q = trimmean(Y,p,DIM)
%     returns the TRIMMEAN along dimension DIM of sample array Y.
%
% see also: MAD, RANGE, HISTO2, HISTO3, PERCENTILE, QUANTILE


%	$Id$
%	Copyright (C) 2009,2010 by Alois Schloegl <alois.schloegl@gmail.com>	
%       This function is part of the NaN-toolbox
%       http://pub.ist.ac.at/~schloegl/matlab/NaN/

%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program; If not, see <http://www.gnu.org/licenses/>.

if nargin<2,
        DIM = [];
end;
if isempty(DIM),
        DIM = find(size(Y)>1,1);
        if isempty(DIM), DIM = 1; end;
end;

if nargin<2,
	help trimmean
        
else
	q1 = p/200; 
	q2 = 1-p/200; 

	sz = size(Y);
	if DIM>length(sz),
	        sz = [sz,ones(1,DIM-length(sz))];
	end;

	D1 = prod(sz(1:DIM-1));
	D3 = prod(sz(DIM+1:length(sz)));
	Q  = repmat(nan,[sz(1:DIM-1),1,sz(DIM+1:length(sz))]);
	for k = 0:D1-1,
		for l = 0:D3-1,
		        xi = k + l * D1*sz(DIM) + 1 ;
			xo = k + l * D1*length(q) + 1;
		        t  = Y(xi:D1:xi+D1*sz(DIM)-1);
		        t  = sort(t(~isnan(t)));
		        N  = length(t); 
		        ix = ((1:N) < N*q2) & ((1:N) > N*q1);
		        f  = mean(t(ix));
			Q(xo:D1:xo + D1*length(q) - 1) = f;
		end;
	end;
end;

