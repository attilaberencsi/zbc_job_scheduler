*----------------------------------------------------------------------*
***INCLUDE LZBC_JOB_SCHEDULEF01.
*----------------------------------------------------------------------*
*-Description----------------------------------------------------------*
* Job Scheduler - Events for Maintenance View/Cluster
* Purpose is to implement additional features and input checks in
* the View Cluster.
*----------------------------------------------------------------------*
*-Creation-------------------------------------------------------------*
* Author:       Attila Berencsi
* SAP Version:  EHP7 for SAP ERP 6.0
* Date:         03.07.2014 10:09:30
*----------------------------------------------------------------------*

FORM oecd_auth_check.
  IF vim_called_by_cluster EQ abap_false.
    MESSAGE ID 'ZBC_MSG' TYPE 'E' NUMBER '030'.
  ENDIF.
ENDFORM.
