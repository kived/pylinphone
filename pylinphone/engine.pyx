'''
.. module: pyphone.engine
	:synopsis: SIP Engine
.. moduleauthor:: "Ryan Pessa <ryan@essential-elements.net>"
'''

import logging
logger = logging.getLogger('SIPEngine')

from cython.operator cimport dereference as deref

from pylinphone.linphone.core cimport LinphoneCore

running_engine = None

cdef class SIPEngine(object):
	'''SIPEngine class'''
	
	def __cinit__(self, ringer=None, playback=None, capture=None, video=None):
		self.core = LinphoneCore()
		self.core.connect('registration_state_changed', self.registration_state_changed)
		self.core.connect('call_state_changed', self.call_state_changed)
	
	def __init__(self, ringer=None, playback=None, capture=None, video=None,
	             echo_cancellation=False, echo_limiter=False, adaptive_jittcomp=False):
		if ringer:
			self.ringer_device = ringer
		if playback:
			self.playback_device = playback
		if capture:
			self.capture_device = capture
		if video:
			self.video_device = video
		
		global running_engine
		running_engine = self
		
		# self.echo_cancellation = echo_cancellation
		# self.echo_limiter = echo_limiter
		# self.audio_adaptive_jittcomp = adaptive_jittcomp
		# self.video_adaptive_jittcomp = adaptive_jittcomp
	
	def connect_event(self, event, callback):
		self.core.connect(event, callback)
	
	def connect_global(self, callback):
		self.core.connect_global(callback)
	
	def disconnect_event(self, event):
		self.core.disconnect(event)
	
	def disconnect_global(self):
		self.core.disconnect_global()
	
	def registration_state_changed(self, proxy, state, message):
		logger.info('new registration state %s for user [%s] at proxy [%s]', 
		            state, 
		            proxy.identity if proxy else 'unknown', 
		            proxy.server_addr if proxy else 'unknown')
	
	def call_state_changed(self, call, state, message):
		logger.info('call [%s] changed state to %s (%s)', str(call), state, message)
	
	def start(self):
		logger.info('start engine')
		self.core.start()
		self.iterate()
	
	def iterate(self):
		self.core.iterate()
	
	cpdef shutdown(self):
		if self.core:
			self.core.shutdown()
	
	def __dealloc__(self):
		self.shutdown()
	
	property sound_devices:
		def __get__(self):
			return self.core.sound_devices
	
	property ringer_device:
		def __get__(self):
			return self.core.ringer_device
		def __set__(self, dev):
			self.core.ringer_device = dev
	
	property playback_device:
		def __get__(self):
			return self.core.playback_device
		def __set__(self, dev):
			self.core.playback_device = dev
	
	property capture_device:
		def __get__(self):
			return self.core.capture_device
		def __set__(self, dev):
			self.core.capture_device = dev
	
	property video_devices:
		def __get__(self):
			return self.core.video_devices
	
	property video_device:
		def __get__(self):
			return self.core.video_device
		def __set__(self, dev):
			self.core.video_device = dev
	
	property echo_cancellation:
		def __get__(self):
			return self.core.echo_cancellation
		def __set__(self, val):
			self.core.echo_cancellation = val
	
	property echo_limiter:
		def __get__(self):
			return self.core.echo_limiter
		def __set__(self, val):
			self.core.echo_limiter = val
	
	property audio_adaptive_jittcomp:
		def __get__(self):
			return self.core.audio_adaptive_jittcomp
		def __set__(self, val):
			self.core.audio_adaptive_jittcomp = val
	
	property video_adaptive_jittcomp:
		def __get__(self):
			return self.core.video_adaptive_jittcomp
		def __set__(self, val):
			self.core.video_adaptive_jittcomp = val
	
	property audio_jittcomp:
		def __get__(self):
			return self.core.audio_jittcomp
		def __set__(self, val):
			self.core.audio_jittcomp = val
	
	property video_jittcomp:
		def __get__(self):
			return self.core.video_jittcomp
		def __set__(self, val):
			self.core.video_jittcomp = val
	
	property audio_codecs:
		def __get__(self):
			return self.core.audio_codecs
	
	property video_codecs:
		def __get__(self):
			return self.core.video_codecs
	
	
