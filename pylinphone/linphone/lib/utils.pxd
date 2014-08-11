
from .core cimport cLinphoneCore

cdef extern from "linphone/linphonecore_utils.h" nogil:
	ctypedef struct LsdPlayer
	ctypedef struct LinphoneSoundDaemon
	
	ctypedef void (*LsdEndOfPlayCallback)(LsdPlayer* p)
	
	void lsd_player_set_callback(LsdPlayer* p, LsdEndOfPlayCallback cb)
	void lsd_player_set_user_pointer(LsdPlayer* p, void* up)
	void* lsd_player_get_user_pointer(const LsdPlayer* p)
	int lsd_player_play(LsdPlayer* p, const char* filename)
	int lsd_player_stop(LsdPlayer* p)
	void lsd_player_enable_loop(LsdPlayer* p, bint loopmode)
	bint lsd_player_loop_enabled(const LsdPlayer* p)
	void lsd_player_set_gain(LsdPlayer* p, float gain)
	LinphoneSoundDaemon* lsd_player_get_daemon(const LsdPlayer* p)
	
	LinphoneSoundDaemon* linphone_sound_daemon_new(const char* cardname, int rate, int nchannels)
	LsdPlayer* linphone_sound_daemon_get_player(LinphoneSoundDaemon* lsd)
	void linphone_sound_daemon_release_player(LinphoneSoundDaemon* lsd, LsdPlayer* lsdplayer)
	void linphone_sound_daemon_stop_all_players(LinphoneSoundDaemon* obj)
	void linphone_sound_daemon_release_all_players(LinphoneSoundDaemon* obj)
	void linphone_core_use_sound_daemon(cLinphoneCore* lc, LinphoneSoundDaemon* lsd)
	void linphone_core_sound_daemon_destroy(LinphoneSoundDaemon* obj)
	
	ctypedef enum LinphoneEcCalibratorStatus:
		LinphoneEcCalibratorInProgress
		LinphoneEcCalibratorDone
		LinphoneEcCalibratorFailed
		LinphoneEcCalibratorDoneNoEcho
	
	ctypedef void (*LinphoneEcCalibrationCallback)(cLinphoneCore* lc, LinphoneEcCalibratorStatus status, int delay_ms, void* data)
	ctypedef void (*LinphoneEcCalibrationAudioInit)(void* data)
	ctypedef void (*LinphoneEcCalibrationAudioUninit)(void* data)
	
	int linphone_core_start_echo_calibration(cLinphoneCore* lc, LinphoneEcCalibrationCallback cb, LinphoneEcCalibrationAudioInit audio_init_cb,
	                                         LinphoneEcCalibrationAudioUninit audio_uninit_cb, void* cb_data)
	
	void linphone_core_start_dtmf_stream(cLinphoneCore* lc)
	void linphone_core_stop_dtmf_stream(cLinphoneCore* lc)
	
	ctypedef bint (*LinphoneCoreIterateHook)(void* data)
	
	void linphone_core_add_iterate_hook(cLinphoneCore* lc, LinphoneCoreIterateHook hook, void* hook_data)
	void linphone_core_remove_iterate_hook(cLinphoneCore* lc, LinphoneCoreIterateHook hook, void* hook_data)
	
	int linphone_dial_plan_lookup_ccc_from_iso(const char* iso)
	int linphone_dial_plan_lookup_ccc_from_e164(const char* e164)
	
