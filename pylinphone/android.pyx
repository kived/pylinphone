include "config.pxi"

IF ANDROID:
	
	from jnius.jnius cimport get_jnienv
	
	cdef extern from "jvm.h":
		cdef struct JavaVM
		cdef struct JNIEnv
	
	cdef extern from "mediastreamer2/msjava.h":
		void ms_set_jvm(JavaVM* vm)
	
	
	def init_android():
		cdef JNIEnv* jnienv = get_jnienv()
		cdef JavaVM* jvm = jnienv.GetJavaVM()
		ms_set_jvm(jvm)
