Function big_sched_init_spec (mbi_adr:Z) (adt: RData) : option RData :=
  match (init adt, pg adt, ikern adt, ihost adt, ipt adt, in_intr adt) with
  | (false, false, true, true, true, false) =>
    let n := adt.(ioapic).(s).(IoApicMaxIntr) + 1 in
    if zeq n (Zlength (adt.(ioapic).(s).(IoApicIrqs))) then
      if zeq n (Zlength (adt.(ioapic).(s).(IoApicEnables))) then
        Some adt {ioapic/s: ioapic_init_aux adt.(ioapic).(s) (Z.to_nat (n - 1))}
             {lapic: (mkLApicData
                        (mkLApicState 0 NoIntr (LapicMaxLvt (s (lapic adt))) true
                                      (32 + 7) true true true 0 50 false 0))
                       {l1: l1 (lapic adt)}
                       {l2: l2 (lapic adt)}
                       {l3: l3 (lapic adt)}
             } {ioapic / s / CurrentIrq: None}
             {vmxinfo: real_vmxinfo} {pg: true} {LAT: real_LAT (LAT adt)} {nps: real_nps}
             {AC: AC_init} {init: true} {PT: 0} {ptpool: real_pt (ptpool adt)}
             {big_log: BigDef nil}
             {lock: real_lock (lock adt)}
             {idpde: real_idpde (idpde adt)}
             {smspool: real_smspool (smspool adt)}
             {syncchpool: real_syncchpool (syncchpool adt)}
             {cid: real_cidpool (cid adt)}
      else None
    else None
  | _ => None
  end.
