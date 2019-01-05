Function mcs_set_next_spec (abid cpuid prev_id: Z) (adt:RData) : option RData :=
  match (ikern adt, ihost adt) with
    | (true, true) =>
      if zle_lt 0 abid lock_range then
        if zle_lt 0 cpuid TOTAL_CPU then
          if zle_lt 0 prev_id TOTAL_CPU then
            match ZMap.get abid (multi_log adt) with
              | MultiDef l =>
                let to := ZMap.get abid (multi_oracle adt) in
                let l1 := (to cpuid l) ++ l in
                match CalMCSLock l1 with
                  | Some _ => let l' := (TEVENT cpuid (TTICKET (SET_NEXT prev_id))) :: l1 in
                              Some adt {multi_log: ZMap.set abid (MultiDef l') (multi_log adt)}
                  | _ => None
                end
              | _ => None
            end
          else None
        else None
      else None
    | _ => None
  end.