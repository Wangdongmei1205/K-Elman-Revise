function idx = findClosestCentroids(X, centroids)
K = size(centroids, 1);

idx = zeros(size(X,1), 1);

for i = 1:size(X, 1)
    min = 1e20;
    for j = 1:K
        cost = sum((X(i, :) - centroids(j, :)).^2);
        if cost < min
            min = cost;
            minj = j;
        end
    end
    idx(i) = minj;
end