     those adjacent packets separately *)
  Fixpoint valid_net_pattern (net_l : Network) :=
    match net_l with 
    | nil => true
    (* ASEND and ARECV are always appeared as a pair *)               
    | (SEND (ASEND to msg))::(RECV owner (ARECV msg'))::net_l' =>
      if valid_net_pattern net_l' then 
        if zeq to (pm_from msg') then 
          if zeq (pm_from msg) owner then true 
          else false else false else false
    (* PBSEND and PRE_ONCE are always appeared as a pair *)                                       
    | (SEND (PBSEND msg))::(GHOST owner (PRE_P ty addr cmd0 cmd1))::net_l' =>  
      if valid_net_pattern net_l' then 
        if zeq owner (pm_from msg) then
          if zeq addr (pm_addr msg) then true
          else false else false else false
    (* simplify unnecessary conditions for our proofs to make the invariant proof easy - we can enrich the conditions on the following cases in the future *)
    (* POST_WAIT_Q and (PBRECV or PBTIME_OUT for the last acceptor) are always appeared as a apair *)
    | (GHOST owner (POST_P ty addr prop))::(RECV owner' (PBRECV index addr' prop' ty' msg))::net_l' =>
      if valid_net_pattern net_l' then true else false
    | (GHOST owner (POST_P ty addr prop))::(RECV owner' (PBTIME_OUT index addr' prop' ty'))::net_l' =>
      if valid_net_pattern net_l' then true else false
    (* PBRECV and PBTIME_OUT can be appeared separately *)
    | (RECV owner (PBRECV index addr prop ty msg))::net_l' =>
      if valid_net_pattern net_l' then true else false
    | (RECV owner (PBTIME_OUT index addr prop ty))::net_l' =>
      if valid_net_pattern net_l' then true else false
    (* CLSEND AND CLRECV does not have any restrictions *)
    | (SEND (CLSEND to msg))::net_l' => valid_net_pattern net_l'
    | (RECV owner (CLRECV msg))::net_l' => valid_net_pattern net_l'
    (* the above cases are the only cases that we need to consider *)
    | _ => false
    end.