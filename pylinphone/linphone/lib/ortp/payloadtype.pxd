


cdef extern from "ortp/payloadtype.h" nogil:
	ctypedef struct PayloadType:
		int type
		int clock_rate
		char bits_per_sample
		char* zero_pattern
		int pattern_length
		int normal_bitrate
		char* mime_type
		int channels
		char* recv_fmtp
		char* send_fmtp
		int flags
		void* user_data
	
	ctypedef struct RtpProfile:
		char* name
		PayloadType[128]* payload
	
	PayloadType* payload_type_new()
	PayloadType* payload_type_clone(PayloadType* payload)
	char* payload_type_get_rtpmap(PayloadType* pt)
	void payload_type_destroy(PayloadType* pt)
	void payload_type_set_recv_fmtp(PayloadType* pt, const char* fmtp)
	void payload_type_set_send_fmtp(PayloadType* pt, const char* fmtp)
	void payload_type_append_recv_fmtp(PayloadType* pt, const char* fmtp)
	void payload_type_append_send_fmtp(PayloadType* pt, const char* fmtp)
	
	bint fmtp_get_value(const char* fmtp, const char* param_name, char* result, size_t result_len)
	
	cdef RtpProfile av_profile
	
	void rtp_profile_set_payload(RtpProfile* prof, int idx, PayloadType* pt)
	
	PayloadType* rtp_profile_get_payload(RtpProfile* prof, int idx)
	
	void rtp_profile_clear_all(RtpProfile* prof)
	void rtp_profile_set_name(RtpProfile* prof, const char* name)
	PayloadType* rtp_profile_get_payload_from_mime(RtpProfile* profile, const char* mime)
	PayloadType* rtp_profile_get_payload_from_rtpmap(RtpProfile* profile, const char* rtpmap)
	int rtp_profile_get_payload_number_from_mime(RtpProfile* profile, const char* mime)
	int rtp_profile_get_payload_number_from_rtpmap(RtpProfile* profile, const char* rtpmap)
	int rtp_profile_find_payload_number(RtpProfile* prof, const char* mime, int rate, int channels)
	PayloadType* rtp_profile_find_payload(RtpProfile* prof, const char* mime, int rate, int channels)
	int rtp_profile_move_payload(RtpProfile* prof, int oldpos, int newpos)
	
	RtpProfile* rtp_profile_new(const char* name)
	RtpProfile* rtp_profile_clone(RtpProfile* prof)
	
	RtpProfile* rtp_profile_clone_full(RtpProfile* prof)
	void rtp_profile_destroy(RtpProfile* prof)
	
	cdef PayloadType payload_type_pcmu8000
	cdef PayloadType payload_type_pcma8000
	cdef PayloadType payload_type_pcm8000
	cdef PayloadType payload_type_l16_mono
	cdef PayloadType payload_type_l16_stereo
	cdef PayloadType payload_type_lpc1016
	cdef PayloadType payload_type_g729
	cdef PayloadType payload_type_g7231
	cdef PayloadType payload_type_g7221
	cdef PayloadType payload_type_g726_40
	cdef PayloadType payload_type_g726_32
	cdef PayloadType payload_type_g726_24
	cdef PayloadType payload_type_g726_16
	cdef PayloadType payload_type_aal2_g726_40
	cdef PayloadType payload_type_aal2_g726_32
	cdef PayloadType payload_type_aal2_g726_24
	cdef PayloadType payload_type_aal2_g726_16
	cdef PayloadType payload_type_gsm
	cdef PayloadType payload_type_lpc
	cdef PayloadType payload_type_lpc1015
	cdef PayloadType payload_type_speex_nb
	cdef PayloadType payload_type_speex_wb
	cdef PayloadType payload_type_speex_uwb
	cdef PayloadType payload_type_ilbc
	cdef PayloadType payload_type_amr
	cdef PayloadType payload_type_amrwb
	cdef PayloadType payload_type_truespeech
	cdef PayloadType payload_type_evrc0
	cdef PayloadType payload_type_evrcb0
	cdef PayloadType payload_type_silk_nb
	cdef PayloadType payload_type_silk_mb
	cdef PayloadType payload_type_silk_wb
	cdef PayloadType payload_type_silk_swb
	cdef PayloadType payload_type_mpv
	cdef PayloadType payload_type_h261
	cdef PayloadType payload_type_h263
	cdef PayloadType payload_type_h263_1998
	cdef PayloadType payload_type_h263_2000
	cdef PayloadType payload_type_mp4v
	cdef PayloadType payload_type_theora
	cdef PayloadType payload_type_h264
	cdef PayloadType payload_type_x_snow
	cdef PayloadType payload_type_jpeg
	cdef PayloadType payload_type_vp8
	cdef PayloadType payload_type_g722
	cdef PayloadType payload_type_t140
	cdef PayloadType payload_type_t140_red
	cdef PayloadType payload_type_x_udpftp
	cdef PayloadType payload_type_telephone_event
	
