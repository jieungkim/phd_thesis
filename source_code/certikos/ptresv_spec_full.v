// primitve: set the n-th page table with virtual address vadr to (padr + perm)
// The pt insert at this layer, is slightly different from the one at MPTComm.
// 0th page map] has been reserved for the kernel thread, 
// hich couldn't be modified after the initialization
Function ptInsert0_spec (nn vadr padr perm: Z) (adt: RData) : option (RData * Z) :=
  match (ikern adt, ihost adt, ipt adt, pg adt, pt_Arg nn vadr padr (nps adt)) with
  | (true, true, true, true, true) =>
    match ZtoPerm perm with
    | Some p =>
        let pt := ZMap.get nn (ptpool adt) in
        let pdi := PDX vadr in
        let pti := PTX vadr in
        match ZMap.get pdi pt with
        | PDEValid pi pdt =>
          match ptInsertPTE0_spec nn vadr padr p adt with
          | Some adt' => Some (adt', 0)
          | _ => None
          end
        | PDEUnPresent =>
          match ptAllocPDE0_spec nn vadr adt with
          | Some (adt', v) =>
            if zeq v 0 then Some (adt', MagicNumber)
            else
              match ptInsertPTE0_spec nn vadr padr p adt' with
              | Some adt'' => Some (adt'', v)
              | _ => None
              end
          | _ => None
          end
        | _ => None
        end
    | _ => None
    end
  | _ => None
  end.


Function ptResv_spec (n vadr perm: Z) (adt: RData): option (RData * Z) :=
  match palloc_spec n adt with
  | Some (abd', b) =>
    if zeq b 0 then Some (abd', MagicNumber)
    else ptInsert0_spec n vadr b perm abd'
  | _ => None
  end.
