Function palloc'_spec (n: Z) (adt: RData): option (RData * Z) := 
  match acquire_lock_AT_spec adt with
    | Some adt' => 
      match palloc_aux_spec n adt' with
        | Some (adt0, i) =>
          match release_lock_AT_spec adt0 with
            | Some adt'' => Some (adt'', i)
            | _ => None end
        | _ => None end
    | _ => None end.
