Fixpoint <@$\replay_{\codeinmath{shared}}$@> (l: Log) (b: Loc) (c: Id) :=
  match l with
    | nil => ret (<@$\vundef$@>, free) (* initial value *)
    | e :: l' =>  (* l' <@$\color{mygreen}\cons$@> a *)
      do r <- <@$\replay_{\codeinmath{shared}}$@> l' b; (* Haskell syntax sugar*)
        match r, e with
          | (v, free), <@$c.\pull(b)$@> => ret (v, own c)
          | (_, own c), <@$c.\push(b, v)$@> => ret (v, free)
          | _ => None (* get stuck *)
        end
  end.
Function <@$\spec_{\pull}$@> <@$\oracle$@> (s: State) (b: Loc) :=
  let l':= <@$s.c.\pull(b)$@> :: <@$\oracle$@>[s.c, s.l] in (* query <@$\color{mygreen}\oracle$@> *)
  do r <- <@$\replay_{\codeinmath{shared}}$@> l' b s.c; ret s {l: l'} {m.b: fst r}.
Function <@$\spec_{\push}$@> <@$\oracle$@> (s: State) (b: Loc) :=
  let l':= <@$s.c.\push(b, s.m\ b)$@> :: s.l in (*do not query <@$\color{mygreen}\oracle$@>*)
  do _ <- <@$\replay_{\codeinmath{shared}}$@> l' b s.c; ret s {l: l'}.