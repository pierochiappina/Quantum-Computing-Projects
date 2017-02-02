function A = amodC(a, C, L, N)
%Creates controlled matrices for the function f(x)=mod(a^x, C) acting on
%L-qubits in an N-qubit register

for i = 1:L
    row = [];
    col = 1:2^N;
    s = ones(1, 2^N);
    
    if i>4
        Ai = mod(vpa([num2str(a) '^(2^' num2str(i-1) ')'], 2^i ), C);
        Ai = double(Ai);
        %To ensure precision in MATLAB, we must use vpa
    else
        Ai = mod(a^(2^(i-1)), C);
    end
    
    for k = 1:2^N
        n = dec2bin(k-1, N); 
        l = n(1:L);
        m = n(L+1:end);
        if l(L-i+1)=='0' || bin2dec(m)>=C
            row = [row k];
        else
            f = bin2dec(m);
            f = mod(Ai*f, C);
            j = [l dec2bin(f, N-L)];
            row  = [row bin2dec(j)+1];
        end
    end
    A.(['A' num2str(i-1)]) = sparse(row, col, s);
end

end
        

