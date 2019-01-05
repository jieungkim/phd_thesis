  Fixpoint nth_send (rn: nat) (net_l : list Pkt) :=
    match rn with
    | O => if find_send O net_l then 1 else 0
    | S p' => let res := nth_send p' net_l in if find_send (S p') net_l then (S res) else res
    end.
