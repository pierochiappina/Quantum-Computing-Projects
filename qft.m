function [Q, count] =  qft(L, N)
% Quantum fourier transform acting on L qubits of an N-qubit register.
 
% Outputs a structure with all matrices necessary to do the QFT.
% To take the QFT, we apply the matrices in the structure to the state psi.
% To take the IQFT, we simply apply the matrices to psi in the reverse
% order.

H = spadamard(N);
l = L;
count = 2;
Q = qftHelp(l, N);
%Since the QFT is defined recursively, need recursive funtion to create all
%necessary gates

    function Q =  qftHelp(l, N)
        if l==1
            Q.('qft1') = H.(['H' num2str(L)]);  
        else
            Q = qftHelp(l-1, N);
            for j = l-1:-1:1
                Q.(['qft' num2str(count)]) = cgate([1 0; 0 exp(i*pi/(2^(j)))], L-l+1, L-l+1+j, N);
                count = count + 1;
            end
            Q.(['qft' num2str(count)]) = H.(['H' num2str(L-l+1)]);
            count = count + 1;
        end
    end

end

