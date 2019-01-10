Inductive match_MCSLOCK: stencil -> MultiLogPool -> mem -> Prop :=
| MATCH_MCSLOCK: forall log m b s
                        (HMCSLock:
                           (forall lock_index
                                   (Hvalid: 0 <= lock_index < lock_range),
                               (exists la bs0 ne0 bs1 ne1 bs2 ne2 bs3 ne3 bs4 ne4 bs5 ne5 bs6 ne6   bs7 ne7,
                                   Mem.load Mint32 m b (tail_pos lock_index) = Some la /\
                                   Mem.load Mint32 m b (busy_pos lock_index 0) = Some bs0 /\
                                   Mem.load Mint32 m b (next_pos lock_index 0) = Some ne0 /\
                                   Mem.load Mint32 m b (busy_pos lock_index 1) = Some bs1 /\
                                   Mem.load Mint32 m b (next_pos lock_index 1) = Some ne1 /\
                                   Mem.load Mint32 m b (busy_pos lock_index 2) = Some bs2 /\
                                   Mem.load Mint32 m b (next_pos lock_index 2) = Some ne2 /\
                                   Mem.load Mint32 m b (busy_pos lock_index 3) = Some bs3 /\
                                   Mem.load Mint32 m b (next_pos lock_index 3) = Some ne3 /\
                                   Mem.load Mint32 m b (busy_pos lock_index 4) = Some bs4 /\
                                   Mem.load Mint32 m b (next_pos lock_index 4) = Some ne4 /\
                                   Mem.load Mint32 m b (busy_pos lock_index 5) = Some bs5 /\
                                   Mem.load Mint32 m b (next_pos lock_index 5) = Some ne5 /\
                                   Mem.load Mint32 m b (busy_pos lock_index 6) = Some bs6 /\
                                   Mem.load Mint32 m b (next_pos lock_index 6) = Some ne6 /\
                                   Mem.load Mint32 m b (busy_pos lock_index 7) = Some bs7 /\
                                   Mem.load Mint32 m b (next_pos lock_index 7) = Some ne7 /\

                                   Mem.valid_access m Mint32 b (tail_pos lock_index) Writable /\
                                   Mem.valid_access m Mint32 b (busy_pos lock_index 0) Writable /\
                                   Mem.valid_access m Mint32 b (next_pos lock_index 0) Writable /\
                                   Mem.valid_access m Mint32 b (busy_pos lock_index 1) Writable /\
                                   Mem.valid_access m Mint32 b (next_pos lock_index 1) Writable /\
                                   Mem.valid_access m Mint32 b (busy_pos lock_index 2) Writable /\
                                   Mem.valid_access m Mint32 b (next_pos lock_index 2) Writable /\
                                   Mem.valid_access m Mint32 b (busy_pos lock_index 3) Writable /\
                                   Mem.valid_access m Mint32 b (next_pos lock_index 3) Writable /\
                                   Mem.valid_access m Mint32 b (busy_pos lock_index 4) Writable /\
                                   Mem.valid_access m Mint32 b (next_pos lock_index 4) Writable /\
                                   Mem.valid_access m Mint32 b (busy_pos lock_index 5) Writable /\
                                   Mem.valid_access m Mint32 b (next_pos lock_index 5) Writable /\
                                   Mem.valid_access m Mint32 b (busy_pos lock_index 6) Writable /\
                                   Mem.valid_access m Mint32 b (next_pos lock_index 6) Writable /\
                                   Mem.valid_access m Mint32 b (busy_pos lock_index 7) Writable /\
                                   Mem.valid_access m Mint32 b (next_pos lock_index 7) Writable /\

                                   match_MCSLOCK_info (ZMap.get lock_index log) la
                                                      (bs0, ne0) (bs1, ne1) (bs2, ne2) (bs3, ne3)
                                                      (bs4, ne4) (bs5, ne5) (bs6, ne6) (bs7, ne7))))
                        (Hsymbol: find_symbol s MCS_LOCK_LOC = Some b),
    match_MCSLOCK s log m.

