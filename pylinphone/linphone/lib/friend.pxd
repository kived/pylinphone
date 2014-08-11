
from .core cimport cLinphoneCore
from pylinphone.linphone.lib.mediastreamer2.mscommon cimport MSList
from .presence cimport LinphonePresenceModel

cdef extern from "linphone/linphonefriend.h" nogil:
	ctypedef enum LinphoneSubscribePolicy:
		LinphoneSPWait
		LinphoneSPDeny
		LinphoneSPAccept
	
	ctypedef enum LinphoneOnlineStatus:
		LinphoneStatusOffline
		LinphoneStatusOnline
		LinphoneStatusBusy
		LinphoneStatusBeRightBack
		LinphoneStatusAway
		LinphoneStatusOnThePhone
		LinphoneStatusOutToLunch
		LinphoneStatusDoNotDisturb
		LinphoneStatusMoved
		LinphoneStatusAltService
		LinphoneStatusPending
		LinphoneStatusVacation
		LinphoneStatusEnd
	
	ctypedef struct LinphoneFriend:
		pass
	
	ctypedef struct LinphoneAddress:
		pass
	
	ctypedef struct BuddyInfo:
		pass
	
	LinphoneFriend* linphone_friend_new()
	LinphoneFriend* linphone_friend_new_with_address(const char* addr)
	
	void linphone_friend_destroy(LinphoneFriend* lf)
	
	int linphone_friend_set_address(LinphoneFriend* fr, const LinphoneAddress* address)
	
	const LinphoneAddress* linphone_friend_get_address(const LinphoneFriend* lf)
	
	const char* linphone_friend_get_name(const LinphoneFriend* lf)
	
	bint linphone_friend_subscribes_enabled(const LinphoneFriend* lf)
	
	int linphone_friend_enable_subscribes(LinphoneFriend* fr, bint val)
	
	int linphone_friend_set_inc_subscribe_policy(LinphoneFriend* fr, LinphoneSubscribePolicy pol)
	
	LinphoneSubscribePolicy linphone_friend_get_inc_subscribe_policy(const LinphoneFriend* lf)
	
	void linphone_friend_edit(LinphoneFriend* fr)
	void linphone_friend_done(LinphoneFriend* fr)
	
	LinphoneOnlineStatus linphone_friend_get_status(const LinphoneFriend* lf)
	const LinphonePresenceModel* linphone_friend_get_presence_model(LinphoneFriend* lf)
	void linphone_friend_set_user_data(const LinphoneFriend* lf, void* data)
	void* linphone_friend_get_user_data(const LinphoneFriend* lf)
	BuddyInfo* linphone_friend_get_info(const LinphoneFriend* lf)
	void linphone_friend_set_ref_key(LinphoneFriend* lf, const char* key)
	const char* linphone_friend_get_ref_key(const LinphoneFriend* lf)
	bint linphone_friend_in_list(const LinphoneFriend* lf)
	
	const char* linphone_online_status_to_string(LinphoneOnlineStatus ss)
	
	LinphoneFriend* linphone_core_create_friend(cLinphoneCore* lc)
	LinphoneFriend* linphone_core_create_friend_with_address(cLinphoneCore* lc, const char* address)
	
	void linphone_core_set_presence_info(cLinphoneCore* lc, int minutes_away, const char* alternative_context, LinphoneOnlineStatus os)
	void linphone_core_set_presence_model(cLinphoneCore* lc, LinphonePresenceModel *presence)
	
	LinphoneOnlineStatus linphone_core_get_presence_info(const cLinphoneCore* lc)
	LinphonePresenceModel* linphone_core_get_presence_model(const cLinphoneCore* lc)
	
	void linphone_core_interpret_friend_uri(cLinphoneCore* lc, const char* uri, char** result)
	
	void linphone_core_add_friend(cLinphoneCore* lc, LinphoneFriend* fr)
	
	void linphone_core_remove_friend(cLinphoneCore* lc, LinphoneFriend* fr)
	
	void linphone_core_reject_subscriber(cLinphoneCore* lc, LinphoneFriend* fr)
	
	const MSList* linphone_core_get_friend_list(const cLinphoneCore* lc)
	
	void linphone_core_notify_all_friends(cLinphoneCore* lc, LinphoneOnlineStatus os)
	LinphoneFriend* linphone_core_get_friend_by_address(const cLinphoneCore* lc, const char* addr)
	LinphoneFriend* linphone_core_get_friend_by_ref_key(const cLinphoneCore* lc, const char* key)
	
	cLinphoneCore* linphone_friend_get_core(const LinphoneFriend* fr)
	
