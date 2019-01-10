Inductive match_MCSLOCK_info: MultiLogType -> val ->
                              (val * val) -> (val * val) -> (val * val) -> (val * val) ->
                              (val * val) -> (val * val) -> (val * val) -> (val * val) -> Prop :=
| MATCH_MCSLOCK_UNDEF: forall la bs0 ne0 bs1 ne1 bs2 ne2 bs3 ne3 bs4 ne4 bs5 ne5 bs6 ne6 bs7 ne7,
    match_MCSLOCK_info MultiUndef la (bs0, ne0) (bs1, ne1) (bs2, ne2) (bs3, ne3) (bs4, ne4)
                       (bs5, ne5) (bs6, ne6) (bs7, ne7)
| MATCH_MCSLOCK_VALID: forall l la np tq bs0 ne0 bs1 ne1 bs2 ne2 bs3 ne3 bs4 ne4 bs5 ne5 bs6 ne6    bs7 ne7
                              (Hcal: CalMCSLock l = Some (MCSLOCK la np tq))
                              (Hnc0: ZMap.get 0 np = (bs0, ne0))
                              (Hnc1: ZMap.get 1 np = (bs1, ne1))
                              (Hnc2: ZMap.get 2 np = (bs2, ne2))
                              (Hnc3: ZMap.get 3 np = (bs3, ne3))
                              (Hnc4: ZMap.get 4 np = (bs4, ne4))
                              (Hnc5: ZMap.get 5 np = (bs5, ne5))
                              (Hnc6: ZMap.get 6 np = (bs6, ne6))
                              (Hnc7: ZMap.get 7 np = (bs7,                                          ne7)),
    match_MCSLOCK_info (MultiDef l) (Vint (Int.repr la))
                       ((Vint (Int.repr (BooltoZ bs0))), (Vint (Int.repr ne0)))
                       ((Vint (Int.repr (BooltoZ bs1))), (Vint (Int.repr ne1)))
                       ((Vint (Int.repr (BooltoZ bs2))), (Vint (Int.repr ne2)))
                       ((Vint (Int.repr (BooltoZ bs3))), (Vint (Int.repr ne3)))
                       ((Vint (Int.repr (BooltoZ bs4))), (Vint (Int.repr ne4)))
                       ((Vint (Int.repr (BooltoZ bs5))), (Vint (Int.repr ne5)))
                       ((Vint (Int.repr (BooltoZ bs6))), (Vint (Int.repr ne6)))
                       ((Vint (Int.repr (BooltoZ bs7))), (Vint (Int.repr ne7))).

