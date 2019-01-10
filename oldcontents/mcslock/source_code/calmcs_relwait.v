Fixpoint CalMCS_RelWait (n: nat) (i : Z) (l: MultiLog) (to: MultiOracle) : option MultiLog :=
  match n with
    | O => None
    | S n' =>
      let l1 := (TEVENT i (TTICKET GET_NEXT)) :: (to i l) ++ l in
      match CalMCSLock l1 with
        | Some (MCSLOCK tail la _) =>
          match ZMap.get i la with
            | (_, p) => if zeq p NULL
                        then CalMCS_RelWait n' i l1 to
                        else
                          match CalMCSLock (to i l1 ++ l1) with
                            | Some (MCSLOCK tail' la' _) =>
                              match ZMap.get i la' with
                                | (_, p') => if zeq p' NULL then None
                                             else Some ((TEVENT i (TTICKET SET_BUSY)) :: (to i l1 ++ l1))
                              end
                            | _ => None
                          end
          end
        | _ => None
      end
  end.