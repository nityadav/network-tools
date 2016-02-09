function clustering_process(points,progress)
	n = size(points,1);
	runs = size(progress,1);
	labels = zeros([n,1]);
	for i = 1:runs
		labels(find(progress(i,:))) = i;
		gscatter(points(:,1), points(:,2),labels);
		axis tight
        axis off
        legend off
        drawnow
        pause(2)
	end
end