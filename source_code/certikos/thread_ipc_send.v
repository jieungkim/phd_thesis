Function thread_syncsendto_chan_spec (chanid vaddr scount : Z) (adt : RData) 
  : option (RData * Z) :=
  // perform pre-send routine 
  // 1 - acquire the lock for chanid (channel ID)
  // 2 - when the channel is busy, goes to the sleep mode after 
  //     releasing its lock
  match thread_syncsendto_chan_pre_spec chanid adt with
  | Some adt0 =>
    // copy the sender's message to the mailbox in the kernel
    match thread_ipc_send_body_spec vaddr scount adt0 with
    | Some (adt1, res) =>
      // release the lock for chanid (channel ID)
      match big2_release_lock_SC_spec chanid adt1 with
      | Some adt2 => Some (adt2, res) | _ => None
      end
    | _ => None
    end
  | _ => None
  end.
