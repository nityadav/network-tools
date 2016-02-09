% random walk simulator in a graph
function prob_dist = random_walk(adj,source,num_steps)
	trans = get_transition(adj);
	init_dist = zeros([1,size(adj,1)]);
	init_dist(source) = 1;
	prob_dist = init_dist*(trans^num_steps);
end