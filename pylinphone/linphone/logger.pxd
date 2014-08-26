cdef extern from "stdarg.h":
	ctypedef struct va_list:
		pass

cdef extern from "stdio.h":
	int vsnprintf(char*s, size_t n, const char*format, va_list arg)

from pylinphone.linphone.lib.ortp.ortp cimport OrtpLogLevel, ORTP_DEBUG, ORTP_MESSAGE, \
	ORTP_WARNING, ORTP_ERROR, ORTP_FATAL

cdef void linphone_logger(OrtpLogLevel lev, const char* fmt, va_list args)
