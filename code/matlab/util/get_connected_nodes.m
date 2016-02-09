% find all the vertices that can be reached from a vertex s
function nodes = get_connected_nodes(adj,s)
	num_nodes = size(adj,1);
	visited = zeros([1,num_nodes]);
	queue = [s];
	while length(queue) > 0
		curr = queue(1);
		queue(1) = [];
		visited(curr) = 1; 
		neighbors = find(adj(curr,:));
		unvisited = neighbors(find(visited(neighbors)==0));
		queue = [queue unvisited];
	end
	nodes = find(visited);
end