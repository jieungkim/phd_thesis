Inductive mcs_SET_NEXT_spec_low_step `{StencilOps} `{Mem.MemoryModelOps} `{UseMemWithData mem}:
  sextcall_sem (mem := mwd LDATAOps) :=
  mcs_SET_NEXT_spec_low_intro s (WB: _ -> Prop) b m m' d d' lock_index cpuid prev_id:
    forall (Hsymbol: find_symbol s MCS_LOCK_LOC = Some b)
           (index_range: 0 <= (Int.unsigned lock_index) < lock_range)
           (curid_range: 0 <= (Int.unsigned cpuid) < TOTAL_CPU)
           (previd_range: 0 <= (Int.unsigned prev_id) < TOTAL_CPU)
           (Hspec: mcs_SET_NEXT_log_spec (Int.unsigned lock_index) (Int.unsigned cpuid) (Int.unsigned prev_id) d = Some d')
           (Hstore: Mem.store Mint32 m b (next_pos (Int.unsigned lock_index) (Int.unsigned prev_id)) (Vint cpuid) = Some m')
           (Hkern: kernel_mode d),
      mcs_SET_NEXT_spec_low_step s WB (Vint lock_index :: Vint cpuid :: Vint prev_id :: nil) (m, d) Vundef (m', d').