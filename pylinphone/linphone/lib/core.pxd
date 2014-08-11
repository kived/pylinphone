'''
Created on Dec 2, 2013

@author: "Ryan Pessa <ryan@essential-elements.net>"
'''
from __future__ import absolute_import

from libc.stdio cimport FILE
from libc.stdint cimport int64_t

cdef extern from "time.h" nogil:
	ctypedef long time_t

from pylinphone.linphone.lib.ortp.payloadtype cimport PayloadType
from pylinphone.linphone.lib.ortp.rtp cimport rtp_stats_t, jitter_stats_t
from pylinphone.linphone.lib.ortp.port cimport ortp_socket_t
from pylinphone.linphone.lib.ortp.ortp cimport OrtpLogFunc, OrtpLogLevel
from pylinphone.linphone.lib.ortp.rtpsession cimport RtpTransport
from pylinphone.linphone.lib.ortp.str_utils cimport mblk_t
from pylinphone.linphone.lib.mediastreamer2.mscommon cimport MSList
from pylinphone.linphone.lib.mediastreamer2.msvideo cimport MSVideoSize
from .lpconfig cimport LpConfig
from .sipsetup cimport SipSetupContext, SipSetup

cdef extern from "linphone/linphonecore.h" nogil:
	cdef int LINPHONE_IPADDR_SIZE
	cdef int LINPHONE_HOSTNAME_SIZE
	
	ctypedef struct cLinphoneCore "LinphoneCore":
		pass
	
	cdef int LC_SIP_TRANSPORT_DISABLED
	cdef int LC_SIP_TRANSPORT_RANDOM
	
	ctypedef struct LCSipTransports:
		int udp_port
		int tcp_port
		int dtls_port
		int tls_port
	
	ctypedef enum LinphoneTransportType:
		LinphoneTransportUdp
		LinphoneTransportTcp
		LinphoneTransportTls
		LinphoneTransportDtls
	
	ctypedef struct LinphoneAddress:
		pass
	
	ctypedef struct LinphoneDictionary:
		pass
	
	ctypedef struct LinphoneContent:
		char* type
		char* subtype
		void* data
		size_t size
		char* encoding

	ctypedef struct cLinphoneCall "LinphoneCall":
		pass

	ctypedef enum LinphoneReason:
		LinphoneReasonNone
		LinphoneReasonNoResponse
		LinphoneReasonForbidden
		LinphoneReasonDeclined
		LinphoneReasonNotFound
		LinphoneReasonNotAnswered
		LinphoneReasonBusy
		LinphoneReasonUnsupportedContent
		LinphoneReasonIOError
		LinphoneReasonDoNotDisturb
		LinphoneReasonUnauthorized
		LinphoneReasonNotAcceptable
		LinphoneReasonNoMatch
		LinphoneReasonMovedPermanently
		LinphoneReasonGone
		LinphoneReasonTemporarilyUnavailable
		LinphoneReasonAddressIncomplete
		LinphoneReasonNotImplemented
		LinphoneReasonBadGateway
		LinphoneReasonServerTimeout
		LinphoneReasonUnknown

	const char* linphone_reason_to_string(LinphoneReason err)
	
	ctypedef struct LinphoneErrorInfo:
		pass
	
	LinphoneReason linphone_error_info_get_reason(const LinphoneErrorInfo* ei)
	const char* linphone_error_info_get_phrase(const LinphoneErrorInfo* ei)
	const char* linphone_error_info_get_details(const LinphoneErrorInfo* ei)
	int linphone_error_info_get_protocol_code(const LinphoneErrorInfo* ei)
	
	LinphoneDictionary* linphone_dictionary_new()
	LinphoneDictionary* linphone_dictionary_clone(const LinphoneDictionary* src)
	LinphoneDictionary* linphone_dictionary_ref(LinphoneDictionary* obj)
	void linphone_dictionary_unref(LinphoneDictionary* obj)
	void linphone_dictionary_set_int(LinphoneDictionary* obj, const char* key, int value)
	int linphone_dictionary_get_int(LinphoneDictionary* obj, const char* key, int default_value)
	void linphone_dictionary_set_string(LinphoneDictionary* obj, const char* key, const char* value)
	const char* linphone_dictionary_get_string(LinphoneDictionary* obj, const char* key, const char* default_value)
	void linphone_dictionary_set_int64(LinphoneDictionary* obj, const char* key, int64_t value)
	int64_t linphone_dictionary_get_int64(LinphoneDictionary* obj, const char* key, int64_t default_value)
	int linphone_dictionary_remove(LinphoneDictionary* obj, const char* key)
	void linphone_dictionary_clear(LinphoneDictionary* obj)
	int linphone_dictionary_haskey(const LinphoneDictionary* obj, const char* key)
	void linphone_dictionary_foreach(const LinphoneDictionary* obj, void (*apply_func)(const char* key, void* value, void* userdata), void* userdata)
	
	LinphoneDictionary* lp_config_section_to_dict(const LpConfig* lpconfig, const char* section)
	void lp_config_load_dict_to_session(LpConfig* lpconfig, const char* section, const LinphoneDictionary* dict)
	
	LinphoneAddress* linphone_address_new(const char* addr)
	LinphoneAddress* linphone_address_clone(const LinphoneAddress* addr)
	LinphoneAddress* linphone_address_ref(LinphoneAddress* addr)
	void linphone_address_unref(LinphoneAddress* addr)
	const char* linphone_address_get_scheme(const LinphoneAddress *u)
	const char* linphone_address_get_display_name(const LinphoneAddress* u)
	const char* linphone_address_get_username(const LinphoneAddress* u)
	const char* linphone_address_get_domain(const LinphoneAddress* u)
	
	int linphone_address_get_port(const LinphoneAddress* u)
	void linphone_address_set_display_name(LinphoneAddress* u, const char* display_name)
	void linphone_address_set_username(LinphoneAddress* uri, const char* username)
	void linphone_address_set_domain(LinphoneAddress* uri, const char* host)
	void linphone_address_set_port(LinphoneAddress* uri, int port)
	void linphone_address_clean(LinphoneAddress* uri)
	bint linphone_address_is_secure(const LinphoneAddress* uri)
	LinphoneTransportType linphone_address_get_transport(const LinphoneAddress* uri)
	void linphone_address_set_transport(LinphoneAddress* uri, LinphoneTransportType type)
	char* linphone_address_as_string(const LinphoneAddress* u)
	char* linphone_address_as_string_uri_only(const LinphoneAddress* u)
	bint linphone_address_weak_equal(const LinphoneAddress *a1, const LinphoneAddress *a2)
	void linphone_address_destroy(LinphoneAddress* u)
	
	LinphoneAddress* linphone_core_create_address(cLinphoneCore* lc, const char* address)
	
	ctypedef enum LinphoneCallDir:
		LinphoneCallOutgoing
		LinphoneCallIncoming
	
	ctypedef enum LinphoneCallStatus:
		LinphoneCallSuccess
		LinphoneCallAborted
		LinphoneCallMissed
		LinphoneCallDeclined
	
	ctypedef struct LinphoneCallLog:
		pass
		# LinphoneCallDir dir
		# LinphoneCallStatus status
		# LinphoneAddress* from_ "from"
		# LinphoneAddress* to
		# char[128] start_data
		# int duration
		# char* refkey
		# void* user_pointer
		# rtp_stats_t local_stats
		# rtp_stats_t remote_stats
		# float quality
		# cLinphoneCore* lc
	
	ctypedef enum LinphoneMediaEncryption:
		LinphoneMediaEncryptionNone
		LinphoneMediaEncryptionSRTP
		LinphoneMediaEncryptionZRTP
	
	const char* linphone_media_encryption_to_string(LinphoneMediaEncryption menc)
	
	LinphoneAddress* linphone_call_log_get_from(LinphoneCallLog* cl)
	LinphoneAddress* linphone_call_log_get_to(LinphoneCallLog* cl)
	LinphoneAddress* linphone_call_log_get_remote_address(LinphoneCallLog* cl)
	LinphoneCallDir linphone_call_log_get_dir(LinphoneCallLog* cl)
	LinphoneCallStatus linphone_call_log_get_status(LinphoneCallLog* cl)
	bint linphone_call_log_video_enabled(LinphoneCallLog* cl)
	time_t linphone_call_log_get_start_date(LinphoneCallLog* cl)
	int linphone_call_log_get_duration(LinphoneCallLog* cl)
	float linphone_call_log_get_quality(LinphoneCallLog* cl)
	void linphone_call_log_set_user_pointer(LinphoneCallLog* cl, void* up)
	void* linphone_call_log_get_user_pointer(const LinphoneCallLog* cl)
	void linphone_call_log_set_ref_key(LinphoneCallLog* cl, const char* refkey)
	const char* linphone_call_log_get_ref_key(const LinphoneCallLog* cl)
	const rtp_stats_t* linphone_call_log_get_local_stats(const LinphoneCallLog* cl)
	const rtp_stats_t* linphone_call_log_get_remote_stats(const LinphoneCallLog* cl)
	const char* linphone_call_log_get_call_id(const LinphoneCallLog* cl)
	char* linphone_call_log_to_str(LinphoneCallLog* cl)
	
	ctypedef struct _LinphoneCallParams "LinphoneCallParams":
		pass
	
	const PayloadType* linphone_call_params_get_used_audio_codec(const _LinphoneCallParams* cp)
	const PayloadType* linphone_call_params_get_used_video_codec(const _LinphoneCallParams* cp)
	_LinphoneCallParams* linphone_call_params_copy(const _LinphoneCallParams* cp)
	void linphone_call_params_enable_video(_LinphoneCallParams* cp, bint enabled)
	bint linphone_call_params_video_enabled(const _LinphoneCallParams* cp)
	LinphoneMediaEncryption linphone_call_params_get_media_encryption(const _LinphoneCallParams* cp)
	void linphone_call_params_set_media_encryption(_LinphoneCallParams* cp, LinphoneMediaEncryption e)
	void linphone_call_params_enable_early_media_sending(_LinphoneCallParams *cp, bint enabled)
	bint linphone_call_params_early_media_sending_enabled(const _LinphoneCallParams *cp)
	bint linphone_call_params_local_conference_mode(const _LinphoneCallParams* cp)
	void linphone_call_params_set_audio_bandwidth_limit(_LinphoneCallParams* cp, int bw)
	void linphone_call_params_destroy(_LinphoneCallParams* cp)
	bint linphone_call_params_low_bandwidth_enabled(const _LinphoneCallParams* cp)
	void linphone_call_params_enable_low_bandwidth(_LinphoneCallParams* cp, bint enabled)
	void linphone_call_params_set_record_file(_LinphoneCallParams* cp, const char* path)
	const char* linphone_call_params_get_record_file(const _LinphoneCallParams* cp)
	const char* linphone_call_params_get_session_name(const _LinphoneCallParams* cp)
	void linphone_call_params_set_session_name(_LinphoneCallParams* cp, const char* subject)
	void linphone_call_params_add_custom_header(_LinphoneCallParams* params, const char* header_name, const char* header_value)
	const char* linphone_call_params_get_custom_header(const _LinphoneCallParams* params, const char* header_name)
	MSVideoSize linphone_call_params_get_sent_video_size(const _LinphoneCallParams* cp)
	MSVideoSize linphone_call_params_get_received_video_size(const _LinphoneCallParams* cp)
	
	ctypedef enum LinphonePrivacy:
		LinphonePrivacyNone
		LinphonePrivacyUser
		LinphonePrivacyHeader
		LinphonePrivacySession
		LinphonePrivacyId
		LinphonePrivacyCritical
		LinphonePrivacyDefault
	
	ctypedef unsigned int LinphonePrivacyMask
	
	const char* linphone_privacy_to_string(LinphonePrivacy privacy)
	void linphone_call_params_set_privacy(_LinphoneCallParams* params, LinphonePrivacyMask privacy)
	LinphonePrivacyMask linphone_call_params_get_privacy(const _LinphoneCallParams* params)
	
	ctypedef struct LinphoneInfoMessage
	
	LinphoneInfoMessage* linphone_core_create_info_message(cLinphoneCore* lc)
	int linphone_call_send_info_message(cLinphoneCall* call, const LinphoneInfoMessage* info)
	void linphone_info_message_add_header(LinphoneInfoMessage* im, const char* name, const char* value)
	const char* linphone_info_message_get_header(const LinphoneInfoMessage* im, const char* name)
	void linphone_info_message_set_content(LinphoneInfoMessage* im, const LinphoneContent* content)
	const LinphoneContent* linphone_info_message_get_content(const LinphoneInfoMessage* im)
	const char* linphone_info_message_get_from(const LinphoneInfoMessage* im)
	void linphone_info_message_destroy(LinphoneInfoMessage* im)
	LinphoneInfoMessage* linphone_info_message_copy(const LinphoneInfoMessage* orig)
	
	ctypedef struct LinphoneVideoPolicy:
		bint automatically_initiate
		bint automatically_accept
		bint[2] unused
	
	cdef int LINPHONE_CALL_STATS_AUDIO
	cdef int LINPHONE_CALL_STATS_VIDEO
	
	ctypedef enum LinphoneIceState:
		LinphoneIceStateNotActivated
		LinphoneIceStateFailed
		LinphoneIceStateInProgress
		LinphoneIceStateHostConnection
		LinphoneIceStateReflexiveConnection
		LinphoneIceStateRelayConnection
	
	ctypedef enum LinphoneUpnpState:
		LinphoneUpnpStateIdle
		LinphoneUpnpStatePending
		LinphoneUpnpStateAdding
		LinphoneUpnpStateRemoving
		LinphoneUpnpStateNotAvailable
		LinphoneUpnpStateOk
		LinphoneUpnpStateKo
		LinphoneUpnpStateBlacklisted
	
	cdef int LINPHONE_CALL_STATS_RECEIVED_RTCP_UPDATE
	cdef int LINPHONE_CALL_STATS_SENT_RTCP_UPDATE
	
	ctypedef struct LinphoneCallStats:
		int type
		jitter_stats_t jitter_stats
		mblk_t* received_rtcp
		mblk_t* sent_rtcp
		float round_trip_delay
		LinphoneIceState ice_state
		LinphoneUpnpState upnp_state
		float download_bandwidth
		float upload_bandwidth
		float local_late_rate
		float local_loss_rate
		int updated
	
	const LinphoneCallStats* linphone_call_get_audio_stats(cLinphoneCall* call)
	const LinphoneCallStats* linphone_call_get_video_stats(cLinphoneCall* call)
	float linphone_call_stats_get_sender_loss_rate(const LinphoneCallStats* stats)
	float linphone_call_stats_get_receiver_loss_rate(const LinphoneCallStats* stats)
	float linphone_call_stats_get_sender_interarrival_jitter(const LinphoneCallStats* stats, cLinphoneCall* call)
	float linphone_call_stats_get_receiver_interarrival_jitter(const LinphoneCallStats* stats, cLinphoneCall* call)
	
	ctypedef void (*LinphoneCallCbFunc)(cLinphoneCall* call, void* user_data)
	
	ctypedef enum LinphoneCallState:
		LinphoneCallIdle
		LinphoneCallIncomingReceived
		LinphoneCallOutgoingInit
		LinphoneCallOutgoingProgress
		LinphoneCallOutgoingRinging
		LinphoneCallOutgoingEarlyMedia
		LinphoneCallConnected
		LinphoneCallStreamsRunning
		LinphoneCallPausing
		LinphoneCallPaused
		LinphoneCallResuming
		LinphoneCallRefered
		LinphoneCallError
		LinphoneCallEnd
		LinphoneCallPausedByRemote
		LinphoneCallUpdatedByRemote
		LinphoneCallIncomingEarlyMedia
		LinphoneCallUpdated
		LinphoneCallReleased
	
	const char* linphone_call_state_to_string(LinphoneCallState cs)
	
	cLinphoneCore* linphone_call_get_core(const cLinphoneCall* call)
	LinphoneCallState linphone_call_get_state(const cLinphoneCall* call)
	bint linphone_call_asked_to_autoanswer(cLinphoneCall* call)
	const LinphoneAddress* linphone_core_get_current_call_remote_address(cLinphoneCore* lc)
	const LinphoneAddress* linphone_call_get_remote_address(const cLinphoneCall* call)
	char* linphone_call_get_remote_address_as_string(const cLinphoneCall* call)
	LinphoneCallDir linphone_call_get_dir(const cLinphoneCall* call)
	cLinphoneCall* linphone_call_ref(cLinphoneCall* call)
	void linphone_call_unref(cLinphoneCall* call)
	LinphoneCallLog* linphone_call_get_call_log(const cLinphoneCall* call)
	const char* linphone_call_get_refer_to(const cLinphoneCall* call)
	bint linphone_call_has_transfer_pending(const cLinphoneCall* call)
	cLinphoneCall* linphone_call_get_transferer_call(const cLinphoneCall* call)
	cLinphoneCall* linphone_call_get_transfer_target_call(const cLinphoneCall* call)
	cLinphoneCall* linphone_call_get_replaced_call(cLinphoneCall* call)
	int linphone_call_get_duration(const cLinphoneCall* call)
	const _LinphoneCallParams* linphone_call_get_current_params(const cLinphoneCall* call)
	const _LinphoneCallParams* linphone_call_get_remote_params(const cLinphoneCall* call)
	void linphone_call_enable_camera(cLinphoneCall* lc, bint enabled)
	bint linphone_call_camera_enabled(const cLinphoneCall* lc)
	int linphone_call_take_video_snapshot(cLinphoneCall* call, const char* file)
	LinphoneReason linphone_call_get_reason(const cLinphoneCall* call)
	const LinphoneErrorInfo* linphone_call_get_error_info(const cLinphoneCall* call)
	const char* linphone_call_get_remote_user_agent(cLinphoneCall* call)
	const char* linphone_call_get_remote_contact(cLinphoneCall* call)
	LinphoneAddress* linphone_call_get_remote_contact_address(cLinphoneCall* call)
	float linphone_call_get_play_volume(cLinphoneCall* call)
	float linphone_call_get_record_volume(cLinphoneCall* call)
	float linphone_call_get_current_quality(cLinphoneCall* call)
	float linphone_call_get_average_quality(cLinphoneCall* call)
	const char* linphone_call_get_authentication_token(cLinphoneCall *call)
	bint linphone_call_get_authentication_token_verified(cLinphoneCall* call)
	void linphone_call_set_authentication_token_verified(cLinphoneCall* call, bint verified)
	void linphone_call_send_vfu_request(cLinphoneCall* call)
	void *linphone_call_get_user_pointer(cLinphoneCall* call)
	void linphone_call_set_user_pointer(cLinphoneCall* call, void* user_pointer)
	void linphone_call_set_next_video_frame_decoded_callback(cLinphoneCall* call, LinphoneCallCbFunc cb, void* user_data)
	LinphoneCallState linphone_call_get_transfer_state(cLinphoneCall* call)
	void linphone_call_zoom_video(cLinphoneCall* call, float zoom_factor, float* cx, float* cy)
	void linphone_call_start_recording(cLinphoneCall* call)
	void linphone_call_stop_recording(cLinphoneCall* call)
	
	bint linphone_call_is_in_conference(const cLinphoneCall* call)
	
	void linphone_call_enable_echo_cancellation(cLinphoneCall* call, bint val)
	
	bint linphone_call_echo_cancellation_enabled(cLinphoneCall* lc)
	
	void linphone_call_enable_echo_limiter(cLinphoneCall* call, bint val)
	
	bint linphone_call_echo_limiter_enabled(const cLinphoneCall* call)
	
	cdef int LINPHONE_VOLUME_DB_LOWEST
	
	ctypedef struct cLinphoneProxyConfig "LinphoneProxyConfig":
		pass
	
	ctypedef enum LinphoneRegistrationState:
		LinphoneRegistrationNone
		LinphoneRegistrationProgress
		LinphoneRegistrationOk
		LinphoneRegistrationCleared
		LinphoneRegistrationFailed
	
	const char* linphone_registration_state_to_string(LinphoneRegistrationState cs)
	
	cLinphoneProxyConfig* linphone_proxy_config_new()
	int linphone_proxy_config_set_server_addr(cLinphoneProxyConfig* obj, const char* server_addr)
	int linphone_proxy_config_set_identity(cLinphoneProxyConfig* obj, const char* identity)
	int linphone_proxy_config_set_route(cLinphoneProxyConfig* obj, const char* route)
	void linphone_proxy_config_set_expires(cLinphoneProxyConfig* obj, int expires)
	
	void linphone_proxy_config_enable_register(cLinphoneProxyConfig* obj, bint val)
	void linphone_proxy_config_edit(cLinphoneProxyConfig* obj)
	int linphone_proxy_config_done(cLinphoneProxyConfig* obj)
	
	void linphone_proxy_config_enable_publish(cLinphoneProxyConfig* obj, bint val)
	void linphone_proxy_config_set_dial_escape_plus(cLinphoneProxyConfig* cfg, bint val)
	void linphone_proxy_config_set_dial_prefix(cLinphoneProxyConfig* cfg, const char* prefix)
	
	LinphoneRegistrationState linphone_proxy_config_get_state(const cLinphoneProxyConfig *obj)
	bint linphone_proxy_config_is_registered(const cLinphoneProxyConfig *obj)
	const char* linphone_proxy_config_get_domain(const cLinphoneProxyConfig *cfg)
	
	const char* linphone_proxy_config_get_route(const cLinphoneProxyConfig *obj)
	const char* linphone_proxy_config_get_identity(const cLinphoneProxyConfig *obj)
	bint linphone_proxy_config_publish_enabled(const cLinphoneProxyConfig *obj)
	const char* linphone_proxy_config_get_addr(const cLinphoneProxyConfig *obj)
	int linphone_proxy_config_get_expires(const cLinphoneProxyConfig *obj)
	bint linphone_proxy_config_register_enabled(const cLinphoneProxyConfig* obj)
	void linphone_proxy_config_refresh_register(cLinphoneProxyConfig* obj)
	const char* linphone_proxy_config_get_contact_parameters(const cLinphoneProxyConfig* obj)
	void linphone_proxy_config_set_contact_parameters(cLinphoneProxyConfig* obj, const char* contact_params)
	void linphone_proxy_config_set_contact_uri_parameters(cLinphoneProxyConfig* obj, const char* contact_uri_params)
	const char* linphone_proxy_config_get_contact_uri_parameters(const cLinphoneProxyConfig* obj)
	
	cLinphoneCore* linphone_proxy_config_get_core(const cLinphoneProxyConfig *obj)
	
	bint linphone_proxy_config_get_dial_escape_plus(const cLinphoneProxyConfig *cfg)
	const char* linphone_proxy_config_get_dial_prefix(const cLinphoneProxyConfig *cfg)
	
	LinphoneReason linphone_proxy_config_get_error(const cLinphoneProxyConfig *cfg)
	const LinphoneErrorInfo* linphone_proxy_config_get_error_info(const cLinphoneProxyConfig* cfg)
	const char* linphone_proxy_config_get_transport(const cLinphoneProxyConfig* cfg)
	
	void linphone_proxy_config_destroy(cLinphoneProxyConfig* cfg)
	void linphone_proxy_config_set_sip_setup(cLinphoneProxyConfig* cfg, const char* type)
	SipSetupContext* linphone_proxy_config_get_sip_setup_context(cLinphoneProxyConfig* cfg)
	SipSetup* linphone_proxy_config_get_sip_setup(cLinphoneProxyConfig* cfg)
	
	int linphone_proxy_config_normalize_number(cLinphoneProxyConfig* proxy, const char* username, char* result, size_t result_len)
	
	void linphone_proxy_config_set_user_data(cLinphoneProxyConfig* cr, void* ud)
	
	void* linphone_proxy_config_get_user_data(cLinphoneProxyConfig* cr)
	
	void linphone_proxy_config_set_privacy(cLinphoneProxyConfig* params, LinphonePrivacyMask privacy)
	LinphonePrivacyMask linphone_proxy_config_get_privacy(const cLinphoneProxyConfig* params)
	
	ctypedef struct LinphoneAccountCreator:
		cLinphoneCore *lc
		SipSetupContext *ssctx
		char* username
		char* password
		char* domain
		char* route
		char* email
		int suscribe
		bint succeeded
	
	LinphoneAccountCreator* linphone_account_creator_new(cLinphoneCore* core, const char* type)
	void linphone_account_creator_set_username(LinphoneAccountCreator* obj, const char* username)
	void linphone_account_creator_set_password(LinphoneAccountCreator* obj, const char* password)
	void linphone_account_creator_set_domain(LinphoneAccountCreator* obj, const char* domain)
	void linphone_account_creator_set_route(LinphoneAccountCreator* obj, const char* route)
	void linphone_account_creator_set_email(LinphoneAccountCreator* obj, const char* email)
	void linphone_account_creator_set_suscribe(LinphoneAccountCreator* obj, int suscribre)
	const char* linphone_account_creator_get_username(LinphoneAccountCreator* obj)
	const char* linphone_account_creator_get_domain(LinphoneAccountCreator* obj)
	int linphone_account_creator_test_existence(LinphoneAccountCreator* obj)
	int linphone_account_creator_test_validation(LinphoneAccountCreator* obj)
	cLinphoneProxyConfig* linphone_account_creator_validate(LinphoneAccountCreator* obj)
	void linphone_account_creator_destroy(LinphoneAccountCreator* obj)
	
	ctypedef struct LinphoneAuthInfo:
		pass
	
	LinphoneAuthInfo* linphone_auth_info_new(const char* username, const char* userid, const char* passwd, const char* ha1, const char* realm, const char* domain)
	void linphone_auth_info_set_passwd(LinphoneAuthInfo* info, const char* passwd)
	void linphone_auth_info_set_username(LinphoneAuthInfo* info, const char* username)
	void linphone_auth_info_set_userid(LinphoneAuthInfo* info, const char* userid)
	void linphone_auth_info_set_realm(LinphoneAuthInfo* info, const char* realm)
	void linphone_auth_info_set_domain(LinphoneAuthInfo* info, const char* domain)
	void linphone_auth_info_set_ha1(LinphoneAuthInfo* info, const char* ha1)
	
	const char* linphone_auth_info_get_username(const LinphoneAuthInfo* i)
	const char* linphone_auth_info_get_passwd(const LinphoneAuthInfo* i)
	const char* linphone_auth_info_get_userid(const LinphoneAuthInfo* i)
	const char* linphone_auth_info_get_realm(const LinphoneAuthInfo* i)
	const char* linphone_auth_info_get_domain(const LinphoneAuthInfo* i)
	const char* linphone_auth_info_get_ha1(const LinphoneAuthInfo* i)

	void linphone_auth_info_destroy(LinphoneAuthInfo* info)
	LinphoneAuthInfo* linphone_auth_info_new_from_config_file(LpConfig* config, int pos)
	
	ctypedef struct LinphoneChatRoom
	ctypedef struct LinphoneChatMessage
	
	ctypedef enum LinphoneChatMessageState:
		LinphoneChatMessageStateIdle
		LinphoneChatMessageStateInProgress
		LinphoneChatMessageStateDelivered
		LinphoneChatMessageStateNotDelivered
	
	ctypedef void (*LinphoneChatMessageStateChangedCb)(LinphoneChatMessage* msg, LinphoneChatMessageState state, void* ud)
	
	void linphone_core_set_chat_database_path(cLinphoneCore* lc, const char* path)
	LinphoneChatRoom* linphone_core_create_chat_room(cLinphoneCore* lc, const char* to)
	LinphoneChatRoom* linphone_core_get_or_create_chat_room(cLinphoneCore* lc, const char* to)
	LinphoneChatRoom* linphone_core_get_chat_room(cLinphoneCore* lc, const LinphoneAddress* addr)
	void linphone_core_disable_chat(cLinphoneCore* lc, LinphoneReason deny_reason)
	void linphone_core_enable_chat(cLinphoneCore* lc)
	bint linphone_core_chat_enabled(const cLinphoneCore* lc)
	void linphone_chat_room_destroy(LinphoneChatRoom* cr)
	
	LinphoneChatMessage* linphone_chat_room_create_message(LinphoneChatRoom* cr, const char* message)
	LinphoneChatMessage* linphone_chat_room_create_message_2(LinphoneChatRoom* cr, const char* message, const char* external_body_url,
	                                                         LinphoneChatMessageState state, time_t time, bint is_read, bint is_incoming)
	const LinphoneAddress* linphone_chat_room_get_peer_address(LinphoneChatRoom* cr)
	void linphone_chat_room_send_message(LinphoneChatRoom* cr, const char* msg)
	void linphone_chat_room_send_message2(LinphoneChatRoom* cr, LinphoneChatMessage* msg, LinphoneChatMessageStateChangedCb status_cb, void* ud)
	void linphone_chat_room_update_url(LinphoneChatRoom* cr, LinphoneChatMessage* msg)
	MSList* linphone_chat_room_get_history(LinphoneChatRoom* cr, int nb_message)
	void linphone_chat_room_mark_as_read(LinphoneChatRoom* cr)
	void linphone_chat_room_delete_message(LinphoneChatRoom* cr, LinphoneChatMessage* msg)
	void linphone_chat_room_delete_history(LinphoneChatRoom* cr)
	void linphone_chat_room_compose(LinphoneChatRoom* cr)
	bint linphone_chat_room_is_remote_composing(const LinphoneChatRoom* cr)
	
	int linphone_chat_room_get_unread_messages_count(LinphoneChatRoom* cr)
	cLinphoneCore* linphone_chat_room_get_lc(LinphoneChatRoom* cr)
	void linphone_chat_room_set_user_data(LinphoneChatRoom* cr, void* ud)
	void* linphone_chat_room_get_user_data(LinphoneChatRoom* cr)
	MSList* linphone_core_get_chat_rooms(cLinphoneCore* lc)
	unsigned int linphone_chat_message_store(LinphoneChatMessage* msg)
	
	const char* linphone_chat_message_state_to_string(const LinphoneChatMessageState state)
	LinphoneChatMessageState linphone_chat_message_get_state(const LinphoneChatMessage* message)
	LinphoneChatMessage* linphone_chat_message_clone(const LinphoneChatMessage* message)
	void linphone_chat_message_destroy(LinphoneChatMessage* msg)
	void linphone_chat_message_set_from(LinphoneChatMessage* message, const LinphoneAddress* from_)
	const LinphoneAddress* linphone_chat_message_get_from(const LinphoneChatMessage* message)
	void linphone_chat_message_set_to(LinphoneChatMessage* message, const LinphoneAddress* from_)
	const LinphoneAddress* linphone_chat_message_get_to(const LinphoneChatMessage* message)
	const char* linphone_chat_message_get_external_body_url(const LinphoneChatMessage* message)
	void linphone_chat_message_set_external_body_url(LinphoneChatMessage* message, const char* url)
	const char* linphone_chat_message_get_text(const LinphoneChatMessage* message)
	time_t linphone_chat_message_get_time(const LinphoneChatMessage* message)
	void* linphone_chat_message_get_user_data(const LinphoneChatMessage* message)
	void linphone_chat_message_set_user_data(LinphoneChatMessage* message, void*)
	LinphoneChatRoom* linphone_chat_message_get_chat_room(LinphoneChatMessage* msg)
	const LinphoneAddress* linphone_chat_message_get_peer_address(LinphoneChatMessage* msg)
	LinphoneAddress* linphone_chat_message_get_local_address(const LinphoneChatMessage* message)
	void linphone_chat_message_add_custom_header(LinphoneChatMessage* message, const char* header_name, const char* header_value)
	const char* linphone_chat_message_get_custom_header(LinphoneChatMessage* message, const char* header_name)
	bint linphone_chat_message_is_read(LinphoneChatMessage* message)
	bint linphone_chat_message_is_outgoing(LinphoneChatMessage* message)
	unsigned int linphone_chat_message_get_storage_id(LinphoneChatMessage* message)
	LinphoneReason linphone_chat_message_get_reason(LinphoneChatMessage* msg)
	const LinphoneErrorInfo* linphone_chat_message_get_error_info(const LinphoneChatMessage* msg)
	
	ctypedef struct LinphoneFriend
	
	ctypedef enum LinphoneGlobalState:
		LinphoneGlobalOff
		LinphoneGlobalStartup
		LinphoneGlobalOn
		LinphoneGlobalShutdown
		LinphoneGlobalConfiguring
	
	const char* linphone_global_state_to_string(LinphoneGlobalState gs)
	
	ctypedef void (*LinphoneCoreGlobalStateChangedCb)(cLinphoneCore* lc, LinphoneGlobalState gstate, const char* message)
	ctypedef void (*LinphoneCoreCallStateChangedCb)(cLinphoneCore* lc, cLinphoneCall* call, LinphoneCallState cstate, const char* message)
	ctypedef void (*LinphoneCoreCallEncryptionChangedCb)(cLinphoneCore* lc, cLinphoneCall* call, bint on, const char* authentication_token)
	
	ctypedef void (*LinphoneCoreRegistrationStateChangedCb)(cLinphoneCore* lc, cLinphoneProxyConfig* cfg, LinphoneRegistrationState cstate, const char* message)
	
	## Deprecated functions; we won't import them
	#ctypedef void (*ShowInterfaceCb)(cLinphoneCore* lc)
	#ctypedef void (*DisplayStatusCb)(cLinphoneCore* lc, const char* message)
	#ctypedef void (*DisplayMessageCb)(cLinphoneCore* lc, const char* message)
	#ctypedef void (*DisplayUrlCb)(cLinphoneCore* lc, const char* message, const char* url)
	ctypedef void (*LinphoneCoreCbFunc)(cLinphoneCore* lc, void* user_data)
	ctypedef void (*LinphoneCoreNotifyPresenceReceivedCb)(cLinphoneCore* lc, LinphoneFriend* lf)
	ctypedef void (*LinphoneCoreNewSubscriptionRequestedCb)(cLinphoneCore* lc, LinphoneFriend* lf, const char* url)
	ctypedef void (*LinphoneCoreAuthInfoRequestedCb)(cLinphoneCore* lc, const char* realm, const char* username)
	ctypedef void (*LinphoneCoreCallLogUpdatedCb)(cLinphoneCore* lc, LinphoneCallLog* newcl)
	ctypedef void (*LinphoneCoreTextMessageReceivedCb)(cLinphoneCore* lc, LinphoneChatRoom* room, const LinphoneAddress* from_, const char* message)
	ctypedef void (*LinphoneCoreMessageReceivedCb)(cLinphoneCore* lc, LinphoneChatRoom* room, LinphoneChatMessage* message)
	ctypedef void (*LinphoneCoreIsComposingReceivedCb)(cLinphoneCore* lc, LinphoneChatRoom* room)
	ctypedef void (*LinphoneCoreDtmfReceivedCb)(cLinphoneCore* lc, cLinphoneCall* call, int dtmf)
	ctypedef void (*LinphoneCoreReferReceivedCb)(cLinphoneCore* lc, const char* refer_to)
	ctypedef void (*LinphoneCoreBuddyInfoUpdatedCb)(cLinphoneCore* lc, LinphoneFriend* lf)
	ctypedef void (*LinphoneCoreTransferStateChangedCb)(cLinphoneCore* lc, cLinphoneCall* transfered, LinphoneCallState new_call_state)
	ctypedef void (*LinphoneCoreCallStatsUpdatedCb)(cLinphoneCore* lc, cLinphoneCall* call, const LinphoneCallStats* stats)
	ctypedef void (*LinphoneCoreInfoReceivedCb)(cLinphoneCore* lc, cLinphoneCall* call, const LinphoneInfoMessage* msg)
	
	ctypedef enum LinphoneConfiguringState:
		LinphoneConfiguringSuccessful
		LinphoneConfiguringFailed
		LinphoneConfiguringSkipped
	
	ctypedef void (*LinphoneCoreConfiguringStatusCb)(cLinphoneCore* lc, LinphoneConfiguringState status, const char* message)
	
	ctypedef void* LinphoneCoreSubscriptionStateChangedCb
	ctypedef void* LinphoneCoreNotifyReceivedCb
	ctypedef void* LinphoneCorePublishStateChangedCb
	
	ctypedef struct cLinphoneCoreVTable "LinphoneCoreVTable":
		LinphoneCoreGlobalStateChangedCb global_state_changed
		LinphoneCoreRegistrationStateChangedCb registration_state_changed
		LinphoneCoreCallStateChangedCb call_state_changed
		LinphoneCoreNotifyPresenceReceivedCb notify_presence_received
		LinphoneCoreNewSubscriptionRequestedCb new_subscription_requested
		LinphoneCoreAuthInfoRequestedCb auth_info_requested
		LinphoneCoreCallLogUpdatedCb call_log_updated
		LinphoneCoreMessageReceivedCb message_received
		LinphoneCoreIsComposingReceivedCb is_composing_received
		LinphoneCoreDtmfReceivedCb dtmf_received
		LinphoneCoreReferReceivedCb refer_received
		LinphoneCoreCallEncryptionChangedCb call_encryption_changed
		LinphoneCoreTransferStateChangedCb transfer_state_changed
		LinphoneCoreBuddyInfoUpdatedCb buddy_info_updated
		LinphoneCoreCallStatsUpdatedCb call_stats_updated
		LinphoneCoreInfoReceivedCb info_received
		LinphoneCoreSubscriptionStateChangedCb subscription_state_changed
		LinphoneCoreNotifyReceivedCb notify_received
		LinphoneCorePublishStateChangedCb publish_state_changed
		LinphoneCoreConfiguringStatusCb configuring_status
	
	ctypedef struct LCCallbackObj:
		LinphoneCoreCbFunc _func
		void* _user_data
	
	ctypedef enum LinphoneFirewallPolicy:
		LinphonePolicyNoFirewall
		LinphonePolicyUseNatAddress
		LinphonePolicyUseStun
		LinphonePolicyUseIce
		LinphonePolicyUseUpnp
	
	ctypedef enum LinphoneWaitingState:
		LinphoneWaitingStart
		LinphoneWaitingProgress
		LinphoneWaitingFinished
	
	ctypedef void* (*LinphoneWaitingCallback)(cLinphoneCore* lc, void* context, LinphoneWaitingState ws, const char* purpose, float progress)
	
	void linphone_core_set_log_handler(OrtpLogFunc logfunc)
	void linphone_core_set_log_file(FILE* file)
	void linphone_core_set_log_level(OrtpLogLevel loglevel)
	
	void linphone_core_enable_logs(FILE* file)
	void linphone_core_enable_logs_with_cb(OrtpLogFunc logfunc)
	void linphone_core_disable_logs()
	const char* linphone_core_get_version()
	const char* linphone_core_get_user_agent_name()
	const char* linphone_core_get_user_agent_version()
	
	cLinphoneCore* linphone_core_new(const cLinphoneCoreVTable* vtable, const char* config_path, const char* factory_config, void* userdata)
	cLinphoneCore* linphone_core_new_with_config(const cLinphoneCoreVTable* vtable, LpConfig* config, void* userdata)
	
	void linphone_core_iterate(cLinphoneCore* lc)
	
	void linphone_core_set_user_agent(cLinphoneCore* lc, const char* ua_name, const char* version)
	
	LinphoneAddress* linphone_core_interpret_url(cLinphoneCore* lc, const char* url)
	
	cLinphoneCall* linphone_core_invite(cLinphoneCore* lc, const char* url)
	
	cLinphoneCall* linphone_core_invite_address(cLinphoneCore* lc, const LinphoneAddress* addr)
	
	cLinphoneCall* linphone_core_invite_with_params(cLinphoneCore* lc, const char* url, const _LinphoneCallParams* params)
	
	cLinphoneCall* linphone_core_invite_address_with_params(cLinphoneCore* lc, const LinphoneAddress* addr, const _LinphoneCallParams* params)
	
	int linphone_core_transfer_call(cLinphoneCore* lc, cLinphoneCall* call, const char* refer_to)
	
	int linphone_core_transfer_call_to_another(cLinphoneCore* lc, cLinphoneCall* call, cLinphoneCall* dest)
	
	cLinphoneCall* linphone_core_start_refered_call(cLinphoneCore* lc, cLinphoneCall* call, const _LinphoneCallParams* params)
	
	bint linphone_core_inc_invite_pending(cLinphoneCore* lc)
	
	bint linphone_core_in_call(const cLinphoneCore* lc)
	
	cLinphoneCall* linphone_core_get_current_call(const cLinphoneCore* lc)
	
	int linphone_core_accept_call(cLinphoneCore* lc, cLinphoneCall* call)
	int linphone_core_accept_call_with_params(cLinphoneCore* lc, cLinphoneCall* call, const _LinphoneCallParams* params)
	int linphone_core_accept_early_media_with_params(cLinphoneCore* lc, cLinphoneCall* call, const _LinphoneCallParams* params)
	int linphone_core_accept_early_media(cLinphoneCore* lc, cLinphoneCall* call)
	
	int linphone_core_terminate_call(cLinphoneCore* lc, cLinphoneCall* call)
	
	int linphone_core_redirect_call(cLinphoneCore* lc, cLinphoneCall* call, const char* redirect_uri)
	
	int linphone_core_decline_call(cLinphoneCore* lc, cLinphoneCall* call, LinphoneReason reason)
	
	int linphone_core_terminate_all_calls(cLinphoneCore* lc)
	
	int linphone_core_pause_call(cLinphoneCore* lc, cLinphoneCall* call)
	
	int linphone_core_pause_all_calls(cLinphoneCore* lc)
	
	int linphone_core_resume_call(cLinphoneCore* lc, cLinphoneCall* call)
	
	int linphone_core_update_call(cLinphoneCore* lc, cLinphoneCall* call, const _LinphoneCallParams* params)
	
	int linphone_core_defer_call_update(cLinphoneCore* lc, cLinphoneCall* call)
	int linphone_core_accept_call_update(cLinphoneCore* lc, cLinphoneCall* call, const _LinphoneCallParams* params)
	
	_LinphoneCallParams* linphone_core_create_default_call_parameters(cLinphoneCore* lc)
	
	cLinphoneCall* linphone_core_get_call_by_remote_address(cLinphoneCore* lc, const char* remote_address)
	
	void linphone_core_send_dtmf(cLinphoneCore* lc, char dtmf)
	
	int linphone_core_set_primary_contact(cLinphoneCore* lc, const char* contact)
	
	const char* linphone_core_get_primary_contact(cLinphoneCore* lc)
	
	const char* linphone_core_get_identity(cLinphoneCore* lc)
	
	void linphone_core_set_guess_hostname(cLinphoneCore* lc, bint val)
	bint linphone_core_get_guess_hostname(cLinphoneCore* lc)
	
	bint linphone_core_ipv6_enabled(cLinphoneCore* lc)
	void linphone_core_enable_ipv6(cLinphoneCore* lc, bint val)
	
	LinphoneAddress* linphone_core_get_primary_contact_parsed(cLinphoneCore* lc)
	const char* linphone_core_get_identity(cLinphoneCore* lc)
	
	void linphone_core_set_download_bandwidth(cLinphoneCore* lc, int bw)
	void linphone_core_set_upload_bandwidth(cLinphoneCore* lc, int bw)
	
	int linphone_core_get_download_bandwidth(cLinphoneCore* lc)
	int linphone_core_get_upload_bandwidth(cLinphoneCore* lc)
	
	void linphone_core_enable_adaptive_rate_control(cLinphoneCore* lc, bint enabled)
	bint linphone_core_adaptive_rate_control_enabled(cLinphoneCore* lc)
	
	void linphone_core_set_download_ptime(cLinphoneCore* lc, int ptime)
	int linphone_core_get_download_ptime(cLinphoneCore* lc)
	
	void linphone_core_set_upload_ptime(cLinphoneCore* lc, int ptime)
	int linphone_core_get_upload_ptime(cLinphoneCore* lc)
	
	void linphone_core_enable_dns_srv(cLinphoneCore* lc, bint enable)
	bint linphone_core_dns_srv_enabled(const cLinphoneCore* lc)
	
	const MSList* linphone_core_get_audio_codecs(const cLinphoneCore* lc)
	int linphone_core_set_audio_codecs(cLinphoneCore* lc, MSList* codecs)
	
	const MSList* linphone_core_get_video_codecs(const cLinphoneCore* lc)
	int linphone_core_set_video_codecs(const cLinphoneCore* lc, MSList* codecs)
	
	bint linphone_core_payload_type_enabled(cLinphoneCore* lc, PayloadType* pt)
	int linphone_core_enable_payload_type(cLinphoneCore* lc, PayloadType* pt, bint enable)
	
	cdef int LINPHONE_FIND_PAYLOAD_IGNORE_RATE
	cdef int LINPHONE_FIND_PAYLOAD_IGNORE_CHANNELS
	
	PayloadType* linphone_core_find_payload_type(cLinphoneCore* lc, const char* type, int rate, int channels)
	int linphone_core_get_payload_type_number(cLinphoneCore* lc, const PayloadType* pt)
	
	const char* linphone_core_get_payload_type_description(cLinphoneCore* lc, PayloadType* pt)
	
	bint linphone_core_check_payload_type_usability(cLinphoneCore* lc, PayloadType* pt)
	
	cLinphoneProxyConfig* linphone_core_create_proxy_config(cLinphoneCore* lc)
	int linphone_core_add_proxy_config(cLinphoneCore* lc, cLinphoneProxyConfig* config)
	void linphone_core_clear_proxy_config(cLinphoneCore* lc)
	void linphone_core_remove_proxy_config(cLinphoneCore* lc, cLinphoneProxyConfig* config)
	
	const MSList* linphone_core_get_proxy_config_list(const cLinphoneCore* lc)
	void linphone_core_set_default_proxy(cLinphoneCore* lc, cLinphoneProxyConfig* config)
	void linphone_core_set_default_proxy_index(cLinphoneCore* lc, int index)
	int linphone_core_get_default_proxy(cLinphoneCore* lc, cLinphoneProxyConfig** config)
	
	LinphoneAuthInfo* linphone_core_create_auth_info(cLinphoneCore* lc, const char* username, const char* userid, const char* passwd,
	                                                 const char* ha1, const char* realm, const char* domain)
	void linphone_core_add_auth_info(cLinphoneCore* lc, const LinphoneAuthInfo* info)
	void linphone_core_remove_auth_info(cLinphoneCore* lc, const LinphoneAuthInfo* info)
	
	const MSList* linphone_core_get_auth_info_list(const cLinphoneCore* lc)
	const LinphoneAuthInfo* linphone_core_find_auth_info(cLinphoneCore* lc, const char* realm, const char* username)
	void linphone_core_abort_authentication(cLinphoneCore* lc, LinphoneAuthInfo* info)
	void linphone_core_clear_all_auth_info(cLinphoneCore* lc)
	
	void linphone_core_enable_audio_adaptive_jittcomp(cLinphoneCore* lc, bint enable)
	bint linphone_core_audio_adaptive_jittcomp_enabled(cLinphoneCore* lc)
	
	int linphone_core_get_audio_jittcomp(cLinphoneCore* lc)
	void linphone_core_set_audio_jittcomp(cLinphoneCore* lc, int value)
	
	void linphone_core_enable_video_adaptive_jittcomp(cLinphoneCore* lc, bint enable)
	bint linphone_core_video_adaptive_jittcomp_enabled(cLinphoneCore* lc)
	
	int linphone_core_get_video_jittcomp(cLinphoneCore* lc)
	void linphone_core_set_video_jittcomp(cLinphoneCore* lc, int value)
	
	int linphone_core_get_audio_port(const cLinphoneCore* lc)
	void linphone_core_get_audio_port_range(const cLinphoneCore* lc, int* min_port, int* max_port)
	int linphone_core_get_video_port(const cLinphoneCore* lc)
	void linphone_core_get_video_port_range(const cLinphoneCore* lc, int* min_port, int* max_port)
	int linphone_core_get_nortp_timeout(const cLinphoneCore* lc)
	
	void linphone_core_set_audio_port(cLinphoneCore* lc, int port)
	void linphone_core_set_audio_port_range(cLinphoneCore* lc, int min_port, int max_port)
	void linphone_core_set_video_port(cLinphoneCore* lc, int port)
	void linphone_core_set_video_port_range(cLinphoneCore* lc, int min_port, int max_port)
	
	void linphone_core_set_nortp_timeout(cLinphoneCore* lc, int port)
	
	void linphone_core_set_use_info_for_dtmf(cLinphoneCore* lc, bint use_info)
	bint linphone_core_get_use_info_for_dtmf(cLinphoneCore* lc)
	
	void linphone_core_set_use_rfc2833_for_dtmf(cLinphoneCore* lc, bint use_rfc2833)
	bint linphone_core_get_use_rfc2833_for_dtfm(cLinphoneCore* lc)
	
	void linphone_core_set_sip_port(cLinphoneCore* lc, int port)
	int linphone_core_get_sip_port(cLinphoneCore* lc)
	
	int linphone_core_set_sip_transports(cLinphoneCore* lc, const LCSipTransports* transports)
	int linphone_core_get_sip_transports(cLinphoneCore* lc, LCSipTransports* transports)
	
	void linphone_core_get_sip_transports_used(cLinphoneCore* lc, LCSipTransports* tr)
	bint linphone_core_sip_transport_supported(const cLinphoneCore* lc, LinphoneTransportType tp)
	
	ortp_socket_t linphone_core_get_sip_socket(cLinphoneCore* lc)
	
	void linphone_core_set_inc_timeout(cLinphoneCore* lc, int seconds)
	int linphone_core_get_inc_timeout(cLinphoneCore* lc)
	
	void linphone_core_set_in_call_timeout(cLinphoneCore* lc, int seconds)
	int linphone_core_get_in_call_timeout(cLinphoneCore* lc)
	void linphone_core_set_delayed_timeout(cLinphoneCore* lc, int seconds)
	int linphone_core_get_delayed_timeout(cLinphoneCore* lc)
	
	void linphone_core_set_stun_server(cLinphoneCore* lc, const char* server)
	const char* linphone_core_get_stun_server(cLinphoneCore* lc)
	
	bint linphone_core_upnp_available()
	LinphoneUpnpState linphone_core_get_upnp_state(const cLinphoneCore* lc)
	const char* linphone_core_get_upnp_external_ipaddress(const cLinphoneCore* lc)
	
	void linphone_core_set_nat_address(cLinphoneCore* lc, const char* addr)
	const char* linphone_core_get_nat_address(const cLinphoneCore* lc)
	
	void linphone_core_set_firewall_policy(cLinphoneCore* lc, LinphoneFirewallPolicy pol)
	LinphoneFirewallPolicy linphone_core_get_firewall_policy(const cLinphoneCore* lc)
	
	const char** linphone_core_get_sound_devices(cLinphoneCore* lc)
	bint linphone_core_sound_device_can_capture(cLinphoneCore* lc, const char* device)
	bint linphone_core_sound_device_can_playback(cLinphoneCore* lc, const char* device)
	int linphone_core_get_ring_level(cLinphoneCore* lc)
	int linphone_core_get_play_level(cLinphoneCore* lc)
	int linphone_core_get_rec_level(cLinphoneCore* lc)
	void linphone_core_set_ring_level(cLinphoneCore* lc, int level)
	void linphone_core_set_play_level(cLinphoneCore* lc, int level)
	void linphone_core_set_rec_level(cLinphoneCore* lc, int level)
	
	void linphone_core_set_mic_gain_db(cLinphoneCore* lc, float level)
	float linphone_core_get_mic_gain_db(cLinphoneCore* lc)
	void linphone_core_set_playback_gain_db(cLinphoneCore *lc, float level)
	float linphone_core_get_playback_gain_db(cLinphoneCore* lc)
	
	const char* linphone_core_get_ringer_device(cLinphoneCore* lc)
	const char* linphone_core_get_playback_device(cLinphoneCore* lc)
	const char* linphone_core_get_capture_device(cLinphoneCore* lc)
	int linphone_core_set_ringer_device(cLinphoneCore* lc, const char* devid)
	int linphone_core_set_playback_device(cLinphoneCore* lc, const char* devid)
	int linphone_core_set_capture_device(cLinphoneCore* lc, const char* devid)
	char linphone_core_get_sound_source(cLinphoneCore* lc)
	void linphone_core_set_sound_source(cLinphoneCore* lc, char source)
	void linphone_core_stop_ringing(cLinphoneCore* lc)
	void linphone_core_set_ring(cLinphoneCore* lc, const char* path)
	const char* linphone_core_get_ring(const cLinphoneCore* lc)
	void linphone_core_verify_server_certificates(cLinphoneCore* lc, bint yesno)
	void linphone_core_verify_server_cn(cLinphoneCore* lc, bint yesno)
	void linphone_core_set_root_ca(cLinphoneCore* lc, const char* path)
	void linphone_core_set_ringback(cLinphoneCore* lc, const char* path)
	const char* linphone_core_get_ringback(const cLinphoneCore* lc)
	
	void linphone_core_set_remote_ringback_tone(cLinphoneCore* lc, const char*)
	const char* linphone_core_get_remote_ringback_tone(const cLinphoneCore* lc)
	
	int linphone_core_preview_ring(cLinphoneCore* lc, const char* ring, LinphoneCoreCbFunc func, void* userdata)
	int linphone_core_play_local(cLinphoneCore* lc, const char* audiofile)
	void linphone_core_enable_echo_cancellation(cLinphoneCore* lc, bint val)
	bint linphone_core_echo_cancellation_enabled(cLinphoneCore* lc)
	
	void linphone_core_enable_echo_limiter(cLinphoneCore* lc, bint val)
	bint linphone_core_echo_limiter_enabled(const cLinphoneCore* lc)
	
	void linphone_core_enable_agc(cLinphoneCore* lc, bint val)
	bint linphone_core_agc_enabled(const cLinphoneCore* lc)
	
	void linphone_core_mute_mic(cLinphoneCore* lc, bint muted)
	bint linphone_core_is_mic_muted(cLinphoneCore* lc)
	
	void linphone_core_enable_mic(cLinphoneCore* lc, bint enable)
	bint linphone_core_mic_enabled(cLinphoneCore* lc)
	
	bint linphone_core_is_rtp_muted(cLinphoneCore* lc)
	
	bint linphone_core_get_rtp_no_xmit_on_audio_mute(const cLinphoneCore* lc)
	void linphone_core_set_rtp_no_xmit_on_audio_mute(cLinphoneCore* lc, bint val)
	
	const MSList* linphone_core_get_call_logs(cLinphoneCore* lc)
	void linphone_core_clear_call_logs(cLinphoneCore* lc)
	
	int linphone_core_get_missed_calls_count(cLinphoneCore* lc)
	void linphone_core_reset_missed_calls_count(cLinphoneCore* lc)
	void linphone_core_remove_call_log(cLinphoneCore* lc, LinphoneCallLog* call_log)
	
	bint linphone_core_video_supported(cLinphoneCore* lc)
	
	void linphone_core_enable_video(cLinphoneCore* lc, bint vcap_enabled, bint display_enabled)
	bint linphone_core_video_enabled(cLinphoneCore* lc)
	void linphone_core_enable_video_capture(cLinphoneCore* lc, bint enable)
	void linphone_core_enable_video_display(cLinphoneCore* lc, bint enable)
	bint linphone_core_video_capture_enabled(cLinphoneCore* lc)
	bint linphone_core_video_display_enabled(cLinphoneCore* lc)
	
	void linphone_core_set_video_policy(cLinphoneCore* lc, const LinphoneVideoPolicy* policy)
	const LinphoneVideoPolicy* linphone_core_get_video_policy(cLinphoneCore* lc)
	
	ctypedef struct MSVideoSizeDef:
		MSVideoSize vsize
		const char* name
	
	const MSVideoSizeDef* linphone_core_get_supported_video_sizes(cLinphoneCore* lc)
	void linphone_core_set_preferred_video_size(cLinphoneCore* lc, MSVideoSize vsize)
	MSVideoSize linphone_core_get_preferred_video_size(cLinphoneCore* lc)
	void linphone_core_set_preferred_video_size_by_name(cLinphoneCore* lc, const char* name)
	
	void linphone_core_enable_video_preview(cLinphoneCore* lc, bint val)
	bint linphone_core_video_preview_enabled(const cLinphoneCore* lc)
	
	void linphone_core_enable_self_view(cLinphoneCore* lc, bint val)
	bint linphone_core_self_view_enabled(const cLinphoneCore* lc)
	
	void linphone_core_reload_video_devices(cLinphoneCore* lc)
	
	const char** linphone_core_get_video_devices(const cLinphoneCore* lc)
	int linphone_core_set_video_device(cLinphoneCore* lc, const char* id)
	const char* linphone_core_get_video_device(const cLinphoneCore* lc)
	
	int linphone_core_set_static_picture(cLinphoneCore* lc, const char* path)
	const char* linphone_core_get_static_picture(cLinphoneCore* lc)
	
	int linphone_core_set_static_picture_fps(cLinphoneCore* lc, float fps)
	float linphone_core_get_static_picture_fps(cLinphoneCore* lc)
	
	unsigned long linphone_core_get_native_video_window_id(const cLinphoneCore* lc)
	void linphone_core_set_native_video_window_id(cLinphoneCore *lc, unsigned long id)
	
	unsigned long linphone_core_get_native_preview_window_id(const cLinphoneCore* lc)
	void linphone_core_set_native_preview_window_id(cLinphoneCore* lc, unsigned long id)
	
	void linphone_core_use_preview_window(cLinphoneCore* lc, bint yesno)
	int linphone_core_get_device_rotation(cLinphoneCore* lc)
	void linphone_core_set_device_rotation(cLinphoneCore* lc, int rotation)
	
	int linphone_core_get_camera_sensor_rotation(cLinphoneCore* lc)
	
	void linphone_core_show_video(cLinphoneCore* lc, bint show)
	
	void linphone_core_use_files(cLinphoneCore* lc, bint yesno)
	void linphone_core_set_play_file(cLinphoneCore* lc, const char* file)
	void linphone_core_set_record_file(cLinphoneCore* lc, const char* file)
	
	void linphone_core_play_dtmf(cLinphoneCore* lc, char dtmf, int duration_ms)
	void linphone_core_stop_dtmf(cLinphoneCore* lc)
	
	int linphone_core_get_current_call_duration(const cLinphoneCore* lc)
	
	int linphone_core_get_mtu(const cLinphoneCore* lc)
	void linphone_core_set_mtu(cLinphoneCore* lc, int mtu)
	
	void linphone_core_set_network_reachable(cLinphoneCore* lc, bint value)
	bint linphone_core_is_network_reachabled(cLinphoneCore* lc)
	
	void linphone_core_enable_keep_alive(cLinphoneCore* lc, bint enable)
	
	bint linphone_core_keep_alive_enabled(cLinphoneCore* lc)
	
	void* linphone_core_get_user_data(cLinphoneCore* lc)
	void linphone_core_set_user_data(cLinphoneCore* lc)
	
	LpConfig* linphone_core_get_config(cLinphoneCore* lc)
	LpConfig* linphone_core_create_lp_config(cLinphoneCore* lc, const char* filename)
	
	void linphone_core_set_waiting_callback(cLinphoneCore* lc, LinphoneWaitingCallback cb, void* user_context)
	
	const MSList* linphone_core_get_sip_setups(cLinphoneCore* lc)
	
	void linphone_core_destroy(cLinphoneCore* lc)
	
	ctypedef RtpTransport* (*LinphoneCoreRtpTransportFactoryFunc)(void* data, int port)
	ctypedef struct LinphoneRtpTransportFactories:
		LinphoneCoreRtpTransportFactoryFunc audio_rtp_func
		void* audio_rtp_func_data
		LinphoneCoreRtpTransportFactoryFunc audio_rtcp_func
		void* audio_rtcp_func_data
		LinphoneCoreRtpTransportFactoryFunc video_rtp_func
		void* video_rtp_func_data
		LinphoneCoreRtpTransportFactoryFunc video_rtcp_func
		void* video_rtcp_func_data
	
	void linphone_core_set_rtp_transport_factories(cLinphoneCore* lc, LinphoneRtpTransportFactories* factories)
	
	int linphone_core_get_current_call_stats(cLinphoneCore* lc, rtp_stats_t* local, rtp_stats_t* remote)
	
	int linphone_core_get_calls_nb(const cLinphoneCore* lc)
	const MSList* linphone_core_get_calls(cLinphoneCore* lc)
	
	LinphoneGlobalState linphone_core_get_global_state(const cLinphoneCore* lc)
	
	void linphone_core_refresh_registers(cLinphoneCore* lc)
	
	void linphone_core_set_zrtp_secrets_file(cLinphoneCore* lc, const char* file)
	const char* linphone_core_get_zrtp_secrets_file(cLinphoneCore* lc)
	
	const cLinphoneCall* linphone_core_find_call_from_uri(cLinphoneCore* lc, const char* uri)
	
	int linphone_core_add_to_conference(cLinphoneCore* lc, cLinphoneCall* call)
	int linphone_core_add_all_to_conference(cLinphoneCore* lc)
	int linphone_core_remove_from_conference(cLinphoneCore* lc, cLinphoneCall* call)
	bint linphone_core_is_in_conference(const cLinphoneCore* lc)
	int linphone_core_enter_conference(cLinphoneCore* lc)
	int linphone_core_leave_conference(cLinphoneCore* lc)
	float linphone_core_get_conference_local_input_volume(cLinphoneCore* lc)
	
	int linphone_core_terminate_conference(cLinphoneCore* lc)
	int linphone_core_get_conference_size(cLinphoneCore* lc)
	
	int linphone_core_start_conference_recording(cLinphoneCore* lc, const char* path)
	int linphone_core_stop_conference_recording(cLinphoneCore* lc)
	
	int linphone_core_get_max_calls(cLinphoneCore* lc)
	void linphone_core_set_max_calls(cLinphoneCore* lc, int max)
	
	bint linphone_core_sound_resources_locked(cLinphoneCore* lc)
	
	bint linphone_core_media_encryption_supported(const cLinphoneCore* lc, LinphoneMediaEncryption menc)
	
	int linphone_core_set_media_encryption(cLinphoneCore* lc, LinphoneMediaEncryption menc)
	LinphoneMediaEncryption linphone_core_get_media_encryption(cLinphoneCore* lc)
	
	bint linphone_core_is_media_encryption_mandatory(cLinphoneCore* lc)
	void linphone_core_set_media_encryption_mandatory(cLinphoneCore* lc, bint m)
	
	void linphone_core_init_default_params(cLinphoneCore* lc, _LinphoneCallParams* params)
	
	bint linphone_core_tunnel_available()
	
	ctypedef struct LinphoneTunnel:
		pass
	
	LinphoneTunnel* linphone_core_get_tunnel(cLinphoneCore* lc)
	
	void linphone_core_set_sip_dscp(cLinphoneCore* lc, int dscp)
	int linphone_core_get_sip_dscp(const cLinphoneCore* lc)
	void linphone_core_set_audio_dscp(cLinphoneCore* lc, int dscp)
	int linphone_core_get_audio_dscp(const cLinphoneCore* lc)
	void linphone_core_set_video_dscp(cLinphoneCore* lc, int dscp)
	int linphone_core_get_video_dscp(const cLinphoneCore* lc)
	const char* linphone_core_get_video_display_filter(cLinphoneCore* lc)
	void linphone_core_set_video_display_filter(cLinphoneCore* lc, const char* filtername)
	
	ctypedef unsigned int ContactSearchID
	
	ctypedef struct LinphoneContactSearch
	ctypedef struct LinphoneContactProvider
	
	ctypedef void (*ContactSearchCallback)(LinphoneContactSearch* id, MSList* friends, void* data)
	
	void linphone_core_set_provisioning_uri(cLinphoneCore* lc, const char* uri)
	const char* linphone_core_get_provisioning_uri(const cLinphoneCore* lc)
	
	bint linphone_core_is_provisioning_transient(cLinphoneCore* lc)
	int linphone_core_migrate_to_multi_transport(cLinphoneCore* lc)
	
	void linphone_core_enable_sdp_200_ack(cLinphoneCore* lc, bint enable)
	bint linphone_core_sdp_200_ack_enabled(const cLinphoneCore* lc)
	
	ctypedef enum LinphoneToneID:
		LinphoneToneUndefined
		LinphoneToneBusy
		LinphoneToneCallWaiting
		LinphoneToneCallOnHold
		LinphoneToneCallLost
	
	void linphone_core_set_call_error_tone(cLinphoneCore* lc, LinphoneReason reason, const char* audiofile)
	void linphone_core_set_tone(cLinphoneCore* lc, LinphoneToneID id, const char* audiofile)

