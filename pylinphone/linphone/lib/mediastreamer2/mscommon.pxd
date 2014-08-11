'''
Created on Dec 2, 2013

@author: "Ryan Pessa <ryan@essential-elements.net>"
'''

from libc.stdint cimport uint64_t

cdef extern from "mediastreamer2/mscommon.h" nogil:
	ctypedef struct MSList:
		MSList* next
		MSList* prev
		void* data
	
	ctypedef int (*MSCompareFunc)(const void* a, const void* b)
	
	ctypedef struct MSTimeSpec:
		pass
	
	void ms_thread_exit(void* ret_val)
	void ms_get_cur_time(MSTimeSpec* ret)
	MSList* ms_list_append(MSList* elem, void* data)
	MSList* ms_list_prepend(MSList* elem, void* data)
	MSList* ms_list_free(MSList* elem)
	MSList* ms_list_concat(MSList* first, MSList* second)
	MSList* ms_list_remove(MSList* first, void* data)
	int ms_list_size(const MSList* first)
	void ms_list_for_each(const MSList* list, void (*func)(void*))
	void ms_list_for_each2(const MSList* list, void (*func)(void*, void*), void* user_data)
	MSList* ms_list_remove_link(MSList* list, MSList* elem)
	MSList* ms_list_find(MSList* list, void* data)
	MSList* ms_list_find_custom(MSList* list, MSCompareFunc compare_func, const void* user_data)
	void* ms_list_nth_data(const MSList* list, int index)
	int ms_list_position(const MSList* list, MSList* elem)
	int ms_list_index(const MSList* list, void* data)
	MSList* ms_list_insert_sorted(MSList* list, void* data, MSCompareFunc compare_func)
	MSList* ms_list_insert(MSList* list, MSList* before, void* data)
	MSList* ms_list_copy(const MSList* list)
	
	void ms_init()
	
	int ms_load_plugins(const char* directory)
	
	void ms_exit()
	
	void ms_sleep(int seconds)
	
	void ms_usleep(uint64_t usec)
	
	int ms_get_payload_max_size()
	
	void ms_set_payload_max_size(int size)
	
	int ms_discover_mtu(const char* destination_host)
	
	void ms_set_mtu(int mtu)
	
	void ms_set_cpu_count(unsigned int c)
	
	unsigned int ms_get_cpu_count()
	
