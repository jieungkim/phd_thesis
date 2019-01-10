typedef struct _mcs_lock{
  uint last;
  mcs_node ndpool[TOTAL_CPU];
}mcs_lock;
