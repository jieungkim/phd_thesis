Function mcs_SET_NEXT_log_spec(abid cpuid prev_id: Z)(adt:RData): option RData:=
    ...
    match ZMap.get abid (multi_log adt) with
    | MultiDef l => 
      let l' := (... (SET_NEXT prev_id))) :: l in
      Some adt {multi_log: ZMap.set abid (MultiDef l') (multi_log adt)}
    ...
  end.

