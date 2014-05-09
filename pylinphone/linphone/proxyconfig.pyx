
from pylinphone.linphone.lib.core cimport linphone_proxy_config_new, linphone_core_add_proxy_config, linphone_core_get_default_proxy, \
	linphone_proxy_config_edit, linphone_proxy_config_done
from pylinphone.linphone.lib.core cimport linphone_proxy_config_set_server_addr, linphone_proxy_config_get_identity, \
	linphone_proxy_config_set_identity, linphone_proxy_config_get_route, linphone_proxy_config_set_route
from pylinphone.linphone.lib.core cimport linphone_proxy_config_get_addr, linphone_proxy_config_get_expires, linphone_proxy_config_set_expires, \
	linphone_proxy_config_enable_register, linphone_proxy_config_register_enabled, linphone_proxy_config_enable_publish, linphone_proxy_config_publish_enabled, linphone_proxy_config_get_state, linphone_registration_state_to_string
from pylinphone.linphone.lib.core cimport cLinphoneProxyConfig, LinphoneAddress
from pylinphone.linphone.core cimport LinphoneCore

from pylinphone.linphone.exception import NoProxyCreatedError
from pylinphone.linphone.lib.core cimport linphone_address_new, linphone_address_get_domain, linphone_address_destroy, linphone_proxy_config_get_dial_escape_plus, linphone_proxy_config_set_dial_escape_plus, linphone_proxy_config_is_registered, linphone_proxy_config_set_dial_prefix, linphone_proxy_config_get_dial_prefix, linphone_proxy_config_normalize_number, linphone_proxy_config_refresh_register, linphone_proxy_config_destroy

cdef class LinphoneProxyConfig(object):
	def __cinit__(self, LinphoneCore core, str identity, bint register=True):
		pass

	def __init__(self, LinphoneCore core, str identity, bint register=True):
		self.core = core
		cdef cLinphoneProxyConfig* proxy_cfg
		proxy_cfg = self.proxy_cfg = linphone_proxy_config_new()
		
		cdef LinphoneAddress* addr = linphone_address_new(identity)
		linphone_proxy_config_set_identity(proxy_cfg, identity)
		cdef const char* server_addr = linphone_address_get_domain(addr)
		linphone_proxy_config_set_server_addr(proxy_cfg, server_addr)
		linphone_proxy_config_enable_register(proxy_cfg, register)
		linphone_address_destroy(addr)
		
		core.add_proxy(proxy_cfg)
		core.set_default_proxy(proxy_cfg)
		self.proxy_cfg = NULL
		
		_proxy_configs.append(self)
	
	def destroy(self):
		_proxy_configs.remove(self)
	
	def __dealloc__(self):
		self.core.remove_proxy(self.proxy())
		# Apparently liblinphone already destroys the proxy config, possibly as a result of
		# calling remove_proxy. Maybe using reference counting? This results in a double-free crash.
		#linphone_proxy_config_destroy(self.proxy_cfg)
	
	cdef cLinphoneProxyConfig* proxy(self):
		self.core.get_proxy(&self.proxy_cfg)
		if self.proxy_cfg == NULL:
			raise NoProxyCreatedError('no proxy config created')
		return self.proxy_cfg
	
	def __enter__(self):
		self.proxy_cfg = NULL
		linphone_proxy_config_edit(self.proxy())
		self.entered = True
		return self

	def __exit__(self):
		linphone_proxy_config_done(self.proxy_cfg)
		self.proxy_cfg = NULL
		self.entered = False
	
	cdef cLinphoneProxyConfig* context(self):
		if not self.entered:
			raise RuntimeError('must enter proxy config before editing')
		return self.proxy()
	
	property c_state:
		def __get__(self):
			return linphone_proxy_config_get_state(self.proxy())
	
	property state:
		def __get__(self):
			return linphone_registration_state_to_string(self.c_state)
	
	property server_addr:
		def __get__(self):
			addr = linphone_proxy_config_get_addr(self.proxy())
			return bytes(addr) if addr else '<unknown>'
		def __set__(self, str value):
			linphone_proxy_config_set_server_addr(self.context(), value)
	
	property identity:
		def __get__(self):
			identity = linphone_proxy_config_get_identity(self.proxy())
			return bytes(identity) if identity else '<unknown>'
		def __set__(self, str value):
			linphone_proxy_config_set_identity(self.context(), value)
	
	property route:
		def __get__(self):
			route = linphone_proxy_config_get_route(self.proxy())
			return bytes(route) if route else '<unknown>'
		def __set__(self, str value):
			linphone_proxy_config_set_route(self.context(), value)
	
	property expires:
		def __get__(self):
			return linphone_proxy_config_get_expires(self.proxy())
		def __set__(self, int value):
			linphone_proxy_config_set_expires(self.context(), value)
	
	property register:
		def __get__(self):
			return linphone_proxy_config_register_enabled(self.proxy())
		def __set__(self, bint value):
			linphone_proxy_config_enable_register(self.context(), value)
	
	property publish:
		def __get__(self):
			return linphone_proxy_config_publish_enabled(self.proxy())
		def __set__(self, bint value):
			linphone_proxy_config_enable_publish(self.context(), value)
	
	property dial_escape_plus:
		def __get__(self):
			return linphone_proxy_config_get_dial_escape_plus(self.proxy())
		def __set__(self, bint value):
			linphone_proxy_config_set_dial_escape_plus(self.context(), value)
	
	property dial_prefix:
		def __get__(self):
			prefix = linphone_proxy_config_get_dial_prefix(self.proxy())
			return bytes(prefix) if prefix else '<unknown>'
		def __set__(self, str value):
			linphone_proxy_config_set_dial_prefix(self.context(), value)
	
	property registered:
		def __get__(self):
			return linphone_proxy_config_is_registered(self.proxy())
	
	cdef int c_normalize_number(self, const char* username, char* result, size_t result_len):
		return linphone_proxy_config_normalize_number(self.proxy(), username, result, result_len)
	
	cpdef normalize_number(self, str username):
		cdef char[64] result
		cdef size_t result_len = 64
		if self.c_normalize_number(username, result, result_len):
			return <bytes>result[:result_len]
		return None
	
	cpdef refresh_register(self):
		linphone_proxy_config_refresh_register(self.proxy())
	
	def getStateToCopy(self):
		return {
			'state': self.state,
		    'server_addr': self.server_addr,
		    'identity': self.identity,
		    'route': self.route,
		    'expires': self.expires,
		    'register': self.register,
		    'publish': self.publish,
		    'dial_escape_plus': self.dial_escape_plus,
		    'dial_prefix': self.dial_prefix,
		    'registered': self.registered
		}
	

cdef list _proxy_configs = []

cdef LinphoneProxyConfig get_proxy_for_c_proxy(cLinphoneProxyConfig* proxy_cfg):
	cdef LinphoneProxyConfig proxy
	for proxy in _proxy_configs:
		if proxy.proxy() == proxy_cfg:
			return proxy
	return None
