
from pylinphone.linphone.lib.core cimport _LinphoneCallParams

cdef class LinphoneCallParams:
	cdef _LinphoneCallParams* _params
	cdef bint _owned
	
	cdef LinphoneCallParams _setup(self, _LinphoneCallParams* params, bint _owned=*)

cdef LinphoneCallParams LinphoneCallParams_create(_LinphoneCallParams* params, bint _owned=*)
