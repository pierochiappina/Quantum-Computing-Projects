function U = cgate(U0, p, q, N)
%Computes 'controlled-U' gate for an N-qubit register with qubit p controlling
%qubit q (i.e. if qubit p is 0, do nothing, if qubit p is 1, perform gate U
%on qubit q). This is again done with sparse matrices to save memory.

m = [];
n = [];
s = [];

for j = 1:2^N
    
    bin1 = dec2bin(j - 1, N);
    bin2 = bin1; 
    %Create two binary representations of the qubit representing the
    %iteration
    
    if bin1(p)=='0'
        m = [m j];
        n = [n j];
        s = [s 1];
        %Assigns matrix index (m, n) depending on if bit p is '0' or '1'
        %If '0', do nothing. If '1', keep going
    else
        switch bin2(q)
            case '0'
                bin2(q)='1';
            case '1'
                bin2(q)='0';
        end
        %Flips qubit q of bin2
        
        dec1 = bin2dec(bin1) + 1;
        dec2 = bin2dec(bin2) + 1;
        switch bin1(q)
            case '0'
                m = [m dec1 dec2];
                n = [n j j];
                s = [s U0(1, 1) U0(2, 1)];
            case '1'
                m = [m dec2 dec1];
                n = [n j j];
                s = [s U0(1, 2) U0(2, 2)];
        end
    end
end

U = sparse(m, n, s);

end
    