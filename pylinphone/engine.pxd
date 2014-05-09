
from pylinphone.linphone.core cimport LinphoneCore #, LinphoneProxyConfig, LinphoneCoreVTable

cdef class SIPEngine:
	#cdef LinphoneCoreVTable vtable
	#cdef LinphoneCore* core
	#cdef LinphoneProxyConfig* proxy_cfg
	cdef public LinphoneCore core
	
	cpdef shutdown(self)
	
