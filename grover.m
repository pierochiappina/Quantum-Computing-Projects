function [out, ans] = grover(N)
%Performs the grover algorithm with N>2 number of qubits.

function O = oracle(N, ans)
%Creates a quantum oracle, which takes the desired output ans(in binary OR decimal) within 2^N
%outputs and makes its amplitude negative.

if class(ans)=='char'
ans = bin2dec(ans) + 1;
end

m = 1:2^N;
n = m;
s = [ones(2^N, 1)];
s(ans) = -1;

O = sparse(m, n, s);

end

psi = zeros(2^N, 1);
psi(1) = 1;
ans = dec2bin(round((2^N - 1)*rand), N);

H = spadamard(N);
O = oracle(N, ans);
J = sparse(1:2^N, 1:2^N, [-1 ones(1, 2^N - 1)]);
%Generate matrices to use in later diffusion operations

for i = 1:N
    psi = H.(['H' num2str(i)])*psi;
end
%Puts psi in an equal superposition of all possible states

for i = 1:round((pi/4)*sqrt(2^N)) 
    %Repeats diffusion process an optimal number of times
    psi = O*psi;
    for i = 1:N
        psi = H.(['H' num2str(i)])*psi;
    end
    psi = J*psi;
    for i = 1:N
    psi = H.(['H' num2str(i)])*psi;
    end
    %This is the diffusion operation, used to drastically increase the
    %probability of measuring the correct answer
end


out = measure_qubit(psi);
%Generates a reliable output for a search in ~sqrt(N) iterations, giving 
%O(sqrt(N)). Thus the algorithm provides a quadratic speedup of the 
%classical search problem.
end