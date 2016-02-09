function mod_mat=modularity_matrix(adj)
	n = size(adj,1);
	deg = sum(adj,2);
	twiceM = sum(deg);
	mod_mat = adj;
	for i = 1:n
		for j = 1:n
			mod_mat(i,j) = adj(i,j) - deg(i)*deg(j)/twiceM;
		end
	end
end