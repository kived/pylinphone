
from libc.stdio cimport FILE
from pylinphone.linphone.lib.ortp.rtp cimport rtp_stats_t

cdef extern from "stdarg.h":
	ctypedef struct va_list:
		pass

cdef extern from "ortp/ortp.h" nogil:
	bint ortp_min_version_required(int major, int minor, int micro)
	void ortp_init()
	void ortp_scheduler_init()
	void ortp_exit()
	
	ctypedef enum OrtpLogLevel:
		ORTP_DEBUG
		ORTP_MESSAGE
		ORTP_WARNING
		ORTP_ERROR
		ORTP_FATAL
		ORTP_LOGLEV_END
	
	ctypedef void (*OrtpLogFunc)(OrtpLogLevel lev, const char* fmt, va_list args)
	
	void ortp_set_log_file(FILE *file)
	void ortp_set_log_handler(OrtpLogFunc func)
	
	cdef OrtpLogFunc ortp_logv_out
	
	void ortp_set_log_level_mask(int levelmask)
	
	void ortp_log(OrtpLogLevel lev, const char* fmt, ...)
	void ortp_message(const char* fmt, ...)
	void ortp_warning(const char* fmt, ...)
	void ortp_error(const char* fmt, ...)
	void ortp_fatal(const char* fmt, ...)
	
	void ortp_global_stats_reset()
	rtp_stats_t* ortp_get_global_stats()
	void rtp_stats_display(const rtp_stats_t* stats, const char* header)
	void rtp_stats_reset(rtp_stats_t* stats)
	
