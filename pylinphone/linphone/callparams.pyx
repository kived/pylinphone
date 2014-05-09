
from pylinphone.linphone.lib.core cimport _LinphoneCallParams, linphone_call_params_get_used_audio_codec, \
	linphone_call_params_get_used_video_codec, linphone_call_params_copy, linphone_call_params_enable_video, \
	linphone_call_params_video_enabled, linphone_call_params_get_media_encryption, \
	linphone_call_params_set_media_encryption, linphone_call_params_enable_early_media_sending, \
	linphone_call_params_early_media_sending_enabled, linphone_call_params_local_conference_mode, \
	linphone_call_params_set_audio_bandwidth_limit, linphone_call_params_destroy, \
	linphone_call_params_low_bandwidth_enabled, linphone_call_params_enable_low_bandwidth, \
	linphone_call_params_set_record_file, linphone_call_params_get_record_file, linphone_call_params_get_session_name, \
	linphone_call_params_set_session_name, linphone_call_params_add_custom_header, \
	linphone_call_params_get_custom_header, linphone_call_params_get_sent_video_size, \
	linphone_call_params_get_received_video_size, linphone_media_encryption_to_string, LinphoneMediaEncryption

from pylinphone.linphone.util cimport nstr, payload2dict, videosize2tuple

cdef class LinphoneCallParams(object):
	
	cdef LinphoneCallParams _setup(self, _LinphoneCallParams* params, bint _owned=False):
		if self._params != NULL:
			raise RuntimeError('call params already assigned to LinphoneCallParams instance')
		self._params = params
		self._owned = _owned
		return self
	
	def __dealloc__(self):
		if self._owned:
			linphone_call_params_destroy(self._params)
			self._params = NULL
	
	property audio_codec_details:
		def __get__(self):
			return payload2dict(linphone_call_params_get_used_audio_codec(self._params))
	
	property audio_codec:
		def __get__(self):
			return self.audio_codec_details.get('mime_type', None)
	
	property video_codec_details:
		def __get__(self):
			return payload2dict(linphone_call_params_get_used_video_codec(self._params))
	
	property video_codec:
		def __get__(self):
			return self.video_codec_details.get('mime_type', None)
	
	property video_enabled:
		def __get__(self):
			return <bint>linphone_call_params_video_enabled(self._params)
		def __set__(self, bint value):
			linphone_call_params_enable_video(self._params, value)
	
	property media_encryption:
		def __get__(self):
			return <int>linphone_call_params_get_media_encryption(self._params)
		def __set__(self, int value):
			linphone_call_params_set_media_encryption(self._params, <LinphoneMediaEncryption>value)
	
	property media_encryption_name:
		def __get__(self):
			return nstr(linphone_media_encryption_to_string(self.media_encryption))
	
	property early_media:
		def __get__(self):
			return <bint>linphone_call_params_early_media_sending_enabled(self._params)
		def __set__(self, bint value):
			linphone_call_params_enable_early_media_sending(self._params, value)
	
	property local_conference:
		def __get__(self):
			return <bint>linphone_call_params_local_conference_mode(self._params)
	
	property audio_bandwidth_limit:
		def __set__(self, int value):
			linphone_call_params_set_audio_bandwidth_limit(self._params, value)
	
	property low_bandwidth:
		def __get__(self):
			return <bint>linphone_call_params_low_bandwidth_enabled(self._params)
		def __set__(self, bint value):
			linphone_call_params_enable_low_bandwidth(self._params, value)
	
	property record_file:
		def __get__(self):
			return nstr(linphone_call_params_get_record_file(self._params))
		def __set__(self, str value):
			linphone_call_params_set_record_file(self._params, <char*>str)
	
	property session_name:
		def __get__(self):
			return nstr(linphone_call_params_get_session_name(self._params))
		def __set__(self, str value):
			linphone_call_params_set_session_name(self._params, value)
	
	property sent_video_size:
		def __get__(self):
			return videosize2tuple(linphone_call_params_get_sent_video_size(self._params))
	
	property received_video_size:
		def __get__(self):
			return videosize2tuple(linphone_call_params_get_received_video_size(self._params))
	
	def copy(self):
		cdef _LinphoneCallParams* params
		params = linphone_call_params_copy(self._params)
		return LinphoneCallParams_create(params, _owned=True)
	
	def get_custom_header(self, str header_name):
		return nstr(linphone_call_params_get_custom_header(self._params, header_name))
	
	def add_custom_header(self, str header_name, str header_value):
		linphone_call_params_add_custom_header(self._params, header_name, header_value)
	
	def to_dict(self):
		return {
			'audio_codec': self.audio_codec,
			'audio_codec_details': self.audio_codec_details,
		    'video_codec': self.video_codec,
		    'video_codec_details': self.video_codec_details,
		    'video_enabled': self.video_enabled,
		    'media_encryption': self.media_encryption,
		    'media_encryption_name': self.media_encryption_name,
		    'early_media': self.early_media,
		    'local_conference': self.local_conference,
		    'low_bandwidth': self.low_bandwidth,
		    'record_file': self.record_file,
		    'session_name': self.session_name,
		    'sent_video_size': self.sent_video_size,
		    'received_video_size': self.received_video_size
		}
	
	

cdef LinphoneCallParams LinphoneCallParams_create(_LinphoneCallParams* params, bint _owned=False):
	return LinphoneCallParams()._setup(params, _owned)
