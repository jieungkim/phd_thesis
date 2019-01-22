typedef struct ticket_lock{
    // the next ticket number
    uint next; 
    // the currently serving number
    uint now;
} ticket_lock;
ticket_lock lkpool[lk_range]; 

// getter/setter layer primitives
uint FAI (uint kid);
uint get_now (uint lkid);
void incr_now(uint lkid);
// acquire lock
void acquire_lock (uint lkid){
    uint my_t = FAI(lkid);
    uint cur;

    cur = get_now(lkid);
    while (cur != my_t){
        cur = get_now(lkid); } }

// release lock
void release_lock (uint lkid){
    incr_now(lkid); }