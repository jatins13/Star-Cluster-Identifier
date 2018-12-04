function [Z,X_approx] = pca(X,K)

mu = mean(X);
X_norm = bsxfun(@minus, X, mu);
sigma = std(X_norm);
X_norm = bsxfun(@rdivide, X_norm, sigma);
[m,n] = size(X_norm);
cov_mat=(X_norm'*X_norm)/m;
[U,S,V]=svd(cov_mat);
Z=X_norm*U(:,1:K);
X_approx=Z*U(:,1:K)';
end
