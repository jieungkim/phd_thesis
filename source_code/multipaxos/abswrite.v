Function WOR_abs_write (addr: Z) (val: Payload) (node_id: Z) 
  (adt: EnvVars) : option (EnvVars * Z) :=
  // get net log from Env context
  let net_l := adt.net_l
  // get current node id 
  let nid := get_node_id adt in 
  // replay the net log; get the local node state; and check 
  // if the node is in a writable status 
  if (can_write ((replay_log(net_l))[nid]) addr val cid)
  then // log write intent with a ghost msg to the net log 
       let net_l<@$_1$@> := (ghost_write nid addr val cid) :: net_l in
       // broadcast msgs and collect acks: 
       // reflect behaviors of other nodes to add send/recv 
       // events by this and other nodes to the net log 
       let net_l<@$_2$@> := bcast_n_recv nid addr val cid net_l<@$_1$@> adt in
       // replay the net log to compute global state; 
       // get node's local state; and check the quorum status 
       let result := is_qrm ((replay_log(net_l<@$_2$@>))[nid]) addr in
       // log the result using a ghost msg to the net log
       let net_l<@$_3$@> := (ghost_result nid result) :: net_l<@$_2$@> in
       // return the updated net log and the result 
       (adt{net_l := net_1<@$_3$@>}, result)
  else None.