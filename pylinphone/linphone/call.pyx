from weakref import ref

from pylinphone.engine cimport SIPEngine
from pylinphone.linphone.exception import InvalidCallError
from pylinphone.linphone.lib.core cimport LinphoneCallEnd, LinphoneCallStreamsRunning, LinphoneCallPaused, \
	_LinphoneCallParams, LinphoneAddress, LinphoneCallLog, LinphoneCallReleased
from pylinphone.linphone.lib.core cimport linphone_core_invite, linphone_call_ref, linphone_call_unref, \
	linphone_call_get_state, linphone_core_terminate_call, linphone_call_get_current_params, \
	linphone_call_state_to_string, linphone_call_get_reason, linphone_reason_to_string, linphone_call_get_user_pointer, \
	linphone_call_set_user_pointer, linphone_call_get_call_log, linphone_call_get_refer_to, linphone_call_get_dir, \
	linphone_call_get_remote_user_agent, linphone_call_has_transfer_pending, linphone_call_get_duration, \
	linphone_call_get_replaced_call, linphone_call_camera_enabled, linphone_call_enable_camera, \
	linphone_call_params_video_enabled, linphone_call_params_enable_video, \
	linphone_call_params_early_media_sending_enabled, linphone_call_params_enable_early_media_sending, \
	linphone_call_params_local_conference_mode, linphone_call_params_set_audio_bandwidth_limit, \
	linphone_call_get_remote_address, linphone_call_get_remote_address_as_string, linphone_call_take_video_snapshot, \
	linphone_core_invite_with_params, linphone_core_invite_address, linphone_core_invite_address_with_params, \
	linphone_core_pause_call, linphone_core_resume_call, linphone_core_accept_call
from pylinphone.linphone.callparams cimport LinphoneCallParams_create

from twisted.internet.task import LoopingCall

cdef extern from "Python.h":
	cdef struct PyObject

cdef class LinphoneCall:
	
	def __init__(self, SIPEngine engine, str uri=None):
		self.engine = engine
		self.uri = None
		self.addr = NULL
		self._call = NULL
		self._lc = None

		_calls.append(ref(self))
		
		if uri:
			self._setup(uri=uri)
	
	cdef _setup(self, str uri=None, const _LinphoneCallParams* params=NULL, const LinphoneAddress* addr=NULL, cLinphoneCall* call=NULL):
		if uri:
			self.uri = uri
			self._call = linphone_core_invite(self.engine.core.core, uri) if params == NULL \
				else linphone_core_invite_with_params(self.engine.core.core, uri, params)
		elif addr != NULL:
			self.addr = addr
			self._call = linphone_core_invite_address(self.engine.core.core, addr) if params == NULL \
				else linphone_core_invite_address_with_params(self.engine.core.core, addr, params)
		elif call != NULL:
			self._call = call
		else:
			raise ValueError('must provide uri, addr, or call')
		
		if self._call == NULL:
			raise ValueError('invalid sip uri')
		
		linphone_call_set_user_pointer(self._call, <void*>self)
		linphone_call_ref(self._call)
		
		self._lc = LoopingCall(self.reset_streams)
		self._lc.start(40, False)
		
		return self
	
	property active:
		def __get__(self):
			return self._call != NULL
	
	def __dealloc__(self):
		if self.active:
			self.end()
		if self._call != NULL:
			linphone_call_unref(self._call)
			self._call = NULL
		
		try:
			_calls.remove(ref(self))
		except ValueError:
			pass

	cpdef end(self):
		if self._call and linphone_call_get_state(self._call) != LinphoneCallEnd:
			linphone_core_terminate_call(self.engine.core.core, self._call)
		
		if self._call != NULL:
			linphone_call_unref(self._call)
			self._call = NULL
		
		if self._lc and self._lc.running:
			self._lc.stop()
		
		try:
			_calls.remove(ref(self))
		except ValueError:
			pass
	
	cdef cLinphoneCall* call(self):
		if not self._call:
			raise InvalidCallError()
		return self._call
	
	cdef _LinphoneCallParams* c_params(self):
		if self._call == NULL:
			return NULL
		return linphone_call_get_current_params(self.call())
	
	property params:
		def __get__(self):
			if self._call == NULL:
				return None
			return LinphoneCallParams_create(self.c_params())
	
	cdef const LinphoneAddress* get_remote_address(self):
		if self._call == NULL:
			return NULL
		return linphone_call_get_remote_address(self.call())
	
	property remote_address:
		def __get__(self):
			if self._call == NULL:
				return None
			return linphone_call_get_remote_address_as_string(self.call())
	
	property c_state:
		def __get__(self):
			if self._call == NULL:
				return None
			return linphone_call_get_state(self.call())
	
	property state:
		def __get__(self):
			if self._call == NULL:
				return None
			return <bytes>linphone_call_state_to_string(self.c_state)
	
	property c_reason:
		def __get__(self):
			if self._call == NULL:
				return None
			return linphone_call_get_reason(self.call())
	
	property reason:
		def __get__(self):
			if self._call == NULL:
				return None
			return <bytes>linphone_reason_to_string(self.c_reason)
	
	cdef void* get_user_pointer(self):
		if self._call == NULL:
			return NULL
		return linphone_call_get_user_pointer(self.call())
	
	cdef void set_user_pointer(self, void* ptr):
		if self._call == NULL:
			return
		linphone_call_set_user_pointer(self.call(), ptr)
	
	cdef LinphoneCallLog* get_call_log(self):
		if self._call == NULL:
			return NULL
		return linphone_call_get_call_log(self.call())
	
	# property refer_to:
	# 	def __get__(self):
	# 		return <bytes>linphone_call_get_refer_to(self.call())
	
	property c_dir:
		def __get__(self):
			if self._call == NULL:
				return None
			return linphone_call_get_dir(self.call())
	
	# property remote_user_agent:
	# 	def __get__(self):
	# 		return <bytes>linphone_call_get_remote_user_agent(self.call())
	 
	property transfer_pending:
		def __get__(self):
			if self._call == NULL:
				return None
			return <bint>linphone_call_has_transfer_pending(self.call())
	
	property duration:
		def __get__(self):
			if self._call == NULL:
				return None
			return linphone_call_get_duration(self.call())
	
	cdef cLinphoneCall* get_replaced_call(self):
		if self._call == NULL:
			return NULL
		return linphone_call_get_replaced_call(self.call())
	
	property camera_enabled:
		def __get__(self):
			if self._call == NULL:
				return None
			return <bint>linphone_call_camera_enabled(self.call())
		def __set__(self, bint value):
			if self._call == NULL:
				return
			linphone_call_enable_camera(self.call(), value)
	
	property video_enabled:
		def __get__(self):
			if self._call == NULL:
				return None
			return <bint>linphone_call_params_video_enabled(self.c_params())
		def __set__(self, bint value):
			if self._call == NULL:
				return
			linphone_call_params_enable_video(self.c_params(), value)
	
	property early_media:
		def __get__(self):
			if self._call == NULL:
				return None
			return <bint>linphone_call_params_early_media_sending_enabled(self.c_params())
		def __set__(self, bint value):
			if self._call == NULL:
				return
			linphone_call_params_enable_early_media_sending(self.c_params(), value)
	
	property conference_mode:
		def __get__(self):
			if self._call == NULL:
				return None
			return <bint>linphone_call_params_local_conference_mode(self.c_params())
	
	property audio_bandwidth_limit:
		def __set__(self, int value):
			if self._call == NULL:
				return
			linphone_call_params_set_audio_bandwidth_limit(self.c_params(), value)
	
	cpdef take_video_snapshot(self, str filename):
		if self._call == NULL:
			return
		linphone_call_take_video_snapshot(self.call(), filename)
	
	def getStateToCopy(self):
		return {
			'uri': self.uri,
		    'active': self.active,
		    'remote_address': self.remote_address,
		    'state': self.state,
		    'reason': self.reason,
		    'transfer_pending': self.transfer_pending,
		    'duration': self.duration,
		    'camera_enabled': self.camera_enabled,
		    'video_enabled': self.video_enabled,
		    'early_media': self.early_media,
		    'conference_mode': self.conference_mode,
		}
	
	def pause(self):
		print 'pausing call'
		linphone_core_pause_call(self.engine.core.core, self.call())
	
	def resume(self):
		print 'resuming call'
		linphone_core_resume_call(self.engine.core.core, self.call())
	
	def answer(self):
		print 'answering call'
		linphone_core_accept_call(self.engine.core.core, self.call())
	
	def reset_streams(self):
		if self._call != NULL:
			if self.c_state == LinphoneCallStreamsRunning:
				self.pause()
				while self.c_state != LinphoneCallPaused:
					# TODO: break loop on timeout
					self.engine.iterate()
				self.resume()
			elif self.c_state == LinphoneCallReleased:
				self.end()

cdef LinphoneCall LinphoneCall_create(SIPEngine engine, str uri=None, const _LinphoneCallParams* params=NULL,
                                      const LinphoneAddress* addr=NULL, cLinphoneCall* call=NULL):
	return LinphoneCall(engine)._setup(uri=uri, params=params, addr=addr, call=call)

cdef list _calls = []

cdef LinphoneCall get_call_for_c_call(cLinphoneCall* call):
	# cdef LinphoneCall pycall
	# if call == NULL:
	# 	return None
	# 
	# for c in _calls:
	# 	pycall = c()
	# 	if pycall._call == call:
	# 		return pycall
	# return None
	
	cdef LinphoneCall pycall = None
	cdef PyObject* callptr
	cdef void* voidptr
	
	if call != NULL:
		voidptr = linphone_call_get_user_pointer(call)
		
		if voidptr != NULL:
			callptr = <PyObject*>voidptr
			pycall = <LinphoneCall>callptr
		else:
			from pylinphone.engine import running_engine
			pycall = LinphoneCall_create(running_engine, None, NULL, NULL, call)
	else:
		print 'call == NULL'
	
	return pycall
