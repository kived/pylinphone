
from .core cimport cLinphoneCore

cdef extern from "time.h" nogil:
	ctypedef unsigned long time_t

cdef extern from "linphone/linphonepresence.h" nogil:
	ctypedef enum LinphonePresenceBasicStatus:
		LinphonePresenceBasicStatusOpen
		LinphonePresenceBasicStatusClosed
	
	ctypedef enum LinphonePresenceActivityType:
		LinphonePresenceActivityOffline
		LinphonePresenceActivityOnline
		LinphonePresenceActivityAppointment
		LinphonePresenceActivityAway
		LinphonePresenceActivityBreakfast
		LinphonePresenceActivityBusy
		LinphonePresenceActivityDinner
		LinphonePresenceActivityHoliday
		LinphonePresenceActivityInTransit
		LinphonePresenceActivityLookingForWork
		LinphonePresenceActivityLunch
		LinphonePresenceActivityMeal
		LinphonePresenceActivityMeeting
		LinphonePresenceActivityOnThePhone
		LinphonePresenceActivityOther
		LinphonePresenceActivityPerformance
		LinphonePresenceActivityPermanentAbsence
		LinphonePresenceActivityPlaying
		LinphonePresenceActivityPresentation
		LinphonePresenceActivityShopping
		LinphonePresenceActivitySleeping
		LinphonePresenceActivitySpectator
		LinphonePresenceActivitySteering
		LinphonePresenceActivityTravel
		LinphonePresenceActivityTV
		LinphonePresenceActivityUnknown
		LinphonePresenceActivityVacation
		LinphonePresenceActivityWorking
		LinphonePresenceActivityWorship
	
	ctypedef struct LinphonePresenceModel
	ctypedef struct LinphonePresencePerson
	ctypedef struct LinphonePresenceService
	ctypedef struct LinphonePresenceActivity
	ctypedef struct LinphonePresenceNote
	
	LinphonePresenceModel* linphone_presence_model_new_with_activity(LinphonePresenceActivityType activity, const char* description)
	LinphonePresenceModel* linphone_presence_model_new_with_activity_and_note(LinphonePresenceActivityType activity, const char* description, const char* note, const char* lang)
	LinphonePresenceBasicStatus linphone_presence_get_basic_status(const LinphonePresenceModel* model)
	int linphone_presence_set_basic_status(LinphonePresenceModel* model, LinphonePresenceBasicStatus basic_status)
	time_t linphone_presence_model_get_timestamp(const LinphonePresenceModel* model)
	char* linphone_presence_model_get_contact(const LinphonePresenceModel* model)
	int linphone_presence_model_set_contact(LinphonePresenceModel* model, const char* contact)
	LinphonePresenceActivity* linphone_presence_model_get_activity(const LinphonePresenceModel* model)
	int linphone_presence_model_set_activity(LinphonePresenceModel* model, LinphonePresenceActivityType activity, const char* description)
	unsigned int linphone_presence_model_get_nb_activities(const LinphonePresenceModel* model)
	LinphonePresenceActivity* linphone_presence_model_get_nth_activity(const LinphonePresenceModel* model, unsigned int idx)
	int linphone_presence_model_add_activity(LinphonePresenceModel* model, LinphonePresenceActivity* activity)
	int linphone_presence_model_clear_activities(LinphonePresenceModel* model)
	LinphonePresenceNote* linphone_presence_model_get_note(const LinphonePresenceModel* model, const char* lang)
	int linphone_presence_model_add_note(LinphonePresenceModel* model, const char* note_content, const char* lang)
	int linphone_presence_model_clear_notes(LinphonePresenceModel* model)
	
	LinphonePresenceModel* linphone_presence_model_new()
	unsigned int linphone_presence_model_get_nb_services(const LinphonePresenceModel* model)
	LinphonePresenceService* linphone_presence_model_get_nth_service(const LinphonePresenceModel* model, unsigned int idx)
	int linphone_presence_model_add_service(LinphonePresenceModel* model, LinphonePresenceService* service)
	int linphone_presence_model_clear_services(LinphonePresenceModel* model)
	unsigned int linphone_presence_model_get_nb_persons(const LinphonePresenceModel* model)
	LinphonePresencePerson* linphone_presence_model_get_nth_person(const LinphonePresenceModel* model, unsigned int idx)
	int linphone_presence_model_add_person(LinphonePresenceModel* model, LinphonePresencePerson* person)
	int linphone_presence_model_clear_persons(LinphonePresenceModel* model)
	
	LinphonePresenceService* linphone_presence_service_new(const char* id, LinphonePresenceBasicStatus, const char* contact)
	char* linphone_presence_service_get_id(const LinphonePresenceService* service)
	int linphone_presence_service_set_id(LinphonePresenceService* service, const char* id)
	LinphonePresenceBasicStatus linphone_presence_service_get_basic_status(const LinphonePresenceService* service)
	int linphone_presence_service_set_basic_status(LinphonePresenceService* service, LinphonePresenceBasicStatus basic_status)
	char* linphone_presence_service_get_contact(const LinphonePresenceService* service)
	int linphone_presence_service_set_contact(LinphonePresenceService* service, const char* contact)
	unsigned int linphone_presence_service_get_nb_notes(const LinphonePresenceService* service)
	LinphonePresenceNote* linphone_presence_service_get_nth_note(const LinphonePresenceService* service, unsigned int idx)
	int linphone_presence_service_add_note(LinphonePresenceService* service, LinphonePresenceNote* note)
	int linphone_presence_service_clear_notes(LinphonePresenceService* service)
	
	LinphonePresencePerson* linphone_presence_person_new(const char* id)
	char* linphone_presence_person_get_id(const LinphonePresencePerson* person)
	int linphone_presence_person_set_id(LinphonePresencePerson* person, const char* id)
	unsigned int linphone_presence_person_get_nb_activities(const LinphonePresencePerson* person)
	LinphonePresenceActivity* linphone_presence_get_nth_activity(const LinphonePresencePerson* person, unsigned int idx)
	int linphone_presence_person_add_activity(LinphonePresencePerson* person, LinphonePresenceActivity* activity)
	int linphone_presence_person_clear_activities(LinphonePresencePerson* person)
	unsigned int linphone_presence_person_get_nb_notes(const LinphonePresencePerson* person)
	LinphonePresenceNote* linphone_presence_person_get_nth_note(const LinphonePresencePerson* person, unsigned int idx)
	int linphone_presence_person_add_note(LinphonePresencePerson* person, LinphonePresenceNote* note)
	int linphone_presence_person_clear_notes(LinphonePresencePerson* person)
	unsigned int linphone_presence_person_get_nb_activities_notes(const LinphonePresencePerson* person)
	LinphonePresenceNote* linphone_presence_person_get_nth_activities_note(const LinphonePresencePerson* person, unsigned int idx)
	int linphone_presence_person_add_activities_note(LinphonePresencePerson* person, LinphonePresenceNote* note)
	int linphone_presence_person_clear_activities_notes(LinphonePresencePerson* person)
	
	LinphonePresenceActivity* linphone_presence_activity_new(LinphonePresenceActivityType acttype, const char* description)
	char* linphone_presence_activity_to_string(const LinphonePresenceActivity* activity)
	LinphonePresenceActivityType linphone_presence_activity_get_type(const LinphonePresenceActivity* activity)
	int linphone_presence_activity_set_type(LinphonePresenceActivity* activity, LinphonePresenceActivityType acttype)
	const char* linphone_presence_activity_get_description(const LinphonePresenceActivity* activity)
	int linphone_presence_activity_set_description(LinphonePresenceActivity* activity, const char* description)
	
	LinphonePresenceNote* linphone_presence_note_new(const char* content, const char* lang)
	const char* linphone_presence_note_get_content(const LinphonePresenceNote* note)
	int linphone_presence_note_set_content(LinphonePresenceNote* note, const char* content)
	const char* linphone_presence_note_get_lang(const LinphonePresenceNote* note)
	int linphone_presence_note_set_lang(LinphonePresenceNote* note, const char* lang)
	
	LinphonePresenceModel* linphone_presence_model_ref(LinphonePresenceModel* model)
	LinphonePresenceModel* linphone_presence_model_unref(LinphonePresenceModel* model)
	void linphone_presence_model_set_user_data(LinphonePresenceModel* model, void* user_data)
	void* linphone_presence_model_get_user_data(LinphonePresenceModel* model)
	LinphonePresenceService* linphone_presence_service_ref(LinphonePresenceService* service)
	LinphonePresenceService* linphone_presence_service_unref(LinphonePresenceService* service)
	void linphone_presence_service_set_user_data(LinphonePresenceService* service, void* user_data)
	void* linphone_presence_service_get_user_data(LinphonePresenceService* service)
	LinphonePresencePerson* linphone_presence_person_ref(LinphonePresencePerson* person)
	LinphonePresencePerson* linphone_presence_person_unref(LinphonePresencePerson* person)
	void linphone_presence_person_set_user_data(LinphonePresencePerson* person, void* user_data)
	void* linphone_presence_person_get_user_data(LinphonePresencePerson* person)
	LinphonePresenceActivity* linphone_presence_activity_ref(LinphonePresenceActivity* activity)
	LinphonePresenceActivity* linphone_presence_activity_unref(LinphonePresenceActivity* activity)
	void linphone_presence_activity_set_user_data(LinphonePresenceActivity* activity, void* user_data)
	void* linphone_presence_activity_get_user_data(LinphonePresenceActivity* activity)
	LinphonePresenceNote* linphone_presence_note_ref(LinphonePresenceNote* note)
	LinphonePresenceNote* linphone_presence_note_unref(LinphonePresenceNote* note)
	void linphone_presence_note_set_user_data(LinphonePresenceNote* note, void* user_data)
	void* linphone_presence_note_get_user_data(LinphonePresenceNote* note)
	
	LinphonePresenceActivity* linphone_core_create_presence_activity(cLinphoneCore* lc, LinphonePresenceActivityType acttype, 
	                                                                 const char* description)
	LinphonePresenceModel* linphone_core_create_presence_model(cLinphoneCore* lc)
	LinphonePresenceModel* linphone_core_create_presence_model_with_activity(cLinphoneCore* lc, 
	                                                                         LinphonePresenceActivityType acttype, 
	                                                                         const char* description)
	LinphonePresenceModel* linphone_core_create_presence_model_with_activity_and_note(cLinphoneCore* lc, 
	                                                                                  LinphonePresenceActivityType acttype,
	                                                                                  const char* description,
	                                                                                  const char* note, const char* lang)
	LinphonePresenceNote* linphone_core_create_presence_note(cLinphoneCore* lc, const char* content, const char* lang)
	LinphonePresencePerson* linphone_core_create_presence_person(cLinphoneCore* lc, const char* id)
	LinphonePresenceService* linphone_core_create_presence_service(cLinphoneCore* lc, const char* id,
	                                                               LinphonePresenceBasicStatus basic_status,
	                                                               const char* contact)
	
