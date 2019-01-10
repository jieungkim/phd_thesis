  Fixpoint Calculate_BRecv (n : nat) (curid : Z) (sock_fds: PaxosSocketFDs) (net_o : WSNetOracle)
           (net_l : Network) := 
    match n with
    | O => Calculate_BRecv_at_i O curid sock_fds net_o net_l
    | S n' => Calculate_BRecv_at_i (S n') curid sock_fds net_o (Calculate_BRecv n' curid sock_fds net_o net_l)
    end.
  
  Function wor_capture_helper_high_spec (addr : Z) (adt : RData) : option (RData * Z) :=
    let curid := ZMap.get (CPU_ID adt) (cid adt) in
    match (ikern adt, ihost adt, init adt, ZMap.get curid (sk_init_flag adt), in_dec zeq curid PROPS_SET,
           zle_lt 0 addr LOG_SIZE, ZMap.get curid (network adt)) with
    | (true, true, true, true, left _, left _, NetValid net_l) =>
      let pre_l := (GHOST curid (PRE_P PRE_EV addr None None)::net_l) in
      match CAL_WS_STATES pre_l with
      | Some (GSTATE _ prop_lsts _) =>
        match ZMap.get curid prop_lsts with
        | PSTATE (PST _ ps_status) _ (Some pkt) =>
          match (ZMap.get addr ps_status) with
          | (IN_P new_prop _ _ _ _ _ _)::_ => 
            let wq_l := Calculate_BRecv (Z.to_nat (NUM_ACC -1)) curid (paxos_sockets adt)
                                        (net_oracle adt) (pkt::pre_l) in
            let post_l := (GHOST curid (POST_P PRE_EV addr new_prop)::wq_l) in
            match CAL_WS_STATES post_l with
            | Some (GSTATE _ prop_lsts _) => 
              match ZMap.get curid prop_lsts with 
              | PSTATE (PST _ ps_status') _ None =>
                match ZMap.get addr ps_status' with
                | (OUT_P _ _ _ _ q_v_l _ _)::_ => Some (adt {network: ZMap.set curid (NetValid post_l) 
                                                                               (network adt)}, cal_res q_v_l)
                | _ => None
                end
              | _ => None
              end
            | _ => None
            end
          | _ => None
          end
        | _ => None
        end
      | _ => None
      end
    | _ => None
    end.
  
  Function wor_write_helper_high_spec (addr : Z) (cmd0 cmd1 : Z) (adt : RData) : option (RData * Z) :=
    let curid := ZMap.get (CPU_ID adt) (cid adt) in
    match (ikern adt, ihost adt, init adt, ZMap.get curid (sk_init_flag adt), in_dec zeq curid PROPS_SET,
           zle_lt 0 addr LOG_SIZE, ZMap.get curid (network adt),  PC_of_Z cmd0,
           zle_le 0 cmd1 Int.max_unsigned) with
    | (true, true, true, true, left _, left _, NetValid net_l, Some cmd0', left _) =>
      let pre_l := (GHOST curid (PRE_P ACC_EV addr (Some cmd0') (Some cmd1))::net_l) in
      match CAL_WS_STATES pre_l with
      | Some (GSTATE _ prop_lsts _) =>
        match ZMap.get curid prop_lsts with
        | PSTATE (PST _ ps_status) _ (Some pkt) =>
          match ZMap.get addr ps_status with
          | ((IN_A new_prop _ _ _ _ _ _)::_) =>
            let wq_l := Calculate_BRecv (Z.to_nat (NUM_ACC -1)) curid (paxos_sockets adt)
                                        (net_oracle adt) (pkt::pre_l) in
            let post_l := (GHOST curid (POST_P ACC_EV addr new_prop)::wq_l) in
            match CAL_WS_STATES post_l with
            | Some (GSTATE _ prop_lsts _) => 
              match ZMap.get curid prop_lsts with 
              | PSTATE (PST _ ps_status') _ None =>
                match ZMap.get addr ps_status' with
                | ((OUT_A _ _ _ _ q_v_l _ _)::_) => Some (adt {network: ZMap.set curid (NetValid post_l) 
                                                                             (network adt)}, cal_res q_v_l)
                | _ => None
                end
              | _ => None
              end
            | _ => None
            end
          | _ => None
          end
        | _ => None
        end
      | _ => None
      end
    | _ => None
    end.
                
  
  Function wor_read_helper_high_spec (addr : Z) (adt : RData) : option (RData * Z) :=
    let curid := ZMap.get (CPU_ID adt) (cid adt) in
    match (ikern adt, ihost adt, init adt, ZMap.get curid (sk_init_flag adt), in_dec zeq curid PROPS_SET,
           zle_lt 0 addr LOG_SIZE, ZMap.get curid (network adt)) with
    | (true, true, true, true, left _, left _, NetValid net_l) =>
      let pre_l := (GHOST curid (PRE_P READ_EV addr None None)::net_l) in
      match CAL_WS_STATES pre_l with
      | Some (GSTATE _ prop_lsts _) =>
        match ZMap.get curid prop_lsts with
        | PSTATE (PST _ ps_status) _ (Some pkt) =>
          match ZMap.get addr ps_status with
          | ((IN_R new_prop _ _ _ _ _ _)::_) => 
            let wq_l := Calculate_BRecv (Z.to_nat (NUM_ACC -1)) curid (paxos_sockets adt) 
                                        (net_oracle adt) (pkt::pre_l) in
            let post_l := (GHOST curid (POST_P READ_EV addr new_prop)::wq_l) in
            match CAL_WS_STATES post_l with
            | Some (GSTATE _ prop_lsts _) => 
              match ZMap.get curid prop_lsts with 
              | PSTATE (PST _ ps_status') _ None =>
                match ZMap.get addr ps_status' with
                | ((OUT_R res _ _ _ _ _ _ _)::_) => Some (adt {network: ZMap.set curid (NetValid post_l)
                                                                                 (network adt)}, res)
                | _ => None
                end
              | _ => None
              end
            | _ => None
            end
          | _ => None
          end
        | _ => None
        end
      | _ => None
      end
    | _ => None
    end.
