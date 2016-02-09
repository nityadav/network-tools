function [C,N,c] = conv2nan(X,Y,arg3)
% CONV2 2-dimensional convolution 
% X and Y can contain missing values encoded with NaN.
% NaN's are skipped, NaN do not result in a NaN output. 
% The output gives NaN only if there are insufficient input data
%
% [...] = CONV2NAN(X,Y);
%      calculates 2-dim convolution between X and Y
% [C]   = CONV2NAN(X,Y);

%    This function is part of the NaN-toolbox
%    http://pub.ist.ac.at/~schloegl/matlab/NaN/

%	$Id: nanconv2.m 8223 2011-04-20 09:16:06Z schloegl $
%	Copyright (C) 2000-2005,2010 by Alois Schloegl <alois.schloegl@gmail.com>	
%       This function is part of the NaN-toolbox
%       http://pub.ist.ac.at/~schloegl/matlab/NaN/

%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program; If not, see <http://www.gnu.org/licenses/>.


if nargin~=2,
        fprintf(2,'Error CONV2NAN: incorrect number of input arguments\n');
end;

m = isnan(X);
n = isnan(Y);

X(m) = 0;
Y(n) = 0;

C = conv2(X,Y);         % 2-dim convolution
N = conv2(real(~m),real(~n));     % normalization term
c = conv2(ones(size(X)),ones(size(Y))); % correction of normalization

if nargout==1,
        C = C.*c./N;
elseif nargout==2,
        N = N./c;
end;

