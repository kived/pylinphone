
from libc.stdint cimport int64_t

cdef extern from "linphone/lpconfig.h" nogil:
	ctypedef struct LpConfig:
		pass
	
	LpConfig* lp_config_new(const char* filename)
	LpConfig* lp_config_new_with_factory(const char* config_filename, const char* factory_config_filename)
	
	int lp_config_read_file(LpConfig* lpconfig, const char* filename)
	
	const char* lp_config_get_string(const LpConfig* lpconfig, const char* section, const char* key, const char* default_string)
	bint lp_config_get_range(const LpConfig* lpconfig, const char* section, const char* key, int* min, int* max,
	                         int default_min, int default_max)
	int lp_config_get_int(const LpConfig* lpconfig, const char* section, const char* key, int default_value)
	int64_t lp_config_get_int64(const LpConfig* lpconfig, const char* section, const char* key, int64_t default_value)
	float lp_config_get_float(const LpConfig* lpconfig, const char* section, const char* key, float default_value)
	
	void lp_config_set_string(LpConfig* lpconfig, const char* section, const char* key, const char* value)
	void lp_config_set_range(LpConfig* lpconfig, const char* section, const char* key, int min_value, int max_value)
	void lp_config_set_int(LpConfig* lpconfig, const char* section, const char* key, int value)
	void lp_config_set_int_hex(LpConfig* lpconfig, const char* section, const char* key, int value)
	void lp_config_set_int64(LpConfig* lpconfig, const char* section, const char* key, int64_t value)
	void lp_config_set_float(LpConfig* lpconfig, const char* section, const char* key, float value)
	
	int lp_config_sync(LpConfig* lpconfig)
	int lp_config_has_section(const LpConfig* lpconfig, const char* section)
	void lp_config_clean_section(LpConfig* lpconfig, const char* section)
	void lp_config_for_each_section(const LpConfig* lpconfig, void (*callback)(const char* section, void* ctx), void* ctx)
	void lp_config_for_each_entry(const LpConfig* lpconfig, const char* section, void (*callback)(const char* entry, void* ctx), void* ctx)
	int lp_config_needs_commit(const LpConfig* lpconfig)
	void lp_config_destroy(LpConfig* cfg)
	
	int lp_config_get_default_int(const LpConfig* lpconfig, const char* section, const char* key, int default_value)
	int64_t lp_config_get_default_int64(const LpConfig* lpconfig, const char* section, const char* key, int64_t default_value)
	float lp_config_get_default_float(const LpConfig* lpconfig, const char* section, const char* key, float default_value)
	const char* lp_config_get_default_string(const LpConfig* lpconfig, const char* section, const char* key, const char* default_value)
	const char* lp_config_get_section_param_string(const LpConfig* lpconfig, const char* section, const char* key, const char* default_value)
	
