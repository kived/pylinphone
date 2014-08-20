from pylinphone.linphone.lib.ortp.payloadtype cimport PayloadType
from pylinphone.linphone.lib.mediastreamer2.msvideo cimport MSVideoSize

cdef str nstr(const char* s):
	return <bytes>s if s != NULL else '(null)'

cdef dict payload2dict(PayloadType* pt):
	if pt == NULL:
		return {}
	return {
		'type': pt.type,
		'clock_rate': pt.clock_rate,
		'bits_per_sample': <int> pt.bits_per_sample,
		'zero_pattern': nstr(pt.zero_pattern),
		'pattern_length': pt.pattern_length,
		'normal_bitrate': pt.normal_bitrate,
		'mime_type': nstr(pt.mime_type),
		'channels': pt.channels,
		'recv_fmtp': nstr(pt.recv_fmtp),
		'send_fmtp': nstr(pt.send_fmtp),
		'flags': pt.flags,
		'user_data_present': False if pt.user_data == NULL else True
	}

cdef tuple videosize2tuple(MSVideoSize sz):
	return sz.width, sz.height

