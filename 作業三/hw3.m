clear;
load 'd2';
load 'd3';

[records, fields ] = size(d2);

% convert to homogeneous coordinate
d2 = [d2 ones(records, 1)];
d3 = [d3 ones(records, 1)];

%% get Projection matrix by solving AP=0
% Matrix A
A = [[d3 zeros(records,4) -d2(:,1).*d3] 
     [zeros(records,4) d3, -d2(:,2).*d3]];
% (t(A)*A)*v = lambda*v
[V , lambda] = eig(A'*A);
% find argmin_eigvalue(eigvector)
[min_eigval, idx] = min(sum(lambda));
% get Projection Matrix 
P = reshape(V(:,idx), 4,3)'

%%
M = P(:,1:3);
% invM = QR -> K=inv(R); Rot=inv(Q)
[Q, R] = qr(inv(M));
% get Calibration Matrix 
K=inv(R)
% get Rotation Matrix 
Rot=inv(Q) 
% get Translation Matrix 
T=K\P(:,4) 

%%
projectedD2 = (P*d3')';
% convert from homogeneous coordinate
projectedD2 = projectedD2./projectedD2(:,3); 
% report projection error  
projection_error = mean(sqrt(sum((d2(:,1:2)-projectedD2(:,1:2)).^2,2)))
