  Fixpoint CAL_WS_STATES (net_l : Network) : option WS_GST :=
    match net_l with
    | nil =>  Some (GSTATE (ZMap.init INIT_WS_ACCS_LST) (ZMap.init INIT_WS_PROPS_LST) 
                           (ZMap.init (NMap.init nil)))
    | hd_pkt::net_l' =>
      match CAL_WS_STATES net_l' with
      | Some (GSTATE acc_lsts prop_lsts w_table)  =>
        match hd_pkt with

        (* HOST - acceptors *)
        (* send from acceptors - pop and check *) 
        | SEND (ASEND to msg) => match ZMap.get (pm_from msg) acc_lsts with
                                | ASTATE ps_st (Some temp_pkt) =>
                                  if isValidASend to (pm_from msg) (pm_addr msg) net_l' 
                                  then if Packet_dec hd_pkt temp_pkt 
                                       then Some (GSTATE (ZMap.set (pm_from msg) (ASTATE ps_st None) 
                                                                   acc_lsts) prop_lsts w_table)
                                       else None else None
                                | _ => None
                                end

        (* recv - update state *)
        | RECV owner (ARECV msg) => match CAL_HOST_RECV owner msg (ZMap.get owner acc_lsts) with
                                   | Some acc_lst' => Some (GSTATE (ZMap.set owner acc_lst' acc_lsts)
                                                                   prop_lsts w_table)
                                   | _ => None
                                   end

         (* broadcast - pop and check *)
        | SEND (PBSEND msg) => match ZMap.get (pm_from msg) prop_lsts with
                              | PSTATE (PST (BUSY addr) pst) ps_st (Some temp_pkt) =>
                                match get_new_w_table (pm_type msg) (pm_addr msg) (pm_prop msg)
                                                      (ZMap.get (pm_addr msg) pst) w_table with
                                | Some w_table' =>
                                  if zeq addr (pm_addr msg) 
                                  then if isValidPBSend (pm_from msg) (pm_addr msg) (ZMap.get (pm_addr msg) 
                                                                                              pst) net_l' 
                                       then if Packet_dec (SEND (PBSEND msg)) temp_pkt
                                            then Some (GSTATE acc_lsts
                                                              (ZMap.set (pm_from msg)
                                                                        (PSTATE (PST (BUSY addr) pst)
                                                                                ps_st None) prop_lsts) 
                                                              w_table')
                                            else None else None else None
                                | _ => None
                                end
                              | _ => None
                              end

        (* recv - proposers *)                                     
        | RECV owner (PBRECV  sockfd addr prop ty msg) =>
          match CAL_PBRecv ty sockfd  addr prop msg hd_pkt (ZMap.get owner prop_lsts) with
          | Some prop_lst' => Some (GSTATE acc_lsts (ZMap.set owner prop_lst' prop_lsts) w_table)
          | _ => None
          end
                               
        (* recv - proposers *)
        | RECV owner (PBTIME_OUT index addr prop ty) =>
          match CAL_TIME_OUT ty index addr prop hd_pkt (ZMap.get owner prop_lsts) with
          | Some prop_lst' => Some (GSTATE acc_lsts (ZMap.set owner prop_lst' prop_lsts) w_table)
          | _ => None
          end
            
        (* ghost - proposers *)                                       
        | GHOST owner (PRE_P ty addr cmd0_op cmd1_op) =>
          match CAL_PRE_ONCE owner ty addr cmd0_op cmd1_op (ZMap.get owner prop_lsts) net_l' with
          | Some prop_lst' => Some (GSTATE acc_lsts (ZMap.set owner prop_lst' prop_lsts) w_table)
          | _ => None
          end
            
        (* ghost - proposers *)                                             
        | GHOST owner (POST_P ty addr prop) =>
          match CAL_POST_WAIT_Q owner ty addr prop net_l' (ZMap.get owner prop_lsts) with
          | Some prop_lst' => Some (GSTATE acc_lsts (ZMap.set owner prop_lst' prop_lsts) w_table)
          | _ => None
          end

                                                     
        (* clients  - it will not change any paxos states  *)
        | RECV owner (CLRECV _) => 
          match ZMap.get owner prop_lsts with
          | PSTATE (PST IDLE _) _ _ => Some (GSTATE acc_lsts prop_lsts w_table)
          | _ => None 
          end

        | SEND (CLSEND _ msg) =>
          match ZMap.get (pm_from msg) prop_lsts with
          | PSTATE (PST IDLE _) _ _ => Some (GSTATE acc_lsts prop_lsts w_table)
          | _ => None 
          end
            
        | _ => None
        end
      | _ => None
      end
    end.
   
  Definition CAL_WS_STATES_WRAP (net_st : NetworkDef) : option WS_GST :=
    match net_st with
    | NetUndef => Some (GSTATE (ZMap.init (ASTATE (ZMap.init PSSUndef) None))
                              (ZMap.init (PSTATE (PST IDLE (ZMap.init nil)) (ZMap.init PSSUndef) None))
                              (ZMap.init (NMap.init nil)))
    | NetValid net_l => CAL_WS_STATES net_l
    end.