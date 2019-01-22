// Set the n-th page table with virtual address vadr to (padr + perm)
// 0th page map has been reserved for the kernel thread, 
// which cannot be modified after the initialization
Function ptInsert_spec (nn vadr padr perm: Z) (adt: RData) : option (RData * Z) :=
  match (ikern adt, ihost adt, ipt adt, pg adt, pt_Arg nn vadr padr (nps adt)) with
  | (true, true, true, true, true) =>
    match ZtoPerm perm with
    | Some p => let pt := ZMap.get nn (ptpool adt) in
                let pdi := PDX vadr in
                let pti := PTX vadr in
                match ZMap.get pdi pt with
                // update a page table
                | PDEValid pi pdt =>
                  match ptInsertPTE_spec nn vadr padr p adt with
                  | Some adt1 => Some (adt1, 0) | _ => None
                  end
                | PDEUnPresent =>
                  // create a page table
                  match ptAllocPDE_spec nn vadr adt with
                  | Some (adt1, v) =>
                    if zeq v 0 then Some (adt1, MagicNumber)
                    // update a page table
                    else match ptInsertPTE_spec nn vadr padr p adt1 with
                         | Some adt2 => Some (adt2, v) | _ => None
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
  // allocate a page
  match palloc_spec n adt with
  | Some (adt1, b) =>
    if zeq b 0 then Some (adt1, MagicNumber)
    // update the page table for the newly allocated page
    else ptInsert_spec n vadr b perm abd'
  | _ => None
  end.
