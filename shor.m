function f = shor(C)
%Performs the Shor factoring algorithm for a number C with an arbitrary
%number of qubits

if mod(C, 2)==0
    f = 2;
    %If C is even, we know that 2 is a factor of C and we are done.
elseif isprime(C)
    f = 'Prime';
else
    p = 1; %Initialize p
    
    while mod(p, 2)~=0 || mod(a^(p/2) + 1, C)==0
        
        a = round(rand*(j-3)) + 1; 
        
        if gcd(a, C) > 1
            f = gcd(a, C);
            break
        else
            M = ceil(log2(C));
            L = ceil(2*log2(C));
            N = L + M;
            
            psi = zeros(2^N, 1);
            psi(2) = 1;
            
            H = spadamard(N);
            for i = 1:L
                psi = H.(['H' num2str(i)])*psi;
            end
            
            A = amodC(a, C, L, N);
            for i = 1:L
                psi = A.(['A' num2str(i-1)])*psi;
            end
            
            [Q, count] = qft(L, N);
            for i = count-1:-1:1
                psi = Q.(['qft' num2str(i)])*psi;
            end
            
            w = measure_qubit(psi);
            x = w(L:-1:1);
            f = bin2dec(x)/(2^L); 
            %The value for f is approximately equal to s/p, where s is some
            %integer and p is the period of the function mod(a^x, C). 
            
            %From this measured f, guess p until we find p that satisfies
            %mod(a^p + 1, C) = 0. If p is odd or p is even and 
            %mod(a^(p/2)+ 1, C) = 0, we must go back and choose a different
            %a.
           
        end
    end
end


end