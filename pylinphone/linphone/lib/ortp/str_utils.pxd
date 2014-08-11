
from libc.stdint cimport uint8_t, uint32_t

cdef extern from "ortp/str_utils.h" nogil:
	ctypedef struct dblk_t:
		unsigned char* db_base
		unsigned char* db_lim
		void (*db_freefn)(void*)
		int db_ref
	
	ctypedef struct mblk_t:
		mblk_t* b_prev
		mblk_t* b_next
		mblk_t* b_cont
		dblk_t* b_datap
		unsigned char* b_rptr
		unsigned char* b_wptr
		uint32_t reserved1
		uint32_t reserved2
	
	ctypedef struct queue_t:
		mblk_t _q_stopper
		int q_mcount
	
	void qinit(queue_t* q)
	void putq(queue_t* q, mblk_t* m)
	mblk_t* getq(queue_t* q)
	void insq(queue_t* q, mblk_t* emp, mblk_t* mp)
	void remq(queue_t* q, mblk_t* mp)
	mblk_t* peekq(queue_t* q)
	
	cdef int FLUSHALL
	void flushq(queue_t* q, int how)
	
	void mblk_init(mblk_t* mp)
	
	mblk_t* alloccb(int size, int unused)
	cdef int BPRI_MED
	
	mblk_t* esballoc(uint8_t* buf, int size, int pri, void (*freefn)(void*))
	void freeb(mblk_t* m)
	void freemsg(mblk_t* mp)
	mblk_t* dupb(mblk_t* m)
	mblk_t* dupmsg(mblk_t* m)
	int msgdsize(const mblk_t* mp)
	void msgpullup(mblk_t* mp, int len)
	mblk_t* copyb(mblk_t* mp)
	mblk_t* copymsg(mblk_t* mp)
	mblk_t* appendb(mblk_t* mp, const char* data, int size, bint pad)
	void msgappend(mblk_t* mp, const char* data, int size, bint pad)
	mblk_t* concatb(mblk_t* mp, mblk_t* newm)
	
	ctypedef struct msgb_allocator_t:
		queue_t q
	
	void msgb_allocator_init(msgb_allocator_t* pa)
	mblk_t* msgb_allocator_alloc(msgb_allocator_t* pa, int size)
	void msgb_allocator_uninit(msgb_allocator_t* pa)
	
	
