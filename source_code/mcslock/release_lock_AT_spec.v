Definition release_lock_AT_spec (adt) := 
let abid := 0 in
let cpu := CPU_ID adt in
let (b, b0) := (ikern adt, ihost adt) in
if b
then
 if b0
 then
  match ZMap.get abid (multi_log adt) with
  | MultiUndef => None
  | MultiDef l =>
      match ZMap.get abid (lock adt) with
      | LockFalse => None
      | LockOwn true =>
          let l' :=
            TEVENT cpu (TTICKET REL_LOCK)
            :: TEVENT cpu (TSHARED (OATE (AT adt))) :: l in
          match H_CalLock l' with
          | Some _ =>
              Some
                (adt {multi_log : ZMap.set abid (MultiDef l') (multi_log adt)})
                {lock : ZMap.set abid LockFalse (lock adt)}
          | None => None
          end
      | LockOwn false => None
      end
  end
 else None
else None
