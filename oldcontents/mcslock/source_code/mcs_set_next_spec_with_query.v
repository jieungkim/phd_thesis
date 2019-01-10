  ...
  match ZMap.get abid (multi_log adt) with
  | MultiDef l =>
    let to := ZMap.get abid (multi_oracle adt) in
    let l1 := (to cpuid l) ++ l in
    match CalMCSLock l1 with
    ....   
    end
  | _ => None
  end
  ...
