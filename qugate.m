function U = qugate(U0, N)
%Takes in a single-qubit gate U0, and outputs the N-qubit U0 gates for
%qubits 1 through N

for i = 1:N 
    m = [];
    n = [];
    s = [];
    for j = 1:2^(i-1)
        for k = 1+2*(j-1)*2^(N-i):2^(N-i)+2*(j-1)*2^(N-i)
            m = [m k k k+2^(N-i) k+2^(N-i)];
            n = [n k k+2^(N-i) k k+2^(N-i)];
            s = [s U0(1, 1) U0(1, 2) U0(2, 1) U0(2, 2)];
        end
    end
    %Undergoes same procedure as hadamard function to find coordinates 
    %(m,n) for each gate, only now we replace the hadamard gate with any
    %arbitrary single qubit gate.
    
    U.(['U' num2str(i)]) = sparse(m,n,s);
    %Saves matrices for each qubit in the register inside a structure 
end
    
end
