Function <@$\spec_{\comm{deQ\_t}}$@> <@$\oracle$@> (s: State) (i: Loc) :=
  do r <- <@$\replay_{\comm{shared}}'$@> s.l i s.c; (* replay ownership *)
  match r with
    | (_, own s.c) => (*if the lock of queue i is held*)
      match s.a.tdqp i with (* case over the queue*)
        | td :: q => ret (s {s.a.tdqp.i: q}, td}
        | _ => ret (s, -1) (* return -1 for empty queue*)
      end
    | _ => None (*get stuck*)
  end.