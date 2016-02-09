function clustering_process(points,progress)
	n = size(points,1);
	k = size(progress,1);
	labels = zeros([n,1]);
	residual = 1:n;
	i = 1;
	while i < k
		scatter(points(residual,1), points(residual,2));
		pause(2)
		seeds = progress(i,:);
		gscatter(points(residual,1), points(residual,2), seeds(residual));
		pause(2)
		expanded_seeds = progress(i+1,:);
		gscatter(points(residual,1), points(residual,2), expanded_seeds(residual));
		pause(2)
		peeled = find(progress(i+2,:));
		residual = setdiff(residual,peeled);
		axis tight
        axis off
        legend off
        drawnow
        i = i + 3;
	end
end