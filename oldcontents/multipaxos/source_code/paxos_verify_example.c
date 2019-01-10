/* Proposer: Phase 1 (Prepare) */
uint prepare(){
    uint crndp, res;
    
    /* increase round number
     local state initialization for phase 1 */
    set_new_rnd();
    qrm_prepare_reset();

    /* Send prepare message */
    crndp = get_paxos_rnd();
    broadcast(PREPARE,crndp,RN_UNDEF,V_UNDEF);

    /* collect quorums */
    res = is_qrm_prepare(crndp);
    return res; }
/* Acceptor: Phase 1 (Prepare) */
void prepare_handler(uint sockfd){
    uint n, rnda, vrnda, vala;
    /* n is eceived round number */
    n = get_msg_rnd();
    
    /* compare n with the current round
     number stored in the acceptor */
    rnda = get_paxos_rnd();
    if (rnda < n){ set_paxos_rnd(m_rnd); }
    
    /* send promise values */
    rnda = get_paxos_rnd();
    vrnda = get_paxos_vrnd();
    vala = get_paxos_val();
    send_msg(sockfd,PROMISE,rnda,vrnda,vala); }
