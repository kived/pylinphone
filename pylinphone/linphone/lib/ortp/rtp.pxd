
from libc.stdint cimport uint16_t, uint32_t, uint64_t

cdef extern from "ortp/rtp.h" nogil:
	ctypedef struct rtp_header_t:
		uint16_t cc
		uint16_t extbit
		uint16_t padbit
		uint16_t version
		uint16_t paytype
		uint16_t markbit
		uint32_t seq_number
		uint32_t timestamp
		uint32_t ssrc
		uint32_t[16] csrc
	
	ctypedef struct rtp_stats_t:
		uint64_t packet_sent
		uint64_t sent
		uint64_t recv
		uint64_t hw_recv
		uint64_t packet_recv
		uint64_t outoftime
		uint64_t cum_packet_loss
		uint64_t bad
		uint64_t discarded
		uint64_t sent_rtcp_packets
	
	ctypedef struct jitter_stats_t:
		uint32_t jitter
		uint32_t max_jitter
		uint64_t sum_jitter
		uint64_t max_jitter_ts
	
