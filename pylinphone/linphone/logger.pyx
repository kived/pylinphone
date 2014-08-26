import logging

_LOG_TAG = 'Linphone'

cpdef linphone_logget_set_tag(str tag):
	global _LOG_TAG
	_LOG_TAG = tag

cdef void linphone_logger_fn(OrtpLogLevel lev, const char* fmt, va_list args):
	cdef char[4096] msg
	cdef str level = 'critical'
	vsnprintf(msg, sizeof(msg) - 1, fmt, args)
	msg[sizeof(msg) - 1] = '\0'
	
	if lev == ORTP_DEBUG:
		level = 'debug'
	elif lev == ORTP_MESSAGE:
		level = 'info'
	elif lev == ORTP_WARNING:
		level = 'warning'
	elif lev == ORTP_ERROR:
		level = 'error'
	elif lev == ORTP_FATAL:
		level = 'critical'
	
	logger = logging.getLogger(_LOG_TAG)
	logger.critical('log output')
	getattr(logger, level)(str(msg))
	logger.critical('log finished')
	
	
cdef OrtpLogFunc linphone_logger = <OrtpLogFunc>linphone_logger_fn
