void mcs_set_next(uint lk_id, uint cpuid, uint pv_id){
    mcs_log(lk_id, cpuid);
    mcs_SET_NEXT(lk_id, cpuid, pv_id); }
