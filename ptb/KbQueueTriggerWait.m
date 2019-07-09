function KbQueueTriggerWait(device,key)
        while 1
            [pressed, firstPress] = KbQueueCheck(device);
            if pressed && find(firstPress)==KbName(key)
                 break
            end
        end
KbQueueFlush();
end

