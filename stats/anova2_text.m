function anova2_text(fid,result,test)
% function anova2_text(fid,results)
%   prints result = rmAnova3(anovaData,factNames,0); nicely

fprintf('\n-----\n%s:\n-----\n',test);
fprintf(fid,'\n-----\n%s:\n-----\n',test);

main.s = []; main.ns = []; int.s = []; int.ns=[];

for n = 2:4
    
    text = sprintf('%s, F(%d)=%.2f, p=%.3f.\n',result{n,1},result{n,3},result{n,5},result{n,6});
    if ~containsTxt(result{n,1},' x ')
        if result{n,6} < .05
            main.s = [main.s text];
        else
            main.ns = [main.ns text];end
    else
        if result{n,6} < .05
            int.s = [int.s text];else
            int.ns = [int.ns text];end
    end
end
fprintf(fid,'Significant Main Effects: \n%s\n',main.s);
fprintf(fid,'Significant Interactions: \n%s\n',int.s);
fprintf(fid,'N.S: \n%s%s\n',main.ns,int.ns);

fprintf('Significant Main Effects: \n%s\n',main.s);
fprintf('Significant Interactions: \n%s\n',int.s);
fprintf('N.S: \n%s%s\n',main.ns,int.ns);
end

