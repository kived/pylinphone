from pylinphone.engine cimport SIPEngine
from pylinphone.linphone.lib.core cimport cLinphoneCall
from pylinphone.linphone.lib.core cimport LinphoneAddress, _LinphoneCallParams, LinphoneCallLog

cdef class LinphoneCall:
	cdef SIPEngine engine
	cdef str uri
	cdef LinphoneAddress* addr
	cdef cLinphoneCall* _call
	cdef object _lc
	cdef bint active
	
	cdef object __weakref__
	
	cdef _setup(self, str uri=?, const _LinphoneCallParams* params=*, const LinphoneAddress* addr=*, cLinphoneCall* call=*)
	
	cdef cLinphoneCall* call(self)
	cpdef end(self)
	
	cdef _LinphoneCallParams* c_params(self)
	
	cdef const LinphoneAddress* get_remote_address(self)
	cdef void* get_user_pointer(self)
	cdef void set_user_pointer(self, void* ptr)
	cdef LinphoneCallLog* get_call_log(self)
	cdef cLinphoneCall* get_replaced_call(self)
	
	cpdef take_video_snapshot(self, str filename)

cdef LinphoneCall LinphoneCall_create(SIPEngine engine, str uri=*, const _LinphoneCallParams* params=*,
                                      const LinphoneAddress* addr=*, cLinphoneCall* call=*)

cdef list _calls
cdef LinphoneCall get_call_for_c_call(cLinphoneCall* call)
