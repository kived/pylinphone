
from pylinphone.linphone.core cimport LinphoneCore
from pylinphone.linphone.lib.core cimport cLinphoneProxyConfig

cdef class LinphoneProxyConfig:
	cdef LinphoneCore core
	cdef cLinphoneProxyConfig* proxy_cfg
	
	cdef cLinphoneProxyConfig* proxy(self)
	cdef cLinphoneProxyConfig* context(self)

	cdef int c_normalize_number(self, const char*username, char*result, size_t result_len)
	cpdef normalize_number(self, str username)
	cpdef refresh_register(self)

cdef list _proxy_configs
cdef LinphoneProxyConfig get_proxy_for_c_proxy(cLinphoneProxyConfig* proxy_cfg)
