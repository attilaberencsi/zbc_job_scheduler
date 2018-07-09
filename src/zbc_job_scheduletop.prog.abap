*-Description----------------------------------------------------------*
* DATA,TYPES,CONSTANTS...for executable report ZBC_JOB_SCHEDULE
*----------------------------------------------------------------------*
*-Creation-------------------------------------------------------------*
* Author:       Attila Berencsi
* SAP Version:  EHP7 for SAP ERP 6.0
* Date:         24.06.2014 14:53:26
*----------------------------------------------------------------------*

DATA:
  gt_job_schedule TYPE STANDARD TABLE OF zbc_job_schedule,
  gs_job_schedule TYPE zbc_job_schedule,
  gt_job_step     TYPE STANDARD TABLE OF zbc_job_step,
  gs_job_step     TYPE zbc_job_step,
  gv_jobcount     TYPE btcjobcnt,
  gs_last_run     TYPE zbc_job_last_run,
  gv_status       TYPE btcstatus,
  gv_next_run     TYPE syuzeit,
  gv_released     TYPE btcchar1.                            "#EC NEEDED
