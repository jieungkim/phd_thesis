Function single_big_ipc_receive_body_spec (chid vaddr rcount : Z) (adt : PData) : option (PData * Z) :=
  let sh_adt := fst adt in
  let pv_adt := snd adt in
  let curid := ZMap.get (CPU_ID sh_adt) (cid sh_adt) in
  match (init sh_adt, pg sh_adt, ikern pv_adt, ihost pv_adt, ipt pv_adt,
         B_inLock (CPU_ID sh_adt) (big_log sh_adt)) with
    | (true, true, true, true, true, true) =>
      if zle_lt 0 chid num_chan then
        match ZMap.get chid (syncchpool pv_adt) with
          | SyncChanValid sender spaddr scount busy =>
            let arecvcount := Z.min (Int.unsigned scount) rcount in
            match single_big_page_copy_back_spec chid arecvcount vaddr adt with
              | Some adt1 =>
                Some ((fst adt1), (snd adt1)
                                    {pv_syncchpool:
                                       ZMap.set chid
                                                (SyncChanValid sender spaddr Int.zero busy)
                                                (syncchpool (snd adt1))}, arecvcount)
              | _ => None
            end
          | _ => None
        end
      else None
    | _ => None
  end.
