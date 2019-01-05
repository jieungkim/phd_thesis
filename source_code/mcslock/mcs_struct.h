typedef struct _mcs_node{
  uint next;
  uint busy;
  uint _node_padding[14];    
}mcs_node;
typedef struct _mcs_lock{
  uint last;
  uint _lock_padding[15];    
  mcs_node ndpool[TOTAL_CPU];
}mcs_lock;
