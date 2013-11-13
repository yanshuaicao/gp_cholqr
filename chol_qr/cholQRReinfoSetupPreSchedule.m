function RIPParams = cholQRReinfoSetupPreSchedule(P,k,RIPParams)
    if  isProperlySet(RIPParams,'pre_scheduled_reinfo') && RIPParams.pre_scheduled_reinfo
        RIPParams.pre_schedule = randperm(k-1);
        if isProperlySet(RIPParams,'num_info_revisit')
            RIPParams.num_info_revisit = min(ceil(RIPParams.num_info_revisit), RIPParams.max_num_info_revisit);
            RIPParams.pre_schedule = RIPParams.pre_schedule(1:RIPParams.num_info_revisit);
        else
            RIPParams.pre_schedule = RIPParams.pre_schedule(1:RIPParams.max_num_info_revisit);
        end
        %fprintf('Prescheduled reinfo inds:\n');
        %disp(RIPParams.pre_schedule)
    end
end