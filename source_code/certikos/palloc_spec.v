Function palloc_spec (n: Z) (adt: RData): option (RData * Z) :=
  let c := ZMap.get n (AC adt) in
  <@$\cdots$@>
    match ZMap.get abid (multi_log adt), ZMap.get AT (lock adt) with
    | MultiDef l, LockFalse =>
      // query the environmental context
      let to := ZMap.get AT (multi_oracle adt) in
      let l1 := (to (CPU_ID add) l) ++ l in
      // check quota
      if (cusage c) <? (cquota c) then
        let cur := mkContainer (cquota c) (cusage c + 1) (cparent c)
                               (cchildren c) (cused c) in
        // calculate the current page allocation table
        match CalAT_log_real l1 with
        | Some a =>
          // find out the available page
          match first_free a (nps adt) with
          | inleft (exist i _) =>
            // add the proper event (OPALLOCE i)
            let l_res := (TEVENT (CPU_ID adt) (TSHARED (OPALLOCE i))) :: l1 in
            Some (adt {multi_log: ZMap.set abid (MultiDef l_res) (multi_log adt)}
                      {pperm: ZMap.set i PGAlloc (pperm adt)}
                      {AC: ZMap.set n cur (AC adt)},i)
          | _ => 
  <@$\cdots$@>
