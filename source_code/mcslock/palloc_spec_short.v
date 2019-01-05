Function palloc'_spec (n: Z) (adt: RData): option (RData * Z) := 
  match acquire_lock_AT_spec adt with
  | Some adt1 => match palloc_aux_spec n adt1 with
                 | Some (adt2, i) =>
                   match release_lock_AT_spec adt2 with
                   | Some adt3 => Some (adt3, i)
                   | _ => None end
                 | _ => None end
  | _ => None end.
