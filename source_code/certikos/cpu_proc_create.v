Definition big_proc_create_spec (adt: RData) (b b' buc: block) (ofs_uc: int) q : option (RData * Z) :=
  let cpu := CPU_ID adt in
  let curid := ZMap.get (CPU_ID adt) (cid adt) in
  let c := ZMap.get curid (AC adt) in
  let i := curid * max_children + 1 + Z_of_nat (length (cchildren c)) in
  match (pg adt, ikern adt, ihost adt, ipt adt,cused c, cused (ZMap.get i (AC adt)), zlt_lt 0 i num_proc,
       zlt (Z_of_nat (length (cchildren c))) max_children,
       zle_le 0 q (cquota c - cusage c)) with
  | (true, true, true, true, true, false, left _, left _, left _) =>
    let child := mkContainer q 0 curid nil true in
    let parent := (mkContainer (cquota c) (cusage c + q)
                               (cparent c) (i :: cchildren c) (cused c)) in
    match big_log adt with
    | BigDef l =>
      let ofs := Int.repr ((i + 1) * PgSize -4) in
      let to := big_oracle adt in
      let l1 := (to cpu l) ++ l in
      let e := TBSHARED (BTDSPAWN curid i q ofs
                                  buc ofs_uc) in
      let l' := (TBEVENT cpu e) :: l1 in
      match B_CalTCB_log_real l' with
      | Some _ =>
        let rs := ((ZMap.get i (kctxt adt))#SP <- (Vptr b ofs))#RA <- (Vptr b' Int.zero) in
        let uctx0 := ZMap.get i (uctxt adt) in
        let uctx1 := ZMap.set U_SS CPU_GDT_UDATA
                              (ZMap.set U_CS CPU_GDT_UCODE
                                        (ZMap.set U_DS CPU_GDT_UDATA
                                                  (ZMap.set U_ES CPU_GDT_UDATA uctx0))) in
        let uctx2 := ZMap.set U_EIP (Vptr buc ofs_uc)
                              (ZMap.set U_EFLAGS FL_IF
                                        (ZMap.set U_ESP (Vint STACK_TOP) uctx1)) in
        Some (adt {big_log: BigDef l'}
                  {AC: ZMap.set i child (ZMap.set curid parent (AC adt))}
                  {kctxt: ZMap.set i rs (kctxt adt)}
                  {uctxt: ZMap.set i uctx2 (uctxt adt)}, i)
      | _ => None
      end
    | _ => None
    end
  | _ => None
  end.
