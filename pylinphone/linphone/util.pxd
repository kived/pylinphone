
from pylinphone.linphone.lib.ortp.payloadtype cimport PayloadType
from pylinphone.linphone.lib.mediastreamer2.msvideo cimport MSVideoSize

cdef str nstr(const char* s)
cdef dict payload2dict(PayloadType* pt)
cdef tuple videosize2tuple(MSVideoSize sz)
