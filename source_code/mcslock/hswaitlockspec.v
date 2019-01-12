Definition wait_hlock_spec (bound index ofs :Z) (adt: RData) : option RData :=
  let cpu := CPU_ID adt in
  match (ikern adt, ihost adt, index2Z index ofs) with
  | (true,  true, Some abid) =>
   match ZMap.get abid (multi_log adt), ZMap.get abid (lock adt) with
   | MultiDef l, LockFalse =>
     let <@$\mathcal{E}_{lock(abid)}$@> := ZMap.get abid (multi_oracle adt) in
     let l1 := (<@$\mathcal{E}_{lock(abid)}$@> cpu l) ++ l in
     let l' := (TEVENT cpu (TTICKET (WAIT_LOCK (Z.to_nat bound)))) :: l1 in
     match H_CalLock l' with
     | Some _ =>
       Some adt {multi_log: ZMap.set abid (MultiDef l') (multi_log adt)}
                {lock: ZMap.set abid (LockOwn false) (lock adt)}
     | _ => None end
   | _, _ => None end
  | _ => None end.
