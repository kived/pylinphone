
from libc.stdint cimport uint8_t, uint16_t, uint32_t, int64_t
cimport pylinphone.linphone.lib.ortp.str_utils as str_utils
cimport pylinphone.linphone.lib.ortp.port as port
cimport pylinphone.linphone.lib.ortp.rtp as rtp
cimport pylinphone.linphone.lib.ortp.payloadtype as payloadtype
cimport pylinphone.linphone.lib.ortp.rtpsignaltable as rtpsignaltable
cimport pylinphone.linphone.lib.ortp.event as event

cdef extern from "time.h" nogil:
	cdef struct timeval:
		pass

cdef extern from "netinet/in.h" nogil:
	cdef struct sockaddr:
		pass
	cdef struct sockaddr_in:
		pass
	ctypedef int socklen_t

cdef extern from "ortp/rtpsession.h" nogil:
	ctypedef struct RtpSession:
		pass
	
	ctypedef enum RtpSessionMode:
		RTP_SESSION_RECVONLY
		RTP_SESSION_SENDONLY
		RTP_SESSION_SENDRECV
	
	ctypedef struct JBParameters:
		int min_size
		int nom_size
		int max_size
		bint adaptive
		bint[3] pad
		int max_packets
	
	ctypedef struct JitterControl:
		int count
		int jitt_comp
		int jitt_comp_ts
		int adapt_jitt_comp_ts
		int64_t slide
		int64_t prev_slide
		float jitter
		int olddiff
		float inter_jitter
		int corrective_step
		int corrective_slide
		bint adaptive
		bint enabled
	
	ctypedef struct WaitPoint:
		port.ortp_mutex_t lock
		port.ortp_cond_t cond
		uint32_t time
		bint wakeup
	
	ctypedef struct RtpTransport:
		void* data
		port.ortp_socket_t (*t_getsocket)(RtpTransport* t)
		int (*t_sendto)(RtpTransport* t, str_utils.mblk_t* msg, int flags, const sockaddr* to, socklen_t tolen)
		int (*t_recvfrom)(RtpTransport* t, str_utils.mblk_t* msg, int flags, sockaddr* from_, socklen_t* fromlen)
		RtpSession* session
		void (*t_close)(RtpTransport* transport, void* userData)
	
	ctypedef struct OrtpNetworkSimulatorParams:
		int enabled
		float max_bandwidth
		float loss_rate
	
	ctypedef struct OrtpNetworkSimulatorCtx:
		OrtpNetworkSimulatorParams params
		int bit_budget
		int qsize
		str_utils.queue_t q
		timeval last_check
	
	ctypedef struct RtpStream:
		port.ortp_socket_t socket
		RtpTransport* tr
		int sockfamily
		int max_rq_size
		int time_jump
		uint32_t ts_jump
		str_utils.queue_t rq
		str_utils.queue_t tev_rq
		str_utils.mblk_t* cached_mp
		int loc_port
		sockaddr_in rem_addr
		int rem_addrlen
		void* QoSHandle
		unsigned long QoSFlowID
		JitterControl jittctl
		uint32_t snd_time_offset
		uint32_t snd_ts_offset
		uint32_t snd_rand_offset
		uint32_t snd_last_ts
		uint32_t rcv_time_offset
		uint32_t rcv_ts_offset
		uint32_t rcv_query_ts_offset
		uint32_t rcv_last_ts
		uint32_t rcv_last_app_ts
		uint32_t rcv_last_ret_ts
		uint32_t hwrcv_extseq
		uint32_t hwrcv_seq_at_last_SR
		uint32_t hwrcv_since_last_SR
		uint32_t last_rcv_SR_ts
		timeval last_rcv_SR_time
		uint16_t snd_seq
		uint32_t last_rtcp_packet_count
		uint32_t sent_payload_bytes
		unsigned int sent_bytes
		timeval send_bw_start
		unsigned int recv_bytes
		timeval recv_bw_start
		rtp.rtp_stats_t stats
		int recv_errno
		int send_errno
		int snd_socket_size
		int rcv_socket_size
		int ssrc_changed_thres
		rtp.jitter_stats_t jitter_stats
	
	ctypedef struct RtcpStream:
		port.ortp_socket_t socket
		int sockfamily
		RtpTransport* tr
		str_utils.mblk_t* cached_mp
		sockaddr_in rem_addr
		int rem_addrlen
		int interval
		uint32_t last_rtcp_report_snt_r
		uint32_t last_rtcp_report_snt_s
		uint32_t rtcp_report_snt_interval_r
		uint32_t rtcp_report_snt_interval_s
		bint enabled
	
	ctypedef struct _cy_rtpsession_snd_rcv:
		payloadtype.RtpProfile* profile
		int pt
		unsigned int ssrc
		WaitPoint wp
		int telephone_events_pt
	
	ctypedef struct RtpSession:
		RtpSession* next
		int mask_pos
		_cy_rtpsession_snd_rcv snd
		_cy_rtpsession_snd_rcv rcv
		unsigned int inc_ssrc_candidate
		int inc_same_ssrc_count
		int hw_recv_pt
		int recv_buf_size
		rtpsignaltable.RtpSignalTable on_ssrc_changed
		rtpsignaltable.RtpSignalTable on_payload_type_changed
		rtpsignaltable.RtpSignalTable on_telephone_event_packet
		rtpsignaltable.RtpSignalTable on_telephone_event
		rtpsignaltable.RtpSignalTable on_timestamp_jump
		rtpsignaltable.RtpSignalTable on_network_error
		rtpsignaltable.RtpSignalTable on_rtcp_bye
		#_OList* signal_tables -- cannot find type _OList
		#_OList* eventqs -- cannot find type _OList
		str_utils.msgb_allocator_t allocator
		RtpStream rtp
		RtcpStream rtcp
		RtpSessionMode mode
		#_RtpScheduler* sched -- cannot find type _RtpScheduler
		uint32_t flags
		int dscp
		int multicast_ttl
		int multicast_loopback
		void* user_data
		timeval last_recv_time
		str_utils.mblk_t* pending
		str_utils.mblk_t* current_tev
		str_utils.mblk_t* sd
		str_utils.queue_t contributing_sources
		unsigned int lost_packets_test_vector
		unsigned int interarrival_jitter_test_vector
		unsigned int delay_test_vector
		float rtt
		OrtpNetworkSimulatorCtx* net_sim_ctx
		bint symmetric_rtp
		bint permissive
		bint use_connect
		bint ssrc_set
	
	RtpSession* rtp_session_new(int mode)
	void rtp_session_set_scheduling_mode(RtpSession* session, int yesno)
	void rtp_session_set_blocking_mode(RtpSession* session, int yesno)
	void rtp_session_set_profile(RtpSession* session, payloadtype.RtpProfile* profile)
	void rtp_session_set_send_profile(RtpSession* session, payloadtype.RtpProfile* profile)
	void rtp_session_set_recv_profile(RtpSession* session, payloadtype.RtpProfile* profile)
	payloadtype.RtpProfile* rtp_session_get_profile(RtpSession* session)
	payloadtype.RtpProfile* rtp_session_get_send_profile(RtpSession* session)
	payloadtype.RtpProfile* rtp_session_get_recv_profile(RtpSession* session)
	int rtp_session_signal_connect(RtpSession* session, const char* signal_name, rtpsignaltable.RtpCallback cb, unsigned long user_data)
	int rtp_session_signal_disconnect_by_callback(RtpSession* session, const char* signal_name, rtpsignaltable.RtpCallback cb)
	void rtp_session_set_ssrc(RtpSession* session, uint32_t ssrc)
	uint32_t rtp_session_get_send_ssrc(RtpSession* session)
	void rtp_session_set_seq_number(RtpSession* session, uint16_t seq)
	uint16_t rtp_session_get_seq_number(RtpSession* session)
	
	void rtp_session_enable_jitter_buffer(RtpSession* session, bint enabled)
	bint rtp_session_jitter_buffer_enabled(const RtpSession* session)
	void rtp_session_set_jitter_buffer_params(RtpSession* session, const JBParameters* par)
	void rtp_session_get_jitter_buffer_params(RtpSession* session, JBParameters* par)
	
	void rtp_session_set_jitter_compensation(RtpSession* session, int milisec)
	void rtp_session_enable_adaptive_jitter_compensation(RtpSession* session, bint val)
	bint rtp_session_adaptive_jitter_compensation_enabled(RtpSession* session)
	
	void rtp_session_set_time_jump_limit(RtpSession* session, int miliseconds)
	int rtp_session_set_local_addr(RtpSession* session, const char* addr, int port)
	int rtp_session_get_local_port(const RtpSession* session)
	
	int rtp_session_set_remote_addr_full(RtpSession* session, const char* addr, int rtp_port, int rtcp_port)
	int rtp_session_set_remote_addr_and_port(RtpSession* session, const char* addr, int rtp_port, int rtcp_port)
	void rtp_session_set_sockets(RtpSession* session, int rtpfd, int rtcpfd)
	void rtp_session_set_transports(RtpSession* session, RtpTransport* rtptr, RtpTransport* rtcptr)
	
	port.ortp_socket_t rtp_session_get_rtp_socket(const RtpSession* session)
	port.ortp_socket_t rtp_session_get_rtcp_socket(const RtpSession* session)
	
	int rtp_session_set_dscp(RtpSession* session, int dscp)
	int rtp_session_get_dscp(const RtpSession* session)
	
	int rtp_session_set_multicast_ttl(RtpSession* session, int ttl)
	int rtp_session_get_multicast_ttl(RtpSession* session)
	
	int rtp_session_set_multicast_loopback(RtpSession* session, int yesno)
	int rtp_session_get_multicast_loopback(RtpSession* session)
	
	int rtp_session_set_send_payload_type(RtpSession* session, int paytype)
	int rtp_session_get_send_payload_type(const RtpSession* session)
	
	int rtp_session_get_recv_payload_type(const RtpSession* session)
	int rtp_session_set_recv_payload_type(RtpSession* session, int paytype)
	
	int rtp_session_set_payload_type(RtpSession* session, int pt)
	void rtp_session_set_symmetric_rtp(RtpSession* session, bint yesno)
	void rtp_session_set_connected_mode(RtpSession* session, bint yesno)
	void rtp_session_enable_rtcp(RtpSession* session, bint yesno)
	void rtp_session_set_rtcp_report_interval(RtpSession* session, int value_ms)
	void rtp_session_set_ssrc_changed_threshold(RtpSession* session, int numpackets)
	
	str_utils.mblk_t* rtp_session_recvm_with_ts(RtpSession* session, uint32_t user_ts)
	str_utils.mblk_t* rtp_session_create_packet(RtpSession* session, int header_size, const uint8_t* payload, int payload_size)
	str_utils.mblk_t* rtp_session_create_packet_with_data(RtpSession* session, uint8_t* payload, int payload_size, void (*freefn)(void*))
	str_utils.mblk_t* rtp_session_create_packet_in_place(RtpSession* session, uint8_t* buffer, int size, void (*freefn)(void*))
	int rtp_session_sendm_with_ts(RtpSession* session, str_utils.mblk_t* mp, uint32_t userts)
	int rtp_session_recv_with_ts(RtpSession* session, uint8_t* buffer, int len, uint32_t ts, int* have_more)
	int rtp_session_send_with_ts(RtpSession* session, const uint8_t* buffer, int len, uint32_t userts)
	
	void rtp_session_register_event_queue(RtpSession* session, event.OrtpEvQueue* q)
	void rtp_session_unregister_event_queue(RtpSession* session, event.OrtpEvQueue* q)
	
	float rtp_session_compute_send_bandwidth(RtpSession* session)
	float rtp_session_compute_recv_bandwidth(RtpSession* session)
	
	void rtp_session_send_rtcp_APP(RtpSession* session, uint8_t subtype, const char* name, const uint8_t* data, int datalen)
	
	uint32_t rtp_session_get_current_send_ts(RtpSession* session)
	uint32_t rtp_session_get_current_recv_ts(RtpSession* session)
	void rtp_session_flush_sockets(RtpSession* session)
	void rtp_session_release_sockets(RtpSession* session)
	void rtp_session_resync(RtpSession* session)
	void rtp_session_reset(RtpSession* session)
	void rtp_session_destroy(RtpSession* session)
	
	const rtp.rtp_stats_t* rtp_session_get_stats(const RtpSession* session)
	const rtp.jitter_stats_t* rtp_session_get_jitter_stats(const RtpSession* session)
	
	void rtp_session_set_data(RtpSession* session, void* data)
	void* rtp_session_get_data(const RtpSession* session)
	
	void rtp_session_set_recv_buf_size(RtpSession* session, int bufsize)
	void rtp_session_set_rtp_socket_send_buffer_size(RtpSession* session, unsigned int size)
	void rtp_session_set_rtp_socket_recv_buffer_size(RtpSession* session, unsigned int size)
	
	uint32_t rtp_session_ts_to_time(RtpSession* session, uint32_t timestamp)
	uint32_t rtp_session_time_to_ts(RtpSession* session, int millisecs)
	
	void rtp_session_make_time_distorsion(RtpSession* session, int milisec)
	
	void rtp_session_set_source_description(RtpSession* session, const char* cname, const char* name, const char* email, const char* phone,
											const char* loc, const char* tool, const char* note)
	void rtp_session_add_contributing_source(RtpSession* session, uint32_t csrc, const char* cname, const char* name, const char* email,
											 const char* phone, const char* loc, const char* tool, const char* note)
	void rtp_session_remove_contributing_sources(RtpSession* session, uint32_t csrc)
	str_utils.mblk_t* rtp_session_create_rtcp_sdes_packet(RtpSession* session)
	
