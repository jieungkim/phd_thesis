Function kctxt_switch_spec (adt: RData) (src des: Z) (rs: KCtxt) 
  : option (RData * KCtxt) :=
  <@$\cdots$@> 
  Some (adt {kctxt: ZMap.set src rs (kctxt adt)} , ZMap.get des (kctxt adt))
  <@$\cdots$@> 
