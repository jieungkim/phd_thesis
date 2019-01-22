Function kctxt_switch_spec (adt: RData) (src des: Z) (rs: KContext) 
  : option (RData * KContext) :=
  match (pg adt, ikern adt, ihost adt, ipt adt) with
  | (true, true, true, true) =>
    if zle_lt 0 src num_proc then if zle_lt 0 des num_proc then
       if zeq src des then None
       else Some (adt {kctxt: ZMap.set src rs (kctxt adt)}
                  , ZMap.get des (kctxt adt))
      else None else None
  | _ => None
  end.
