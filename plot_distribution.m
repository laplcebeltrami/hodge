function plot_distribution(stat_s, observation)
%function plot_distribution(stat_s, observation)


histogram(stat_s,'FaceColor',[0.7 0.7 0.7],'Normalization', 'probability',...
    'NumBins',20);
hold on
plot([observation observation],[0 1],'--r','linewidth',2);
xlabel('Test Statistic')
ylabel('Probability')
set(gcf, 'Position', [400 400 600 250])
set(gca, 'fontsize',16) 


% (C) 2022 D. Vijay Anand, Moo K. Chung
%     University of Wisconsin-Madison
%  Contact mkchung@wisc.edu for support 
%
% Update history
%   2022 created Anand & Chung

