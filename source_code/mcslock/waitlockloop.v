Fixpoint CalMCS_AcqWait (n: nat) (i : Z) l <@$\mathcal{E}^{mcs(lkid)}_{\mathrm{i}}$@> : option MultiLog :=
  match n with 
    | O => None
    | S n' =>
      let l' :=  (<@$\mathcal{E}^{mcs(lkid)}_{\mathrm{i}}$@> i l) ++ l in
      match CalMCSLock l' with
        | Some (MCSLOCK tail la _) =>
          match ZMap.get i la with
            | (false, _) => Some ((TEVENT i (TTICKET (GET_BUSY false))) :: l')
            | _ => 
            CalMCS_AcqWait n' i ((TEVENT i (TTICKET (GET_BUSY true))) ::l') <@$\mathcal{E}^{mcs(lkid)}_{\mathrm{i}}$@>
          end
        | _ => None
      end
   end.
