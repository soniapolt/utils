function [result] = rmAnova3(X,factNames,printOut)
% RMAOv(3)3 modified by SP to provide sensible output, not just fprintf
% values. see RMAOv(3)3.m for documentation on the function itself
%
%   Syntax: function anova = rmAnova(X,factNames)
%
%     Inputs:
%          X - data matrix (Size of matrix must be n-by-5:
%          [ data fact1 fact2 fact3 subject]
%  factnames - am 1 x 3 (or 3 x 1) cell array of factor names: e.g. {'A' 'B' 'C'}  <= Default
%    Outputs:
%            - Structure summarizing ANOVA output

alpha = 0.05;

if ~exist('factNames','var')
    factNames = {'A' 'B' 'C' };
end
if ~exist('printOut','var')
    printOut = 0;
end

factNames{end+1} = 's';

levels = max(X);
an = struct('name',factNames,'levels',num2cell(levels(2:end)));

if printOut
    disp('   ');
    for n = 1:length(an)
        fprintf('The number of levels [%s]:\t%2i\n', an(n).name, an(n).levels); end
    fprintf('The number of subjects:      \t%2i\n\n', an(end).levels); end

CT = (sum(X(:,1)))^2/length(X(:,1));  %correction term
SSTO = sum(X(:,1).^2)-CT;  %total sum of squares
v(16) = length(X(:,1))-1;  %total degrees of freedom

%procedure related to the subjects.
S = [];
indice = X(:,5);
for l = 1:an(end).levels
    Xe = find(indice==l);
    eval(['S' num2str(l) '=X(Xe,1);']);
    eval(['x =((sum(S' num2str(l) ').^2)/length(S' num2str(l) '));']);
    S = [S,x];
end;

SSS = sum(S)-CT;
v(15) = an(end).levels-1;

%--Procedure Related to the Within-Subjects--
%procedure related to the Iv(1) (independent variable 1 [within-subjects]).
A = [];
indice = X(:,2);
for i = 1:an(1).levels
    Xe = find(indice==i);
    eval(['A' num2str(i) '=X(Xe,1);']);
    eval(['x =((sum(A' num2str(i) ').^2)/length(A' num2str(i) '));']);
    A = [A,x];
end;
SSA = sum(A)-CT;  %sum of squares for the Iv(1)
v(1) = an(1).levels-1;  %degrees of freedom for the Iv(1)
MSA = SSA/v(1);  %mean square for the Iv(1)

%procedure related to the Iv(1)-error.
EIv1 = [];
for i = 1:an(1).levels
    for l = 1:an(end).levels
        Xe = find((X(:,2)==i) & (X(:,5)==l));
        eval(['Iv1S' num2str(i) num2str(l) '=X(Xe,1);']);
        eval(['x =((sum(Iv1S' num2str(i) num2str(l) ').^2)/length(Iv1S' num2str(i) num2str(l) '));']);
        EIv1 = [EIv1,x];
    end;
end;
SSEA = sum(EIv1)-sum(A)-sum(S)+CT;  %sum of squares of the Iv(1)-error
v(2) = v(1)*v(15);  %degrees of freedom of the Iv(1)-error
MSEA = SSEA/v(2);  %mean square for the Iv(1)-error

%F-statistics calculation.
F(1) = MSA/MSEA;

%Probability associated to the F-statistics.
P(1) = 1 - fcdf(F(1),v(1),v(2));

%procedure related to the Iv(2) (independent variable 2 [within-subjects]).
B = [];
indice = X(:,3);
for j = 1:an(2).levels
    Xe = find(indice==j);
    eval(['B' num2str(j) '=X(Xe,1);']);
    eval(['x =((sum(B' num2str(j) ').^2)/length(B' num2str(j) '));']);
    B =[B,x];
end;
SSB = sum(B)-CT;  %sum of squares for the Iv(2)
v(3) = an(2).levels-1;  %degrees of freedom for the Iv(2)
MSB = SSB/v(3);  %mean square for the Iv(2)

%procedure related to the Iv(2)-error.
EIv2 = [];
for j = 1:an(2).levels
    for l = 1:an(end).levels
        Xe = find((X(:,3)==j) & (X(:,5)==l));
        eval(['Iv2S' num2str(j) num2str(l) '=X(Xe,1);']);
        eval(['x =((sum(Iv2S' num2str(j) num2str(l) ').^2)/length(Iv2S' num2str(j) num2str(l) '));']);
        EIv2 = [EIv2,x];
    end;
end;
SSEB = sum(EIv2)-sum(B)-sum(S)+CT;  %sum of squares of the Iv(2)-error
v(4) = v(3)*v(15);  %degrees of freedom of the Iv(2)-error
MSEB = SSEB/v(4);  %mean square for the Iv(2)-error

%F-statistics calculation.
F(2) = MSB/MSEB;

%Probability associated to the F-statistics.
P(2) = 1 - fcdf(F(2),v(3),v(4));

%procedure related to the Iv(3) (independent variable 3 [within-subject]).
C = [];
indice = X(:,4);
for k = 1:an(3).levels
    Xe = find(indice==k);
    eval(['C' num2str(k) '=X(Xe,1);']);
    eval(['x =((sum(C' num2str(k) ').^2)/length(C' num2str(k) '));']);
    C =[C,x];
end;
SSC = sum(C)-CT;  %sum of squares for the Iv(3)
v(5) = an(3).levels-1;  %degrees of freedom for the Iv(3)
MSC = SSC/v(5);  %mean square for the Iv(3)

%procedure related to the Iv(3)-error.
EIv3 = [];
for k = 1:an(3).levels
    for l = 1:an(end).levels
        Xe = find((X(:,4)==k) & (X(:,5)==l));
        eval(['Iv3S' num2str(k) num2str(l) '=X(Xe,1);']);
        eval(['x =((sum(Iv3S' num2str(k) num2str(l) ').^2)/length(Iv3S' num2str(k) num2str(l) '));']);
        EIv3 = [EIv3,x];
    end;
end;
SSEC = sum(EIv3)-sum(C)-sum(S)+CT;  %sum of squares of the Iv(3)-error
v(6) = v(5)*v(15);  %degrees of freedom of the Iv(3)-error
MSEC = SSEC/v(6);  %mean square for the Iv(3)-error

%F-statistics calculation.
F(3) = MSC/MSEC;

%Probability associated to the F-statistics.
P(3) = 1 - fcdf(F(3),v(5),v(6));

%procedure related to the Iv(1) and Iv(2) (within- and within- subject).
AB = [];
for i = 1:an(1).levels
    for j = 1:an(2).levels
        Xe = find((X(:,2)==i) & (X(:,3)==j));
        eval(['AB' num2str(i) num2str(j) '=X(Xe,1);']);
        eval(['x =((sum(AB' num2str(i) num2str(j) ').^2)/length(AB' num2str(i) num2str(j) '));']);
        AB = [AB,x];
    end;
end;
SSAB = sum(AB)-sum(A)-sum(B)+CT;  %sum of squares of the Iv(1)xIv(2)
v(7) = v(1)*v(3);  %degrees of freedom of the Iv(1)xIv(2)
MSAB = SSAB/v(7);  %mean square for the Iv(1)xIv(2)

%procedure related to the Iv(1)-Iv(2)-error.
EIv12 = [];
for i = 1:an(1).levels
    for j = 1:an(2).levels
        for l = 1:an(end).levels
            Xe = find((X(:,2)==i) & (X(:,3)==j) & (X(:,5)==l));
            eval(['Iv12S' num2str(i) num2str(j) num2str(l) '=X(Xe,1);']);
            eval(['x =((sum(Iv12S' num2str(i) num2str(j) num2str(l) ').^2)/length(Iv12S' num2str(i) num2str(j) num2str(l) '));']);
            EIv12 = [EIv12,x];
        end;
    end;
end;
SSEAB = sum(EIv12)-sum(AB)-sum(EIv2)+sum(B)-sum(EIv1)+sum(A)+sum(S)-CT;
v(8)= v(2)*v(3);  %degrees of freedom of the Iv(1)-Iv(2)-error
MSEAB = SSEAB/v(8);  %mean square for the Iv(1)-Iv(2)-error

%F-statistics calculation
F(4) = MSAB/MSEAB;

%Probability associated to the F-statistics.
P(4) = 1 - fcdf(F(4),v(7),v(8));

%procedure related to the Iv(1) and Iv(3) (between- and within- subject).
AC = [];
for i = 1:an(1).levels
    for k = 1:an(3).levels
        Xe = find((X(:,2)==i) & (X(:,4)==k));
        eval(['AC' num2str(i) num2str(k) '=X(Xe,1);']);
        eval(['x =((sum(AC' num2str(i) num2str(k) ').^2)/length(AC' num2str(i) num2str(k) '));']);
        AC = [AC,x];
    end;
end;
SSAC = sum(AC)-sum(A)-sum(C)+CT;  %sum of squares of the Iv(1)xIv(3)
v(9) = v(1)*v(5);  %degrees of freedom of the Iv(1)xIv(3)
MSAC = SSAC/v(9);  %mean square for the Iv(1)xIv(3)

%procedure related to the Iv(1)-Iv(3)-error.
EIv13 = [];
for i = 1:an(1).levels
    for k = 1:an(3).levels
        for l = 1:an(end).levels
            Xe = find((X(:,2)==i) & (X(:,4)==k) & (X(:,5)==l));
            eval(['Iv13S' num2str(i) num2str(k) num2str(l) '=X(Xe,1);']);
            eval(['x =((sum(Iv13S' num2str(i) num2str(k) num2str(l) ').^2)/length(Iv13S' num2str(i) num2str(k) num2str(l) '));']);
            EIv13 = [EIv13,x];
        end;
    end;
end;
SSEAC = sum(EIv13)-sum(AC)-sum(EIv3)+sum(C)-sum(EIv1)+sum(A)+sum(S)-CT;
v(10) = v(2)*v(5);  %degrees of freedom of the Iv(1)-Iv(3)-error
MSEAC = SSEAC/v(10);  %mean square for the Iv(1)-Iv(3)-error

%F-statistics calculation
F(5) = MSAC/MSEAC;

%Probability associated to the F-statistics.
P(5) = 1 - fcdf(F(5),v(9),v(10));

%procedure related to the Iv(2) and Iv(3) (within- and within- subject).
BC = [];
for j = 1:an(2).levels
    for k = 1:an(3).levels
        Xe = find((X(:,3)==j) & (X(:,4)==k));
        eval(['BC' num2str(j) num2str(k) '=X(Xe,1);']);
        eval(['x =((sum(BC' num2str(j) num2str(k) ').^2)/length(BC' num2str(j) num2str(k) '));']);
        BC = [BC,x];
    end;
end;
SSBC = sum(BC)-sum(B)-sum(C)+CT;  %sum of squares of the Iv(2)xIv(3)
v(11) = v(3)*v(5);  %degrees of freedom of the Iv(2)xIv(3)
MSBC = SSBC/v(11);  %mean square for the Iv(2)xIv(3)

%procedure related to the Iv(2)-Iv(3)-error.
EIv23 = [];
for j = 1:an(2).levels
    for k = 1:an(3).levels
        for l = 1:an(end).levels
            Xe = find((X(:,3)==j) & (X(:,4)==k) & (X(:,5)==l));
            eval(['Iv23S' num2str(j) num2str(k) num2str(l) '=X(Xe,1);']);
            eval(['x =((sum(Iv23S' num2str(j) num2str(k) num2str(l) ').^2)/length(Iv23S' num2str(j) num2str(k) num2str(l) '));']);
            EIv23 = [EIv23,x];
        end;
    end;
end;
SSEBC = sum(EIv23)-sum(BC)-sum(EIv3)+sum(C)-sum(EIv2)+sum(B)+sum(S)-CT;
v(12) = v(4)*v(5);  %degrees of freedom of the Iv(2)-Iv(3)-error
MSEBC = SSEBC/v(12);  %mean square for the Iv(2)-Iv(3)-error

%F-statistics calculation
F(6) = MSBC/MSEBC;

%Probability associated to the F-statistics.
P(6) = 1 - fcdf(F(6),v(11),v(12));

%procedure related to the Iv(1), Iv(2) and Iv(3) (within, within- and within- subject).
ABC = [];
for i = 1:an(1).levels
    for j = 1:an(2).levels
        for k = 1:an(3).levels
            Xe = find((X(:,2)==i) & (X(:,3)==j) & (X(:,4)==k));
            eval(['AB' num2str(i) num2str(j) num2str(k) '=X(Xe,1);']);
            eval(['x =((sum(AB' num2str(i) num2str(j) num2str(k) ').^2)/length(AB' num2str(i) num2str(j) num2str(k) '));']);
            ABC = [ABC,x];
        end;
    end;
end;
SSABC = sum(ABC)+sum(A)+sum(B)+sum(C)-sum(AB)-sum(AC)-sum(BC)-CT;  %sum of squares of the Iv(1)xIv(2)xIv(3)
v(13) = v(1)*v(3)*v(5);  %degrees of freedom of the Iv(1)xIv(2)xIv(3)
MSABC = SSABC/v(13);  %mean square for the Iv(1)xIv(2)xIv(3)

%procedure related to the Iv(1)-Iv(2)-Iv(3)-error.
EIv123 = [];
for i = 1:an(1).levels
    for j = 1:an(2).levels
        for k = 1:an(3).levels
            for l = 1:an(end).levels
                Xe = find((X(:,2)==i) &(X(:,3)==j) & (X(:,4)==k) & (X(:,5)==l));
                eval(['Iv123S' num2str(i) num2str(j) num2str(k) num2str(l) '=X(Xe,1);']);
                eval(['x =((sum(Iv123S' num2str(i) num2str(j) num2str(k) num2str(l) ').^2)/length(Iv123S' num2str(i) num2str(j) num2str(k) num2str(l) '));']);
                EIv123 = [EIv123,x];
            end;
        end;
    end;
end;
SSEABC = sum(EIv123)-sum(ABC)-sum(EIv23)+sum(BC)-sum(EIv13)+sum(AC)+sum(EIv3)-sum(C)-sum(EIv12)+sum(AB)+sum(EIv2)-sum(B)+sum(EIv1)-sum(A)-sum(S)+CT;  %sum of squares of the Iv(1)-Iv(2)-Iv(3)-error
v(14) = v(2)*v(3)*v(5);  %degrees of freedom of the Iv(1)-Iv(2)-Iv(3)-error
MSEABC = SSEABC/v(14);  %mean square for the Iv(1)-Iv(2)-Iv(3)-error

%F-statistics calculation
F(7) = MSABC/MSEABC;

%Probability associated to the F-statistics.
P(7) = 1 - fcdf(F(7),v(13),v(14));

SSWS = SSA+SSEA+SSB+SSEB+SSC+SSEC+SSAB+SSEAB+SSAC+SSAC+SSEAC+SSBC+SSEBC+SSABC+SSEABC;
vWS = sum(v(1:14));

dfs = reshape(v,2,8)';

for n=1:7
    if  P(n) < .001;   eval(['ds' num2str(n) '= ''***'' ;'])
    elseif P(n) < .01; eval(['ds' num2str(n) '= ''**'' ;'])
    elseif P(n) < .05; eval(['ds' num2str(n) '= ''*'' ;'])
    else eval(['ds' num2str(n) '= '' '' ;']) % n.s.
    end
end

result = an(1:end-1); % trim subj term
% r.dfs = [v(15), vWS];
% r.dfLabels = {'between' 'within'};

% main factors
for n = 1:length(result)
    result(n).type = 'main';
    result(n).F = F(n);
    result(n).p = P(n);
    result(n).h = result(n).p<alpha;
    result(n).df = dfs(n,:);
end

int = nchoosek([1:3],2); % interactions
for nn = 1:length(int)
    n = length(factNames)-1+nn;
    result(n).name = [factNames{int(nn,1)} ' x ' factNames{int(nn,2)}];
    result(n).type = 'interaction';
    result(n).F = F(n);
    result(n).p = P(n);
    result(n).h = result(n).p<alpha;
    result(n).df = dfs(n,:);
end

% big interaction
n = n+1;
result(n).name = [factNames{1} ' x ' factNames{2} ' x ' factNames{3}];
result(n).type = 'interaction';
result(n).F = F(end);
result(n).p = P(end);
result(n).h = result(n).p<alpha;
result(n).df = dfs(n,:);

if printOut
    space = length([factNames{:}])+12;% 30;
    disp('Three-Way Analysis of Variance With Repeated Measures on Three Factors (Within-Subjects) Table.')
    Blanks = repmat(' ',1,space-length('SOV'));
    fprintf('---------------------------------------------------------------------------------------------------\n');
    fprintf('SOV%s        SS          df           MS             F        P      Conclusion\n', Blanks);
    fprintf('---------------------------------------------------------------------------------------------------\n');
    Source = 'Between-Subjects'; Blanks = repmat(' ',1,space-length(Source));
    fprintf('%s %11.3f%10i\n\n',[Source Blanks],SSS,v(15));
    
    Source = 'Within-Subjects'; Blanks = repmat(' ',1,space-length(Source));
    fprintf('%s %11.3f%10i\n\n',[Source Blanks],SSWS,vWS);
    
    Source = [factNames{1}]; Blanks = repmat(' ',1,space-length(Source));
    fprintf('%s %11.3f%10i%15.3f%14.3f%9.4f%9s\n',[Source Blanks], SSA,v(1),MSA,F(1),P(1),ds1);
    
    Source = ['Error (' factNames{1} ')' ]; Blanks = repmat(' ',1,space-length(Source));
    fprintf('%s %11.3f%10i%15.3f\n\n',[Source Blanks],SSEA,v(2),MSEA);
    
    Source = [factNames{2}]; Blanks = repmat(' ',1,space-length(Source));
    fprintf('%s %11.3f%10i%15.3f%14.3f%9.4f%9s\n',[Source Blanks],SSB,v(3),MSB,F(2),P(2),ds2);
    
    Source = ['Error (' factNames{2} ')' ]; Blanks = repmat(' ',1,space-length(Source));
    fprintf('%s %11.3f%10i%15.3f\n\n',[Source Blanks],SSEB,v(4),MSEB);
    
    Source = [factNames{3}]; Blanks = repmat(' ',1,space-length(Source));
    fprintf('%s %11.3f%10i%15.3f%14.3f%9.4f%9s\n',[Source Blanks],SSC,v(5),MSC,F(3),P(3),ds3);
    
    Source = ['Error (' factNames{3} ')' ]; Blanks = repmat(' ',1,space-length(Source));
    fprintf('%s %11.3f%10i%15.3f\n\n\n',[Source Blanks],SSEC,v(6),MSEC);
    
    Source = [ factNames{1} ' x ' factNames{2} ]; Blanks = repmat(' ',1,space-length(Source));
    fprintf('%s %11.3f%10i%15.3f%14.3f%9.4f%9s\n',[Source Blanks],SSAB,v(7),MSAB,F(4),P(4),ds4);
    
    Source = [ 'Error (' factNames{1} ' x ' factNames{2} ')' ]; Blanks = repmat(' ',1,space-length(Source));
    fprintf('%s %11.3f%10i%15.3f\n\n',[Source Blanks],SSEAB,v(8),MSEAB);
    
    Source = [ factNames{1} ' x ' factNames{3} ]; Blanks = repmat(' ',1,space-length(Source));
    fprintf('%s %11.3f%10i%15.3f%14.3f%9.4f%9s\n',[Source Blanks],SSAC,v(9),MSAC,F(5),P(5),ds5);
    
    Source = [ 'Error (' factNames{1} ' x ' factNames{3} ')' ]; Blanks = repmat(' ',1,space-length(Source));
    fprintf('%s %11.3f%10i%15.3f\n\n',[Source Blanks],SSEAC,v(10),MSEAC);
    
    Source = [ factNames{2} ' x ' factNames{3} ]; Blanks = repmat(' ',1,space-length(Source));
    fprintf('%s %11.3f%10i%15.3f%14.3f%9.4f%9s\n',[Source Blanks],SSBC,v(11),MSBC,F(6),P(6),ds6);
    
    Source = [ 'Error (' factNames{2} ' x ' factNames{3} ')' ]; Blanks = repmat(' ',1,space-length(Source));
    fprintf('%s %11.3f%10i%15.3f\n\n\n',[Source Blanks],SSEBC,v(12),MSEBC);
    
    Source = [ factNames{1} ' x ' factNames{2} ' x ' factNames{3} ]; Blanks = repmat(' ',1,space-length(Source));
    fprintf('%s %11.3f%10i%15.3f%14.3f%9.4f%9s\n',[Source Blanks],SSABC,v(13),MSABC,F(7),P(7),ds7);
    
    Source = [ 'Error (' factNames{1} ' x ' factNames{2} ' x ' factNames{3} ')' ]; Blanks = repmat(' ',1,space-length(Source));
    fprintf('%s %11.3f%10i%15.3f\n',[Source Blanks],SSEABC,v(14),MSEABC);
    
    fprintf('---------------------------------------------------------------------------------------------------\n');
    fprintf('Total                    %11.3f%10i\n',SSTO,v(16));
    fprintf('---------------------------------------------------------------------------------------------------\n');
    
    % fprintf('With a given significance level of: %.2f\n', alpha);
    % disp('The results are significant (S) or not significant (NS).');
    fprintf( '\t\t\t\t\t\t\t\t\t\t\t   * = p < .05 \n');
    fprintf('\n\t\t\t\t\t\t\t\t\t\t\t  ** = p < .01 \n');
    fprintf('\n\t\t\t\t\t\t\t\t\t\t\t *** = p < .001 \n');
end
