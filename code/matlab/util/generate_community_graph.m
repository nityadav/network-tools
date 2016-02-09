function [adj,labels] = generate_community_graph(n, div, p_in, p_out)
	adj = zeros([n,n]);
	div = [div n-sum(div)];
	k = length(div);
	cum_div = 0;
	for i = 1:k
		cum_div(i+1) = cum_div(i) + div(i);
	end
	% do the labeling according to div
	for c = 1:k
		labels(cum_div(c)+1:cum_div(c+1)) = c;
	end
	% construct the adjacency matrix now
	for i = 1:n
		for j = i+1:n
			if labels(i) == labels(j)
				adj(i,j) = rand(1) < p_in;
			else
				adj(i,j) = rand(1) < p_out;
			end
			adj(j,i) = adj(i,j);
		end
	end
	labels = labels';
end