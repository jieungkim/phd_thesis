  
  Function acceptor_handler_high_spec  (sockfd : Z) (adt : RData) : option (RData * Z) :=
    let curid := ZMap.get (CPU_ID adt) (cid adt) in        
    match (ikern adt, ihost adt, init adt, In_dec zeq curid ACCS_SET) with
    | (true, true, true, left _) =>
      match ZMap.get curid (network adt) with
      | NetValid net_l =>
        let res := ((net_oracle adt) curid sockfd net_l) in
        match CAL_WS_STATES (res++net_l) with
        | Some (GSTATE accs_lsts _ _) =>
          match ZMap.get curid accs_lsts with
          | ASTATE _ (Some pkt) => Some (adt {network: ZMap.set curid (NetValid (pkt::(res++net_l))) 
                                                                (network adt)}, STATUS_OK)
          | _ => None
          end
        | _ => None
        end
      | _ => None
      end
    | _ => None
    end.