void mcs_SET_NEXT(uint lk_id, uint cpuid, uint pv_id) {
    mcs_SET_NEXT_log(lk_id, cpuid, pv_id);
    (LK[lk_id].ndpool[pv_id]).next = cpuid; }
