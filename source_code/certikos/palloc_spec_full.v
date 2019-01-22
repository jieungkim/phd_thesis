Function palloc_spec (n: Z) (adt: RData): option (RData * Z) :=
  let abid := 0 in
  let cpu := CPU_ID adt in
  let c := ZMap.get n (AC adt) in
  match (ikern adt, ihost adt, pg adt, ipt adt, cused c) with
  | (true, true, true, true, true) =>
    match ZMap.get abid (multi_log adt), ZMap.get abid (lock adt) with
    | MultiDef l, LockFalse =>
      let to := ZMap.get abid (multi_oracle adt) in
      let l1 := (to cpu l) ++ l in
      if (cusage c) <? (cquota c) then
        let cur := mkContainer (cquota c) (cusage c + 1) (cparent c)
                               (cchildren c) (cused c) in
        match CalAT_log_real l1 with
        | Some a =>
          match first_free a (nps adt) with
          | inleft (exist i _) =>
            let l_res := (TEVENT cpu (TSHARED (OPALLOCE i))) :: l1 in
            Some (adt {multi_log: ZMap.set abid (MultiDef l_res) (multi_log adt)}
                      {pperm: ZMap.set i PGAlloc (pperm adt)}
                      {AC: ZMap.set n cur (AC adt)},i)
          | _ => 
            let l_res := (TEVENT cpu (TSHARED (OPALLOCE 0))) :: l1 in
            Some (adt{multi_log: ZMap.set abid (MultiDef l_res) (multi_log adt)}, 0)
          end
        | _ => None
        end
      else
        let l_res := (TEVENT cpu (TSHARED (OPALLOCE 0))) :: l1 in
        Some (adt{multi_log: ZMap.set abid (MultiDef l_res) (multi_log adt)}, 0)
    | _,_ => None
      end
  | _ => None
  end.