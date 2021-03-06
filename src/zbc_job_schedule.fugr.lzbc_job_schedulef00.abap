*---------------------------------------------------------------------*
*    view related FORM routines
*   generation date: 20.10.2016 at 10:19:36 by user BERENCSI_A
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZBCV_JOB_SCHEDUL................................*
FORM GET_DATA_ZBCV_JOB_SCHEDUL.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZBC_JOB_SCHEDULE WHERE
(VIM_WHERETAB) .
    CLEAR ZBCV_JOB_SCHEDUL .
ZBCV_JOB_SCHEDUL-CLIENT =
ZBC_JOB_SCHEDULE-CLIENT .
ZBCV_JOB_SCHEDUL-JOBNAME =
ZBC_JOB_SCHEDULE-JOBNAME .
ZBCV_JOB_SCHEDUL-DAILY_FROM =
ZBC_JOB_SCHEDULE-DAILY_FROM .
ZBCV_JOB_SCHEDUL-DAILY_TO =
ZBC_JOB_SCHEDULE-DAILY_TO .
ZBCV_JOB_SCHEDUL-EVERYMIN =
ZBC_JOB_SCHEDULE-EVERYMIN .
ZBCV_JOB_SCHEDUL-ACTIVE =
ZBC_JOB_SCHEDULE-ACTIVE .
<VIM_TOTAL_STRUC> = ZBCV_JOB_SCHEDUL.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZBCV_JOB_SCHEDUL .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZBCV_JOB_SCHEDUL.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZBCV_JOB_SCHEDUL-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZBC_JOB_SCHEDULE WHERE
  JOBNAME = ZBCV_JOB_SCHEDUL-JOBNAME .
    IF SY-SUBRC = 0.
    DELETE ZBC_JOB_SCHEDULE .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZBC_JOB_SCHEDULE WHERE
  JOBNAME = ZBCV_JOB_SCHEDUL-JOBNAME .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZBC_JOB_SCHEDULE.
    ENDIF.
ZBC_JOB_SCHEDULE-CLIENT =
ZBCV_JOB_SCHEDUL-CLIENT .
ZBC_JOB_SCHEDULE-JOBNAME =
ZBCV_JOB_SCHEDUL-JOBNAME .
ZBC_JOB_SCHEDULE-DAILY_FROM =
ZBCV_JOB_SCHEDUL-DAILY_FROM .
ZBC_JOB_SCHEDULE-DAILY_TO =
ZBCV_JOB_SCHEDUL-DAILY_TO .
ZBC_JOB_SCHEDULE-EVERYMIN =
ZBCV_JOB_SCHEDUL-EVERYMIN .
ZBC_JOB_SCHEDULE-ACTIVE =
ZBCV_JOB_SCHEDUL-ACTIVE .
    IF SY-SUBRC = 0.
    UPDATE ZBC_JOB_SCHEDULE .
    ELSE.
    INSERT ZBC_JOB_SCHEDULE .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZBCV_JOB_SCHEDUL-UPD_FLAG,
STATUS_ZBCV_JOB_SCHEDUL-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZBCV_JOB_SCHEDUL.
  SELECT SINGLE * FROM ZBC_JOB_SCHEDULE WHERE
JOBNAME = ZBCV_JOB_SCHEDUL-JOBNAME .
ZBCV_JOB_SCHEDUL-CLIENT =
ZBC_JOB_SCHEDULE-CLIENT .
ZBCV_JOB_SCHEDUL-JOBNAME =
ZBC_JOB_SCHEDULE-JOBNAME .
ZBCV_JOB_SCHEDUL-DAILY_FROM =
ZBC_JOB_SCHEDULE-DAILY_FROM .
ZBCV_JOB_SCHEDUL-DAILY_TO =
ZBC_JOB_SCHEDULE-DAILY_TO .
ZBCV_JOB_SCHEDUL-EVERYMIN =
ZBC_JOB_SCHEDULE-EVERYMIN .
ZBCV_JOB_SCHEDUL-ACTIVE =
ZBC_JOB_SCHEDULE-ACTIVE .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZBCV_JOB_SCHEDUL USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZBCV_JOB_SCHEDUL-JOBNAME TO
ZBC_JOB_SCHEDULE-JOBNAME .
MOVE ZBCV_JOB_SCHEDUL-CLIENT TO
ZBC_JOB_SCHEDULE-CLIENT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZBC_JOB_SCHEDULE'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZBC_JOB_SCHEDULE TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZBC_JOB_SCHEDULE'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
*...processing: ZBCV_JOB_STEP...................................*
FORM GET_DATA_ZBCV_JOB_STEP.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZBC_JOB_STEP WHERE
(VIM_WHERETAB) .
    CLEAR ZBCV_JOB_STEP .
ZBCV_JOB_STEP-CLIENT =
ZBC_JOB_STEP-CLIENT .
ZBCV_JOB_STEP-JOBNAME =
ZBC_JOB_STEP-JOBNAME .
ZBCV_JOB_STEP-STEPCOUNT =
ZBC_JOB_STEP-STEPCOUNT .
ZBCV_JOB_STEP-PROGNAME =
ZBC_JOB_STEP-PROGNAME .
ZBCV_JOB_STEP-VARIANT =
ZBC_JOB_STEP-VARIANT .
<VIM_TOTAL_STRUC> = ZBCV_JOB_STEP.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZBCV_JOB_STEP .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZBCV_JOB_STEP.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZBCV_JOB_STEP-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZBC_JOB_STEP WHERE
  JOBNAME = ZBCV_JOB_STEP-JOBNAME AND
  STEPCOUNT = ZBCV_JOB_STEP-STEPCOUNT .
    IF SY-SUBRC = 0.
    DELETE ZBC_JOB_STEP .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZBC_JOB_STEP WHERE
  JOBNAME = ZBCV_JOB_STEP-JOBNAME AND
  STEPCOUNT = ZBCV_JOB_STEP-STEPCOUNT .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZBC_JOB_STEP.
    ENDIF.
ZBC_JOB_STEP-CLIENT =
ZBCV_JOB_STEP-CLIENT .
ZBC_JOB_STEP-JOBNAME =
ZBCV_JOB_STEP-JOBNAME .
ZBC_JOB_STEP-STEPCOUNT =
ZBCV_JOB_STEP-STEPCOUNT .
ZBC_JOB_STEP-PROGNAME =
ZBCV_JOB_STEP-PROGNAME .
ZBC_JOB_STEP-VARIANT =
ZBCV_JOB_STEP-VARIANT .
    IF SY-SUBRC = 0.
    UPDATE ZBC_JOB_STEP .
    ELSE.
    INSERT ZBC_JOB_STEP .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZBCV_JOB_STEP-UPD_FLAG,
STATUS_ZBCV_JOB_STEP-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZBCV_JOB_STEP.
  SELECT SINGLE * FROM ZBC_JOB_STEP WHERE
JOBNAME = ZBCV_JOB_STEP-JOBNAME AND
STEPCOUNT = ZBCV_JOB_STEP-STEPCOUNT .
ZBCV_JOB_STEP-CLIENT =
ZBC_JOB_STEP-CLIENT .
ZBCV_JOB_STEP-JOBNAME =
ZBC_JOB_STEP-JOBNAME .
ZBCV_JOB_STEP-STEPCOUNT =
ZBC_JOB_STEP-STEPCOUNT .
ZBCV_JOB_STEP-PROGNAME =
ZBC_JOB_STEP-PROGNAME .
ZBCV_JOB_STEP-VARIANT =
ZBC_JOB_STEP-VARIANT .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZBCV_JOB_STEP USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZBCV_JOB_STEP-JOBNAME TO
ZBC_JOB_STEP-JOBNAME .
MOVE ZBCV_JOB_STEP-STEPCOUNT TO
ZBC_JOB_STEP-STEPCOUNT .
MOVE ZBCV_JOB_STEP-CLIENT TO
ZBC_JOB_STEP-CLIENT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZBC_JOB_STEP'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZBC_JOB_STEP TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZBC_JOB_STEP'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
