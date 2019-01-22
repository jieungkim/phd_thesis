// page allocation function w.o. locking
uint palloc_aux(uint id) {
    uint tnps, curid, index, cur_at, 
      is_norm, free_idx, 
      alloc_succeeded;

    // get max. page number
    tnps = get_nps();
    index = 1;
    free_idx = tnps;

    // search a free index
    while (index < tnps && 
           free_idx == tnps) {
        is_norm = is_norm(index);
        if (is_norm == 1) {
            cur_at = at_get(index);
            if (cur_at == 0)
                free_idx = index; }
        index ++; }

    // no free pages
    if (free_idx == tnps){
        free_idx = 0; 
    // free pages available
    } else {
        // check container info. 
        alloc_succeeded 
          = container_alloc(id);
         
        // exceed the max. capacity
        // (quota of process id)
        if (alloc_succeeded == 0){
            free_idx = 0;
        // allocation succeed
        } else {
            at_set(free_idx, 1);
            at_set_c(free_idx, 0); } }
    return free_idx; }

// page allocation function w. locking
uint palloc(uint id) {
    uint free_idx;

    acquire_lock(ID_AT);
    free_idx = palloc_aux(id);
    release_lock(ID_AT);
    return free_idx; }