
from libc.stdint cimport uint8_t, uint32_t
cimport pylinphone.linphone.lib.ortp.str_utils as str_utils

cdef extern from "mediastreamer2/msvideo.h" nogil:
	cdef int MS_VIDEO_SIZE_SQCIF_W
	cdef int MS_VIDEO_SIZE_SQCIF_H
	cdef int MS_VIDEO_SIZE_WQCIF_W
	cdef int MS_VIDEO_SIZE_WQCIF_H
	cdef int MS_VIDEO_SIZE_QCIF_W
	cdef int MS_VIDEO_SIZE_QCIF_H
	cdef int MS_VIDEO_SIZE_CIF_W
	cdef int MS_VIDEO_SIZE_CIF_H
	cdef int MS_VIDEO_SIZE_CVD_W
	cdef int MS_VIDEO_SIZE_CVD_H
	cdef int MS_VIDEO_SIZE_ICIF_W
	cdef int MS_VIDEO_SIZE_ICIF_H
	cdef int MS_VIDEO_SIZE_4CIF_W
	cdef int MS_VIDEO_SIZE_4CIF_H
	cdef int MS_VIDEO_SIZE_W4CIF_W
	cdef int MS_VIDEO_SIZE_W4CIF_H
	cdef int MS_VIDEO_SIZE_QQVGA_W
	cdef int MS_VIDEO_SIZE_QQVGA_H
	cdef int MS_VIDEO_SIZE_HQVGA_W
	cdef int MS_VIDEO_SIZE_HQVGA_H
	cdef int MS_VIDEO_SIZE_QVGA_W
	cdef int MS_VIDEO_SIZE_QVGA_H
	cdef int MS_VIDEO_SIZE_HVGA_W
	cdef int MS_VIDEO_SIZE_HVGA_H
	cdef int MS_VIDEO_SIZE_VGA_W
	cdef int MS_VIDEO_SIZE_VGA_H
	cdef int MS_VIDEO_SIZE_SVGA_W
	cdef int MS_VIDEO_SIZE_SVGA_H
	cdef int MS_VIDEO_SIZE_NS1_W
	cdef int MS_VIDEO_SIZE_NS1_H
	cdef int MS_VIDEO_SIZE_QSIF_W
	cdef int MS_VIDEO_SIZE_QSIF_H
	cdef int MS_VIDEO_SIZE_SIF_W
	cdef int MS_VIDEO_SIZE_SIF_H
	cdef int MS_VIDEO_SIZE_IOS_MEDIUM_W
	cdef int MS_VIDEO_SIZE_IOS_MEDIUM_H
	cdef int MS_VIDEO_SIZE_ISIF_W
	cdef int MS_VIDEO_SIZE_ISIF_H
	cdef int MS_VIDEO_SIZE_4SIF_W
	cdef int MS_VIDEO_SIZE_4SIF_H
	cdef int MS_VIDEO_SIZE_288P_W
	cdef int MS_VIDEO_SIZE_288P_H
	cdef int MS_VIDEO_SIZE_432P_W
	cdef int MS_VIDEO_SIZE_432P_H
	cdef int MS_VIDEO_SIZE_448P_W
	cdef int MS_VIDEO_SIZE_448P_H
	cdef int MS_VIDEO_SIZE_480P_W
	cdef int MS_VIDEO_SIZE_480P_H
	cdef int MS_VIDEO_SIZE_576P_W
	cdef int MS_VIDEO_SIZE_576P_H
	cdef int MS_VIDEO_SIZE_720P_W
	cdef int MS_VIDEO_SIZE_720P_H
	cdef int MS_VIDEO_SIZE_1080P_W
	cdef int MS_VIDEO_SIZE_1080P_H
	cdef int MS_VIDEO_SIZE_SDTV_W
	cdef int MS_VIDEO_SIZE_SDTV_H
	cdef int MS_VIDEO_SIZE_HDTVP_W
	cdef int MS_VIDEO_SIZE_HDTVP_H
	cdef int MS_VIDEO_SIZE_XGA_W
	cdef int MS_VIDEO_SIZE_XGA_H
	cdef int MS_VIDEO_SIZE_WXGA_W
	cdef int MS_VIDEO_SIZE_WXGA_H
	cdef int MS_VIDEO_SIZE_MAX_W
	cdef int MS_VIDEO_SIZE_MAX_H
	
	ctypedef struct MSVideoSize:
		int width, height
	
	ctypedef struct MSRect:
		int x, y, w, h
	
	cdef MSVideoSize MS_VIDEO_SIZE_CIF
	cdef MSVideoSize MS_VIDEO_SIZE_QCIF
	cdef MSVideoSize MS_VIDEO_SIZE_4CIF
	cdef MSVideoSize MS_VIDEO_SIZE_CVD
	cdef MSVideoSize MS_VIDEO_SIZE_QQVGA
	cdef MSVideoSize MS_VIDEO_SIZE_QVGA
	cdef MSVideoSize MS_VIDEO_SIZE_VGA
	cdef MSVideoSize MS_VIDEO_SIZE_720P
	cdef MSVideoSize MS_VIDEO_SIZE_NS1
	cdef MSVideoSize MS_VIDEO_SIZE_XGA
	cdef MSVideoSize MS_VIDEO_SIZE_SVGA
	cdef int MS_VIDEO_SIZE_800X600_W
	cdef int MS_VIDEO_SIZE_800X600_H
	cdef MSVideoSize MS_VIDEO_SIZE_800X600
	cdef int MS_VIDEO_SIZE_1024_W
	cdef int MS_VIDEO_SIZE_1024_h
	cdef MSVideoSize MS_VIDEO_SIZE_1024
	
	ctypedef enum MSMirrorType:
		MS_NO_MIRROR
		MS_HORIZONTAL_MIRROR
		MS_CENTRAL_MIRROR
		MS_VERTICAL_MIRROR
	
	ctypedef enum MSVideoOrientation:
		MS_VIDEO_LANDSCAPE
		MS_VIDEO_PORTRAIT
	
	ctypedef enum MSPixFmt:
		MS_YUV420P
		MS_YUYV
		MS_RGB24
		MS_RGB24_REV
		MS_MJPEG
		MS_UYVY
		MS_YUY2
		MS_RGBA32
		MS_RGB565
		MS_PIX_FMT_UNKNOWN
	
	ctypedef struct MSPicture:
		int w, h
		uint8_t[4]* planes
		int[4] strides
	
	ctypedef MSPicture YuvBuf
	
	int ms_pix_fmt_to_ffmpeg(MSPixFmt fmt)
	MSPixFmt ffmpeg_pix_fmt_to_ms(int fmt)
	MSPixFmt ms_fourcc_to_pix_fmt(uint32_t fourcc)
	void ms_ffmpeg_check_init()
	int ms_yuv_buf_init_from_mblk(MSPicture* buf, str_utils.mblk_t* m)
	int ms_yuv_buf_init_from_mblk_with_size(MSPicture* buf, str_utils.mblk_t* m, int w, int h)
	int ms_picture_init_from_mblk_with_size(MSPicture* buf, str_utils.mblk_t* m, MSPixFmt fmt, int w, int h)
	str_utils.mblk_t* ms_yuv_buf_alloc(MSPicture* buf, int w, int h)
	str_utils.mblk_t* ms_yuv_buf_alloc_from_buffer(int w, int h, str_utils.mblk_t* buffer)
	void ms_yuv_buf_copy(uint8_t[]* src_planes, const int[] src_strides, uint8_t[]* dst_planes, const int[3] dst_strides, MSVideoSize roi)
	void ms_yuv_buf_mirror(YuvBuf* buf)
	void ms_yuv_buf_mirrors(YuvBuf* buf, const MSMirrorType type)
	void rgb24_mirror(uint8_t* buf, int w, int h, int linesize)
	void rgb24_revert(uint8_t* buf, int w, int h, int linesize)
	void rgb24_copy_revert(uint8_t* dstbuf, int dstlsz, const uint8_t* srcbuf, int srclsz, MSVideoSize roi)
	
	void ms_rgb_to_yuv(const uint8_t[3] rgb, uint8_t[3] yuv)
	
	bint ms_video_size_greater_than(MSVideoSize vs1, MSVideoSize vs2)
	bint ms_video_size_area_greater_than(MSVideoSize vs1, MSVideoSize vs2)
	MSVideoSize ms_video_size_max(MSVideoSize vs1, MSVideoSize vs2)
	MSVideoSize ms_video_size_min(MSVideoSize vs1, MSVideoSize vs2)
	MSVideoSize ms_video_size_area_max(MSVideoSize vs1, MSVideoSize vs2)
	MSVideoSize ms_video_size_area_min(MSVideoSize vs1, MSVideoSize vs2)
	bint ms_video_size_equal(MSVideoSize vs1, MSVideoSize vs2)
	MSVideoSize ms_video_size_get_just_lower_than(MSVideoSize vs)
	MSVideoOrientation ms_video_size_get_orientation(MSVideoSize vs)
	MSVideoSize ms_video_size_change_orientation(MSVideoSize vs, MSVideoOrientation o)
	
	ctypedef struct MSScalerContext:
		pass
	
	cdef int MS_SCALER_METHOD_NEIGHBOUR
	cdef int MS_SCALER_METHOD_BILINEAR
	
	ctypedef struct MSScalerDesc:
		MSScalerContext* (*create_context)(int src_w, int src_h, MSPixFmt src_fmt, int dst_w, int dst_h, MSPixFmt dst_fmt, int flags)
		int (*context_process)(MSScalerContext* ctx, uint8_t[]* src, int[] src_strides, uint8_t[]* dst, int[] dst_strides)
		void (*context_free)(MSScalerContext* ctx)
	
	MSScalerContext* ms_scaler_create_context(int src_w, int src_h, MSPixFmt src_fmt, int dst_w, int dst_h, MSPixFmt dst_fmt, int flags)
	
	int ms_scaler_process(MSScalerContext* ctx, uint8_t[]* src, int[] src_strides, uint8_t[]* dst, int[] dst_strides)
	
	void ms_scaler_context_free(MSScalerContext* ctx)
	
	void ms_video_set_scaler_impl(MSScalerDesc* desc)
	
	str_utils.mblk_t* copy_ycbcrbiplanar_to_true_yuv_with_rotation(uint8_t* y, uint8_t* cbcr, int rotation, int w, int h, int y_byte_per_row, int cbcr_byte_per_row, bint uFirstvSecond)
	
	ctypedef struct MSFrameRateController:
		unsigned int start_time
		int th_frame_count
		float fps
	
	void ms_video_init_framerate_controller(MSFrameRateController* ctrl, float fps)
	bint ms_video_capture_new_frame(MSFrameRateController* ctrl, uint32_t current_time)
	
	ctypedef struct MSAverageFPS:
		unsigned int last_frame_time, last_print_time
		float mean_inter_frame
		float expected_fps
	
	void ms_video_init_average_fps(MSAverageFPS* afps, float expectedFps)
	void ms_video_update_average_fps(MSAverageFPS* afps, uint32_t current_time)
	
