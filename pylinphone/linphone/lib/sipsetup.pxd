'''
Created on Dec 2, 2013

@author: "Ryan Pessa <ryan@essential-elements.net>"
'''

from libc.stdint cimport uint8_t
from pylinphone.linphone.lib.mediastreamer2.mscommon cimport MSList

cdef extern from "linphone/sipsetup.h" nogil:
	ctypedef struct SipSetup:
		pass
	ctypedef struct LinphoneProxyConfig:
		pass
	
	ctypedef struct SipSetupContext:
		SipSetup* funcs
		LinphoneProxyConfig* cfg
		char[128] domain
		char[128] username
		void* data
	
	cdef int SIP_SETUP_CAP_PROXY_PROVIDER
	cdef int SIP_SETUP_CAP_STUN_PROVIDER
	cdef int SIP_SETUP_CAP_RELAY_PROVIDER
	cdef int SIP_SETUP_CAP_BUDDY_LOOKUP
	cdef int SIP_SETUP_CAP_ACCOUNT_MANAGER
	cdef int SIP_SETUP_CAP_LOGIN
	
	ctypedef enum BuddyLookupStatus:
		BuddyLookupNone
		BuddyLookupConnecting
		BuddyLookupConnected
		BuddyLookupRecevingResponse
		BuddyLookupDone
		BuddyLookupFailure
	
	ctypedef struct BuddyAddress:
		char[64] street
		char[64] zip
		char[64] town
		char[64] country
	
	ctypedef struct BuddyInfo:
		char[64] firstname
		char[64] lastname
		char[64] displayname
		char[128] sip_uri
		char[128] email
		BuddyAddress address
		char[32] image_type
		uint8_t* image_data
		int image_length
	
	ctypedef struct BuddyLookupRequest:
		char* key
		int max_results
		BuddyLookupStatus status
		MSList* results
	
	ctypedef struct BuddyLookupFuncs:
		BuddyLookupRequest* (*request_create)(SipSetupContext *ctx)
		int (*request_submit)(SipSetupContext *ctx, BuddyLookupRequest* req)
		int (*request_free)(SipSetupContext *ctx, BuddyLookupRequest* req)
	
	ctypedef struct SipSetup:
		char* name
		unsigned int capabilities
		int initialized
		bint (*init)()
		void (*exit)()
		void (*init_instance)(SipSetupContext* ctx)
		void (*uninit_instance)(SipSetupContext* ctx)
		int (*account_exists)(SipSetupContext* ctx, const char* uri)
		int (*create_account)(SipSetupContext* ctx, const char* uri, const char* passwd, const char* email, int suscribe)
		int (*login_account)(SipSetupContext* ctx, const char* uri, const char* passwd, const char* userid)
		int (*get_proxy)(SipSetupContext* ctx, const char* domain, char* proxy, size_t sz)
		int (*get_stun_servers)(SipSetupContext* ctx, char* stun1, char* stun2, size_t size)
		int (*get_relay)(SipSetupContext* ctx, char* relay, size_t size)
		const char* (*get_notice)(SipSetupContext* ctx)
		const char** (*get_domains)(SipSetupContext* ctx)
		int (*logout_account)(SipSetupContext* ctx)
		BuddyLookupFuncs *buddy_lookup_funcs
		int (*account_validated)(SipSetupContext* ctx, const char* uri)
	
	BuddyInfo* buddy_info_new()
	void buddy_info_free(BuddyInfo *info)
	
	void buddy_lookup_request_set_key(BuddyLookupRequest* req, const char* key)
	void buddy_lookup_request_set_max_results(BuddyLookupRequest* req, int ncount)
	
	void sip_setup_register(SipSetup* ss)
	void sip_setup_register_all()
	SipSetup* sip_setup_lookup(const char* type_name)
	void sip_setup_unregister_all()
	unsigned int sip_setup_get_capabilities(SipSetup* s)
	
	SipSetupContext* sip_setup_context_new(SipSetup* s, LinphoneProxyConfig* cfg)
	int sip_setup_context_account_exists(SipSetupContext* ctx, const char* uri)
	int sip_setup_context_account_validated(SipSetupContext* ctx, const char* uri)
	int sip_setup_context_create_account(SipSetupContext* ctx, const char* uri, const char* passwd, const char* email, int suscribe)
	int sip_setup_context_get_capabilities(SipSetupContext* ctx)
	int sip_setup_context_login_account(SipSetupContext* ctx, const char* uri, const char* passwd, const char* userid)
	int sip_setup_context_get_proxy(SipSetupContext* ctx, const char* domain, char* proxy, size_t sz)
	int sip_setup_context_get_stun_servers(SipSetupContext* ctx, char* stun1, char* stun2, size_t size)
	int sip_setup_context_get_relay(SipSetupContext* ctx, char* relay, size_t size)
	
	BuddyLookupRequest* sip_setup_context_create_buddy_lookup_request(SipSetupContext* ctx)
	int sip_setup_context_buddy_lookup_submit(SipSetupContext* ctx, BuddyLookupRequest* req)
	int sip_setup_context_buddy_lookup_free(SipSetupContext* ctx, BuddyLookupRequest* req)
	
	const char* sip_setup_context_get_notice(SipSetupContext* ctx)
	const char** sip_setup_context_get_domains(SipSetupContext* ctx)
	
	void sip_setup_context_free(SipSetupContext* ctx)
	
	int sip_setup_context_logout(SipSetupContext* ctx)
	
	LinphoneProxyConfig* sip_setup_context_get_proxy_config(const SipSetupContext* ctx)
	void buddy_lookup_request_free(BuddyLookupRequest* req)
	


