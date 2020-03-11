function cdKNK
% goes to the knkutils directory (try local, then raid)

try
    cd '/Users/sonia/Documents/MATLAB/knkutils'
catch
    cd([raid 'sonia/knkutils/']);
end


