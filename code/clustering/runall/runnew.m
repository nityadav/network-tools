A = csvread('../data/adj.csv');
results = [];
repeat = 1;

% run peeling
cd ../peeling

disp('Now running nbr peeling algorithm')
minq = 1;
total_n = 0;
for i = 1:repeat
	[l,q,n,t] = nbr_peeling(A,50);
	total_n = total_n + n;
	if q < minq
		minq = q;
		worst_l = l;
		time = t;
	end
end
avg_n = total_n/repeat;
results = [results; avg_n time*avg_n]
csvwrite('../data/nbr_peel.csv',worst_l);

disp('Now running unormalized nbr peeling algorithm')
minq = 1;
total_n = 0;
for i = 1:repeat
	[l,q,n,t] = peeling(A,1);
	total_n = total_n + n;
	if q < minq
		minq = q;
		worst_l = l;
		time = t;
	end
end
avg_n = total_n/repeat;
results = [results; avg_n time*avg_n]
csvwrite('../data/nbr_unorm_peel.csv',worst_l);

csvwrite('../data/results.csv',results)

cd ../EO
disp('Now running mod EO algorithm')
minq = 1;
total_n = 0;
for i = 1:repeat
	[l,q,n,t] = eo_mod(A,1);
	total_n = total_n + n;
	if q < minq
		minq = q;
		worst_l = l;
		time = t;
	end
end
avg_n = total_n/repeat;
results = [results; avg_n time*avg_n]
csvwrite('../data/mod_eo.csv',worst_l);

disp('Now running normalized mod EO algorithm')
minq = 1;
total_n = 0;
for i = 1:repeat
	[l,q,n,t] = eo_mod_norm(A,1);
	total_n = total_n + n;
	if q < minq
		minq = q;
		worst_l = l;
		time = t;
	end
end
avg_n = total_n/repeat;
results = [results; avg_n time*avg_n]
csvwrite('../data/norm_mod_eo.csv',worst_l);

% write the time and iteration results
csvwrite('../data/results.csv',results)
clear;
beep;
%}