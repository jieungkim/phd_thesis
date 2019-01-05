Definition NULL := TOTAL_CPU.

Definition init_MCSLock :=
  MCSLOCK NULL (ZMap.init (false, NULL)) nil.
