Definition mcs_wait_hlock_spec(bound index ofs :Z)(adt: RData): option RData:=
  ...
  let to := ZMap.get abid (multi_oracle adt) in
  let l1 := (to cpu l) ++ l in
  let l' := (TEVENT cpu (TTICKET (WAIT_LOCK (Z.to_nat bound)))) :: l1 in
  match H_CalLock l' with
  | Some _ = >Some adt {multi_log:ZMap.set abid (MultiDef l') (multi_log adt)}
  ...
