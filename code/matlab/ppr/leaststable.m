% get Q least stable nodes from each cluster
% mosts : KxQ matrix, where K is the number of clusters
function leasts = leaststable(affinity,labels,Q)
	n = size(affinity,1);
	k = size(affinity,2);
	leasts = [];
	stb = max(affinity,[],2);
	for l = 0:k-1
		members = find(labels==l);
		members_stb = stb(members);
		[minstb, minstbidx] = sort(members_stb);
		leasts = [leasts; members(minstbidx(1:Q))'];
	end
end