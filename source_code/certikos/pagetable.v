// Permissions for page tables
Inductive PTPerm := | PTP | PTU | PTK (b: bool).

// Identity page tables
Inductive IDPTEInfo:= | IDPTEValid (p: PTPerm) | IDPTEUndef.

Definition IDPTE := ZMap.t IDPTEInfo.
Definition IDPDE := ZMap.t IDPTE.

// 2-level page tables
Inductive PTEInfo:= | PTEValid (v: Z) (p: PTPerm) | PTEUnPresent | PTEUndef.

Definition PTE := ZMap.t PTEInfo.

Inductive PDE := | PDEValid (pi: Z) (pte: PTE) | PDEID | PDEUnPresent | PDEUndef.

Definition PMap := ZMap.t PDE.
Definition PMapPool := ZMap.t PMap.
