*&---------------------------------------------------------------------*
*& Subroutine Pool   ZBC_JOB_SCHEDULE_VC_SUBRPOOL
*&
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*-Description----------------------------------------------------------*
* Job Scheduler - Subroutine Pool for ViewCluster checks
*----------------------------------------------------------------------*
*-Creation-------------------------------------------------------------*
* Author:       Attila Berencsi
* SAP Version:  EhP3 for SAP SRM 7.0
* Date:         03.07.2014 14:23:33
*----------------------------------------------------------------------*

PROGRAM zbc_job_schedule_vc_subrpool.

INCLUDE lsvcmcod.

DATA:
  gt_job_schedule TYPE STANDARD TABLE OF zbc_job_schedule,
  gs_job_schedule TYPE zbc_job_schedule,
  gt_job_step     TYPE STANDARD TABLE OF zbc_job_step,
  gs_job_step     TYPE zbc_job_step.

FORM check_vc_data.

  gt_job_schedule = vcl_total_s_1.
  gt_job_step     = vcl_total_m_2.

  LOOP AT gt_job_schedule INTO gs_job_schedule."Job Schedule

    IF    gs_job_schedule-daily_from  EQ ''
      OR  gs_job_schedule-daily_to    EQ ''.
      MESSAGE ID 'ZBC_MSG' TYPE 'I' NUMBER '028' WITH gs_job_schedule-jobname DISPLAY LIKE 'E'.
      vcl_stop = abap_true.
      EXIT.
    ENDIF.

    IF gs_job_schedule-daily_from GE gs_job_schedule-daily_to.
      MESSAGE ID 'ZBC_MSG' TYPE 'I' NUMBER '026' WITH gs_job_schedule-jobname DISPLAY LIKE 'E'.
      vcl_stop = abap_true.
      EXIT.
    ENDIF.
    IF gs_job_schedule-everymin LT 5.
      MESSAGE ID 'ZBC_MSG' TYPE 'I' NUMBER '027' WITH gs_job_schedule-jobname DISPLAY LIKE 'E'.
      vcl_stop = abap_true.
      EXIT.
    ENDIF.

    LOOP AT gt_job_step INTO gs_job_step WHERE jobname EQ  gs_job_schedule-jobname."Job Step
      IF gs_job_step-progname IS INITIAL.
        MESSAGE ID 'ZBC_MSG' TYPE 'I' NUMBER '029' WITH gs_job_step-jobname gs_job_step-stepcount DISPLAY LIKE 'E'.
        vcl_stop = abap_true.
        EXIT.
      ENDIF.
    ENDLOOP.

  ENDLOOP.

ENDFORM.
