Definition big_proc_create_spec (adt: RData) (b bkc buc: block) (ofs_uc: int) (q: Z) 
  : option (RData * Z) :=
  let curid := ZMap.get (CPU_ID adt) (cid adt) in
  let c := ZMap.get curid (AC adt) in
  // assign a new thread ID for the child
  let i := curid * max_children + 1 + Z_of_nat (length (cchildren c)) in
    // check the validity of the quota (given as an argument)
    match (zle_le 0 q (cquota c - cusage c), <@$\cdots$@>
    <@$\cdots$@>
    // create the container for the child
    let child := mkContainer q 0 curid nil true in
    // adjust the container information for the parent
    let parent := (mkContainer (cquota c) (cusage c + q)
                               (cparent c) (i :: cchildren c) (cused c)) in
    match big_log adt with
    | BigDef l =>
      let ofs := Int.repr ((i + 1) * PgSize -4) in
      let to := big_oracle adt in
      let l1 := (to (CPU_ID adt) l) ++ l in
      // add the thread spawn event
      let e := TBSHARED (BTDSPAWN curid i q ofs buc ofs_uc) in
      let l_res := (TBEVENT cpu e) :: l1 in
      <@$\cdots$@>
        // build the new kernel context for the child
        let rs := ((ZMap.get i (kctxt adt))#SP <- (Vptr b ofs))
                   #RA <- (Vptr bkc Int.zero) in
        // build the new user context for the child
        let uctx := <@$\cdots$@>
        // return the new state and the child's thread ID
        Some (adt {big_log: BigDef l_res}
                  {AC: ZMap.set i child (ZMap.set curid parent (AC adt))}
                  {kctxt: ZMap.set i rs (kctxt adt)}
                  {uctxt: ZMap.set i uctx (uctxt adt)}, i)
      <@$\cdots$@>
