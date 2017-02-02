function H = spadamard(N)
%Uses sparse matrices to create Hadamard gates of N qubits. This is MUCH
%faster and requires much less memory than creating hadamard gates with 
%regular matrices.

for i = 1:N 
    m = [];
    n = [];
    s = [];
    for j = 1:2^(i-1)
        for k = 1+2*(j-1)*2^(N-i):2^(N-i)+2*(j-1)*2^(N-i)
            m = [m k k k+2^(N-i) k+2^(N-i)];
            n = [n k k+2^(N-i) k k+2^(N-i)];
            s = [s 1/sqrt(2) 1/sqrt(2) 1/sqrt(2) -1/sqrt(2)];
        end
    end
    %For each qubit in the register, we iterate through and create a
    %hadamard gate that acts on this qubit. 
    
    %The indices (m, n) of the matrix are created so that they match the
    %tensor product formula for calculating these single qubit gates
    
    %Ex: In a 3-qubit register, the first qubit hadamard gate is the tensor
    %product H1 = HxIxI. H2 = IxHxI. H3 = IxIxH.
    
    H.(['H' num2str(i)]) = sparse(m,n,s);
    %Saves all N hadamard matrices for an N-qubit register in a structure
end

end