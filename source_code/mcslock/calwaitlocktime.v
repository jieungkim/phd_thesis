Definition CalWaitLockTime (tq: list nat) :=
  ((5 + WaitConstant + length tq + (CalSumWait tq)) * WaitConstant)%nat.