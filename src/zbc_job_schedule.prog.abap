*&---------------------------------------------------------------------*
*-Description----------------------------------------------------------*
* Job Scheduler to manage daily scheduling between time from and to.
* The jobs can be scheduled in View Cluster ZBCVC_JOB_SCHED to run
* every x minutes between from and to daily.
* This report is planned to run every 5 minutes=>the jobs to be scheduled
* can be planned to run at least every 5 minutes. Maximum is 6 hours,
* because more can be scheduled manually easier in transaction SM36.
* ---------------------------------------------------------------------*
* Job Status Codes: R=Released, Z=Suspended, A=Cancelled, P=Scheduled
* S=Released,Y=Released. A Job is Active in status R, if start time
* is maintained and less then current time.
* We consider only whether it is released or not and created by us,
* because the background system resource can delay a scheduled job.
* In this case we do not schedule it again, but waiting if it is ended.
*----------------------------------------------------------------------*
*-Creation-------------------------------------------------------------*
* Author:       Attila Berencsi
* SAP Version:  EHP7 for SAP ERP 6.0
* Date:         24.06.2014 14:28:23
*----------------------------------------------------------------------*
REPORT zbc_job_schedule.

INCLUDE zbc_job_scheduletop. "Global Data

IF sy-batch IS INITIAL.
  RETURN.
ENDIF.

SELECT * FROM zbc_job_schedule  INTO TABLE gt_job_schedule.
SELECT * FROM zbc_job_step      INTO TABLE gt_job_step.

LOOP AT gt_job_schedule INTO gs_job_schedule
  WHERE daily_from  LE sy-uzeit
    AND daily_to    GE sy-uzeit
    AND active      EQ abap_true.

  CLEAR: gv_jobcount, gv_status.

  "$. Region Check criterias whether to submit the Job or not
  SELECT SINGLE * FROM zbc_job_last_run INTO gs_last_run
    WHERE jobname = gs_job_schedule-jobname.

  IF sy-subrc EQ 0."There is information about last run planned by this Scheduler.

    CALL FUNCTION 'BP_JOB_STATUS_GET'
      EXPORTING
        jobcount                   = gs_last_run-jobcount
        jobname                    = gs_last_run-jobname
        read_only_status           = abap_true
      IMPORTING
        status                     = gv_status
      EXCEPTIONS
        job_doesnt_exist           = 1
        unknown_error              = 2
        parent_child_inconsistency = 3
        OTHERS                     = 4.

    IF sy-subrc EQ 0.
      CASE gv_status.
        WHEN 'R' OR 'S' OR 'Y' OR 'Z' OR 'P'."Released or Suspended or Planned
          CONTINUE.
      ENDCASE.

      IF gs_last_run-last_day EQ sy-datum."Run this day
        gv_next_run = gs_last_run-last_time + ( gs_job_schedule-everymin * 60 ).
        IF gv_next_run LT gs_last_run-last_time."Turn Over = Next Day => do it tomorrow
          CONTINUE.
        ENDIF.
        IF gv_next_run GT sy-uzeit."Next execution time not reached yet
          CONTINUE.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
  "$. Endregion Check criterias whether to submit the Job or not

  "All checks passed, open the Job
  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = gs_job_schedule-jobname
    IMPORTING
      jobcount         = gv_jobcount
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.

  IF sy-subrc NE 0."Problem occured opening the job =>take next job
    CASE sy-subrc.
      WHEN 1.
        WRITE: / 'Cannot create job:'(001),gs_job_schedule-jobname.
      WHEN 2.
        WRITE: / 'Invalid job data:'(002), gs_job_schedule-jobname.
      WHEN 3.
        WRITE: / 'Job name missing:'(003), gs_job_schedule-jobname.
      WHEN 4.
        WRITE: / 'Job'(004), gs_job_schedule-jobname, 'could not be scheduled'(005).
    ENDCASE.
    CONTINUE.
  ENDIF.

  "Add steps
  LOOP AT gt_job_step INTO gs_job_step WHERE jobname EQ gs_job_schedule-jobname.
    IF gs_job_step-variant IS NOT INITIAL.
      SUBMIT (gs_job_step-progname)
      VIA JOB gs_job_step-jobname NUMBER gv_jobcount
      USING SELECTION-SET gs_job_step-variant AND RETURN.
    ELSE.
      SUBMIT (gs_job_step-progname)
      VIA JOB gs_job_step-jobname NUMBER gv_jobcount AND RETURN.
    ENDIF.
  ENDLOOP.

  "Finalize
  CALL FUNCTION 'JOB_CLOSE'
    EXPORTING
      jobcount             = gv_jobcount
      jobname              = gs_job_step-jobname
      strtimmed            = abap_true
    IMPORTING
      job_was_released     = gv_released
    EXCEPTIONS
      cant_start_immediate = 1
      invalid_startdate    = 2
      jobname_missing      = 3
      job_close_failed     = 4
      job_nosteps          = 5
      job_notex            = 6
      lock_failed          = 7
      invalid_target       = 8
      OTHERS               = 9.

  IF sy-subrc NE 0."Error occured => store not as planned successfully
    WRITE: /
    'Job'(004), gs_job_schedule-jobname,
    'could not be scheduled, function JOB_CLOSE sy-subrc='(006),sy-subrc.
    CONTINUE.
  ENDIF.

  CLEAR gs_last_run.
  gs_last_run-jobname   = gs_job_schedule-jobname.
  gs_last_run-jobcount  = gv_jobcount.
  gs_last_run-last_day  = sy-datum.
  gs_last_run-last_time = sy-uzeit.

  MODIFY zbc_job_last_run FROM gs_last_run.

ENDLOOP.

COMMIT WORK.
