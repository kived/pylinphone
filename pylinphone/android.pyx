include "config.pxi"

IF ANDROID:
	
	cdef extern from "jvm.h":
		cdef struct JavaVM
		cdef struct JNIEnv
	
	cdef extern JNIEnv* SDL_ANDROID_GetJNIEnv()
	
	cdef extern from "mediastreamer2/msjava.h":
		void ms_set_jvm(JavaVM* vm)
	
	
	def init_android():
		cdef JavaVM* jvm
		cdef JNIEnv* jnienv = SDL_ANDROID_GetJNIEnv()
		jnienv[0].GetJavaVM(jnienv, &jvm)
		ms_set_jvm(jvm)
