Function <@$\spec_{\pull}'$@> (s: State) (b: Loc) :=
  match s.a.status b with
    | free => ret s {l: <@$s.c.\pull(b)$@>::s.l} {a.status.b: own s.c}
    | _ => None
  end.
Function <@$\spec_{\push}'$@> (s: State) (b: Loc) :=
  match s.a.status b with
    | own s.c => let l':= <@$s.c.\push(b, s.m\ b)$@>::s.l in
                 ret s {l: l'} {a.status.b: free}
    | _ => None
  end.