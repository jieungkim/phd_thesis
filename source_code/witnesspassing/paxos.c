unsigned int prepare(unsigned int addr)
{
	unsigned int prop;

	wor_set_new_proposal(addr);
	wor_quorums_prepare_reset(addr);
     
   	prop = get_paxos_space_prop(addr);
	paxos_broadcast_msg(MSG_PREPARE, addr, prop, PROP_UNDEF, CMD_UNDEF, 0);

        unsigned int res = wor_wait_quorum_prepare(addr, prop);
	return res;
}

unsigned int accept(unsigned int addr, unsigned int cmd0, unsigned int cmd1)
{

	unsigned int sel_cmd0 = get_paxos_space_vcmd0(addr);
	unsigned int sel_cmd1 = get_paxos_space_vcmd1(addr);
	if (sel_cmd0 == CMD_UNDEF) {
		set_paxos_space_vcmd0(addr, cmd0);
		set_paxos_space_vcmd1(addr, cmd1);
		sel_cmd0 = cmd0;
		sel_cmd1 = cmd1;
	}

	unsigned int prop;
	
	wor_quorums_accept_reset(addr);
	prop = get_paxos_space_prop(addr);

 	paxos_broadcast_msg(MSG_ACCEPT, addr, prop, prop, sel_cmd0, sel_cmd1);

	unsigned int res = wor_wait_quorum_accept(addr, prop);

	if (res == STATUS_OK) {
		set_paxos_space_is_written_on(addr);
		return res;
	} else { return res; }

}
