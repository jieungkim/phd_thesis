Function thread_syncreceive_chan_spec (chanid vaddr rcount : Z) (adt : RData) 
  : option (RData * Z) :=
  match (pg adt, ikern adt, ihost adt, ipt adt) with
  | (true, true, true, true) =>
    // acquire the lock for chanid (channel ID)
    match acquire_lock_SC_spec chanid adt with
    | Some adt0 =>
      // perform the receive routine
      // 1 - copy the value inside the mailbox to the receiver's memory
      // 2 - wakes up the sender for the next communication
      match thread_tryreceive_chan_spec chanid vaddr rcount adt0 with
      | Some (adt1, res) =>
        // release the lock for chanid (channel ID)
        match release_lock_SC_spec chanid adt1 with
        | Some adt2 => Some (adt2, res) | _ => None
        end
      | _ => None
      end
    | _ => None
    end
  | _ => None
  end.
