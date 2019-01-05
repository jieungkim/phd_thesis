void mcs_acquire(uint lk_id){
  uint cpuid, prev;
  cpuid = get_CPU_ID();
  LK[lk_id].ndpool[cpuid].busy = BUSY;
  LK[lk_id].ndpool[cpuid].next = TOTAL_CPU;
  prev = FAS(&(LK[lk_id].last),cpuid);
  if(prev == TOTAL_CPU) return;
  LK[lk_id].ndpool[prev].next = cpuid;
  while(LK[lk_id].ndpool[cpuid].busy==BUSY);
  return;
}
void mcs_release(uint lk_id){
  uint cpuid, nid;
  cpuid = get_CPU_ID();
  if(CAS(&(LK[lk_id].last),cpuid,TOTAL_CPU) return;
  while (LK[lk_id].ndpool[cpuid].next== TOTAL_CPU);
  nid = LK[lk_id].ndpool[cpuid].next;
  LK[lk_id].ndpool[nid].busy = FREE;
  return;
}
