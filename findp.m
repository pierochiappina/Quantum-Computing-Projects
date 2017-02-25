function pvec = findp(out)

pvec = [];
p = [];

function frac = findfrac(out, n)
    %Uses method of repeating fractions to approximate 'out'
    
    intg = floor(1/out);
    rest = 1/out - intg;
    %Invert out, then separate into the integer part and the decimal part
    
    if n == 1;
        frac = 1/intg;
    else
        frac = 1/(intg + findfrac(rest, n-1));
    end
    
end

for i = 1:10
    frac = findfrac(out, i);
    s = frac;
    c = 1;
    while mod(s, 1)>1e-5
        c = c + 1;
        s = c*frac;
    end
    %Find the numbers s and p that correspond to the approximated fraction s/p
    
    s = round(s);
    p = [p round(s/frac)];
    
    %Now we make a list of possible values for s/p
    if length(p)==1
        pvec = [pvec ' ' num2str(s) '/' num2str(p(end)) ' '];
    elseif ~isnan(p(end)) && p(end) ~= p(end-1)
        pvec = [pvec ' ' num2str(s) '/' num2str(p(end)) ' '];
    end
end

end