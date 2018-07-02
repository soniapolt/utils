for m = 1:length(dataTYPES)
    for n = 1:length(dataTYPES(m).scanParams)
        dataTYPES(m).scanParams(n).PfileName = strrep(dataTYPES(m).scanParams(n).PfileName,...
            'Volumes','share/kalanit/biac2/kgs/projects');
        dataTYPES(m).scanParams(n).inplanePath = strrep(dataTYPES(m).scanParams(n).PfileName,...
            'Volumes','share/kalanit/biac2/kgs/projects');
    end
end

for n = 1:length(mrSESSION.functionals)
   mrSESSION.functionals(n).PfileName = strrep(mrSESSION.functionals(n).PfileName,...
            'Volumes','share/kalanit/biac2/kgs/projects'); 
end