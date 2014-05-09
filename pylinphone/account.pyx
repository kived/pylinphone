'''
.. module: pylinphone.account
	:synopsis: Account class
.. moduleauthor:: "Ryan Pessa <ryan@essential-elements.net>"
'''
import logging
logger = logging.getLogger('Account')

from pylinphone.linphone.lib.core cimport linphone_core_add_auth_info, linphone_address_get_username
from pylinphone.linphone.lib.core cimport linphone_address_new, linphone_auth_info_new, linphone_address_destroy, linphone_auth_info_destroy, linphone_core_remove_auth_info
from pylinphone.linphone.lib.core cimport linphone_core_invite, linphone_call_ref, linphone_call_get_state, linphone_core_terminate_call, linphone_call_unref
from pylinphone.linphone.lib.core cimport LinphoneCallEnd, LinphoneAddress, _LinphoneCallParams

from pylinphone.linphone.proxyconfig cimport LinphoneProxyConfig
from pylinphone.linphone.call cimport LinphoneCall, LinphoneCall_create

cdef class Account(object):
	'''Account class'''
	
	def __init__(self, SIPEngine engine, str uri, str password, bint register=True):
		self.engine = engine
		self.uri = uri
		self.password = password
		self._current_call = None
		self.proxy_container = [None]
		
		addr = linphone_address_new(uri)
		if addr == NULL:
			raise ValueError('%s not a valid SIP uri' % (uri,))
		
		if self.password:
			logger.info('create auth info for %s', uri)
			self.auth = linphone_auth_info_new(linphone_address_get_username(addr), NULL, self.password, NULL, NULL, NULL)
			linphone_core_add_auth_info(self.engine.core.core, self.auth)
		
		linphone_address_destroy(addr)
		
		logger.info('create proxy for %s', uri)
		self.proxy = LinphoneProxyConfig(engine.core, uri, register)
	
	property proxy:
		def __get__(self):
			return self.proxy_container[0]
		def __set__(self, value):
			self.proxy_container[0] = value
	
	cdef LinphoneCall callex(self, str dest_uri=None, const LinphoneAddress* addr=NULL, const _LinphoneCallParams* params=NULL):
		cdef LinphoneCall call = LinphoneCall_create(self.engine, uri=dest_uri, addr=addr, params=params)
		self._current_call = call
		return call
	
	property current_call:
		def __get__(self):
			return self._current_call
		def __set__(self, value):
			self._current_call = value
	
	cpdef call(self, str dest_uri):
		return self.callex(dest_uri=dest_uri)
	
	def __dealloc__(self):
		if self.auth is not NULL:
			logger.info('destroy auth info for %s', self.uri)
			linphone_core_remove_auth_info(self.engine.core.core, self.auth)
			linphone_auth_info_destroy(self.auth)
			self.auth = NULL
		
		if self.proxy:
			logger.info('destroy proxy for %s', self.uri)
			self.proxy.destroy()
			del self.proxy_container[0]
			self.proxy_container = [None]
	

