function view_graph(adj)
	coords = tsne_p(adj,[],2);
	gplot(adj,coords);
end