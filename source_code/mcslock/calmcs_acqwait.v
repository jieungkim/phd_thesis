Fixpoint CalMCS_AcqWait (n: nat) (i : Z) (l: MultiLog) (to: MultiOracle) : option MultiLog :=
  match n with
    | O => None
    | S n' =>
      let l' :=  (to i l) ++ l in
      match CalMCSLock l' with
        | Some (MCSLOCK tail la _) =>
          match ZMap.get i la with
            | (false, _) => Some ((TEVENT i (TTICKET (GET_BUSY false))) :: l')
            | _ =>
              CalMCS_AcqWait n' i ((TEVENT i (TTICKET (GET_BUSY true))) ::l') to
          end
        | _ => None
      end
  end.
