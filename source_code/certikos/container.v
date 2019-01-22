// container in Coq (and in abs. data)
Inductive Container :=
  mkContainer {
    cquota : Z;
    cusage : Z;
    parent : Z;
    cchildren : list Z;
    cused : bool
}.

Definition CPool := ZMap.t Container.
