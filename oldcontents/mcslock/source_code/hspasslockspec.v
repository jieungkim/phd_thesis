Function mcs_pass_hslock_spec (index ofs :Z) (adt: RData) : option RData :=
  let cpu := CPU_ID adt in
  match (ikern adt, ihost adt, index2Z index ofs) with
  | (true, true, Some abid) =>
    match ZMap.get abid (multi_log adt), ZMap.get abid (lock adt) with
    | MultiDef l, LockOwn =>
      let l' := (TEVENT cpu (TTICKET REL_LOCK)):: l in
      match H_CalLock l' with
      | Some _ => Some adt {multi_log: ZMap.set abid (MultiDef l') (multi_log adt)}
                           {lock: ZMap.set abid LockFalse (lock adt)}
      | _ => None
      end
   | _,_ => None
   end
  | _ => None
  end.