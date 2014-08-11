
from .core cimport cLinphoneCore, LinphoneAddress, LinphoneReason, LinphoneContent, LinphoneErrorInfo

cdef extern from "linphone/event.h" nogil:
	ctypedef struct LinphoneEvent:
		pass
	
	ctypedef enum LinphoneSubscriptionDir:
		LinphoneSubscriptionIncoming
		LinphoneSubscriptionOutgoing
		LinphoneSubscriptionInvalidDir
	
	ctypedef enum LinphoneSubscriptionState:
		LinphoneSubscriptionNone
		LinphoneSubscriptionOutgoingInit
		LinphoneSubscriptionIncomingReceived
		LinphoneSubscriptionPending
		LinphoneSubscriptionActive
		LinphoneSubscriptionTerminated
		LinphoneSubscriptionError
		LinphoneSubscriptionExpiring
	
	const char* linphone_subscription_state_to_string(LinphoneSubscriptionState state)
	
	ctypedef enum LinphonePublishState:
		LinphonePublishNone
		LinphonePublishProgress
		LinphonePublishOk
		LinphonePublishError
		LinphonePublishExpiring
		LinphonePublishCleared
	
	const char* linphone_publish_state_to_string(LinphonePublishState state)
	
	ctypedef void (*LinphoneCoreNotifyReceivedCb)(cLinphoneCore* lc, LinphoneEvent* lev, const char* notified_event, const LinphoneContent* body)
	ctypedef void (*LinphoneCoreSubscriptionStateChangedCb)(cLinphoneCore* lc, LinphoneEvent* lev, LinphonePublishState state)
	ctypedef void (*LinphoneCorePublishStateChangedCb)(cLinphoneCore* lc, LinphoneEvent* lev, LinphonePublishState state)
	
	LinphoneEvent* linphone_core_subscribe(cLinphoneCore* lc, const LinphoneAddress* resource, const char* event, int expires, const LinphoneContent* body)
	
	LinphoneEvent* linphone_core_create_subscribe(cLinphoneCore* lc, const LinphoneAddress* resource, const char* event, int expires)
	
	int linphone_event_send_subscribe(LinphoneEvent* lev, const LinphoneContent* body)
	
	int linphone_event_update_subscribe(LinphoneEvent* lev, const LinphoneContent* body)
	
	int linphone_event_accept_subscription(LinphoneEvent* lev)
	
	int linphone_event_deny_subscription(LinphoneEvent* lev, LinphoneReason reason)
	
	int linphone_event_notify(LinphoneEvent* lev, const LinphoneContent* body)
	
	LinphoneEvent* linphone_core_publish(cLinphoneCore* lc, const LinphoneAddress* resource, const char* event, int expires, const LinphoneContent* body)
	
	LinphoneEvent* linphone_core_create_publish(cLinphoneCore* lc, const LinphoneAddress* resource, const char* event, int expires)
	
	int linphone_event_send_publish(LinphoneEvent* lev, const LinphoneContent* body)
	
	int linphone_event_update_publish(LinphoneEvent* lev, const LinphoneContent* body)
	
	LinphoneReason linphone_event_get_reason(const LinphoneEvent* lev)
	
	const LinphoneErrorInfo* linphone_event_get_error_info(const LinphoneEvent* lev)
	
	LinphoneSubscriptionState linphone_event_get_subscription_state(const LinphoneEvent* lev)
	
	LinphonePublishState linphone_event_get_publish_state(const LinphoneEvent* lev)
	
	LinphoneSubscriptionDir linphone_event_get_subscription_dir(LinphoneEvent* lev)
	
	void linphone_event_set_user_data(LinphoneEvent* ev, void* up)
	
	void* linphone_event_get_user_data(LinphoneEvent* ev)
	
	void linphone_event_add_custom_header(LinphoneEvent* ev, const char* name, const char* value)
	
	const char* linphone_event_get_custom_header(LinphoneEvent* ev, const char* name)
	
	void linphone_event_terminate(LinphoneEvent* lev)
	
	LinphoneEvent* linphone_event_ref(LinphoneEvent* lev)
	
	void linphone_event_unref(LinphoneEvent* lev)
	
	const char* linphone_event_get_name(const LinphoneEvent* lev)
	
	const LinphoneAddress* linphone_event_get_from(const LinphoneEvent* lev)
	
	const LinphoneAddress* linphone_event_get_resource(const LinphoneEvent* lev)
	
	cLinphoneCore* linphone_event_get_core(const LinphoneEvent* lev)
	
