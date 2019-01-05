 Fixpoint CalBound (j:Z) (l: MultiLog) : nat := 
  match l with
  | nil => F
  | (TEVENT i e) :: l' => match (CalBound j l') with
                          | (S n') => if zeq i j then F else n'
                          | O => O
                          end
  end.
