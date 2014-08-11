
cimport pylinphone.linphone.lib.ortp.str_utils as str_utils
cimport pylinphone.linphone.lib.ortp.port as port

cdef extern from "time.h" nogil:
	cdef struct timeval:
		pass

cdef extern from "netinet/in.h" nogil:
	cdef struct sockaddr:
		pass
	cdef struct sockaddr_in:
		pass
	ctypedef int socklen_t

cdef extern from "ortp/event.h" nogil:
	ctypedef str_utils.mblk_t OrtpEvent
	ctypedef unsigned long OrtpEventType
	
	ctypedef struct RtpEndpoint:
		sockaddr addr
		socklen_t addrlen
	
	ctypedef struct _ZrtpSas:
		char[5] sas
		bint verified
	
	ctypedef union _cy_ortpeventdata_info:
		int telephone_event
		int payload_type
		bint zrtp_stream_encrypted
		_ZrtpSas zrtp_sas
	
	ctypedef struct OrtpEventData:
		str_utils.mblk_t* packet
		RtpEndpoint* ep
		_cy_ortpeventdata_info info
	
	RtpEndpoint* rtp_endpoint_new(sockaddr* addr, socklen_t addrlen)
	RtpEndpoint* rtp_endpoint_dup(const RtpEndpoint* ep)
	
	OrtpEvent* ortp_event_new(OrtpEventType tp)
	OrtpEventType ortp_event_get_type(const OrtpEvent* ev)
	
	ctypedef enum OrtpEventType:
		ORTP_EVENT_STUN_PACKET_RECEIVED
		ORTP_EVENT_PAYLOAD_TYPE_CHANGED
		ORTP_EVENT_TELEPHONE_EVENT
		ORTP_EVENT_RTCP_PACKET_RECEIVED
		ORTP_EVENT_RTCP_PACKET_EMITTED
		ORTP_EVENT_ZRTP_ENCRYPTION_CHANGED
		ORTP_EVENT_ZRTP_SAS_READY
	
	OrtpEventData* ortp_event_get_data(OrtpEvent* ev)
	void ortp_event_destroy(OrtpEvent* ev)
	OrtpEvent* ortp_event_dup(OrtpEvent* ev)
	
	ctypedef struct OrtpEvQueue:
		str_utils.queue_t q
		port.ortp_mutex_t mutex
	
	OrtpEvQueue* ortp_ev_queue_new()
	void ortp_ev_queue_destroy(OrtpEvQueue* q)
	OrtpEvent* ortp_ev_queue_get(OrtpEvQueue* q)
	void ortp_ev_queue_flush(OrtpEvQueue* qp)
	
