Function <@$\spec_{\pull}'$@> (s: State) (b: Loc) :=
  match s.a.status b with
    |free=>ret s{l: <@$s.c.\pull(b)$@>::s.l}{a.status.b: own s.c}
    | _ => None (* get stuck*)
  end.