function adjnew = adj2bin(adj,threshold)
    % This function converts the weighted adjacency matrix
    % to binary matrix and returns sparse binary adjacency matrix.
    % INPUT 
    % adj - weighted adjacency matrix
    % OUTPUT 
    % adjnew - sparse binary adjacency matrix

    adjnew=sparse(size(adj,1), size(adj,1));
    [I,J] = find(abs(adj)>threshold);
    n=length(I);
    for i=1:n
        adjnew(I(i),J(i))=1;
    end
end






