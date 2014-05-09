
from pylinphone.linphone.lib.core cimport cLinphoneCore, cLinphoneCoreVTable, cLinphoneProxyConfig
from pylinphone.linphone.proxyconfig cimport LinphoneProxyConfig
from pylinphone.linphone.lib.mediastreamer2.mscommon cimport MSList

cdef class LinphoneCore:
	cdef cLinphoneCore* core
	cdef cLinphoneCoreVTable vtable
	cdef dict callbacks
	cdef LinphoneProxyConfig proxy_cfg
	cdef bint running
	cdef object iterate_lc
	cdef object status_lc
	cdef object global_callback
	
	cdef void add_proxy(self, cLinphoneProxyConfig* proxy_cfg)
	cdef void get_proxy(self, cLinphoneProxyConfig** proxy_cfg)
	cdef void set_default_proxy(self, cLinphoneProxyConfig* proxy_cfg)
	cdef void remove_proxy(self, cLinphoneProxyConfig* proxy_cfg)
	
	cdef public object get_callback(self, str event)
	cpdef connect(self, str event, object callback)
	cpdef connect_global(self, object callback)
	cpdef disconnect(self, str event)
	cpdef disconnect_global(self)
	
	cpdef unregister(self)
	cpdef shutdown(self)
	cpdef iterate(self, bint shutdown=?)
	cpdef status(self)

	cpdef refresh_registers(self)
	
	cdef _get_codecs(self, MSList* (*fn)(cLinphoneCore*))

cdef LinphoneCore _core
