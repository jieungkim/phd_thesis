void acceptor_prepare_handler (unsigned int sockfd)
{
    unsigned int m_addr, m_prop;
    unsigned int cur_prop, cur_vprop, cur_vcmd0, cur_vcmd1;
    
    m_addr = get_msg_addr();
    m_prop = get_msg_prop();
    
    cur_prop = get_paxos_space_prop(m_addr);
    if (cur_prop < m_prop){
        set_paxos_space_prop(m_addr, m_prop);
    } else { }
    
    cur_prop = get_paxos_space_prop(m_addr);
    cur_vprop = get_paxos_space_vprop(m_addr);
    cur_vcmd0 = get_paxos_space_vcmd0(m_addr);
    cur_vcmd1 = get_paxos_space_vcmd1(m_addr);

    send_msg(sockfd, MSG_PREPARE_ACK, m_addr, cur_prop, cur_vprop, cur_vcmd0, cur_vcmd1);
}

void acceptor_accept_handler (unsigned int sockfd)
{
    
    unsigned int m_addr, m_prop, m_vcmd0, m_vcmd1;
    unsigned int cur_prop;
    
    m_addr = get_msg_addr();
    m_prop = get_msg_prop();
    m_vcmd0 = get_msg_vote_cmd0();
    m_vcmd1 = get_msg_vote_cmd1();
    
    cur_prop = get_paxos_space_prop(m_addr);
    if (cur_prop <= m_prop) {
        set_paxos_space_prop(m_addr, m_prop);
        set_paxos_space_vprop(m_addr, m_prop);
        set_paxos_space_vcmd0(m_addr, m_vcmd0);
        set_paxos_space_vcmd1(m_addr, m_vcmd1);
        send_msg (sockfd, MSG_ACCEPT_ACK, m_addr, m_prop, m_prop, m_vcmd0, m_vcmd1);
    } else {
        send_msg (sockfd, MSG_ACCEPT_ACK, m_addr, cur_prop, 0, 0, 0);
    }
}


unsigned int acceptor_handler (unsigned int sockfd){
    
    unsigned int res, m_type, m_addr;
    
    res = receive_msg(sockfd);
    
    if (res == STATUS_OK){
        m_type = get_msg_type();
        m_addr = get_msg_addr();
        if (0 <= m_addr && m_addr < LOG_SIZE){
            if (m_type == MSG_PREPARE) { // Phase 1b
                acceptor_prepare_handler(sockfd);
                return STATUS_OK;
            } else if (m_type == MSG_ACCEPT) { // Phase 2b
                acceptor_accept_handler(sockfd);
                return STATUS_OK;
            } else { return STATUS_OK; }
        } else { return STATUS_OK; }
    } else { return SOCKET_RECV_FAIL; }
}
