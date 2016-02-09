function avg_deg = find_avg_deg(adj)
	n = size(adj,1);
	avg_deg = sum(sum(adj,2))/n;
end