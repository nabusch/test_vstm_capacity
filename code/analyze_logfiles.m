%%
clear

% logs = dir('./logs/*.mat')
dir_logs = './logs/';
log_inds = [4 5 6 7 8, 101, 102, 103];

%%
figure('color', 'w');
hold on

legstr = {};

for ilog = 1:length(log_inds)
    
    logname = fullfile(dir_logs, [num2str(log_inds(ilog)) '_Logfile.mat']);
    load(logname)
    
    legstr{ilog} = num2str(log_inds(ilog));
    
    P = INFO.P;
    
    correct = [INFO.T.correct];
    ss{ilog}      = [INFO.T.setsize];
    
    for iss = 1:length(P.paradigm.setsizes)
        
        this_ss = P.paradigm.setsizes(iss);
        
        p{ilog}(iss) = sum(correct & ss{ilog}==this_ss) / sum(ss{ilog}==this_ss);
        k{ilog}(iss) = this_ss * (2*p{ilog}(iss) - 1);
    end
    
    axh(1) = subplot(2,1,1); hold all
    ph = plot(unique(ss{ilog}), k{ilog}, 'o-');
    ph.MarkerFaceColor = ph.Color;

    axh(2) = subplot(2,1,2); hold all
    ph = plot(unique(ss{ilog}), p{ilog}, 'o-');
    ph.MarkerFaceColor = ph.Color;
end
hold off
set(axh, 'XTick', unique(ss{ilog}))
set(axh(1), 'ylim', [0 5])
set(axh(2), 'ylim', [0.45 1.01])
xlabel(axh(2), 'Set Size')
ylabel(axh(1), 'K')
ylabel(axh(2), 'p_{correct}')
title(axh(1), 'Memory capacity')
title(axh(2), 'Accuracy')
legend(legstr, 'location', 'South')



