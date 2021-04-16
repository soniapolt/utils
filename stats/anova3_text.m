function anova_text(fid,result,test)
% function anova3_text(fid,results)
%   prints result = rmAnova3(anovaData,factNames,0); nicely
    
    fprintf('\n-----\n%s:\n-----\n',test);
    fprintf(fid,'\n-----\n%s:\n-----\n',test);
    
    main.s = []; main.ns = []; int.s = []; int.ns=[];
    for n = 1:length(result)
        
            text = sprintf('%s, F(%d,%d)=%.8f, p=%.8f.\n',result(n).name,result(n).df(1),result(n).df(2),result(n).F,result(n).p);
        if strcmp(result(n).type,'main')
            if result(n).h
        main.s = [main.s text];
        else
        main.ns = [main.ns text];end
        else
        if result(n).h
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

