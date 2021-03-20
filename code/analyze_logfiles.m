%%
clear

% logs = dir('./logs/*.mat')
dir_logs = './logs/';
log_inds = [4 5 6 51];

%%
figure('color', 'w');
hold on
for ilog = 1:length(log_inds)
    
    logname = fullfile(dir_logs, [num2str(log_inds(ilog)) '_Logfile.mat']);
    load(logname)
    
    P = INFO.P;
    
    correct = [INFO.T.correct];
    ss{ilog}      = [INFO.T.setsize];
    
    for iss = 1:length(P.paradigm.setsizes)
        
        this_ss = P.paradigm.setsizes(iss);
        
        p{ilog}(iss) = sum(correct & ss{ilog}==this_ss) / sum(ss{ilog}==this_ss);
        k{ilog}(iss) = this_ss * (2*p{ilog}(iss) - 1);
    end
    
    axh(1) = subplot(2,1,1); hold all
    plot(unique(ss{ilog}), k{ilog}, 'o-')

    axh(2) = subplot(2,1,2); hold all
    plot(unique(ss{ilog}), p{ilog}, 'o-')
end
hold off
set(axh, 'XTick', unique(ss{ilog}))
set(axh(2), 'ylim', [0.5 1])
xlabel(axh, 'Set Size')
ylabel(axh(1), 'K')
ylabel(axh(2), 'p_{correct}')
title(axh(1), 'Memory capacity')
title(axh(2), 'Accuracy')




