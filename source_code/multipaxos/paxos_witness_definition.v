Definition is_quorum (accs: list Z) :=
    NoDup accs /\ (forall a, In a accs -> In a ASET) /\ Zlength accs * 2 > Zlength ASET.
Inductive W_EL := | IN_PREPARE (rnd: nat) (value: Z) (q_voted: list Z) (voted_pkts: list Pkt) ...
Definition W := list W_EL.
