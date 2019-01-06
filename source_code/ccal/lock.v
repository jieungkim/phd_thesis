Fixpoint <@$\replay_{\codeinmath{ticket}}$@> (l: Log) (b: Loc) :=
  match l with
    | nil => (0, 0) (* ticket and now*)
    | a :: l' => let (t, n):= <@$\replay_{\codeinmath{ticket}}$@> l' b in
                 match a with
                   | <@$c.\incticket(b)$@> => (t + 1, n)
                   | <@$c.\incnow(b)$@> => (t, n + 1)
                   | _, _ => (t, n)
                 end
  end.
Function <@$\spec_{\incticket}$@> <@$\oracle$@> (s: State) (b: Loc) :=
  let l':= <@$s.c.\incticket(b)$@> :: <@$\oracle$@>[s.c, s.l] in
  let (t, n):= <@$\replay_{\codeinmath{ticket}}$@> l' b in ret (s {l: l'}, t - 1).