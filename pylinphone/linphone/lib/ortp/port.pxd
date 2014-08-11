
from libc.stdint cimport uint8_t

cdef extern from "stdarg.h" nogil:
	ctypedef struct va_list:
		pass

cdef extern from "pthread.h" nogil:
	ctypedef int pthread_t
	ctypedef struct pthread_mutex_t:
		pass
	ctypedef struct pthread_cond_t:
		pass

cdef extern from "ortp/port.h" nogil:
	ctypedef int ortp_socket_t
	ctypedef pthread_t ortp_thread_t
	ctypedef pthread_mutex_t ortp_mutex_t
	ctypedef pthread_cond_t ortp_cond_t
	
	ctypedef bint bool_t
	
	void* ortp_malloc(size_t sz)
	void ortp_free(void* ptr)
	void* ortp_realloc(void* ptr, size_t sz)
	void* ortp_malloc0(size_t sz)
	char* ortp_strdup(const char* tmp)
	
	ctypedef struct OrtpMemoryFunctions:
		void* (*malloc_fun)(size_t sz)
		void* (*realloc_fun)(void* ptr, size_t sz)
		void (*free_fun)(void* ptr)
	
	void ortp_set_memory_functions(OrtpMemoryFunctions* functions)
	
	int close_socket(ortp_socket_t sock)
	int set_non_blocking_socket(ortp_socket_t sock)
	
	char* ortp_strndup(const char* str, int n)
	char* ortp_strdup_printf(const char* fmt, ...)
	char* ortp_strdup_vprintf(const char* fmt, va_list ap)
	
	int ortp_file_exist(const char* pathname)
	
	ctypedef int ortp_pipe_t
	cdef int ORTP_PIPE_INVALID
	
	ortp_pipe_t ortp_server_pipe_create(const char* name)
	
	ortp_pipe_t ortp_server_pipe_accept_client(ortp_pipe_t server)
	int ortp_server_pipe_close(ortp_pipe_t spipe)
	int ortp_server_pipe_close_client(ortp_pipe_t client)
	
	ortp_pipe_t ortp_client_pipe_connect(const char* name)
	int ortp_client_pipe_close(ortp_pipe_t sock)
	
	int ortp_pipe_read(ortp_pipe_t p, uint8_t* buf, int len)
	int ortp_pipe_write(ortp_pipe_t p, const uint8_t* buf, int len)
	
	void* ortp_shm_open(unsigned int keyid, int size, int create)
	void ortp_shm_close(void* memory)
	
