   Function single_big_ipc_send_body_spec (chid vaddr scount : Z) (adt : PData) : option (PData * Z) :=
      let sh_adt := fst adt in
      let pv_adt := snd adt in
      let curid := ZMap.get (CPU_ID sh_adt) (cid sh_adt) in
      (*let chid := slp_q_id cv 0 in*)
      match (init sh_adt, pg sh_adt, ikern pv_adt, ihost pv_adt, ipt pv_adt,
             B_inLock (CPU_ID sh_adt) (big_log sh_adt)) with
        | (true, true, true, true, true, true) =>
          if zle_lt 0 chid num_chan then
            (*match single_get_kernel_pa_spec curid vaddr adt with
            | Some skpa =>
              if zle_le 0 skpa Int.max_unsigned then*)
            match ZMap.get chid (syncchpool pv_adt) with
              | SyncChanValid sender spaddr _ busy =>
                let asendval := Z.min (scount) (1024) in
                match single_big_page_copy_spec chid asendval vaddr adt with
                  | Some adt' =>
                    Some (fst adt', (snd adt') {pv_syncchpool :
                                                  ZMap.set chid
                                                           (SyncChanValid sender spaddr (Int.repr asendval) busy)
                                                           (syncchpool (snd adt'))}, asendval)
                  | _ => None
                end
              (*| _ => None
                end
              else None*)
              | _ => None
            end
          else None
        | _ => None
      end.
