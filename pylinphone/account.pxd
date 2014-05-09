
from pylinphone.linphone.lib.core cimport LinphoneAuthInfo, LinphoneAddress, _LinphoneCallParams
from pylinphone.linphone.call cimport LinphoneCall
from pylinphone.engine cimport SIPEngine

cdef class Account:
	cdef SIPEngine engine
	cdef LinphoneAuthInfo* auth
	cdef str uri
	cdef str password
	cdef list proxy_container
	
	cdef LinphoneCall _current_call
	
	cdef LinphoneCall callex(self, str dest_uri=?, const LinphoneAddress* addr=?, const _LinphoneCallParams* params=?)
	cpdef call(self, str dest_uri)
