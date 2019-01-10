void mcs_release(unsigned int lk_id){
  unsigned int cpuid, nid;

  // pre-setting
  cpuid = get_CPU_ID();
    
  if(CAS(&LK[lk_id].last, cpuid, 
         NULL){
    return;
  } else {
    // busy waiting
    while (LK[lk_id].ndpool[curid].next 
           == NULL);       
    nid = LK[lk_id].ndpool[curid].next;
    LK[lk_id].ndpool[nid].busy = FREE;
    return; 
  } 
}
