*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 20.10.2016 at 10:19:36 by user BERENCSI_A
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZBCV_JOB_SCHEDUL................................*
TABLES: ZBCV_JOB_SCHEDUL, *ZBCV_JOB_SCHEDUL. "view work areas
CONTROLS: TCTRL_ZBCV_JOB_SCHEDUL
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZBCV_JOB_SCHEDUL. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZBCV_JOB_SCHEDUL.
* Table for entries selected to show on screen
DATA: BEGIN OF ZBCV_JOB_SCHEDUL_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZBCV_JOB_SCHEDUL.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZBCV_JOB_SCHEDUL_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZBCV_JOB_SCHEDUL_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZBCV_JOB_SCHEDUL.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZBCV_JOB_SCHEDUL_TOTAL.

*...processing: ZBCV_JOB_STEP...................................*
TABLES: ZBCV_JOB_STEP, *ZBCV_JOB_STEP. "view work areas
CONTROLS: TCTRL_ZBCV_JOB_STEP
TYPE TABLEVIEW USING SCREEN '0002'.
DATA: BEGIN OF STATUS_ZBCV_JOB_STEP. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZBCV_JOB_STEP.
* Table for entries selected to show on screen
DATA: BEGIN OF ZBCV_JOB_STEP_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZBCV_JOB_STEP.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZBCV_JOB_STEP_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZBCV_JOB_STEP_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZBCV_JOB_STEP.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZBCV_JOB_STEP_TOTAL.

*.........table declarations:.................................*
TABLES: ZBC_JOB_SCHEDULE               .
TABLES: ZBC_JOB_STEP                   .
