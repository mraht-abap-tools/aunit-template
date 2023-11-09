"! <p class="shorttext synchronized" lang="en">ABAP Unit Test Class</p>
CLASS lcl_aunit DEFINITION
  FINAL
  CREATE PUBLIC
  FOR TESTING RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    TYPES: BEGIN OF s_tdc_data,
             lgnum TYPE /scwm/lgnum,
           END OF s_tdc_data.

    CONSTANTS: mc_tdc_cnt           TYPE etobj_name VALUE '${ZCL_UNDER_TEST}',
               mc_tdc_dflt_var_name TYPE etvar_id   VALUE 'ECATTDEFAULT'.
    CLASS-DATA: mo_tdc          TYPE REF TO cl_apl_ecatt_tdc_api,
                mv_tdc_var_name TYPE etvar_id,
                ms_tdc_data     TYPE s_tdc_data.

    CLASS-METHODS:
      class_setup
        RAISING
          cx_ecatt_tdc_access,
      class_teardown.

    METHODS:
      setup,
      teardown.

    METHODS ${t0001} FOR TESTING RAISING cx_static_check.

ENDCLASS.



CLASS lcl_aunit IMPLEMENTATION.

  METHOD class_setup.

    mo_tdc = cl_apl_ecatt_tdc_api=>get_instance( i_testdatacontainer = mc_tdc_cnt ).
    
	mv_tdc_var_name = |{ sy-sysid }{ sy-mandt }|.
    DATA(lt_tdc_var) = mo_tdc->get_variant_list( ).
    IF NOT line_exists( lt_tdc_var[ table_line = mv_tdc_var_name ] ).
      mv_tdc_var_name = mc_tdc_dflt_var_name.
    ENDIF.

    LOOP AT mo_tdc->get_variant_content( mv_tdc_var_name ) ASSIGNING FIELD-SYMBOL(<ls_tdc_var_content>).
      ASSIGN COMPONENT <ls_tdc_var_content>-parname OF STRUCTURE ms_tdc_data TO FIELD-SYMBOL(<lv_tdc_value>).
      CHECK <lv_tdc_value> IS ASSIGNED.
      ASSIGN <ls_tdc_var_content>-value_ref->* TO FIELD-SYMBOL(<lv_tdc_var_value>).
      CHECK <lv_tdc_var_value> IS ASSIGNED.
      <lv_tdc_value> = <lv_tdc_var_value>.
      UNASSIGN: <lv_tdc_value>, <lv_tdc_var_value>.
    ENDLOOP.

    /scwm/cl_tm=>set_lgnum( ms_tdc_data-lgnum ).

  ENDMETHOD.


  METHOD class_teardown.
  ENDMETHOD.


  METHOD setup.
  ENDMETHOD.


  METHOD teardown.
  ENDMETHOD.


  METHOD ${t0001}.

    CHECK 1 = 2. ##DEACTIVATED.

    cl_abap_unit_assert=>assert_equals( act = 1
                                        exp = 1 ).

  ENDMETHOD.

ENDCLASS.
