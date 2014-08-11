
cdef extern from "ortp/rtpsignaltable.h" nogil:
	cdef int RTP_CALLBACK_TABLE_MAX_ENTRIES
	
	ctypedef struct RtpSession:
		pass
	
	ctypedef void (*RtpCallback)(RtpSession*, ...)
	
	ctypedef struct RtpSignalTable:
		RtpCallback[5] callback
		unsigned long[5] user_data
		RtpSession* session
		const char* signal_name
		int count
	
	void rtp_signal_table_init(RtpSignalTable* table, RtpSession* session, const char* signal_name)
	int rtp_signal_table_add(RtpSignalTable* table, RtpCallback cb, unsigned long user_data)
	void rtp_signal_table_emit(RtpSignalTable* table)
	void rtp_signal_table_emit2(RtpSignalTable* table, unsigned long arg)
	void rtp_signal_table_emit3(RtpSignalTable* table, unsigned long arg1, unsigned long arg2)
	int rtp_signal_table_remove_by_callback(RtpSignalTable* table, RtpCallback cb)
	
