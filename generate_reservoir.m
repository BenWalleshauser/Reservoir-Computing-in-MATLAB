function out = generate_reservoir(dim_reservoir,density)

%Creating matrix of random weights with a set density. The random weights
%are then scaled by the spectral radius

array = rand(dim_reservoir,dim_reservoir) < density;    
ran = 2*(rand(dim_reservoir,dim_reservoir)-0.5);
res = ran.*array;      

[eigvec,eigval]=eig(res) ;     
max_eig = max(max(eigval));    
max_length = abs(max_eig);      

out = res/(max_length);                
end
