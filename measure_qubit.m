function [state] =  measure_qubit(psi)
%Takes in a qubit in the state psi, and simulates a measurement on the
%qubit. The output will be one of the basis states of the qubit, with a
%probability given by the square of the amplitude of the state in psi.

N = log2(length(psi));

r = rand; %Generates random number from 0-1
q = 0; 

for i = 1:length(psi)
    if r < q + (abs(psi(i)))^2
         state = dec2bin(i-1, N); %Outputs state expressed in binary
         break
    else
        q = q + (abs(psi(i)))^2;
    end
end
%Ensures that the output of the function will be one of the states in psi.
%The probability that the function will output a particular state is given
%by the square of the amplitude of that state.
 

end