function CloseAndCleanup(P)
% Used for closing screens and ports after experiments finishes or crashes.
ListenChar(0);
Screen('CloseAll');
% ListenChar(1)
ShowCursor;
Priority(0);

if P.setup.isEEG
    SendTrigger(P.trigger.stop_recording, P.trigger.duration);
    CloseTriggerPort
end


end