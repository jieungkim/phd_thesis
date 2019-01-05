Function enQ a i e :=
  let q := a#queue i in
  a {i,queue: q++[e]}.

Function deQ a i :=
  match a#queue i with
    |nil=>(a,INVALID_TID)
    |e::q=>(a{i,queue: q},e)
  end.



