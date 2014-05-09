'''
Created on Dec 2, 2013

@author: "Ryan Pessa <ryan@essential-elements.net>"
'''
from __future__ import absolute_import

from time import sleep
from cython.operator cimport dereference as deref

from pylinphone.linphone.lib.core cimport linphone_core_new, linphone_core_destroy, \
	linphone_core_set_sip_transports, linphone_core_iterate, linphone_core_get_default_proxy, \
	linphone_core_add_proxy_config, linphone_core_set_default_proxy, linphone_registration_state_to_string, \
	linphone_core_refresh_registers, linphone_call_state_to_string, linphone_global_state_to_string, \
	linphone_core_get_sound_devices, linphone_core_get_capture_device, linphone_core_set_capture_device, \
	linphone_core_remove_proxy_config, linphone_core_get_ringer_device, linphone_core_get_playback_device, \
	linphone_core_set_playback_device, linphone_core_set_ringer_device, linphone_core_get_video_devices, \
	linphone_core_get_video_device, linphone_core_set_video_device, linphone_core_echo_cancellation_enabled, \
	linphone_core_enable_echo_cancellation, linphone_core_echo_limiter_enabled, linphone_core_enable_echo_limiter, \
	linphone_core_audio_adaptive_jittcomp_enabled, linphone_core_enable_audio_adaptive_jittcomp, \
	linphone_core_video_adaptive_jittcomp_enabled, linphone_core_enable_video_adaptive_jittcomp, \
	linphone_core_get_audio_jittcomp, linphone_core_set_audio_jittcomp, linphone_core_get_video_jittcomp, \
	linphone_core_set_video_jittcomp, linphone_core_get_audio_codecs, linphone_core_get_video_codecs, \
	linphone_core_enable_video_capture, linphone_core_video_capture_enabled, linphone_core_enable_video_display, \
	linphone_core_video_display_enabled, linphone_call_get_user_pointer
from pylinphone.linphone.lib.core cimport cLinphoneCore, cLinphoneProxyConfig, LinphoneRegistrationState, \
	LinphoneFriend, LinphoneCallLog, LinphoneChatRoom, cLinphoneCall, LinphoneCallState, LinphoneGlobalState, \
	LinphoneAddress, LCSipTransports, LinphoneRegistrationCleared
from pylinphone.linphone.lib.core cimport LinphoneCoreGlobalStateChangedCb, \
	LinphoneCoreCallStateChangedCb, LinphoneCoreCallEncryptionChangedCb, LinphoneCoreRegistrationStateChangedCb, \
	LinphoneCoreNotifyPresenceReceivedCb, LinphoneCoreNewSubscriptionRequestedCb, LinphoneCoreAuthInfoRequestedCb, \
	LinphoneCoreCallLogUpdatedCb, LinphoneCoreDtmfReceivedCb, LinphoneCoreReferReceivedCb, \
	LinphoneCoreBuddyInfoUpdatedCb

from pylinphone.linphone.lib.mediastreamer2.mscommon cimport MSList
from pylinphone.linphone.lib.ortp.payloadtype cimport PayloadType

from pylinphone.linphone.exception import NoProxyCreatedError
from pylinphone.linphone.call cimport LinphoneCall, get_call_for_c_call

from pylinphone.linphone.proxyconfig cimport get_proxy_for_c_proxy, LinphoneProxyConfig
from pylinphone.linphone.util cimport payload2dict, nstr

cdef void c_auth_info_requested(cLinphoneCore* lc, const char* realm, const char* username):
	cdef object cb = _core.get_callback('auth_info_requested')
	if cb:
		cb(<bytes>realm, <bytes>username)

cdef void c_buddy_info_updated(cLinphoneCore* lc, LinphoneFriend* lf):
	cdef object cb = _core.get_callback('buddy_info_updated')
	if cb:
		print 'buddy_info_updated TODO: LinphoneFriend'
		cb()

cdef void c_call_encryption_changed(cLinphoneCore* lc, cLinphoneCall* call, LinphoneRegistrationState cstate,
                                    const char* message):
	cdef object cb = _core.get_callback('call_encryption_changed')
	cdef LinphoneCall c
	cdef char* state
	if cb:
		c = get_call_for_c_call(call)
		#c = <LinphoneCall>linphone_call_get_user_pointer(call) if call != NULL else None
		state = linphone_registration_state_to_string(cstate)
		cb(c, <bytes>state, <bytes>message)

cdef void c_call_log_updated(cLinphoneCore* lc, LinphoneCallLog* newcl):
	cdef object cb = _core.get_callback('call_log_updated')
	if cb:
		print 'call_log_updated TODO: LinphoneCallLog'
		cb()

cdef void c_call_state_changed(cLinphoneCore* lc, cLinphoneCall* call, LinphoneCallState cstate, const char* message):
	cdef object cb = _core.get_callback('call_state_changed')
	cdef LinphoneCall c
	cdef char* state
	if cb:
		c = get_call_for_c_call(call)
		#c = <LinphoneCall>linphone_call_get_user_pointer(call) if call != NULL else None
		state = linphone_call_state_to_string(cstate)
		cb(c, <bytes>state, <bytes>message)

cdef void c_display_message(cLinphoneCore* lc, const char* message):
	cdef object cb = _core.get_callback('display_message')
	if cb:
		cb(<bytes>message)

cdef void c_display_status(cLinphoneCore* lc, const char* message):
	cdef object cb = _core.get_callback('display_status')
	if cb:
		cb(<bytes>message)

cdef void c_display_url(cLinphoneCore* lc, const char* message, const char* url):
	cdef object cb = _core.get_callback('display_url')
	if cb:
		cb(<bytes>message, <bytes>url)

cdef void c_display_warning(cLinphoneCore* lc, const char* message):
	cdef object cb = _core.get_callback('display_warning')
	if cb:
		cb(<bytes>message)

cdef void c_dtmf_received(cLinphoneCore* lc, cLinphoneCall* call, int dtmf):
	cdef object cb = _core.get_callback('dtmf_received')
	cdef LinphoneCall c
	if cb:
		c = get_call_for_c_call(call)
		#c = <LinphoneCall>linphone_call_get_user_pointer(call) if call != NULL else None
		cb(c, dtmf)

cdef void c_global_state_changed(cLinphoneCore* lc, LinphoneGlobalState gstate, const char* message):
	cdef object cb = _core.get_callback('global_state_changed')
	cdef char* state
	if cb:
		state = linphone_global_state_to_string(gstate)
		cb(<bytes>state, <bytes>message)

cdef void c_new_subscription_request(cLinphoneCore* lc, LinphoneFriend* lf, const char* url):
	cdef object cb = _core.get_callback('new_subscription_request')
	if cb:
		print 'new_subscription_request TODO: LinphoneFriend'
		cb()

cdef void c_notify_presence_recv(cLinphoneCore* lc, LinphoneFriend* lf):
	cdef object cb = _core.get_callback('notify_presence_recv')
	if cb:
		print 'notify_presence_recv TODO: LinphoneFriend'
		cb()

cdef void c_notify_recv(cLinphoneCore* lc, cLinphoneCall* call, const char* from_, const char* event):
	cdef object cb = _core.get_callback('notify_recv')
	cdef LinphoneCall c
	if cb:
		c = get_call_for_c_call(call)
		#c = <LinphoneCall>linphone_call_get_user_pointer(call) if call != NULL else None
		cb(c, <bytes>from_, <bytes>event)

cdef void c_refer_received(cLinphoneCore* lc, const char* refer_to):
	cdef object cb = _core.get_callback('refer_received')
	if cb:
		cb(bytes(refer_to))

cdef void c_registration_state_changed(cLinphoneCore* lc, cLinphoneProxyConfig* cfg, LinphoneRegistrationState cstate,
                                       const char* message):
	cdef object cb = _core.get_callback('registration_state_changed')
	cdef LinphoneProxyConfig proxy
	cdef char* state
	if cb:
		proxy = get_proxy_for_c_proxy(cfg)
		state = linphone_registration_state_to_string(cstate)
		cb(proxy, <bytes>state, <bytes>message)

cdef void c_show(cLinphoneCore* lc):
	cdef object cb = _core.get_callback('show')
	if cb:
		cb()

cdef void c_text_received(cLinphoneCore* lc, LinphoneChatRoom* room, const LinphoneAddress* from_, const char* message):
	cdef object cb = _core.get_callback('text_received')
	if cb:
		print 'text_received TODO: LinphoneChatRoom, LinphoneAddress'
		cb()

cdef class LinphoneCore:
	def __init__(self, config_path=None, factory_config=None, userdata=None, use_twisted=True):
		global _core
		if _core:
			raise RuntimeError('cannot instantiate more than one LinphoneCore')
		_core = self
		cdef const char* cpath = NULL
		cdef const char* fconf = NULL
		cdef void* udata = NULL
		if config_path is not None:
			cpath = config_path
		if factory_config is not None:
			fconf = factory_config
		if userdata is not None:
			ubytes = bytes(userdata)
			udata = <void*> ubytes
		cdef cLinphoneCore* core

		self.callbacks = {}
		self.vtable.global_state_changed = <LinphoneCoreGlobalStateChangedCb> c_global_state_changed
		self.vtable.registration_state_changed = <LinphoneCoreRegistrationStateChangedCb> c_registration_state_changed
		self.vtable.call_state_changed = <LinphoneCoreCallStateChangedCb> c_call_state_changed
		self.vtable.notify_presence_received = <LinphoneCoreNotifyPresenceReceivedCb> c_notify_presence_recv
		self.vtable.new_subscription_requested = <LinphoneCoreNewSubscriptionRequestedCb> c_new_subscription_request
		self.vtable.auth_info_requested = <LinphoneCoreAuthInfoRequestedCb> c_auth_info_requested
		self.vtable.call_log_updated = <LinphoneCoreCallLogUpdatedCb> c_call_log_updated
		#self.vtable.message_received = <LinphoneCoreMessageReceivedCb> c_message_received
		#self.vtable.is_composing_received = <LinphoneCoreIsComposingReceivedCb> c_is_composing_received
		self.vtable.dtmf_received = <LinphoneCoreDtmfReceivedCb> c_dtmf_received
		self.vtable.refer_received = <LinphoneCoreReferReceivedCb> c_refer_received
		self.vtable.call_encryption_changed = <LinphoneCoreCallEncryptionChangedCb> c_call_encryption_changed
		#self.vtable.transfer_state_changed = <LinphoneCoreTransferStateChangedCb> c_transfer_state_changed
		self.vtable.buddy_info_updated = <LinphoneCoreBuddyInfoUpdatedCb> c_buddy_info_updated
		#self.vtable.call_stats_updated = <LinphoneCoreCallStatsUpdatedCb> c_call_stats_updated
		#self.vtable.info_received = <LinphoneCoreInfoReceivedCb> c_info_received
		#self.vtable.subscription_state_changed = <LinphoneCoreSubscriptionStateChangedCb> c_subscription_state_changed
		#self.vtable.notify_received = <LinphoneCoreNotifyReceivedCb> c_notify_received
		#self.vtable.publish_state_changed = <LinphoneCorePublishStateChangedCb> c_publish_state_changed
		#self.vtable.configuring_status = <LinphoneCoreConfiguringStatusCb> c_configuring_status
		
		core = self.core = linphone_core_new(&self.vtable, cpath, fconf, udata)
		self.proxy_cfg = None
		
		cdef LCSipTransports tr
		tr.udp_port = 5060
		tr.dtls_port = 0
		tr.tls_port = 0
		tr.tcp_port = 5060
		linphone_core_set_sip_transports(core, &tr)
		
		self.video_capture = True
		self.video_display = True
		
		self.global_callback = None
		
		self.running = False
		
		if use_twisted:
			from twisted.internet.task import LoopingCall
			self.iterate_lc = LoopingCall(self.iterate)
			self.status_lc = LoopingCall(self.status)
		else:
			self.iterate_lc = None
			self.status_lc = None
	
	cdef void add_proxy(self, cLinphoneProxyConfig* proxy_cfg):
		linphone_core_add_proxy_config(self.core, proxy_cfg)
	
	cdef void get_proxy(self, cLinphoneProxyConfig** proxy_cfg):
		linphone_core_get_default_proxy(self.core, proxy_cfg)
	
	cdef void set_default_proxy(self, cLinphoneProxyConfig* proxy_cfg):
		linphone_core_set_default_proxy(self.core, proxy_cfg)
	
	cdef void remove_proxy(self, cLinphoneProxyConfig* proxy_cfg):
		linphone_core_remove_proxy_config(self.core, proxy_cfg)
	
	def start(self):
		self.running = True
		
		if self.iterate_lc:
			self.iterate_lc.start(0.050, False)
		#if self.status_lc:
		#	self.status_lc.start(5, False)

	cpdef iterate(self, bint shutdown=False):
		if shutdown or self.running:
			linphone_core_iterate(self.core)
	
	cpdef status(self):
		if self.running:
			print 'capture:', self.video_capture, '  display:', self.video_display
	
	cpdef shutdown(self):
		if self.running:
			self.running = False
			
			self.unregister()
	
	cpdef unregister(self):
		if self.proxy_cfg:
			try:
				with self.proxy_cfg as cfg:
					cfg.register = False
		
				print 'waiting for registration cleared...'
				while self.proxy_cfg.c_state != LinphoneRegistrationCleared:
					self.iterate(shutdown=True)
					sleep(0.050)
			except NoProxyCreatedError:
				pass
	
	cdef public object get_callback(self, str event):
		if self.global_callback:
			return self.global_callback(event)
		return self.callbacks.get(event, None)
	
	cpdef connect(self, str event, object callback):
		self.callbacks[event] = callback
	
	cpdef connect_global(self, object callback):
		self.global_callback = callback
	
	cpdef disconnect(self, str event):
		if event in self.callbacks:
			del self.callbacks[event]
	
	cpdef disconnect_global(self):
		self.global_callback = None

	def __dealloc__(self):
		self.shutdown()
		linphone_core_destroy(self.core)
	
	cpdef refresh_registers(self):
		linphone_core_refresh_registers(self.core)
	
	property sound_devices:
		def __get__(self):
			cdef char** dev = linphone_core_get_sound_devices(self.core)
			cdef int s = sizeof(char*)
			cdef list devs = []
			cdef bytes dname
			while dev != NULL and deref(dev) != NULL:
				dname = <bytes>deref(dev)
				devs.append(dname)
				dev = <char**>(<int>dev + s)
			return devs
	
	property ringer_device:
		def __get__(self):
			cdef char* dev = linphone_core_get_ringer_device(self.core)
			return <bytes>dev
		def __set__(self, bytes dev):
			if dev not in self.sound_devices:
				raise ValueError('invalid sound device')
			linphone_core_set_ringer_device(self.core, <char*>dev)
	
	property playback_device:
		def __get__(self):
			cdef char* dev = linphone_core_get_playback_device(self.core)
			return <bytes>dev
		def __set__(self, bytes dev):
			if dev not in self.sound_devices:
				raise ValueError('invalid sound device')
			linphone_core_set_playback_device(self.core, <char*>dev)
	
	property capture_device:
		def __get__(self):
			cdef char* dev = linphone_core_get_capture_device(self.core)
			return <bytes>dev
		def __set__(self, bytes dev):
			if dev not in self.sound_devices:
				raise ValueError('invalid sound device')
			linphone_core_set_capture_device(self.core, <char*>dev)
	
	property video_devices:
		def __get__(self):
			cdef char** dev = linphone_core_get_video_devices(self.core)
			cdef int s = sizeof(char*)
			cdef list devs = []
			cdef bytes dname
			while dev != NULL and deref(dev) != NULL:
				dname = <bytes>deref(dev)
				devs.append(dname)
				dev = <char**>(<int>dev + s)
			return devs
	
	property video_device:
		def __get__(self):
			cdef char* dev = linphone_core_get_video_device(self.core)
			return <bytes>dev
		def __set__(self, bytes dev):
			if dev not in self.video_devices:
				raise ValueError('invalid video device')
			linphone_core_set_video_device(self.core, <char*>dev)
	
	property echo_cancellation:
		def __get__(self):
			return <bint>linphone_core_echo_cancellation_enabled(self.core)
		def __set__(self, bint val):
			linphone_core_enable_echo_cancellation(self.core, val)
	
	property echo_limiter:
		def __get__(self):
			return <bint>linphone_core_echo_limiter_enabled(self.core)
		def __set__(self, bint val):
			linphone_core_enable_echo_limiter(self.core, val)
	
	property audio_adaptive_jittcomp:
		def __get__(self):
			return <bint>linphone_core_audio_adaptive_jittcomp_enabled(self.core)
		def __set__(self, bint val):
			linphone_core_enable_audio_adaptive_jittcomp(self.core, val)
	
	property video_adaptive_jittcomp:
		def __get__(self):
			return <bint>linphone_core_video_adaptive_jittcomp_enabled(self.core)
		def __set__(self, bint val):
			linphone_core_enable_video_adaptive_jittcomp(self.core, val)
	
	property audio_jittcomp:
		def __get__(self):
			return linphone_core_get_audio_jittcomp(self.core)
		def __set__(self, int val):
			linphone_core_set_audio_jittcomp(self.core, val)
	
	property video_jittcomp:
		def __get__(self):
			return linphone_core_get_video_jittcomp(self.core)
		def __set__(self, int val):
			linphone_core_set_video_jittcomp(self.core, val)
	
	cdef _get_codecs(self, MSList* (*fn)(cLinphoneCore*)):
		cdef PayloadType* pt
		cdef MSList* cl = fn(self.core)
		codecs = {}
		while cl != NULL:
			if cl.data != NULL:
				pt = <PayloadType*>cl.data
				codecs[nstr(pt.mime_type)] = payload2dict(pt)
			cl = cl.next
		return codecs

	property audio_codecs:
		def __get__(self):
			return self._get_codecs(linphone_core_get_audio_codecs)
	
	property video_codecs:
		def __get__(self):
			return self._get_codecs(linphone_core_get_video_codecs)
	
	property video_capture:
		def __get__(self):
			return <bint>linphone_core_video_capture_enabled(self.core)
		def __set__(self, bint val):
			linphone_core_enable_video_capture(self.core, val)
	
	property video_display:
		def __get__(self):
			return <bint>linphone_core_video_display_enabled(self.core)
		def __set__(self, bint val):
			linphone_core_enable_video_display(self.core, val)
	
	# property video_display_filter:
	# 	def __get__(self):
	# 		cdef char* filt = linphone_core_get_video_display_filter(self.core)
	# 		return <bytes>filt
	# 	def __set__(self, bytes filt):
	# 		linphone_core_set_video_display_filter(self.core, filt)

cdef LinphoneCore _core = None
