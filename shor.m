function f = shor(C)
%Performs the Shor factoring algorithm for a number C with an arbitrary
%number of qubits

L = input('Choose L (optimal L is given by ceil(2*log2(C)) :');
M = input('Choose M (optimal M is given by ceil(log2(C)) :');
N = L + M;
%Size of the L-qubit register and M-qubit register selected by the user
 
if mod(C, 2)==0
    f = [2, C/2];
    %If C is even, we know that 2 is a factor of C and we are done
elseif isprime(C)
    f = 'Prime';
else
    p = 1; %Initialize p
    
    while mod(p, 2)~=0 || double(mod(vpa([num2str(a) '^(' num2str(p) '/2) + 1'], p), C))==0
        
        a = ceil(rand*(C-1));
        %Choose a random number 'a' in the range 1 < a < C
        
        if gcd(a, C) > 1
            f = [gcd(a, C), C/(gcd(a, C))];
            break
            %If by chance 'a' is a factor of C, we are done
        else
            psi = zeros(2^N, 1);
            psi(2) = 1;
            %Initialize psi in the state '000 .... 001'
            
            H = spadamard(N);
            for i = 1:L
                psi = H.(['H' num2str(i)])*psi;
            end
            %Puts the L-qubit register in an equal superposition of all of
            %its states
            
            A = amodC(a, C, L, N);
            for i = 1:L
                psi = A.(['A' num2str(i-1)])*psi;
            end
            %Performs the function mod(a^x, C) in the M-qubit register
            
            [Q, count] = qft(L, N);
            for i = count-1:-1:1
                psi = Q.(['qft' num2str(i)])*psi;
            end
            %Performs the IQFT on the L-qubit register to find the
            %frequency (and hence the period) of the function mod(a^x, C)
            
            out = 0; 
            %If our measured output for the algorithm happens to be 0, we
            %get no useful information out of it. We must measure a nonzero
            %output, so we keep measuring until we do
            while out==0
                w = measure_qubit(psi);
                x = w(L:-1:1);
                out = bin2dec(x)/(2^L);
            end
            %The value for f is approximately equal to s/p, where s is some
            %integer and p is the period of the function mod(a^x, C). 
            
            pvec = findp(out)
            p = input('Guess period:');
            
            while double(mod(vpa([num2str(a) '^' num2str(p) '- 1'], p), C))~=0
                pvec
                p = input('Guess again:');
            end
            %From this measured f, guess p until we find p that satisfies
            %mod(a^p - 1, C) = 0. 
            
            if mod(p, 2)==0 & double(mod(vpa([num2str(a) '^(' num2str(p) '/2) + 1'], p), C))~=0
                f = [double(gcd(vpa([num2str(a) '^(' num2str(p) '/2) + 1'], p), C)), double(gcd(vpa([num2str(a) '^(' num2str(p) '/2) - 1'], p), C))];
            end
            %If p is odd or p is even and mod(a^(p/2)+ 1, C) = 0, we must 
            %go back and choose a different a.
            
            %Otherwise, the factors of C are the gcd's of a^(p/2) +- 1 and
            %C
            
        end 
           
        end
    end
end