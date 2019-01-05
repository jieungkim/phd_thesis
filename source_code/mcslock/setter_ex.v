Function mcs_SET_NEXT_spec (abid cpuid prev_id: Z) (adt:RData) : option RData :=
  match (ikern adt, ihost adt) with
    | (true, true) =>
      if zle_lt 0 abid lock_range then
        if zle_lt 0 cpuid TOTAL_CPU then
          if zle_lt 0 prev_id TOTAL_CPU then
            match ZMap.get abid (multi_log adt) with
              | MultiDef l =>
                let l' := (TEVENT cpuid (TTICKET (SET_NEXT prev_id))) :: l in
                Some adt {multi_log: ZMap.set abid (MultiDef l') (multi_log adt)}
              | _ => None
            end
          else None
        else None
      else None
    | _ => None
  end.