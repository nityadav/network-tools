function clustering_process(points,progress)
	n = size(points,1);
	k = size(progress,1);
	maxx = max(points(:,1));
	minx = min(points(:,1));
	maxy = max(points(:,2));
	miny = min(points(:,2));
	residual = 1:n;
	i = 1;
	aviobj = avifile('clustering.avi','fps',1);
	while i < k
		% show all the points left
		h = scatter(points(residual,1), points(residual,2));
		axis([minx maxx miny maxy]);
        axis off
        legend off
        f = getframe(gcf);
        aviobj = addframe(aviobj,f);
        pause(2)
        % show the seeds
		seeds = progress(i,:);
		gscatter(points(residual,1), points(residual,2), seeds(residual));
		axis([minx maxx miny maxy]);
        axis off
        legend off
        f = getframe(gcf);
        aviobj = addframe(aviobj,f);
        pause(2)
		% show the expanded seeds
		expanded_seeds = progress(i+1,:);
		gscatter(points(residual,1), points(residual,2), expanded_seeds(residual));
		axis([minx maxx miny maxy]);
        axis off
        legend off
        f = getframe(gcf);
        aviobj = addframe(aviobj,f);
        pause(2)
        % remove the peeled points
		peeled = find(progress(i+2,:));
		residual = setdiff(residual,peeled);
        i = i + 3;
	end
	scatter(points(residual,1), points(residual,2));
	axis([minx maxx miny maxy]);
    axis off
    legend off
    f = getframe(gcf);
    aviobj = addframe(aviobj,f);
    pause(2)
    aviobj = close(aviobj);
end