% get Q most stable nodes from each cluster
% mosts : KxQ matrix, where K is the number of clusters
function mosts = moststable(affinity,labels,Q)
	n = size(affinity,1);
    clusters = unique(labels);
	k = length(clusters);
	mosts = [];
	stb = max(affinity,[],2);
	for i = 1:k
        l = clusters(i);
		members = find(labels==l);
		members_stb = stb(members);
		[maxstb, maxstbidx] = sort(members_stb,'descend');
		mosts = [mosts; members(maxstbidx(1:Q))'];
	end
end
