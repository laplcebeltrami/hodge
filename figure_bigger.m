function figure_bigger(c)
%
% function figure_bigger(c)
% 
% The function makes the fonts used in the figure bigger
%
% (C) 2013-. Moo K. Chung
% Department of Biostatistics and Medical Informatics
% University of Wisconsin-Madison
%
% mkchung@wisc.edu
% Update: November 27, 2013

set(gca, 'Fontsize',c);
%title(gcf, 'FontSize', c)