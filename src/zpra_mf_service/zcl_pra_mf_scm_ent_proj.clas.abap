"! <p class="shorttext synchronized">Consumption model for client proxy - generated</p>
"! This class has been generated based on the metadata with namespace
"! <em>API_ENTERPRISE_PROJECT_SRV</em>
CLASS zcl_pra_mf_scm_ent_proj DEFINITION
  PUBLIC
  INHERITING FROM /iwbep/cl_v4_abs_pm_model_prov
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      "! <p class="shorttext synchronized">Types for "OData Primitive Types"</p>
      BEGIN OF tys_types_for_prim_types,
        "! Used for primitive type CUSTOMER_UUID
        customer_uuid              TYPE sysuuid_x16,
        "! Used for primitive type ENTERPRISE_PROJECT_SERVICE
        enterprise_project_service TYPE c LENGTH 5,
        "! Used for primitive type ENT_PROJECT_IS_CONFIDENTIA
        ent_project_is_confidentia TYPE abap_bool,
        "! Used for primitive type ENT_PROJ_DEMAND_COPY_IS_RE
        ent_proj_demand_copy_is_re TYPE abap_bool,
        "! Used for primitive type ENT_PROJ_ELMNT_DISTRIBUTIO
        ent_proj_elmnt_distributio TYPE int1,
        "! Used for primitive type ENT_PROJ_SETTLMT_RULE_CPY
        ent_proj_settlmt_rule_cpy  TYPE abap_bool,
        "! Used for primitive type LEFT_SIBLING_UUID
        left_sibling_uuid          TYPE sysuuid_x16,
        "! Used for primitive type PARENT_OBJECT_UUID
        parent_object_uuid         TYPE sysuuid_x16,
        "! Used for primitive type PLANNED_END_DATE
        planned_end_date           TYPE datn,
        "! Used for primitive type PLANNED_START_DATE
        planned_start_date         TYPE datn,
        "! Used for primitive type PROCESSING_STATUS
        processing_status          TYPE c LENGTH 2,
        "! Used for primitive type PROCESSING_STATUS_2
        processing_status_2        TYPE c LENGTH 2,
        "! Used for primitive type PROJECT
        project                    TYPE c LENGTH 24,
        "! Used for primitive type PROJECT_CURRENCY
        project_currency           TYPE c LENGTH 5,
        "! Used for primitive type PROJECT_ELEMENT_UUID
        project_element_uuid       TYPE sysuuid_x16,
        "! Used for primitive type PROJECT_ELEMENT_UUID_2
        project_element_uuid_2     TYPE sysuuid_x16,
        "! Used for primitive type PROJECT_ELEMENT_UUID_3
        project_element_uuid_3     TYPE sysuuid_x16,
        "! Used for primitive type PROJECT_END_DATE
        project_end_date           TYPE datn,
        "! Used for primitive type PROJECT_MANAGER_UUID
        project_manager_uuid       TYPE sysuuid_x16,
        "! Used for primitive type PROJECT_NAME
        project_name               TYPE c LENGTH 60,
        "! Used for primitive type PROJECT_START_DATE
        project_start_date         TYPE datn,
        "! Used for primitive type PROJECT_UUID
        project_uuid               TYPE sysuuid_x16,
        "! Used for primitive type PROJECT_UUID_2
        project_uuid_2             TYPE sysuuid_x16,
        "! Used for primitive type RESPONSIBLE_COST_CENTER
        responsible_cost_center    TYPE c LENGTH 10,
        "! Used for primitive type RESTRICTED_TIME_POSTING
        restricted_time_posting    TYPE c LENGTH 1,
      END OF tys_types_for_prim_types.

    TYPES:
      "! <p class="shorttext synchronized">Parameters of function ChangeEntProjElmntPosition</p>
      "! <em>with the internal name</em> CHANGE_ENT_PROJ_ELMNT_POSI
      BEGIN OF tys_parameters_1,
        "! ProjectElementUUID
        project_element_uuid TYPE sysuuid_x16,
        "! ParentObjectUUID
        parent_object_uuid   TYPE sysuuid_x16,
        "! LeftSiblingUUID
        left_sibling_uuid    TYPE sysuuid_x16,
      END OF tys_parameters_1,
      "! <p class="shorttext synchronized">List of TYS_PARAMETERS_1</p>
      tyt_parameters_1 TYPE STANDARD TABLE OF tys_parameters_1 WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">Parameters of function ChangeEntProjElmntProcgStatus</p>
      "! <em>with the internal name</em> CHANGE_ENT_PROJ_ELMNT_PROC
      BEGIN OF tys_parameters_2,
        "! ProjectElementUUID
        project_element_uuid TYPE sysuuid_x16,
        "! ProcessingStatus
        processing_status    TYPE c LENGTH 2,
      END OF tys_parameters_2,
      "! <p class="shorttext synchronized">List of TYS_PARAMETERS_2</p>
      tyt_parameters_2 TYPE STANDARD TABLE OF tys_parameters_2 WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">Parameters of function ChangeEntProjProcgStatus</p>
      "! <em>with the internal name</em> CHANGE_ENT_PROJ_PROCG_STAT
      BEGIN OF tys_parameters_3,
        "! ProjectUUID
        project_uuid      TYPE sysuuid_x16,
        "! ProcessingStatus
        processing_status TYPE c LENGTH 2,
      END OF tys_parameters_3,
      "! <p class="shorttext synchronized">List of TYS_PARAMETERS_3</p>
      tyt_parameters_3 TYPE STANDARD TABLE OF tys_parameters_3 WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">Parameters of function ChangePeriodDistributionOption</p>
      "! <em>with the internal name</em> CHANGE_PERIOD_DISTRIBUTION
      BEGIN OF tys_parameters_4,
        "! ProjectElementUUID
        project_element_uuid       TYPE sysuuid_x16,
        "! PlannedStartDate
        planned_start_date         TYPE datn,
        "! PlannedEndDate
        planned_end_date           TYPE datn,
        "! EntProjElmntDistributionOption
        ent_proj_elmnt_distributio TYPE int1,
      END OF tys_parameters_4,
      "! <p class="shorttext synchronized">List of TYS_PARAMETERS_4</p>
      tyt_parameters_4 TYPE STANDARD TABLE OF tys_parameters_4 WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">Parameters of function CopyToActiveDocument</p>
      "! <em>with the internal name</em> COPY_TO_ACTIVE_DOCUMENT
      BEGIN OF tys_parameters_5,
        "! ProjectUUID
        project_uuid               TYPE sysuuid_x16,
        "! EntProjDemandCopyIsRequested
        ent_proj_demand_copy_is_re TYPE abap_bool,
        "! EntProjSettlmtRuleCpyIsReqd
        ent_proj_settlmt_rule_cpy  TYPE abap_bool,
        "! Project
        project                    TYPE c LENGTH 24,
        "! ProjectName
        project_name               TYPE c LENGTH 60,
        "! ProjectStartDate
        project_start_date         TYPE datn,
        "! ProjectEndDate
        project_end_date           TYPE datn,
        "! CustomerUUID
        customer_uuid              TYPE sysuuid_x16,
        "! EnterpriseProjectServiceOrg
        enterprise_project_service TYPE c LENGTH 5,
        "! ResponsibleCostCenter
        responsible_cost_center    TYPE c LENGTH 10,
        "! ProjectManagerUUID
        project_manager_uuid       TYPE sysuuid_x16,
        "! ProjectCurrency
        project_currency           TYPE c LENGTH 5,
        "! EntProjectIsConfidential
        ent_project_is_confidentia TYPE abap_bool,
        "! RestrictedTimePosting
        restricted_time_posting    TYPE c LENGTH 1,
      END OF tys_parameters_5,
      "! <p class="shorttext synchronized">List of TYS_PARAMETERS_5</p>
      tyt_parameters_5 TYPE STANDARD TABLE OF tys_parameters_5 WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">A_EnterpriseProjectElementType</p>
      BEGIN OF tys_a_enterprise_project_ele_2,
        "! ChangeEntProjElmntPosition_ac
        change_ent_proj_elmnt_posi TYPE abap_bool,
        "! ChangeEntProjElmntProcgStatus_ac
        change_ent_proj_elmnt_proc TYPE abap_bool,
        "! ChangePeriodDistributionOption_ac
        change_period_distribution TYPE abap_bool,
        "! ActualEndDate_fc
        actual_end_date_fc         TYPE int1,
        "! ActualStartDate_fc
        actual_start_date_fc       TYPE int1,
        "! ControllingArea_fc
        controlling_area_fc        TYPE int1,
        "! CostCenter_fc
        cost_center_fc             TYPE int1,
        "! CostingSheet_fc
        costing_sheet_fc           TYPE int1,
        "! FactoryCalendar_fc
        factory_calendar_fc        TYPE int1,
        "! ForecastedEndDate_fc
        forecasted_end_date_fc     TYPE int1,
        "! FunctionalArea_fc
        functional_area_fc         TYPE int1,
        "! FunctionalLocation_fc
        functional_location_fc     TYPE int1,
        "! InvestmentProfile_fc
        investment_profile_fc      TYPE int1,
        "! IsMainMilestone_fc
        is_main_milestone_fc       TYPE int1,
        "! Location_fc
        location_fc                TYPE int1,
        "! MilestoneApprovalStatus_fc
        milestone_approval_status  TYPE int1,
        "! PlannedEndDate_fc
        planned_end_date_fc        TYPE int1,
        "! PlannedStartDate_fc
        planned_start_date_fc      TYPE int1,
        "! Plant_fc
        plant_fc                   TYPE int1,
        "! ProfitCenter_fc
        profit_center_fc           TYPE int1,
        "! ProjectElement_fc
        project_element_fc         TYPE int1,
        "! ProjectElementDescription_fc
        project_element_descriptio TYPE int1,
        "! ResponsibleCostCenter_fc
        responsible_cost_center_fc TYPE int1,
        "! ResultAnalysisInternalID_fc
        result_analysis_internal_i TYPE int1,
        "! TaxJurisdiction_fc
        tax_jurisdiction_fc        TYPE int1,
        "! WBSElementIsBillingElement_fc
        wbselement_is_billing_elem TYPE int1,
        "! Delete_mc
        delete_mc                  TYPE abap_bool,
        "! Update_mc
        update_mc                  TYPE abap_bool,
        "! to_EntProjElmntBlkFunc_oc
        to_ent_proj_elmnt_blk_func TYPE abap_bool,
        "! to_EntProjElmntDlvbrl_oc
        to_ent_proj_elmnt_dlvbrl_o TYPE abap_bool,
        "! to_EntProjElmntWorkItem_oc
        to_ent_proj_elmnt_work_ite TYPE abap_bool,
        "! to_SubProjElement_oc
        to_sub_proj_element_oc     TYPE abap_bool,
        "! <em>Key property</em> ProjectElementUUID
        project_element_uuid       TYPE sysuuid_x16,
        "! ProjectElement
        project_element            TYPE c LENGTH 24,
        "! WBSElementInternalID
        wbselement_internal_id     TYPE c LENGTH 8,
        "! ProjectUUID
        project_uuid               TYPE sysuuid_x16,
        "! ProjectElementDescription
        project_element_descript_2 TYPE c LENGTH 60,
        "! ParentObjectUUID
        parent_object_uuid         TYPE sysuuid_x16,
        "! ProjectElementOrdinalNumber
        project_element_ordinal_nu TYPE int4,
        "! ProcessingStatus
        processing_status          TYPE c LENGTH 2,
        "! EntProjectElementType
        ent_project_element_type   TYPE c LENGTH 15,
        "! PlannedStartDate
        planned_start_date         TYPE datn,
        "! PlannedEndDate
        planned_end_date           TYPE datn,
        "! ActualStartDate
        actual_start_date          TYPE datn,
        "! ActualEndDate
        actual_end_date            TYPE datn,
        "! ResponsibleCostCenter
        responsible_cost_center    TYPE c LENGTH 10,
        "! CompanyCode
        company_code               TYPE c LENGTH 4,
        "! ProfitCenter
        profit_center              TYPE c LENGTH 10,
        "! FunctionalArea
        functional_area            TYPE c LENGTH 16,
        "! ControllingArea
        controlling_area           TYPE c LENGTH 4,
        "! Plant
        plant                      TYPE c LENGTH 4,
        "! Location
        location                   TYPE c LENGTH 10,
        "! TaxJurisdiction
        tax_jurisdiction           TYPE c LENGTH 15,
        "! FunctionalLocation
        functional_location        TYPE c LENGTH 40,
        "! FactoryCalendar
        factory_calendar           TYPE c LENGTH 2,
        "! CostingSheet
        costing_sheet              TYPE c LENGTH 6,
        "! InvestmentProfile
        investment_profile         TYPE c LENGTH 6,
        "! WBSIsStatisticalWBSElement
        wbsis_statistical_wbseleme TYPE abap_bool,
        "! CostCenter
        cost_center                TYPE c LENGTH 10,
        "! WBSElementIsBillingElement
        wbselement_is_billing_el_2 TYPE abap_bool,
        "! ResultAnalysisInternalID
        result_analysis_internal_2 TYPE c LENGTH 6,
        "! IsProjectMilestone
        is_project_milestone       TYPE c LENGTH 1,
        "! ForecastedEndDate
        forecasted_end_date        TYPE datn,
        "! MilestoneApprovalStatus
        milestone_approval_statu_2 TYPE c LENGTH 5,
        "! IsMainMilestone
        is_main_milestone          TYPE abap_bool,
        "! CreatedByUser
        created_by_user            TYPE c LENGTH 12,
        "! CreationDateTime
        creation_date_time         TYPE timestamp,
        "! LastChangeDateTime
        last_change_date_time      TYPE timestamp,
        "! LastChangedByUser
        last_changed_by_user       TYPE c LENGTH 12,
      END OF tys_a_enterprise_project_ele_2,
      "! <p class="shorttext synchronized">List of A_EnterpriseProjectElementType</p>
      tyt_a_enterprise_project_ele_2 TYPE STANDARD TABLE OF tys_a_enterprise_project_ele_2 WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">A_EnterpriseProjectJVAType</p>
      BEGIN OF tys_a_enterprise_project_jvaty,
        "! JntIntrstBillgClass_fc
        jnt_intrst_billg_class_fc  TYPE int1,
        "! JntIntrstBillgSubClass_fc
        jnt_intrst_billg_sub_class TYPE int1,
        "! JntVntrProjectType_fc
        jnt_vntr_project_type_fc   TYPE int1,
        "! JointVenture_fc
        joint_venture_fc           TYPE int1,
        "! JointVentureCostRecoveryCode_fc
        joint_venture_cost_recover TYPE int1,
        "! JointVentureEquityType_fc
        joint_venture_equity_type  TYPE int1,
        "! Update_mc
        update_mc                  TYPE abap_bool,
        "! <em>Key property</em> ProjectUUID
        project_uuid               TYPE sysuuid_x16,
        "! JointVenture
        joint_venture              TYPE c LENGTH 6,
        "! JointVentureCostRecoveryCode
        joint_venture_cost_recov_2 TYPE c LENGTH 2,
        "! JointVentureEquityType
        joint_venture_equity_typ_2 TYPE c LENGTH 3,
        "! JntVntrProjectType
        jnt_vntr_project_type      TYPE c LENGTH 4,
        "! JntIntrstBillgClass
        jnt_intrst_billg_class     TYPE c LENGTH 3,
        "! JntIntrstBillgSubClass
        jnt_intrst_billg_sub_cla_2 TYPE c LENGTH 5,
      END OF tys_a_enterprise_project_jvaty,
      "! <p class="shorttext synchronized">List of A_EnterpriseProjectJVAType</p>
      tyt_a_enterprise_project_jvaty TYPE STANDARD TABLE OF tys_a_enterprise_project_jvaty WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">A_EnterpriseProjectRoleType</p>
      BEGIN OF tys_a_enterprise_project_rol_2,
        "! <em>Key property</em> ProjectRoleUUID
        project_role_uuid     TYPE sysuuid_x16,
        "! ProjectUUID
        project_uuid          TYPE sysuuid_x16,
        "! ProjectRoleType
        project_role_type     TYPE c LENGTH 15,
        "! ProjectRoleCategory
        project_role_category TYPE c LENGTH 3,
        "! ProjectRoleName
        project_role_name     TYPE c LENGTH 40,
        "! CreatedByUser
        created_by_user       TYPE c LENGTH 12,
        "! CreationDateTime
        creation_date_time    TYPE timestamp,
        "! LastChangedByUser
        last_changed_by_user  TYPE c LENGTH 12,
        "! LastChangeDateTime
        last_change_date_time TYPE timestamp,
      END OF tys_a_enterprise_project_rol_2,
      "! <p class="shorttext synchronized">List of A_EnterpriseProjectRoleType</p>
      tyt_a_enterprise_project_rol_2 TYPE STANDARD TABLE OF tys_a_enterprise_project_rol_2 WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">A_EnterpriseProjectTeamMemberType</p>
      BEGIN OF tys_a_enterprise_project_tea_2,
        "! to_EntProjEntitlement_oc
        to_ent_proj_entitlement_oc TYPE abap_bool,
        "! <em>Key property</em> TeamMemberUUID
        team_member_uuid           TYPE sysuuid_x16,
        "! BusinessPartnerUUID
        business_partner_uuid      TYPE sysuuid_x16,
        "! ProjectUUID
        project_uuid               TYPE sysuuid_x16,
        "! CreatedByUser
        created_by_user            TYPE c LENGTH 12,
        "! CreationDateTime
        creation_date_time         TYPE timestamp,
        "! LastChangedByUser
        last_changed_by_user       TYPE c LENGTH 12,
        "! LastChangeDateTime
        last_change_date_time      TYPE timestamp,
      END OF tys_a_enterprise_project_tea_2,
      "! <p class="shorttext synchronized">List of A_EnterpriseProjectTeamMemberType</p>
      tyt_a_enterprise_project_tea_2 TYPE STANDARD TABLE OF tys_a_enterprise_project_tea_2 WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">A_EnterpriseProjectType</p>
      BEGIN OF tys_a_enterprise_project_type,
        "! ChangeEntProjProcgStatus_ac
        change_ent_proj_procg_stat TYPE abap_bool,
        "! CopyToActiveDocument_ac
        copy_to_active_document_ac TYPE abap_bool,
        "! ActualEndDate_fc
        actual_end_date_fc         TYPE int1,
        "! ActualStartDate_fc
        actual_start_date_fc       TYPE int1,
        "! AvailabilityControlIsActive_fc
        availability_control_is_ac TYPE int1,
        "! AvailabilityControlProfile_fc
        availability_control_profi TYPE int1,
        "! ControllingArea_fc
        controlling_area_fc        TYPE int1,
        "! CostingSheet_fc
        costing_sheet_fc           TYPE int1,
        "! EnterpriseProjectType_fc
        enterprise_project_type_fc TYPE int1,
        "! EntProjIsMultiSlsOrdItmsEnbld_fc
        ent_proj_is_multi_sls_ord  TYPE int1,
        "! FunctionalArea_fc
        functional_area_fc         TYPE int1,
        "! FunctionalLocation_fc
        functional_location_fc     TYPE int1,
        "! InvestmentProfile_fc
        investment_profile_fc      TYPE int1,
        "! IsBillingRelevant_fc
        is_billing_relevant_fc     TYPE int1,
        "! Location_fc
        location_fc                TYPE int1,
        "! Plant_fc
        plant_fc                   TYPE int1,
        "! PriorityCode_fc
        priority_code_fc           TYPE int1,
        "! ProfitCenter_fc
        profit_center_fc           TYPE int1,
        "! Project_fc
        project_fc                 TYPE int1,
        "! ProjectCurrency_fc
        project_currency_fc        TYPE int1,
        "! ProjectDescription_fc
        project_description_fc     TYPE int1,
        "! ProjectEndDate_fc
        project_end_date_fc        TYPE int1,
        "! ProjectProfileCode_fc
        project_profile_code_fc    TYPE int1,
        "! ProjectStartDate_fc
        project_start_date_fc      TYPE int1,
        "! ResponsibleCostCenter_fc
        responsible_cost_center_fc TYPE int1,
        "! ResultAnalysisInternalID_fc
        result_analysis_internal_i TYPE int1,
        "! Delete_mc
        delete_mc                  TYPE abap_bool,
        "! Update_mc
        update_mc                  TYPE abap_bool,
        "! to_EnterpriseProjectElement_oc
        to_enterprise_project_elem TYPE abap_bool,
        "! to_EntProjBlkFunc_oc
        to_ent_proj_blk_func_oc    TYPE abap_bool,
        "! to_EntProjRole_oc
        to_ent_proj_role_oc        TYPE abap_bool,
        "! to_EntProjTeamMember_oc
        to_ent_proj_team_member_oc TYPE abap_bool,
        "! <em>Key property</em> ProjectUUID
        project_uuid               TYPE sysuuid_x16,
        "! ProjectInternalID
        project_internal_id        TYPE c LENGTH 8,
        "! Project
        project                    TYPE c LENGTH 24,
        "! ProjectDescription
        project_description        TYPE c LENGTH 60,
        "! EnterpriseProjectType
        enterprise_project_type    TYPE c LENGTH 2,
        "! PriorityCode
        priority_code              TYPE c LENGTH 3,
        "! ProjectStartDate
        project_start_date         TYPE datn,
        "! ProjectEndDate
        project_end_date           TYPE datn,
        "! ActualStartDate
        actual_start_date          TYPE datn,
        "! ActualEndDate
        actual_end_date            TYPE datn,
        "! CustomerUUID
        customer_uuid              TYPE sysuuid_x16,
        "! EnterpriseProjectServiceOrg
        enterprise_project_service TYPE c LENGTH 5,
        "! EntProjectIsConfidential
        ent_project_is_confidentia TYPE abap_bool,
        "! RestrictedTimePosting
        restricted_time_posting    TYPE c LENGTH 1,
        "! ProcessingStatus
        processing_status          TYPE c LENGTH 2,
        "! ResponsibleCostCenter
        responsible_cost_center    TYPE c LENGTH 10,
        "! ProfitCenter
        profit_center              TYPE c LENGTH 10,
        "! ProjectProfileCode
        project_profile_code       TYPE c LENGTH 7,
        "! FunctionalArea
        functional_area            TYPE c LENGTH 16,
        "! CompanyCode
        company_code               TYPE c LENGTH 4,
        "! ControllingArea
        controlling_area           TYPE c LENGTH 4,
        "! Plant
        plant                      TYPE c LENGTH 4,
        "! Location
        location                   TYPE c LENGTH 10,
        "! TaxJurisdiction
        tax_jurisdiction           TYPE c LENGTH 15,
        "! ProjectCurrency
        project_currency           TYPE c LENGTH 5,
        "! AvailabilityControlProfile
        availability_control_pro_2 TYPE c LENGTH 6,
        "! AvailabilityControlIsActive
        availability_control_is__2 TYPE abap_bool,
        "! FunctionalLocation
        functional_location        TYPE c LENGTH 40,
        "! IsBillingRelevant
        is_billing_relevant        TYPE abap_bool,
        "! InvestmentProfile
        investment_profile         TYPE c LENGTH 6,
        "! LastChangeDateTime
        last_change_date_time      TYPE timestamp,
        "! ProjectLastChangedDateTime
        project_last_changed_date  TYPE timestamp,
        "! LastChangedByUser
        last_changed_by_user       TYPE c LENGTH 12,
        "! EntProjIsMultiSlsOrdItmsEnbld
        ent_proj_is_multi_sls_or_2 TYPE abap_bool,
        "! ResultAnalysisInternalID
        result_analysis_internal_2 TYPE c LENGTH 6,
        "! CostingSheet
        costing_sheet              TYPE c LENGTH 6,
        "! CreatedByUser
        created_by_user            TYPE c LENGTH 12,
        "! CreationDateTime
        creation_date_time         TYPE timestamp,
      END OF tys_a_enterprise_project_type,
      "! <p class="shorttext synchronized">List of A_EnterpriseProjectType</p>
      tyt_a_enterprise_project_type TYPE STANDARD TABLE OF tys_a_enterprise_project_type WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">A_EnterpriseProjBlkFuncType</p>
      BEGIN OF tys_a_enterprise_proj_blk_fu_2,
        "! Update_mc
        update_mc                  TYPE abap_bool,
        "! <em>Key property</em> ProjectUUID
        project_uuid               TYPE sysuuid_x16,
        "! EntProjTimeRecgIsBlkd
        ent_proj_time_recg_is_blkd TYPE abap_bool,
        "! EntProjStaffExpensePostgIsBlkd
        ent_proj_staff_expense_pos TYPE abap_bool,
        "! EntProjServicePostingIsBlkd
        ent_proj_service_posting_i TYPE abap_bool,
        "! EntProjOtherExpensePostgIsBlkd
        ent_proj_other_expense_pos TYPE abap_bool,
        "! EntProjPurchasingIsBlkd
        ent_proj_purchasing_is_blk TYPE abap_bool,
      END OF tys_a_enterprise_proj_blk_fu_2,
      "! <p class="shorttext synchronized">List of A_EnterpriseProjBlkFuncType</p>
      tyt_a_enterprise_proj_blk_fu_2 TYPE STANDARD TABLE OF tys_a_enterprise_proj_blk_fu_2 WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">A_EntProjectElementJVAType</p>
      BEGIN OF tys_a_ent_project_element_jvat,
        "! JntIntrstBillgClass_fc
        jnt_intrst_billg_class_fc  TYPE int1,
        "! JntIntrstBillgSubClass_fc
        jnt_intrst_billg_sub_class TYPE int1,
        "! JntVntrProjectType_fc
        jnt_vntr_project_type_fc   TYPE int1,
        "! JointVenture_fc
        joint_venture_fc           TYPE int1,
        "! JointVentureCostRecoveryCode_fc
        joint_venture_cost_recover TYPE int1,
        "! JointVentureEquityType_fc
        joint_venture_equity_type  TYPE int1,
        "! Update_mc
        update_mc                  TYPE abap_bool,
        "! <em>Key property</em> ProjectElementUUID
        project_element_uuid       TYPE sysuuid_x16,
        "! ProjectUUID
        project_uuid               TYPE sysuuid_x16,
        "! JointVenture
        joint_venture              TYPE c LENGTH 6,
        "! JointVentureCostRecoveryCode
        joint_venture_cost_recov_2 TYPE c LENGTH 2,
        "! JointVentureEquityType
        joint_venture_equity_typ_2 TYPE c LENGTH 3,
        "! JntVntrProjectType
        jnt_vntr_project_type      TYPE c LENGTH 4,
        "! JntIntrstBillgClass
        jnt_intrst_billg_class     TYPE c LENGTH 3,
        "! JntIntrstBillgSubClass
        jnt_intrst_billg_sub_cla_2 TYPE c LENGTH 5,
      END OF tys_a_ent_project_element_jvat,
      "! <p class="shorttext synchronized">List of A_EntProjectElementJVAType</p>
      tyt_a_ent_project_element_jvat TYPE STANDARD TABLE OF tys_a_ent_project_element_jvat WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">A_EntProjectElmntPublicSectorType</p>
      BEGIN OF tys_a_ent_project_elmnt_publ_2,
        "! FunctionalAreaIsFixAssigned_fc
        functional_area_is_fix_ass TYPE int1,
        "! Fund_fc
        fund_fc                    TYPE int1,
        "! FundIsFixAssigned_fc
        fund_is_fix_assigned_fc    TYPE int1,
        "! GrantID_fc
        grant_id_fc                TYPE int1,
        "! GrantIsFixAssigned_fc
        grant_is_fix_assigned_fc   TYPE int1,
        "! SponsoredProgram_fc
        sponsored_program_fc       TYPE int1,
        "! Update_mc
        update_mc                  TYPE abap_bool,
        "! <em>Key property</em> ProjectElementUUID
        project_element_uuid       TYPE sysuuid_x16,
        "! ProjectUUID
        project_uuid               TYPE sysuuid_x16,
        "! Fund
        fund                       TYPE c LENGTH 10,
        "! FundIsFixAssigned
        fund_is_fix_assigned       TYPE abap_bool,
        "! FunctionalAreaIsFixAssigned
        functional_area_is_fix_a_2 TYPE abap_bool,
        "! GrantID
        grant_id                   TYPE c LENGTH 20,
        "! GrantIsFixAssigned
        grant_is_fix_assigned      TYPE abap_bool,
        "! SponsoredProgram
        sponsored_program          TYPE c LENGTH 20,
      END OF tys_a_ent_project_elmnt_publ_2,
      "! <p class="shorttext synchronized">List of A_EntProjectElmntPublicSectorType</p>
      tyt_a_ent_project_elmnt_publ_2 TYPE STANDARD TABLE OF tys_a_ent_project_elmnt_publ_2 WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">A_EntProjectPublicSectorType</p>
      BEGIN OF tys_a_ent_project_public_sec_2,
        "! FunctionalAreaIsFixAssigned_fc
        functional_area_is_fix_ass TYPE int1,
        "! Fund_fc
        fund_fc                    TYPE int1,
        "! FundIsFixAssigned_fc
        fund_is_fix_assigned_fc    TYPE int1,
        "! GrantID_fc
        grant_id_fc                TYPE int1,
        "! GrantIsFixAssigned_fc
        grant_is_fix_assigned_fc   TYPE int1,
        "! SponsoredProgram_fc
        sponsored_program_fc       TYPE int1,
        "! Update_mc
        update_mc                  TYPE abap_bool,
        "! <em>Key property</em> ProjectUUID
        project_uuid               TYPE sysuuid_x16,
        "! Fund
        fund                       TYPE c LENGTH 10,
        "! FundIsFixAssigned
        fund_is_fix_assigned       TYPE abap_bool,
        "! FunctionalAreaIsFixAssigned
        functional_area_is_fix_a_2 TYPE abap_bool,
        "! GrantID
        grant_id                   TYPE c LENGTH 20,
        "! GrantIsFixAssigned
        grant_is_fix_assigned      TYPE abap_bool,
        "! SponsoredProgram
        sponsored_program          TYPE c LENGTH 20,
      END OF tys_a_ent_project_public_sec_2,
      "! <p class="shorttext synchronized">List of A_EntProjectPublicSectorType</p>
      tyt_a_ent_project_public_sec_2 TYPE STANDARD TABLE OF tys_a_ent_project_public_sec_2 WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">A_EntProjElmntBlockFuncType</p>
      BEGIN OF tys_a_ent_proj_elmnt_block_f_2,
        "! EntProjOtherExpensePostgIsBlkd_fc
        ent_proj_other_expense_pos TYPE int1,
        "! EntProjPurchasingIsBlkd_fc
        ent_proj_purchasing_is_blk TYPE int1,
        "! EntProjServicePostingIsBlkd_fc
        ent_proj_service_posting_i TYPE int1,
        "! EntProjStaffExpensePostgIsBlkd_fc
        ent_proj_staff_expense_pos TYPE int1,
        "! EntProjTimeRecgIsBlkd_fc
        ent_proj_time_recg_is_blkd TYPE int1,
        "! Update_mc
        update_mc                  TYPE abap_bool,
        "! <em>Key property</em> ProjectElementUUID
        project_element_uuid       TYPE sysuuid_x16,
        "! ProjectUUID
        project_uuid               TYPE sysuuid_x16,
        "! EntProjTimeRecgIsBlkd
        ent_proj_time_recg_is_bl_2 TYPE abap_bool,
        "! EntProjStaffExpensePostgIsBlkd
        ent_proj_staff_expense_p_2 TYPE abap_bool,
        "! EntProjServicePostingIsBlkd
        ent_proj_service_posting_2 TYPE abap_bool,
        "! EntProjOtherExpensePostgIsBlkd
        ent_proj_other_expense_p_2 TYPE abap_bool,
        "! EntProjPurchasingIsBlkd
        ent_proj_purchasing_is_b_2 TYPE abap_bool,
      END OF tys_a_ent_proj_elmnt_block_f_2,
      "! <p class="shorttext synchronized">List of A_EntProjElmntBlockFuncType</p>
      tyt_a_ent_proj_elmnt_block_f_2 TYPE STANDARD TABLE OF tys_a_ent_proj_elmnt_block_f_2 WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">A_EntProjElmntCnfgrdWrkItmTxtType</p>
      BEGIN OF tys_a_ent_proj_elmnt_cnfgrd__2,
        "! <em>Key property</em> EntProjElmntWorkItem
        ent_proj_elmnt_work_item  TYPE c LENGTH 10,
        "! <em>Key property</em> Language
        language                  TYPE c LENGTH 2,
        "! EntProjElmntCnfgrdWrkItmName
        ent_proj_elmnt_cnfgrd_wrk TYPE c LENGTH 40,
      END OF tys_a_ent_proj_elmnt_cnfgrd__2,
      "! <p class="shorttext synchronized">List of A_EntProjElmntCnfgrdWrkItmTxtType</p>
      tyt_a_ent_proj_elmnt_cnfgrd__2 TYPE STANDARD TABLE OF tys_a_ent_proj_elmnt_cnfgrd__2 WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">A_EntProjElmntDlvbrlType</p>
      BEGIN OF tys_a_ent_proj_elmnt_dlvbrl_ty,
        "! Update_mc
        update_mc                  TYPE abap_bool,
        "! to_EntProjElmntDlvDistr_oc
        to_ent_proj_elmnt_dlv_dist TYPE abap_bool,
        "! <em>Key property</em> EntProjElmntDeliverableUUID
        ent_proj_elmnt_deliverable TYPE sysuuid_x16,
        "! ProjectElementUUID
        project_element_uuid       TYPE sysuuid_x16,
        "! ProjectUUID
        project_uuid               TYPE sysuuid_x16,
        "! EntProjElmntDeliverableType
        ent_proj_elmnt_deliverab_2 TYPE c LENGTH 6,
        "! EntProjElmntDlvbrlQuantity
        ent_proj_elmnt_dlvbrl_quan TYPE p LENGTH 12 DECIMALS 2,
        "! EntProjElmntDlvbrlQuantityUnit
        ent_proj_elmnt_dlvbrl_qu_2 TYPE c LENGTH 3,
        "! CreatedByUser
        created_by_user            TYPE c LENGTH 12,
        "! CreationDateTime
        creation_date_time         TYPE timestamp,
        "! LastChangeDateTime
        last_change_date_time      TYPE timestamp,
        "! LastChangedByUser
        last_changed_by_user       TYPE c LENGTH 12,
      END OF tys_a_ent_proj_elmnt_dlvbrl_ty,
      "! <p class="shorttext synchronized">List of A_EntProjElmntDlvbrlType</p>
      tyt_a_ent_proj_elmnt_dlvbrl_ty TYPE STANDARD TABLE OF tys_a_ent_proj_elmnt_dlvbrl_ty WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">A_EntProjElmntDlvbrlDistrType</p>
      BEGIN OF tys_a_ent_proj_elmnt_dlvbrl__2,
        "! Update_mc
        update_mc                  TYPE abap_bool,
        "! <em>Key property</em> EntProjElmntDlvbrlDistrUUID
        ent_proj_elmnt_dlvbrl_dist TYPE sysuuid_x16,
        "! EntProjElmntDeliverableUUID
        ent_proj_elmnt_deliverable TYPE sysuuid_x16,
        "! ProjectElementUUID
        project_element_uuid       TYPE sysuuid_x16,
        "! ProjectUUID
        project_uuid               TYPE sysuuid_x16,
        "! EntProjElmntDlvbrlDistrYearVal
        ent_proj_elmnt_dlvbrl_di_2 TYPE c LENGTH 4,
        "! EntProjElmntDlvbrlDistrPerdVal
        ent_proj_elmnt_dlvbrl_di_3 TYPE c LENGTH 3,
        "! EntProjElmntDlvbrlDistrQty
        ent_proj_elmnt_dlvbrl_di_4 TYPE p LENGTH 12 DECIMALS 2,
        "! EntProjElmntDlvbrlDistrQtyUnit
        ent_proj_elmnt_dlvbrl_di_5 TYPE c LENGTH 3,
      END OF tys_a_ent_proj_elmnt_dlvbrl__2,
      "! <p class="shorttext synchronized">List of A_EntProjElmntDlvbrlDistrType</p>
      tyt_a_ent_proj_elmnt_dlvbrl__2 TYPE STANDARD TABLE OF tys_a_ent_proj_elmnt_dlvbrl__2 WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">A_EntProjElmntWorkItemType</p>
      BEGIN OF tys_a_ent_proj_elmnt_work_it_2,
        "! Delete_mc
        delete_mc                  TYPE abap_bool,
        "! Update_mc
        update_mc                  TYPE abap_bool,
        "! <em>Key property</em> EntProjElmntWorkItemUUID
        ent_proj_elmnt_work_item_u TYPE sysuuid_x16,
        "! EntProjElmntWorkItem
        ent_proj_elmnt_work_item   TYPE c LENGTH 10,
        "! EntProjElmntWorkItemName
        ent_proj_elmnt_work_item_n TYPE c LENGTH 40,
        "! EntProjElmntWorkItemIsInactive
        ent_proj_elmnt_work_item_i TYPE abap_bool,
        "! EntProjElmntWorkItemIsCnfgrd
        ent_proj_elmnt_work_item_2 TYPE abap_bool,
        "! ProjectUUID
        project_uuid               TYPE sysuuid_x16,
        "! ProjectElementUUID
        project_element_uuid       TYPE sysuuid_x16,
        "! EntProjElmntWrkItmLastUpdtSrce
        ent_proj_elmnt_wrk_itm_las TYPE c LENGTH 1,
        "! EntProjElmntWrkItmCrtedByUsr
        ent_proj_elmnt_wrk_itm_crt TYPE c LENGTH 12,
        "! EntProjElmntWrkItmCrtnDteTme
        ent_proj_elmnt_wrk_itm_c_2 TYPE timestamp,
        "! EntProjElmntWrkItmLstChgByUsr
        ent_proj_elmnt_wrk_itm_lst TYPE c LENGTH 12,
        "! EntProjElmntWrkItmLstChgDteTme
        ent_proj_elmnt_wrk_itm_l_2 TYPE timestamp,
      END OF tys_a_ent_proj_elmnt_work_it_2,
      "! <p class="shorttext synchronized">List of A_EntProjElmntWorkItemType</p>
      tyt_a_ent_proj_elmnt_work_it_2 TYPE STANDARD TABLE OF tys_a_ent_proj_elmnt_work_it_2 WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">A_EntTeamMemberEntitlementType</p>
      BEGIN OF tys_a_ent_team_member_entitl_2,
        "! Delete_mc
        delete_mc                TYPE abap_bool,
        "! Update_mc
        update_mc                TYPE abap_bool,
        "! <em>Key property</em> ProjectEntitlementUUID
        project_entitlement_uuid TYPE sysuuid_x16,
        "! ProjectUUID
        project_uuid             TYPE sysuuid_x16,
        "! ProjectRoleUUID
        project_role_uuid        TYPE sysuuid_x16,
        "! TeamMemberUUID
        team_member_uuid         TYPE sysuuid_x16,
        "! ProjectRoleType
        project_role_type        TYPE c LENGTH 15,
        "! CreatedByUser
        created_by_user          TYPE c LENGTH 12,
        "! CreationDateTime
        creation_date_time       TYPE timestamp,
        "! LastChangedByUser
        last_changed_by_user     TYPE c LENGTH 12,
        "! LastChangeDateTime
        last_change_date_time    TYPE timestamp,
      END OF tys_a_ent_team_member_entitl_2,
      "! <p class="shorttext synchronized">List of A_EntTeamMemberEntitlementType</p>
      tyt_a_ent_team_member_entitl_2 TYPE STANDARD TABLE OF tys_a_ent_team_member_entitl_2 WITH DEFAULT KEY.


    CONSTANTS:
      "! <p class="shorttext synchronized">Internal Names of the entity sets</p>
      BEGIN OF gcs_entity_set,
        "! A_EnterpriseProject
        "! <br/> Collection of type 'A_EnterpriseProjectType'
        a_enterprise_project       TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'A_ENTERPRISE_PROJECT',
        "! A_EnterpriseProjectElement
        "! <br/> Collection of type 'A_EnterpriseProjectElementType'
        a_enterprise_project_eleme TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'A_ENTERPRISE_PROJECT_ELEME',
        "! A_EnterpriseProjectJVA
        "! <br/> Collection of type 'A_EnterpriseProjectJVAType'
        a_enterprise_project_jva   TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'A_ENTERPRISE_PROJECT_JVA',
        "! A_EnterpriseProjectRole
        "! <br/> Collection of type 'A_EnterpriseProjectRoleType'
        a_enterprise_project_role  TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'A_ENTERPRISE_PROJECT_ROLE',
        "! A_EnterpriseProjectTeamMember
        "! <br/> Collection of type 'A_EnterpriseProjectTeamMemberType'
        a_enterprise_project_team  TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'A_ENTERPRISE_PROJECT_TEAM',
        "! A_EnterpriseProjBlkFunc
        "! <br/> Collection of type 'A_EnterpriseProjBlkFuncType'
        a_enterprise_proj_blk_func TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'A_ENTERPRISE_PROJ_BLK_FUNC',
        "! A_EntProjectElementJVA
        "! <br/> Collection of type 'A_EntProjectElementJVAType'
        a_ent_project_element_jva  TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'A_ENT_PROJECT_ELEMENT_JVA',
        "! A_EntProjectElmntPublicSector
        "! <br/> Collection of type 'A_EntProjectElmntPublicSectorType'
        a_ent_project_elmnt_public TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'A_ENT_PROJECT_ELMNT_PUBLIC',
        "! A_EntProjectPublicSector
        "! <br/> Collection of type 'A_EntProjectPublicSectorType'
        a_ent_project_public_secto TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'A_ENT_PROJECT_PUBLIC_SECTO',
        "! A_EntProjElmntBlockFunc
        "! <br/> Collection of type 'A_EntProjElmntBlockFuncType'
        a_ent_proj_elmnt_block_fun TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'A_ENT_PROJ_ELMNT_BLOCK_FUN',
        "! A_EntProjElmntCnfgrdWrkItmTxt
        "! <br/> Collection of type 'A_EntProjElmntCnfgrdWrkItmTxtType'
        a_ent_proj_elmnt_cnfgrd_wr TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'A_ENT_PROJ_ELMNT_CNFGRD_WR',
        "! A_EntProjElmntDlvbrl
        "! <br/> Collection of type 'A_EntProjElmntDlvbrlType'
        a_ent_proj_elmnt_dlvbrl    TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'A_ENT_PROJ_ELMNT_DLVBRL',
        "! A_EntProjElmntDlvbrlDistr
        "! <br/> Collection of type 'A_EntProjElmntDlvbrlDistrType'
        a_ent_proj_elmnt_dlvbrl_di TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'A_ENT_PROJ_ELMNT_DLVBRL_DI',
        "! A_EntProjElmntWorkItem
        "! <br/> Collection of type 'A_EntProjElmntWorkItemType'
        a_ent_proj_elmnt_work_item TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'A_ENT_PROJ_ELMNT_WORK_ITEM',
        "! A_EntTeamMemberEntitlement
        "! <br/> Collection of type 'A_EntTeamMemberEntitlementType'
        a_ent_team_member_entitlem TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'A_ENT_TEAM_MEMBER_ENTITLEM',
      END OF gcs_entity_set .

    CONSTANTS:
      "! <p class="shorttext synchronized">Internal Names of the function imports</p>
      BEGIN OF gcs_function_import,
        "! ChangeEntProjElmntPosition
        "! <br/> See structure type {@link ..tys_parameters_1} for the parameters
        change_ent_proj_elmnt_posi TYPE /iwbep/if_cp_runtime_types=>ty_operation_name VALUE 'CHANGE_ENT_PROJ_ELMNT_POSI',
        "! ChangeEntProjElmntProcgStatus
        "! <br/> See structure type {@link ..tys_parameters_2} for the parameters
        change_ent_proj_elmnt_proc TYPE /iwbep/if_cp_runtime_types=>ty_operation_name VALUE 'CHANGE_ENT_PROJ_ELMNT_PROC',
        "! ChangeEntProjProcgStatus
        "! <br/> See structure type {@link ..tys_parameters_3} for the parameters
        change_ent_proj_procg_stat TYPE /iwbep/if_cp_runtime_types=>ty_operation_name VALUE 'CHANGE_ENT_PROJ_PROCG_STAT',
        "! ChangePeriodDistributionOption
        "! <br/> See structure type {@link ..tys_parameters_4} for the parameters
        change_period_distribution TYPE /iwbep/if_cp_runtime_types=>ty_operation_name VALUE 'CHANGE_PERIOD_DISTRIBUTION',
        "! CopyToActiveDocument
        "! <br/> See structure type {@link ..tys_parameters_5} for the parameters
        copy_to_active_document    TYPE /iwbep/if_cp_runtime_types=>ty_operation_name VALUE 'COPY_TO_ACTIVE_DOCUMENT',
      END OF gcs_function_import.

    CONSTANTS:
      "! <p class="shorttext synchronized">Internal Names of the bound functions</p>
      BEGIN OF gcs_bound_function,
         "! Dummy field - Structure must not be empty
         dummy TYPE int1 VALUE 0,
      END OF gcs_bound_function.

    CONSTANTS:
      "! <p class="shorttext synchronized">Internal names for complex types</p>
      BEGIN OF gcs_complex_type,
         "! Dummy field - Structure must not be empty
         dummy TYPE int1 VALUE 0,
      END OF gcs_complex_type.

    CONSTANTS:
      "! <p class="shorttext synchronized">Internal names for entity types</p>
      BEGIN OF gcs_entity_type,
        "! <p class="shorttext synchronized">Internal names for A_EnterpriseProjectElementType</p>
        "! See also structure type {@link ..tys_a_enterprise_project_ele_2}
        BEGIN OF a_enterprise_project_ele_2,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! to_EnterpriseProject
            to_enterprise_project      TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENTERPRISE_PROJECT',
            "! to_EntProjectElementJVA
            to_ent_project_element_jva TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENT_PROJECT_ELEMENT_JVA',
            "! to_EntProjectElmntPublicSector
            to_ent_project_elmnt_publi TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENT_PROJECT_ELMNT_PUBLI',
            "! to_EntProjElmntBlkFunc
            to_ent_proj_elmnt_blk_fu_2 TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENT_PROJ_ELMNT_BLK_FU_2',
            "! to_EntProjElmntDlvbrl
            to_ent_proj_elmnt_dlvbrl   TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENT_PROJ_ELMNT_DLVBRL',
            "! to_EntProjElmntWorkItem
            to_ent_proj_elmnt_work_i_2 TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENT_PROJ_ELMNT_WORK_I_2',
            "! to_ParentProjElement
            to_parent_proj_element     TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_PARENT_PROJ_ELEMENT',
            "! to_SubProjElement
            to_sub_proj_element        TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_SUB_PROJ_ELEMENT',
          END OF navigation,
        END OF a_enterprise_project_ele_2,
        "! <p class="shorttext synchronized">Internal names for A_EnterpriseProjectJVAType</p>
        "! See also structure type {@link ..tys_a_enterprise_project_jvaty}
        BEGIN OF a_enterprise_project_jvaty,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! to_EnterpriseProject
            to_enterprise_project TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENTERPRISE_PROJECT',
          END OF navigation,
        END OF a_enterprise_project_jvaty,
        "! <p class="shorttext synchronized">Internal names for A_EnterpriseProjectRoleType</p>
        "! See also structure type {@link ..tys_a_enterprise_project_rol_2}
        BEGIN OF a_enterprise_project_rol_2,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! to_EnterpriseProject
            to_enterprise_project TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENTERPRISE_PROJECT',
          END OF navigation,
        END OF a_enterprise_project_rol_2,
        "! <p class="shorttext synchronized">Internal names for A_EnterpriseProjectTeamMemberType</p>
        "! See also structure type {@link ..tys_a_enterprise_project_tea_2}
        BEGIN OF a_enterprise_project_tea_2,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! to_EnterpriseProject
            to_enterprise_project   TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENTERPRISE_PROJECT',
            "! to_EntProjEntitlement
            to_ent_proj_entitlement TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENT_PROJ_ENTITLEMENT',
          END OF navigation,
        END OF a_enterprise_project_tea_2,
        "! <p class="shorttext synchronized">Internal names for A_EnterpriseProjectType</p>
        "! See also structure type {@link ..tys_a_enterprise_project_type}
        BEGIN OF a_enterprise_project_type,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! to_EnterpriseProjectElement
            to_enterprise_project_el_2 TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENTERPRISE_PROJECT_EL_2',
            "! to_EnterpriseProjectJVA
            to_enterprise_project_jva  TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENTERPRISE_PROJECT_JVA',
            "! to_EntProjectPublicSector
            to_ent_project_public_sect TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENT_PROJECT_PUBLIC_SECT',
            "! to_EntProjBlkFunc
            to_ent_proj_blk_func       TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENT_PROJ_BLK_FUNC',
            "! to_EntProjRole
            to_ent_proj_role           TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENT_PROJ_ROLE',
            "! to_EntProjTeamMember
            to_ent_proj_team_member    TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENT_PROJ_TEAM_MEMBER',
          END OF navigation,
        END OF a_enterprise_project_type,
        "! <p class="shorttext synchronized">Internal names for A_EnterpriseProjBlkFuncType</p>
        "! See also structure type {@link ..tys_a_enterprise_proj_blk_fu_2}
        BEGIN OF a_enterprise_proj_blk_fu_2,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! to_EnterpriseProject
            to_enterprise_project TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENTERPRISE_PROJECT',
          END OF navigation,
        END OF a_enterprise_proj_blk_fu_2,
        "! <p class="shorttext synchronized">Internal names for A_EntProjectElementJVAType</p>
        "! See also structure type {@link ..tys_a_ent_project_element_jvat}
        BEGIN OF a_ent_project_element_jvat,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! to_EnterpriseProject
            to_enterprise_project      TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENTERPRISE_PROJECT',
            "! to_EnterpriseProjectElement
            to_enterprise_project_elem TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENTERPRISE_PROJECT_ELEM',
          END OF navigation,
        END OF a_ent_project_element_jvat,
        "! <p class="shorttext synchronized">Internal names for A_EntProjectElmntPublicSectorType</p>
        "! See also structure type {@link ..tys_a_ent_project_elmnt_publ_2}
        BEGIN OF a_ent_project_elmnt_publ_2,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! to_EnterpriseProject
            to_enterprise_project      TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENTERPRISE_PROJECT',
            "! to_EnterpriseProjectElement
            to_enterprise_project_elem TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENTERPRISE_PROJECT_ELEM',
          END OF navigation,
        END OF a_ent_project_elmnt_publ_2,
        "! <p class="shorttext synchronized">Internal names for A_EntProjectPublicSectorType</p>
        "! See also structure type {@link ..tys_a_ent_project_public_sec_2}
        BEGIN OF a_ent_project_public_sec_2,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! to_EnterpriseProject
            to_enterprise_project TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENTERPRISE_PROJECT',
          END OF navigation,
        END OF a_ent_project_public_sec_2,
        "! <p class="shorttext synchronized">Internal names for A_EntProjElmntBlockFuncType</p>
        "! See also structure type {@link ..tys_a_ent_proj_elmnt_block_f_2}
        BEGIN OF a_ent_proj_elmnt_block_f_2,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! to_EnterpriseProject
            to_enterprise_project      TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENTERPRISE_PROJECT',
            "! to_EnterpriseProjectElement
            to_enterprise_project_elem TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENTERPRISE_PROJECT_ELEM',
          END OF navigation,
        END OF a_ent_proj_elmnt_block_f_2,
        "! <p class="shorttext synchronized">Internal names for A_EntProjElmntCnfgrdWrkItmTxtType</p>
        "! See also structure type {@link ..tys_a_ent_proj_elmnt_cnfgrd__2}
        BEGIN OF a_ent_proj_elmnt_cnfgrd__2,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! Dummy field - Structure must not be empty
            dummy TYPE int1 VALUE 0,
          END OF navigation,
        END OF a_ent_proj_elmnt_cnfgrd__2,
        "! <p class="shorttext synchronized">Internal names for A_EntProjElmntDlvbrlType</p>
        "! See also structure type {@link ..tys_a_ent_proj_elmnt_dlvbrl_ty}
        BEGIN OF a_ent_proj_elmnt_dlvbrl_ty,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! to_EnterpriseProjectElement
            to_enterprise_project_elem TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENTERPRISE_PROJECT_ELEM',
            "! to_EntProjElmntDlvDistr
            to_ent_proj_elmnt_dlv_di_2 TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENT_PROJ_ELMNT_DLV_DI_2',
          END OF navigation,
        END OF a_ent_proj_elmnt_dlvbrl_ty,
        "! <p class="shorttext synchronized">Internal names for A_EntProjElmntDlvbrlDistrType</p>
        "! See also structure type {@link ..tys_a_ent_proj_elmnt_dlvbrl__2}
        BEGIN OF a_ent_proj_elmnt_dlvbrl__2,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! to_EntProjElmntDlvbrl
            to_ent_proj_elmnt_dlvbrl TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENT_PROJ_ELMNT_DLVBRL',
          END OF navigation,
        END OF a_ent_proj_elmnt_dlvbrl__2,
        "! <p class="shorttext synchronized">Internal names for A_EntProjElmntWorkItemType</p>
        "! See also structure type {@link ..tys_a_ent_proj_elmnt_work_it_2}
        BEGIN OF a_ent_proj_elmnt_work_it_2,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! to_ConfiguredWorkItemText
            to_configured_work_item_te TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_CONFIGURED_WORK_ITEM_TE',
            "! to_EnterpriseProject
            to_enterprise_project      TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENTERPRISE_PROJECT',
            "! to_EnterpriseProjectElement
            to_enterprise_project_elem TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENTERPRISE_PROJECT_ELEM',
          END OF navigation,
        END OF a_ent_proj_elmnt_work_it_2,
        "! <p class="shorttext synchronized">Internal names for A_EntTeamMemberEntitlementType</p>
        "! See also structure type {@link ..tys_a_ent_team_member_entitl_2}
        BEGIN OF a_ent_team_member_entitl_2,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! to_EnterpriseProject
            to_enterprise_project TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ENTERPRISE_PROJECT',
            "! to_Role
            to_role               TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ROLE',
            "! to_TeamMember
            to_team_member        TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_TEAM_MEMBER',
          END OF navigation,
        END OF a_ent_team_member_entitl_2,
      END OF gcs_entity_type.


    METHODS /iwbep/if_v4_mp_basic_pm~define REDEFINITION.


  PRIVATE SECTION.

    "! <p class="shorttext synchronized">Model</p>
    DATA mo_model TYPE REF TO /iwbep/if_v4_pm_model.


    "! <p class="shorttext synchronized">Define A_EnterpriseProjectElementType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_a_enterprise_project_ele_2 RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define A_EnterpriseProjectJVAType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_a_enterprise_project_jvaty RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define A_EnterpriseProjectRoleType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_a_enterprise_project_rol_2 RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define A_EnterpriseProjectTeamMemberType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_a_enterprise_project_tea_2 RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define A_EnterpriseProjectType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_a_enterprise_project_type RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define A_EnterpriseProjBlkFuncType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_a_enterprise_proj_blk_fu_2 RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define A_EntProjectElementJVAType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_a_ent_project_element_jvat RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define A_EntProjectElmntPublicSectorType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_a_ent_project_elmnt_publ_2 RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define A_EntProjectPublicSectorType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_a_ent_project_public_sec_2 RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define A_EntProjElmntBlockFuncType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_a_ent_proj_elmnt_block_f_2 RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define A_EntProjElmntCnfgrdWrkItmTxtType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_a_ent_proj_elmnt_cnfgrd__2 RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define A_EntProjElmntDlvbrlType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_a_ent_proj_elmnt_dlvbrl_ty RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define A_EntProjElmntDlvbrlDistrType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_a_ent_proj_elmnt_dlvbrl__2 RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define A_EntProjElmntWorkItemType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_a_ent_proj_elmnt_work_it_2 RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define A_EntTeamMemberEntitlementType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_a_ent_team_member_entitl_2 RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define ChangeEntProjElmntPosition</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_change_ent_proj_elmnt_posi RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define ChangeEntProjElmntProcgStatus</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_change_ent_proj_elmnt_proc RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define ChangeEntProjProcgStatus</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_change_ent_proj_procg_stat RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define ChangePeriodDistributionOption</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_change_period_distribution RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define CopyToActiveDocument</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_copy_to_active_document RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define all primitive types</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS define_primitive_types RAISING /iwbep/cx_gateway.

ENDCLASS.



CLASS ZCL_PRA_MF_SCM_ENT_PROJ IMPLEMENTATION.


  METHOD /iwbep/if_v4_mp_basic_pm~define.

    mo_model = io_model.
    mo_model->set_schema_namespace( 'API_ENTERPRISE_PROJECT_SRV' ) ##NO_TEXT.

    def_a_enterprise_project_ele_2( ).
    def_a_enterprise_project_jvaty( ).
    def_a_enterprise_project_rol_2( ).
    def_a_enterprise_project_tea_2( ).
    def_a_enterprise_project_type( ).
    def_a_enterprise_proj_blk_fu_2( ).
    def_a_ent_project_element_jvat( ).
    def_a_ent_project_elmnt_publ_2( ).
    def_a_ent_project_public_sec_2( ).
    def_a_ent_proj_elmnt_block_f_2( ).
    def_a_ent_proj_elmnt_cnfgrd__2( ).
    def_a_ent_proj_elmnt_dlvbrl_ty( ).
    def_a_ent_proj_elmnt_dlvbrl__2( ).
    def_a_ent_proj_elmnt_work_it_2( ).
    def_a_ent_team_member_entitl_2( ).
    def_change_ent_proj_elmnt_posi( ).
    def_change_ent_proj_elmnt_proc( ).
    def_change_ent_proj_procg_stat( ).
    def_change_period_distribution( ).
    def_copy_to_active_document( ).
    define_primitive_types( ).

  ENDMETHOD.


  METHOD define_primitive_types.

    DATA lo_primitive_type TYPE REF TO /iwbep/if_v4_pm_prim_type.


    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'CUSTOMER_UUID'
                            iv_element             = VALUE tys_types_for_prim_types-customer_uuid( ) ).
    lo_primitive_type->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_type->set_scale_variable( ).

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'ENTERPRISE_PROJECT_SERVICE'
                            iv_element             = VALUE tys_types_for_prim_types-enterprise_project_service( ) ).
    lo_primitive_type->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_type->set_scale_variable( ).

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'ENT_PROJECT_IS_CONFIDENTIA'
                            iv_element             = VALUE tys_types_for_prim_types-ent_project_is_confidentia( ) ).
    lo_primitive_type->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_type->set_scale_variable( ).

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'ENT_PROJ_DEMAND_COPY_IS_RE'
                            iv_element             = VALUE tys_types_for_prim_types-ent_proj_demand_copy_is_re( ) ).
    lo_primitive_type->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_type->set_scale_variable( ).

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'ENT_PROJ_ELMNT_DISTRIBUTIO'
                            iv_element             = VALUE tys_types_for_prim_types-ent_proj_elmnt_distributio( ) ).
    lo_primitive_type->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_type->set_scale_variable( ).

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'ENT_PROJ_SETTLMT_RULE_CPY'
                            iv_element             = VALUE tys_types_for_prim_types-ent_proj_settlmt_rule_cpy( ) ).
    lo_primitive_type->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_type->set_scale_variable( ).

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'LEFT_SIBLING_UUID'
                            iv_element             = VALUE tys_types_for_prim_types-left_sibling_uuid( ) ).
    lo_primitive_type->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_type->set_scale_variable( ).

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'PARENT_OBJECT_UUID'
                            iv_element             = VALUE tys_types_for_prim_types-parent_object_uuid( ) ).
    lo_primitive_type->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_type->set_scale_variable( ).

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'PLANNED_END_DATE'
                            iv_element             = VALUE tys_types_for_prim_types-planned_end_date( ) ).
    lo_primitive_type->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_type->set_edm_type_v2( 'DateTime' ) ##NO_TEXT.

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'PLANNED_START_DATE'
                            iv_element             = VALUE tys_types_for_prim_types-planned_start_date( ) ).
    lo_primitive_type->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_type->set_edm_type_v2( 'DateTime' ) ##NO_TEXT.

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'PROCESSING_STATUS'
                            iv_element             = VALUE tys_types_for_prim_types-processing_status( ) ).
    lo_primitive_type->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_type->set_scale_variable( ).

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'PROCESSING_STATUS_2'
                            iv_element             = VALUE tys_types_for_prim_types-processing_status_2( ) ).
    lo_primitive_type->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_type->set_scale_variable( ).

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'PROJECT'
                            iv_element             = VALUE tys_types_for_prim_types-project( ) ).
    lo_primitive_type->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_type->set_scale_variable( ).

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'PROJECT_CURRENCY'
                            iv_element             = VALUE tys_types_for_prim_types-project_currency( ) ).
    lo_primitive_type->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_type->set_scale_variable( ).

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'PROJECT_ELEMENT_UUID'
                            iv_element             = VALUE tys_types_for_prim_types-project_element_uuid( ) ).
    lo_primitive_type->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_type->set_scale_variable( ).

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'PROJECT_ELEMENT_UUID_2'
                            iv_element             = VALUE tys_types_for_prim_types-project_element_uuid_2( ) ).
    lo_primitive_type->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_type->set_scale_variable( ).

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'PROJECT_ELEMENT_UUID_3'
                            iv_element             = VALUE tys_types_for_prim_types-project_element_uuid_3( ) ).
    lo_primitive_type->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_type->set_scale_variable( ).

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'PROJECT_END_DATE'
                            iv_element             = VALUE tys_types_for_prim_types-project_end_date( ) ).
    lo_primitive_type->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_type->set_edm_type_v2( 'DateTime' ) ##NO_TEXT.

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'PROJECT_MANAGER_UUID'
                            iv_element             = VALUE tys_types_for_prim_types-project_manager_uuid( ) ).
    lo_primitive_type->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_type->set_scale_variable( ).

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'PROJECT_NAME'
                            iv_element             = VALUE tys_types_for_prim_types-project_name( ) ).
    lo_primitive_type->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_type->set_scale_variable( ).

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'PROJECT_START_DATE'
                            iv_element             = VALUE tys_types_for_prim_types-project_start_date( ) ).
    lo_primitive_type->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_type->set_edm_type_v2( 'DateTime' ) ##NO_TEXT.

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'PROJECT_UUID'
                            iv_element             = VALUE tys_types_for_prim_types-project_uuid( ) ).
    lo_primitive_type->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_type->set_scale_variable( ).

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'PROJECT_UUID_2'
                            iv_element             = VALUE tys_types_for_prim_types-project_uuid_2( ) ).
    lo_primitive_type->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_type->set_scale_variable( ).

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'RESPONSIBLE_COST_CENTER'
                            iv_element             = VALUE tys_types_for_prim_types-responsible_cost_center( ) ).
    lo_primitive_type->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_type->set_scale_variable( ).

    lo_primitive_type = mo_model->create_primitive_type_by_elem(
                            iv_primitive_type_name = 'RESTRICTED_TIME_POSTING'
                            iv_element             = VALUE tys_types_for_prim_types-restricted_time_posting( ) ).
    lo_primitive_type->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_type->set_scale_variable( ).

  ENDMETHOD.


  METHOD def_a_enterprise_project_ele_2.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'A_ENTERPRISE_PROJECT_ELE_2'
                                    is_structure              = VALUE tys_a_enterprise_project_ele_2( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'A_EnterpriseProjectElementType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'A_ENTERPRISE_PROJECT_ELEME' ).
    lo_entity_set->set_edm_name( 'A_EnterpriseProjectElement' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'CHANGE_ENT_PROJ_ELMNT_POSI' ).
    lo_primitive_property->set_edm_name( 'ChangeEntProjElmntPosition_ac' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CHANGE_ENT_PROJ_ELMNT_PROC' ).
    lo_primitive_property->set_edm_name( 'ChangeEntProjElmntProcgStatus_ac' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CHANGE_PERIOD_DISTRIBUTION' ).
    lo_primitive_property->set_edm_name( 'ChangePeriodDistributionOption_ac' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ACTUAL_END_DATE_FC' ).
    lo_primitive_property->set_edm_name( 'ActualEndDate_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ACTUAL_START_DATE_FC' ).
    lo_primitive_property->set_edm_name( 'ActualStartDate_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CONTROLLING_AREA_FC' ).
    lo_primitive_property->set_edm_name( 'ControllingArea_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'COST_CENTER_FC' ).
    lo_primitive_property->set_edm_name( 'CostCenter_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'COSTING_SHEET_FC' ).
    lo_primitive_property->set_edm_name( 'CostingSheet_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FACTORY_CALENDAR_FC' ).
    lo_primitive_property->set_edm_name( 'FactoryCalendar_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FORECASTED_END_DATE_FC' ).
    lo_primitive_property->set_edm_name( 'ForecastedEndDate_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FUNCTIONAL_AREA_FC' ).
    lo_primitive_property->set_edm_name( 'FunctionalArea_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FUNCTIONAL_LOCATION_FC' ).
    lo_primitive_property->set_edm_name( 'FunctionalLocation_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'INVESTMENT_PROFILE_FC' ).
    lo_primitive_property->set_edm_name( 'InvestmentProfile_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'IS_MAIN_MILESTONE_FC' ).
    lo_primitive_property->set_edm_name( 'IsMainMilestone_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LOCATION_FC' ).
    lo_primitive_property->set_edm_name( 'Location_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'MILESTONE_APPROVAL_STATUS' ).
    lo_primitive_property->set_edm_name( 'MilestoneApprovalStatus_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PLANNED_END_DATE_FC' ).
    lo_primitive_property->set_edm_name( 'PlannedEndDate_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PLANNED_START_DATE_FC' ).
    lo_primitive_property->set_edm_name( 'PlannedStartDate_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PLANT_FC' ).
    lo_primitive_property->set_edm_name( 'Plant_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROFIT_CENTER_FC' ).
    lo_primitive_property->set_edm_name( 'ProfitCenter_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_ELEMENT_FC' ).
    lo_primitive_property->set_edm_name( 'ProjectElement_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_ELEMENT_DESCRIPTIO' ).
    lo_primitive_property->set_edm_name( 'ProjectElementDescription_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'RESPONSIBLE_COST_CENTER_FC' ).
    lo_primitive_property->set_edm_name( 'ResponsibleCostCenter_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'RESULT_ANALYSIS_INTERNAL_I' ).
    lo_primitive_property->set_edm_name( 'ResultAnalysisInternalID_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'TAX_JURISDICTION_FC' ).
    lo_primitive_property->set_edm_name( 'TaxJurisdiction_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'WBSELEMENT_IS_BILLING_ELEM' ).
    lo_primitive_property->set_edm_name( 'WBSElementIsBillingElement_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'DELETE_MC' ).
    lo_primitive_property->set_edm_name( 'Delete_mc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UPDATE_MC' ).
    lo_primitive_property->set_edm_name( 'Update_mc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'TO_ENT_PROJ_ELMNT_BLK_FUNC' ).
    lo_primitive_property->set_edm_name( 'to_EntProjElmntBlkFunc_oc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'TO_ENT_PROJ_ELMNT_DLVBRL_O' ).
    lo_primitive_property->set_edm_name( 'to_EntProjElmntDlvbrl_oc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'TO_ENT_PROJ_ELMNT_WORK_ITE' ).
    lo_primitive_property->set_edm_name( 'to_EntProjElmntWorkItem_oc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'TO_SUB_PROJ_ELEMENT_OC' ).
    lo_primitive_property->set_edm_name( 'to_SubProjElement_oc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_ELEMENT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectElementUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_ELEMENT' ).
    lo_primitive_property->set_edm_name( 'ProjectElement' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 24 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'WBSELEMENT_INTERNAL_ID' ).
    lo_primitive_property->set_edm_name( 'WBSElementInternalID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 8 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_ELEMENT_DESCRIPT_2' ).
    lo_primitive_property->set_edm_name( 'ProjectElementDescription' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 60 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PARENT_OBJECT_UUID' ).
    lo_primitive_property->set_edm_name( 'ParentObjectUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_ELEMENT_ORDINAL_NU' ).
    lo_primitive_property->set_edm_name( 'ProjectElementOrdinalNumber' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Int32' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROCESSING_STATUS' ).
    lo_primitive_property->set_edm_name( 'ProcessingStatus' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 2 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJECT_ELEMENT_TYPE' ).
    lo_primitive_property->set_edm_name( 'EntProjectElementType' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 15 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PLANNED_START_DATE' ).
    lo_primitive_property->set_edm_name( 'PlannedStartDate' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->set_edm_type_v2( 'DateTime' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PLANNED_END_DATE' ).
    lo_primitive_property->set_edm_name( 'PlannedEndDate' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->set_edm_type_v2( 'DateTime' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ACTUAL_START_DATE' ).
    lo_primitive_property->set_edm_name( 'ActualStartDate' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->set_edm_type_v2( 'DateTime' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ACTUAL_END_DATE' ).
    lo_primitive_property->set_edm_name( 'ActualEndDate' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->set_edm_type_v2( 'DateTime' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'RESPONSIBLE_COST_CENTER' ).
    lo_primitive_property->set_edm_name( 'ResponsibleCostCenter' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'COMPANY_CODE' ).
    lo_primitive_property->set_edm_name( 'CompanyCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROFIT_CENTER' ).
    lo_primitive_property->set_edm_name( 'ProfitCenter' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FUNCTIONAL_AREA' ).
    lo_primitive_property->set_edm_name( 'FunctionalArea' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 16 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CONTROLLING_AREA' ).
    lo_primitive_property->set_edm_name( 'ControllingArea' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PLANT' ).
    lo_primitive_property->set_edm_name( 'Plant' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LOCATION' ).
    lo_primitive_property->set_edm_name( 'Location' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'TAX_JURISDICTION' ).
    lo_primitive_property->set_edm_name( 'TaxJurisdiction' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 15 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FUNCTIONAL_LOCATION' ).
    lo_primitive_property->set_edm_name( 'FunctionalLocation' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 40 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FACTORY_CALENDAR' ).
    lo_primitive_property->set_edm_name( 'FactoryCalendar' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 2 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'COSTING_SHEET' ).
    lo_primitive_property->set_edm_name( 'CostingSheet' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 6 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'INVESTMENT_PROFILE' ).
    lo_primitive_property->set_edm_name( 'InvestmentProfile' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 6 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'WBSIS_STATISTICAL_WBSELEME' ).
    lo_primitive_property->set_edm_name( 'WBSIsStatisticalWBSElement' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'COST_CENTER' ).
    lo_primitive_property->set_edm_name( 'CostCenter' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'WBSELEMENT_IS_BILLING_EL_2' ).
    lo_primitive_property->set_edm_name( 'WBSElementIsBillingElement' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'RESULT_ANALYSIS_INTERNAL_2' ).
    lo_primitive_property->set_edm_name( 'ResultAnalysisInternalID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 6 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'IS_PROJECT_MILESTONE' ).
    lo_primitive_property->set_edm_name( 'IsProjectMilestone' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 1 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FORECASTED_END_DATE' ).
    lo_primitive_property->set_edm_name( 'ForecastedEndDate' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->set_edm_type_v2( 'DateTime' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'MILESTONE_APPROVAL_STATU_2' ).
    lo_primitive_property->set_edm_name( 'MilestoneApprovalStatus' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 5 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'IS_MAIN_MILESTONE' ).
    lo_primitive_property->set_edm_name( 'IsMainMilestone' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CREATED_BY_USER' ).
    lo_primitive_property->set_edm_name( 'CreatedByUser' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CREATION_DATE_TIME' ).
    lo_primitive_property->set_edm_name( 'CreationDateTime' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LAST_CHANGE_DATE_TIME' ).
    lo_primitive_property->set_edm_name( 'LastChangeDateTime' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LAST_CHANGED_BY_USER' ).
    lo_primitive_property->set_edm_name( 'LastChangedByUser' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENTERPRISE_PROJECT' ).
    lo_navigation_property->set_edm_name( 'to_EnterpriseProject' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_TYPE' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENT_PROJECT_ELEMENT_JVA' ).
    lo_navigation_property->set_edm_name( 'to_EntProjectElementJVA' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENT_PROJECT_ELEMENT_JVAT' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENT_PROJECT_ELMNT_PUBLI' ).
    lo_navigation_property->set_edm_name( 'to_EntProjectElmntPublicSector' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENT_PROJECT_ELMNT_PUBL_2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENT_PROJ_ELMNT_BLK_FU_2' ).
    lo_navigation_property->set_edm_name( 'to_EntProjElmntBlkFunc' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENT_PROJ_ELMNT_BLOCK_F_2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENT_PROJ_ELMNT_DLVBRL' ).
    lo_navigation_property->set_edm_name( 'to_EntProjElmntDlvbrl' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENT_PROJ_ELMNT_DLVBRL_TY' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_many_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENT_PROJ_ELMNT_WORK_I_2' ).
    lo_navigation_property->set_edm_name( 'to_EntProjElmntWorkItem' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENT_PROJ_ELMNT_WORK_IT_2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_many_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_PARENT_PROJ_ELEMENT' ).
    lo_navigation_property->set_edm_name( 'to_ParentProjElement' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_ELE_2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_SUB_PROJ_ELEMENT' ).
    lo_navigation_property->set_edm_name( 'to_SubProjElement' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_ELE_2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_many_optional ).

  ENDMETHOD.


  METHOD def_a_enterprise_project_jvaty.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'A_ENTERPRISE_PROJECT_JVATY'
                                    is_structure              = VALUE tys_a_enterprise_project_jvaty( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'A_EnterpriseProjectJVAType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'A_ENTERPRISE_PROJECT_JVA' ).
    lo_entity_set->set_edm_name( 'A_EnterpriseProjectJVA' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'JNT_INTRST_BILLG_CLASS_FC' ).
    lo_primitive_property->set_edm_name( 'JntIntrstBillgClass_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JNT_INTRST_BILLG_SUB_CLASS' ).
    lo_primitive_property->set_edm_name( 'JntIntrstBillgSubClass_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JNT_VNTR_PROJECT_TYPE_FC' ).
    lo_primitive_property->set_edm_name( 'JntVntrProjectType_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JOINT_VENTURE_FC' ).
    lo_primitive_property->set_edm_name( 'JointVenture_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JOINT_VENTURE_COST_RECOVER' ).
    lo_primitive_property->set_edm_name( 'JointVentureCostRecoveryCode_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JOINT_VENTURE_EQUITY_TYPE' ).
    lo_primitive_property->set_edm_name( 'JointVentureEquityType_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UPDATE_MC' ).
    lo_primitive_property->set_edm_name( 'Update_mc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JOINT_VENTURE' ).
    lo_primitive_property->set_edm_name( 'JointVenture' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 6 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JOINT_VENTURE_COST_RECOV_2' ).
    lo_primitive_property->set_edm_name( 'JointVentureCostRecoveryCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 2 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JOINT_VENTURE_EQUITY_TYP_2' ).
    lo_primitive_property->set_edm_name( 'JointVentureEquityType' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JNT_VNTR_PROJECT_TYPE' ).
    lo_primitive_property->set_edm_name( 'JntVntrProjectType' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JNT_INTRST_BILLG_CLASS' ).
    lo_primitive_property->set_edm_name( 'JntIntrstBillgClass' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JNT_INTRST_BILLG_SUB_CLA_2' ).
    lo_primitive_property->set_edm_name( 'JntIntrstBillgSubClass' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 5 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENTERPRISE_PROJECT' ).
    lo_navigation_property->set_edm_name( 'to_EnterpriseProject' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_TYPE' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

  ENDMETHOD.


  METHOD def_a_enterprise_project_rol_2.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'A_ENTERPRISE_PROJECT_ROL_2'
                                    is_structure              = VALUE tys_a_enterprise_project_rol_2( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'A_EnterpriseProjectRoleType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'A_ENTERPRISE_PROJECT_ROLE' ).
    lo_entity_set->set_edm_name( 'A_EnterpriseProjectRole' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_ROLE_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectRoleUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_ROLE_TYPE' ).
    lo_primitive_property->set_edm_name( 'ProjectRoleType' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 15 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_ROLE_CATEGORY' ).
    lo_primitive_property->set_edm_name( 'ProjectRoleCategory' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_ROLE_NAME' ).
    lo_primitive_property->set_edm_name( 'ProjectRoleName' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 40 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CREATED_BY_USER' ).
    lo_primitive_property->set_edm_name( 'CreatedByUser' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CREATION_DATE_TIME' ).
    lo_primitive_property->set_edm_name( 'CreationDateTime' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LAST_CHANGED_BY_USER' ).
    lo_primitive_property->set_edm_name( 'LastChangedByUser' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LAST_CHANGE_DATE_TIME' ).
    lo_primitive_property->set_edm_name( 'LastChangeDateTime' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENTERPRISE_PROJECT' ).
    lo_navigation_property->set_edm_name( 'to_EnterpriseProject' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_TYPE' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

  ENDMETHOD.


  METHOD def_a_enterprise_project_tea_2.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'A_ENTERPRISE_PROJECT_TEA_2'
                                    is_structure              = VALUE tys_a_enterprise_project_tea_2( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'A_EnterpriseProjectTeamMemberType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'A_ENTERPRISE_PROJECT_TEAM' ).
    lo_entity_set->set_edm_name( 'A_EnterpriseProjectTeamMember' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'TO_ENT_PROJ_ENTITLEMENT_OC' ).
    lo_primitive_property->set_edm_name( 'to_EntProjEntitlement_oc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'TEAM_MEMBER_UUID' ).
    lo_primitive_property->set_edm_name( 'TeamMemberUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'BUSINESS_PARTNER_UUID' ).
    lo_primitive_property->set_edm_name( 'BusinessPartnerUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CREATED_BY_USER' ).
    lo_primitive_property->set_edm_name( 'CreatedByUser' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CREATION_DATE_TIME' ).
    lo_primitive_property->set_edm_name( 'CreationDateTime' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LAST_CHANGED_BY_USER' ).
    lo_primitive_property->set_edm_name( 'LastChangedByUser' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LAST_CHANGE_DATE_TIME' ).
    lo_primitive_property->set_edm_name( 'LastChangeDateTime' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENTERPRISE_PROJECT' ).
    lo_navigation_property->set_edm_name( 'to_EnterpriseProject' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_TYPE' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENT_PROJ_ENTITLEMENT' ).
    lo_navigation_property->set_edm_name( 'to_EntProjEntitlement' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENT_TEAM_MEMBER_ENTITL_2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_many_optional ).

  ENDMETHOD.


  METHOD def_a_enterprise_project_type.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'A_ENTERPRISE_PROJECT_TYPE'
                                    is_structure              = VALUE tys_a_enterprise_project_type( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'A_EnterpriseProjectType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'A_ENTERPRISE_PROJECT' ).
    lo_entity_set->set_edm_name( 'A_EnterpriseProject' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'CHANGE_ENT_PROJ_PROCG_STAT' ).
    lo_primitive_property->set_edm_name( 'ChangeEntProjProcgStatus_ac' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'COPY_TO_ACTIVE_DOCUMENT_AC' ).
    lo_primitive_property->set_edm_name( 'CopyToActiveDocument_ac' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ACTUAL_END_DATE_FC' ).
    lo_primitive_property->set_edm_name( 'ActualEndDate_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ACTUAL_START_DATE_FC' ).
    lo_primitive_property->set_edm_name( 'ActualStartDate_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'AVAILABILITY_CONTROL_IS_AC' ).
    lo_primitive_property->set_edm_name( 'AvailabilityControlIsActive_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'AVAILABILITY_CONTROL_PROFI' ).
    lo_primitive_property->set_edm_name( 'AvailabilityControlProfile_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CONTROLLING_AREA_FC' ).
    lo_primitive_property->set_edm_name( 'ControllingArea_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'COSTING_SHEET_FC' ).
    lo_primitive_property->set_edm_name( 'CostingSheet_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENTERPRISE_PROJECT_TYPE_FC' ).
    lo_primitive_property->set_edm_name( 'EnterpriseProjectType_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_IS_MULTI_SLS_ORD' ).
    lo_primitive_property->set_edm_name( 'EntProjIsMultiSlsOrdItmsEnbld_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FUNCTIONAL_AREA_FC' ).
    lo_primitive_property->set_edm_name( 'FunctionalArea_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FUNCTIONAL_LOCATION_FC' ).
    lo_primitive_property->set_edm_name( 'FunctionalLocation_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'INVESTMENT_PROFILE_FC' ).
    lo_primitive_property->set_edm_name( 'InvestmentProfile_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'IS_BILLING_RELEVANT_FC' ).
    lo_primitive_property->set_edm_name( 'IsBillingRelevant_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LOCATION_FC' ).
    lo_primitive_property->set_edm_name( 'Location_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PLANT_FC' ).
    lo_primitive_property->set_edm_name( 'Plant_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PRIORITY_CODE_FC' ).
    lo_primitive_property->set_edm_name( 'PriorityCode_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROFIT_CENTER_FC' ).
    lo_primitive_property->set_edm_name( 'ProfitCenter_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_FC' ).
    lo_primitive_property->set_edm_name( 'Project_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_CURRENCY_FC' ).
    lo_primitive_property->set_edm_name( 'ProjectCurrency_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_DESCRIPTION_FC' ).
    lo_primitive_property->set_edm_name( 'ProjectDescription_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_END_DATE_FC' ).
    lo_primitive_property->set_edm_name( 'ProjectEndDate_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_PROFILE_CODE_FC' ).
    lo_primitive_property->set_edm_name( 'ProjectProfileCode_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_START_DATE_FC' ).
    lo_primitive_property->set_edm_name( 'ProjectStartDate_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'RESPONSIBLE_COST_CENTER_FC' ).
    lo_primitive_property->set_edm_name( 'ResponsibleCostCenter_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'RESULT_ANALYSIS_INTERNAL_I' ).
    lo_primitive_property->set_edm_name( 'ResultAnalysisInternalID_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'DELETE_MC' ).
    lo_primitive_property->set_edm_name( 'Delete_mc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UPDATE_MC' ).
    lo_primitive_property->set_edm_name( 'Update_mc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'TO_ENTERPRISE_PROJECT_ELEM' ).
    lo_primitive_property->set_edm_name( 'to_EnterpriseProjectElement_oc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'TO_ENT_PROJ_BLK_FUNC_OC' ).
    lo_primitive_property->set_edm_name( 'to_EntProjBlkFunc_oc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'TO_ENT_PROJ_ROLE_OC' ).
    lo_primitive_property->set_edm_name( 'to_EntProjRole_oc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'TO_ENT_PROJ_TEAM_MEMBER_OC' ).
    lo_primitive_property->set_edm_name( 'to_EntProjTeamMember_oc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_INTERNAL_ID' ).
    lo_primitive_property->set_edm_name( 'ProjectInternalID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 8 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT' ).
    lo_primitive_property->set_edm_name( 'Project' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 24 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_DESCRIPTION' ).
    lo_primitive_property->set_edm_name( 'ProjectDescription' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 60 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENTERPRISE_PROJECT_TYPE' ).
    lo_primitive_property->set_edm_name( 'EnterpriseProjectType' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 2 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PRIORITY_CODE' ).
    lo_primitive_property->set_edm_name( 'PriorityCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_START_DATE' ).
    lo_primitive_property->set_edm_name( 'ProjectStartDate' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->set_edm_type_v2( 'DateTime' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_END_DATE' ).
    lo_primitive_property->set_edm_name( 'ProjectEndDate' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->set_edm_type_v2( 'DateTime' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ACTUAL_START_DATE' ).
    lo_primitive_property->set_edm_name( 'ActualStartDate' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->set_edm_type_v2( 'DateTime' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ACTUAL_END_DATE' ).
    lo_primitive_property->set_edm_name( 'ActualEndDate' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->set_edm_type_v2( 'DateTime' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CUSTOMER_UUID' ).
    lo_primitive_property->set_edm_name( 'CustomerUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENTERPRISE_PROJECT_SERVICE' ).
    lo_primitive_property->set_edm_name( 'EnterpriseProjectServiceOrg' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 5 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJECT_IS_CONFIDENTIA' ).
    lo_primitive_property->set_edm_name( 'EntProjectIsConfidential' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'RESTRICTED_TIME_POSTING' ).
    lo_primitive_property->set_edm_name( 'RestrictedTimePosting' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 1 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROCESSING_STATUS' ).
    lo_primitive_property->set_edm_name( 'ProcessingStatus' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 2 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'RESPONSIBLE_COST_CENTER' ).
    lo_primitive_property->set_edm_name( 'ResponsibleCostCenter' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROFIT_CENTER' ).
    lo_primitive_property->set_edm_name( 'ProfitCenter' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_PROFILE_CODE' ).
    lo_primitive_property->set_edm_name( 'ProjectProfileCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 7 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FUNCTIONAL_AREA' ).
    lo_primitive_property->set_edm_name( 'FunctionalArea' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 16 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'COMPANY_CODE' ).
    lo_primitive_property->set_edm_name( 'CompanyCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CONTROLLING_AREA' ).
    lo_primitive_property->set_edm_name( 'ControllingArea' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PLANT' ).
    lo_primitive_property->set_edm_name( 'Plant' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LOCATION' ).
    lo_primitive_property->set_edm_name( 'Location' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'TAX_JURISDICTION' ).
    lo_primitive_property->set_edm_name( 'TaxJurisdiction' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 15 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_CURRENCY' ).
    lo_primitive_property->set_edm_name( 'ProjectCurrency' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 5 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'AVAILABILITY_CONTROL_PRO_2' ).
    lo_primitive_property->set_edm_name( 'AvailabilityControlProfile' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 6 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'AVAILABILITY_CONTROL_IS__2' ).
    lo_primitive_property->set_edm_name( 'AvailabilityControlIsActive' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FUNCTIONAL_LOCATION' ).
    lo_primitive_property->set_edm_name( 'FunctionalLocation' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 40 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'IS_BILLING_RELEVANT' ).
    lo_primitive_property->set_edm_name( 'IsBillingRelevant' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'INVESTMENT_PROFILE' ).
    lo_primitive_property->set_edm_name( 'InvestmentProfile' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 6 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LAST_CHANGE_DATE_TIME' ).
    lo_primitive_property->set_edm_name( 'LastChangeDateTime' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_LAST_CHANGED_DATE' ).
    lo_primitive_property->set_edm_name( 'ProjectLastChangedDateTime' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LAST_CHANGED_BY_USER' ).
    lo_primitive_property->set_edm_name( 'LastChangedByUser' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_IS_MULTI_SLS_OR_2' ).
    lo_primitive_property->set_edm_name( 'EntProjIsMultiSlsOrdItmsEnbld' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'RESULT_ANALYSIS_INTERNAL_2' ).
    lo_primitive_property->set_edm_name( 'ResultAnalysisInternalID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 6 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'COSTING_SHEET' ).
    lo_primitive_property->set_edm_name( 'CostingSheet' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 6 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CREATED_BY_USER' ).
    lo_primitive_property->set_edm_name( 'CreatedByUser' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CREATION_DATE_TIME' ).
    lo_primitive_property->set_edm_name( 'CreationDateTime' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENTERPRISE_PROJECT_EL_2' ).
    lo_navigation_property->set_edm_name( 'to_EnterpriseProjectElement' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_ELE_2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_many_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENTERPRISE_PROJECT_JVA' ).
    lo_navigation_property->set_edm_name( 'to_EnterpriseProjectJVA' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_JVATY' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENT_PROJECT_PUBLIC_SECT' ).
    lo_navigation_property->set_edm_name( 'to_EntProjectPublicSector' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENT_PROJECT_PUBLIC_SEC_2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENT_PROJ_BLK_FUNC' ).
    lo_navigation_property->set_edm_name( 'to_EntProjBlkFunc' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJ_BLK_FU_2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENT_PROJ_ROLE' ).
    lo_navigation_property->set_edm_name( 'to_EntProjRole' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_ROL_2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_many_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENT_PROJ_TEAM_MEMBER' ).
    lo_navigation_property->set_edm_name( 'to_EntProjTeamMember' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_TEA_2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_many_optional ).

  ENDMETHOD.


  METHOD def_a_enterprise_proj_blk_fu_2.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'A_ENTERPRISE_PROJ_BLK_FU_2'
                                    is_structure              = VALUE tys_a_enterprise_proj_blk_fu_2( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'A_EnterpriseProjBlkFuncType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'A_ENTERPRISE_PROJ_BLK_FUNC' ).
    lo_entity_set->set_edm_name( 'A_EnterpriseProjBlkFunc' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'UPDATE_MC' ).
    lo_primitive_property->set_edm_name( 'Update_mc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_TIME_RECG_IS_BLKD' ).
    lo_primitive_property->set_edm_name( 'EntProjTimeRecgIsBlkd' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_STAFF_EXPENSE_POS' ).
    lo_primitive_property->set_edm_name( 'EntProjStaffExpensePostgIsBlkd' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_SERVICE_POSTING_I' ).
    lo_primitive_property->set_edm_name( 'EntProjServicePostingIsBlkd' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_OTHER_EXPENSE_POS' ).
    lo_primitive_property->set_edm_name( 'EntProjOtherExpensePostgIsBlkd' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_PURCHASING_IS_BLK' ).
    lo_primitive_property->set_edm_name( 'EntProjPurchasingIsBlkd' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENTERPRISE_PROJECT' ).
    lo_navigation_property->set_edm_name( 'to_EnterpriseProject' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_TYPE' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

  ENDMETHOD.


  METHOD def_a_ent_project_element_jvat.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'A_ENT_PROJECT_ELEMENT_JVAT'
                                    is_structure              = VALUE tys_a_ent_project_element_jvat( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'A_EntProjectElementJVAType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'A_ENT_PROJECT_ELEMENT_JVA' ).
    lo_entity_set->set_edm_name( 'A_EntProjectElementJVA' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'JNT_INTRST_BILLG_CLASS_FC' ).
    lo_primitive_property->set_edm_name( 'JntIntrstBillgClass_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JNT_INTRST_BILLG_SUB_CLASS' ).
    lo_primitive_property->set_edm_name( 'JntIntrstBillgSubClass_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JNT_VNTR_PROJECT_TYPE_FC' ).
    lo_primitive_property->set_edm_name( 'JntVntrProjectType_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JOINT_VENTURE_FC' ).
    lo_primitive_property->set_edm_name( 'JointVenture_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JOINT_VENTURE_COST_RECOVER' ).
    lo_primitive_property->set_edm_name( 'JointVentureCostRecoveryCode_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JOINT_VENTURE_EQUITY_TYPE' ).
    lo_primitive_property->set_edm_name( 'JointVentureEquityType_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UPDATE_MC' ).
    lo_primitive_property->set_edm_name( 'Update_mc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_ELEMENT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectElementUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JOINT_VENTURE' ).
    lo_primitive_property->set_edm_name( 'JointVenture' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 6 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JOINT_VENTURE_COST_RECOV_2' ).
    lo_primitive_property->set_edm_name( 'JointVentureCostRecoveryCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 2 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JOINT_VENTURE_EQUITY_TYP_2' ).
    lo_primitive_property->set_edm_name( 'JointVentureEquityType' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JNT_VNTR_PROJECT_TYPE' ).
    lo_primitive_property->set_edm_name( 'JntVntrProjectType' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JNT_INTRST_BILLG_CLASS' ).
    lo_primitive_property->set_edm_name( 'JntIntrstBillgClass' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'JNT_INTRST_BILLG_SUB_CLA_2' ).
    lo_primitive_property->set_edm_name( 'JntIntrstBillgSubClass' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 5 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENTERPRISE_PROJECT' ).
    lo_navigation_property->set_edm_name( 'to_EnterpriseProject' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_TYPE' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENTERPRISE_PROJECT_ELEM' ).
    lo_navigation_property->set_edm_name( 'to_EnterpriseProjectElement' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_ELE_2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

  ENDMETHOD.


  METHOD def_a_ent_project_elmnt_publ_2.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'A_ENT_PROJECT_ELMNT_PUBL_2'
                                    is_structure              = VALUE tys_a_ent_project_elmnt_publ_2( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'A_EntProjectElmntPublicSectorType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'A_ENT_PROJECT_ELMNT_PUBLIC' ).
    lo_entity_set->set_edm_name( 'A_EntProjectElmntPublicSector' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'FUNCTIONAL_AREA_IS_FIX_ASS' ).
    lo_primitive_property->set_edm_name( 'FunctionalAreaIsFixAssigned_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FUND_FC' ).
    lo_primitive_property->set_edm_name( 'Fund_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FUND_IS_FIX_ASSIGNED_FC' ).
    lo_primitive_property->set_edm_name( 'FundIsFixAssigned_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'GRANT_ID_FC' ).
    lo_primitive_property->set_edm_name( 'GrantID_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'GRANT_IS_FIX_ASSIGNED_FC' ).
    lo_primitive_property->set_edm_name( 'GrantIsFixAssigned_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SPONSORED_PROGRAM_FC' ).
    lo_primitive_property->set_edm_name( 'SponsoredProgram_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UPDATE_MC' ).
    lo_primitive_property->set_edm_name( 'Update_mc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_ELEMENT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectElementUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FUND' ).
    lo_primitive_property->set_edm_name( 'Fund' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FUND_IS_FIX_ASSIGNED' ).
    lo_primitive_property->set_edm_name( 'FundIsFixAssigned' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FUNCTIONAL_AREA_IS_FIX_A_2' ).
    lo_primitive_property->set_edm_name( 'FunctionalAreaIsFixAssigned' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'GRANT_ID' ).
    lo_primitive_property->set_edm_name( 'GrantID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 20 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'GRANT_IS_FIX_ASSIGNED' ).
    lo_primitive_property->set_edm_name( 'GrantIsFixAssigned' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SPONSORED_PROGRAM' ).
    lo_primitive_property->set_edm_name( 'SponsoredProgram' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 20 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENTERPRISE_PROJECT' ).
    lo_navigation_property->set_edm_name( 'to_EnterpriseProject' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_TYPE' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENTERPRISE_PROJECT_ELEM' ).
    lo_navigation_property->set_edm_name( 'to_EnterpriseProjectElement' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_ELE_2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

  ENDMETHOD.


  METHOD def_a_ent_project_public_sec_2.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'A_ENT_PROJECT_PUBLIC_SEC_2'
                                    is_structure              = VALUE tys_a_ent_project_public_sec_2( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'A_EntProjectPublicSectorType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'A_ENT_PROJECT_PUBLIC_SECTO' ).
    lo_entity_set->set_edm_name( 'A_EntProjectPublicSector' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'FUNCTIONAL_AREA_IS_FIX_ASS' ).
    lo_primitive_property->set_edm_name( 'FunctionalAreaIsFixAssigned_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FUND_FC' ).
    lo_primitive_property->set_edm_name( 'Fund_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FUND_IS_FIX_ASSIGNED_FC' ).
    lo_primitive_property->set_edm_name( 'FundIsFixAssigned_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'GRANT_ID_FC' ).
    lo_primitive_property->set_edm_name( 'GrantID_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'GRANT_IS_FIX_ASSIGNED_FC' ).
    lo_primitive_property->set_edm_name( 'GrantIsFixAssigned_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SPONSORED_PROGRAM_FC' ).
    lo_primitive_property->set_edm_name( 'SponsoredProgram_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UPDATE_MC' ).
    lo_primitive_property->set_edm_name( 'Update_mc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FUND' ).
    lo_primitive_property->set_edm_name( 'Fund' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FUND_IS_FIX_ASSIGNED' ).
    lo_primitive_property->set_edm_name( 'FundIsFixAssigned' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FUNCTIONAL_AREA_IS_FIX_A_2' ).
    lo_primitive_property->set_edm_name( 'FunctionalAreaIsFixAssigned' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'GRANT_ID' ).
    lo_primitive_property->set_edm_name( 'GrantID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 20 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'GRANT_IS_FIX_ASSIGNED' ).
    lo_primitive_property->set_edm_name( 'GrantIsFixAssigned' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SPONSORED_PROGRAM' ).
    lo_primitive_property->set_edm_name( 'SponsoredProgram' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 20 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENTERPRISE_PROJECT' ).
    lo_navigation_property->set_edm_name( 'to_EnterpriseProject' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_TYPE' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

  ENDMETHOD.


  METHOD def_a_ent_proj_elmnt_block_f_2.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'A_ENT_PROJ_ELMNT_BLOCK_F_2'
                                    is_structure              = VALUE tys_a_ent_proj_elmnt_block_f_2( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'A_EntProjElmntBlockFuncType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'A_ENT_PROJ_ELMNT_BLOCK_FUN' ).
    lo_entity_set->set_edm_name( 'A_EntProjElmntBlockFunc' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_OTHER_EXPENSE_POS' ).
    lo_primitive_property->set_edm_name( 'EntProjOtherExpensePostgIsBlkd_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_PURCHASING_IS_BLK' ).
    lo_primitive_property->set_edm_name( 'EntProjPurchasingIsBlkd_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_SERVICE_POSTING_I' ).
    lo_primitive_property->set_edm_name( 'EntProjServicePostingIsBlkd_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_STAFF_EXPENSE_POS' ).
    lo_primitive_property->set_edm_name( 'EntProjStaffExpensePostgIsBlkd_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_TIME_RECG_IS_BLKD' ).
    lo_primitive_property->set_edm_name( 'EntProjTimeRecgIsBlkd_fc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UPDATE_MC' ).
    lo_primitive_property->set_edm_name( 'Update_mc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_ELEMENT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectElementUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_TIME_RECG_IS_BL_2' ).
    lo_primitive_property->set_edm_name( 'EntProjTimeRecgIsBlkd' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_STAFF_EXPENSE_P_2' ).
    lo_primitive_property->set_edm_name( 'EntProjStaffExpensePostgIsBlkd' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_SERVICE_POSTING_2' ).
    lo_primitive_property->set_edm_name( 'EntProjServicePostingIsBlkd' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_OTHER_EXPENSE_P_2' ).
    lo_primitive_property->set_edm_name( 'EntProjOtherExpensePostgIsBlkd' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_PURCHASING_IS_B_2' ).
    lo_primitive_property->set_edm_name( 'EntProjPurchasingIsBlkd' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENTERPRISE_PROJECT' ).
    lo_navigation_property->set_edm_name( 'to_EnterpriseProject' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_TYPE' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENTERPRISE_PROJECT_ELEM' ).
    lo_navigation_property->set_edm_name( 'to_EnterpriseProjectElement' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_ELE_2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

  ENDMETHOD.


  METHOD def_a_ent_proj_elmnt_cnfgrd__2.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'A_ENT_PROJ_ELMNT_CNFGRD__2'
                                    is_structure              = VALUE tys_a_ent_proj_elmnt_cnfgrd__2( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'A_EntProjElmntCnfgrdWrkItmTxtType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'A_ENT_PROJ_ELMNT_CNFGRD_WR' ).
    lo_entity_set->set_edm_name( 'A_EntProjElmntCnfgrdWrkItmTxt' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_WORK_ITEM' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntWorkItem' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LANGUAGE' ).
    lo_primitive_property->set_edm_name( 'Language' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 2 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_CNFGRD_WRK' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntCnfgrdWrkItmName' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 40 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

  ENDMETHOD.


  METHOD def_a_ent_proj_elmnt_dlvbrl_ty.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'A_ENT_PROJ_ELMNT_DLVBRL_TY'
                                    is_structure              = VALUE tys_a_ent_proj_elmnt_dlvbrl_ty( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'A_EntProjElmntDlvbrlType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'A_ENT_PROJ_ELMNT_DLVBRL' ).
    lo_entity_set->set_edm_name( 'A_EntProjElmntDlvbrl' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'UPDATE_MC' ).
    lo_primitive_property->set_edm_name( 'Update_mc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'TO_ENT_PROJ_ELMNT_DLV_DIST' ).
    lo_primitive_property->set_edm_name( 'to_EntProjElmntDlvDistr_oc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_DELIVERABLE' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntDeliverableUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_ELEMENT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectElementUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_DELIVERAB_2' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntDeliverableType' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 6 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_DLVBRL_QUAN' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntDlvbrlQuantity' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Decimal' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 23 ) ##NUMBER_OK.
    lo_primitive_property->set_scale( 2 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_DLVBRL_QU_2' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntDlvbrlQuantityUnit' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CREATED_BY_USER' ).
    lo_primitive_property->set_edm_name( 'CreatedByUser' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CREATION_DATE_TIME' ).
    lo_primitive_property->set_edm_name( 'CreationDateTime' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LAST_CHANGE_DATE_TIME' ).
    lo_primitive_property->set_edm_name( 'LastChangeDateTime' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LAST_CHANGED_BY_USER' ).
    lo_primitive_property->set_edm_name( 'LastChangedByUser' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENTERPRISE_PROJECT_ELEM' ).
    lo_navigation_property->set_edm_name( 'to_EnterpriseProjectElement' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_ELE_2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENT_PROJ_ELMNT_DLV_DI_2' ).
    lo_navigation_property->set_edm_name( 'to_EntProjElmntDlvDistr' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENT_PROJ_ELMNT_DLVBRL__2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_many_optional ).

  ENDMETHOD.


  METHOD def_a_ent_proj_elmnt_dlvbrl__2.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'A_ENT_PROJ_ELMNT_DLVBRL__2'
                                    is_structure              = VALUE tys_a_ent_proj_elmnt_dlvbrl__2( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'A_EntProjElmntDlvbrlDistrType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'A_ENT_PROJ_ELMNT_DLVBRL_DI' ).
    lo_entity_set->set_edm_name( 'A_EntProjElmntDlvbrlDistr' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'UPDATE_MC' ).
    lo_primitive_property->set_edm_name( 'Update_mc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_DLVBRL_DIST' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntDlvbrlDistrUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_DELIVERABLE' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntDeliverableUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_ELEMENT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectElementUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_DLVBRL_DI_2' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntDlvbrlDistrYearVal' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_DLVBRL_DI_3' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntDlvbrlDistrPerdVal' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_DLVBRL_DI_4' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntDlvbrlDistrQty' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Decimal' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 23 ) ##NUMBER_OK.
    lo_primitive_property->set_scale( 2 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_DLVBRL_DI_5' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntDlvbrlDistrQtyUnit' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENT_PROJ_ELMNT_DLVBRL' ).
    lo_navigation_property->set_edm_name( 'to_EntProjElmntDlvbrl' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENT_PROJ_ELMNT_DLVBRL_TY' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

  ENDMETHOD.


  METHOD def_a_ent_proj_elmnt_work_it_2.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'A_ENT_PROJ_ELMNT_WORK_IT_2'
                                    is_structure              = VALUE tys_a_ent_proj_elmnt_work_it_2( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'A_EntProjElmntWorkItemType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'A_ENT_PROJ_ELMNT_WORK_ITEM' ).
    lo_entity_set->set_edm_name( 'A_EntProjElmntWorkItem' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'DELETE_MC' ).
    lo_primitive_property->set_edm_name( 'Delete_mc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UPDATE_MC' ).
    lo_primitive_property->set_edm_name( 'Update_mc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_WORK_ITEM_U' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntWorkItemUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_WORK_ITEM' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntWorkItem' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_WORK_ITEM_N' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntWorkItemName' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 40 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_WORK_ITEM_I' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntWorkItemIsInactive' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_WORK_ITEM_2' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntWorkItemIsCnfgrd' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_ELEMENT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectElementUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_WRK_ITM_LAS' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntWrkItmLastUpdtSrce' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 1 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_WRK_ITM_CRT' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntWrkItmCrtedByUsr' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_WRK_ITM_C_2' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntWrkItmCrtnDteTme' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_WRK_ITM_LST' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntWrkItmLstChgByUsr' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENT_PROJ_ELMNT_WRK_ITM_L_2' ).
    lo_primitive_property->set_edm_name( 'EntProjElmntWrkItmLstChgDteTme' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_CONFIGURED_WORK_ITEM_TE' ).
    lo_navigation_property->set_edm_name( 'to_ConfiguredWorkItemText' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENT_PROJ_ELMNT_CNFGRD__2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_many_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENTERPRISE_PROJECT' ).
    lo_navigation_property->set_edm_name( 'to_EnterpriseProject' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_TYPE' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENTERPRISE_PROJECT_ELEM' ).
    lo_navigation_property->set_edm_name( 'to_EnterpriseProjectElement' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_ELE_2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

  ENDMETHOD.


  METHOD def_a_ent_team_member_entitl_2.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'A_ENT_TEAM_MEMBER_ENTITL_2'
                                    is_structure              = VALUE tys_a_ent_team_member_entitl_2( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'A_EntTeamMemberEntitlementType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'A_ENT_TEAM_MEMBER_ENTITLEM' ).
    lo_entity_set->set_edm_name( 'A_EntTeamMemberEntitlement' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'DELETE_MC' ).
    lo_primitive_property->set_edm_name( 'Delete_mc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UPDATE_MC' ).
    lo_primitive_property->set_edm_name( 'Update_mc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_ENTITLEMENT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectEntitlementUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_ROLE_UUID' ).
    lo_primitive_property->set_edm_name( 'ProjectRoleUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'TEAM_MEMBER_UUID' ).
    lo_primitive_property->set_edm_name( 'TeamMemberUUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROJECT_ROLE_TYPE' ).
    lo_primitive_property->set_edm_name( 'ProjectRoleType' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 15 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CREATED_BY_USER' ).
    lo_primitive_property->set_edm_name( 'CreatedByUser' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CREATION_DATE_TIME' ).
    lo_primitive_property->set_edm_name( 'CreationDateTime' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LAST_CHANGED_BY_USER' ).
    lo_primitive_property->set_edm_name( 'LastChangedByUser' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LAST_CHANGE_DATE_TIME' ).
    lo_primitive_property->set_edm_name( 'LastChangeDateTime' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ENTERPRISE_PROJECT' ).
    lo_navigation_property->set_edm_name( 'to_EnterpriseProject' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_TYPE' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ROLE' ).
    lo_navigation_property->set_edm_name( 'to_Role' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_ROL_2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_TEAM_MEMBER' ).
    lo_navigation_property->set_edm_name( 'to_TeamMember' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_ENTERPRISE_PROJECT_TEA_2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

  ENDMETHOD.


  METHOD def_change_ent_proj_elmnt_posi.

    DATA:
      lo_function        TYPE REF TO /iwbep/if_v4_pm_function,
      lo_function_import TYPE REF TO /iwbep/if_v4_pm_func_imp,
      lo_parameter       TYPE REF TO /iwbep/if_v4_pm_func_param,
      lo_return          TYPE REF TO /iwbep/if_v4_pm_func_return.


    lo_function = mo_model->create_function( 'CHANGE_ENT_PROJ_ELMNT_POSI' ).
    lo_function->set_edm_name( 'ChangeEntProjElmntPosition' ) ##NO_TEXT.

    " Name of the runtime structure that represents the parameters of this operation
    lo_function->/iwbep/if_v4_pm_fu_advanced~set_parameter_structure_info( VALUE tys_parameters_1( ) ).

    lo_function_import = lo_function->create_function_import( 'CHANGE_ENT_PROJ_ELMNT_POSI' ).
    lo_function_import->set_edm_name( 'ChangeEntProjElmntPosition' ) ##NO_TEXT.
    lo_function_import->/iwbep/if_v4_pm_func_imp_v2~set_http_method( 'POST' ).


    lo_parameter = lo_function->create_parameter( 'PROJECT_ELEMENT_UUID' ).
    lo_parameter->set_edm_name( 'ProjectElementUUID' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'PROJECT_ELEMENT_UUID' ).
    lo_parameter->set_is_nullable( ).

    lo_parameter = lo_function->create_parameter( 'PARENT_OBJECT_UUID' ).
    lo_parameter->set_edm_name( 'ParentObjectUUID' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'PARENT_OBJECT_UUID' ).
    lo_parameter->set_is_nullable( ).

    lo_parameter = lo_function->create_parameter( 'LEFT_SIBLING_UUID' ).
    lo_parameter->set_edm_name( 'LeftSiblingUUID' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'LEFT_SIBLING_UUID' ).
    lo_parameter->set_is_nullable( ).

    lo_return = lo_function->create_return( ).
    lo_return->set_entity_type( 'A_ENTERPRISE_PROJECT_ELE_2' ).

  ENDMETHOD.


  METHOD def_change_ent_proj_elmnt_proc.

    DATA:
      lo_function        TYPE REF TO /iwbep/if_v4_pm_function,
      lo_function_import TYPE REF TO /iwbep/if_v4_pm_func_imp,
      lo_parameter       TYPE REF TO /iwbep/if_v4_pm_func_param,
      lo_return          TYPE REF TO /iwbep/if_v4_pm_func_return.


    lo_function = mo_model->create_function( 'CHANGE_ENT_PROJ_ELMNT_PROC' ).
    lo_function->set_edm_name( 'ChangeEntProjElmntProcgStatus' ) ##NO_TEXT.

    " Name of the runtime structure that represents the parameters of this operation
    lo_function->/iwbep/if_v4_pm_fu_advanced~set_parameter_structure_info( VALUE tys_parameters_2( ) ).

    lo_function_import = lo_function->create_function_import( 'CHANGE_ENT_PROJ_ELMNT_PROC' ).
    lo_function_import->set_edm_name( 'ChangeEntProjElmntProcgStatus' ) ##NO_TEXT.
    lo_function_import->/iwbep/if_v4_pm_func_imp_v2~set_http_method( 'POST' ).


    lo_parameter = lo_function->create_parameter( 'PROJECT_ELEMENT_UUID' ).
    lo_parameter->set_edm_name( 'ProjectElementUUID' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'PROJECT_ELEMENT_UUID_2' ).
    lo_parameter->set_is_nullable( ).

    lo_parameter = lo_function->create_parameter( 'PROCESSING_STATUS' ).
    lo_parameter->set_edm_name( 'ProcessingStatus' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'PROCESSING_STATUS' ).
    lo_parameter->set_is_nullable( ).

    lo_return = lo_function->create_return( ).
    lo_return->set_entity_type( 'A_ENTERPRISE_PROJECT_ELE_2' ).

  ENDMETHOD.


  METHOD def_change_ent_proj_procg_stat.

    DATA:
      lo_function        TYPE REF TO /iwbep/if_v4_pm_function,
      lo_function_import TYPE REF TO /iwbep/if_v4_pm_func_imp,
      lo_parameter       TYPE REF TO /iwbep/if_v4_pm_func_param,
      lo_return          TYPE REF TO /iwbep/if_v4_pm_func_return.


    lo_function = mo_model->create_function( 'CHANGE_ENT_PROJ_PROCG_STAT' ).
    lo_function->set_edm_name( 'ChangeEntProjProcgStatus' ) ##NO_TEXT.

    " Name of the runtime structure that represents the parameters of this operation
    lo_function->/iwbep/if_v4_pm_fu_advanced~set_parameter_structure_info( VALUE tys_parameters_3( ) ).

    lo_function_import = lo_function->create_function_import( 'CHANGE_ENT_PROJ_PROCG_STAT' ).
    lo_function_import->set_edm_name( 'ChangeEntProjProcgStatus' ) ##NO_TEXT.
    lo_function_import->/iwbep/if_v4_pm_func_imp_v2~set_http_method( 'POST' ).


    lo_parameter = lo_function->create_parameter( 'PROJECT_UUID' ).
    lo_parameter->set_edm_name( 'ProjectUUID' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'PROJECT_UUID' ).
    lo_parameter->set_is_nullable( ).

    lo_parameter = lo_function->create_parameter( 'PROCESSING_STATUS' ).
    lo_parameter->set_edm_name( 'ProcessingStatus' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'PROCESSING_STATUS_2' ).
    lo_parameter->set_is_nullable( ).

    lo_return = lo_function->create_return( ).
    lo_return->set_entity_type( 'A_ENTERPRISE_PROJECT_TYPE' ).

  ENDMETHOD.


  METHOD def_change_period_distribution.

    DATA:
      lo_function        TYPE REF TO /iwbep/if_v4_pm_function,
      lo_function_import TYPE REF TO /iwbep/if_v4_pm_func_imp,
      lo_parameter       TYPE REF TO /iwbep/if_v4_pm_func_param,
      lo_return          TYPE REF TO /iwbep/if_v4_pm_func_return.


    lo_function = mo_model->create_function( 'CHANGE_PERIOD_DISTRIBUTION' ).
    lo_function->set_edm_name( 'ChangePeriodDistributionOption' ) ##NO_TEXT.

    " Name of the runtime structure that represents the parameters of this operation
    lo_function->/iwbep/if_v4_pm_fu_advanced~set_parameter_structure_info( VALUE tys_parameters_4( ) ).

    lo_function_import = lo_function->create_function_import( 'CHANGE_PERIOD_DISTRIBUTION' ).
    lo_function_import->set_edm_name( 'ChangePeriodDistributionOption' ) ##NO_TEXT.
    lo_function_import->/iwbep/if_v4_pm_func_imp_v2~set_http_method( 'POST' ).


    lo_parameter = lo_function->create_parameter( 'PROJECT_ELEMENT_UUID' ).
    lo_parameter->set_edm_name( 'ProjectElementUUID' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'PROJECT_ELEMENT_UUID_3' ).
    lo_parameter->set_is_nullable( ).

    lo_parameter = lo_function->create_parameter( 'PLANNED_START_DATE' ).
    lo_parameter->set_edm_name( 'PlannedStartDate' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'PLANNED_START_DATE' ).
    lo_parameter->set_is_nullable( ).

    lo_parameter = lo_function->create_parameter( 'PLANNED_END_DATE' ).
    lo_parameter->set_edm_name( 'PlannedEndDate' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'PLANNED_END_DATE' ).
    lo_parameter->set_is_nullable( ).

    lo_parameter = lo_function->create_parameter( 'ENT_PROJ_ELMNT_DISTRIBUTIO' ).
    lo_parameter->set_edm_name( 'EntProjElmntDistributionOption' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'ENT_PROJ_ELMNT_DISTRIBUTIO' ).
    lo_parameter->set_is_nullable( ).

    lo_return = lo_function->create_return( ).
    lo_return->set_entity_type( 'A_ENTERPRISE_PROJECT_ELE_2' ).

  ENDMETHOD.


  METHOD def_copy_to_active_document.

    DATA:
      lo_function        TYPE REF TO /iwbep/if_v4_pm_function,
      lo_function_import TYPE REF TO /iwbep/if_v4_pm_func_imp,
      lo_parameter       TYPE REF TO /iwbep/if_v4_pm_func_param,
      lo_return          TYPE REF TO /iwbep/if_v4_pm_func_return.


    lo_function = mo_model->create_function( 'COPY_TO_ACTIVE_DOCUMENT' ).
    lo_function->set_edm_name( 'CopyToActiveDocument' ) ##NO_TEXT.

    " Name of the runtime structure that represents the parameters of this operation
    lo_function->/iwbep/if_v4_pm_fu_advanced~set_parameter_structure_info( VALUE tys_parameters_5( ) ).

    lo_function_import = lo_function->create_function_import( 'COPY_TO_ACTIVE_DOCUMENT' ).
    lo_function_import->set_edm_name( 'CopyToActiveDocument' ) ##NO_TEXT.
    lo_function_import->/iwbep/if_v4_pm_func_imp_v2~set_http_method( 'POST' ).


    lo_parameter = lo_function->create_parameter( 'PROJECT_UUID' ).
    lo_parameter->set_edm_name( 'ProjectUUID' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'PROJECT_UUID_2' ).
    lo_parameter->set_is_nullable( ).

    lo_parameter = lo_function->create_parameter( 'ENT_PROJ_DEMAND_COPY_IS_RE' ).
    lo_parameter->set_edm_name( 'EntProjDemandCopyIsRequested' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'ENT_PROJ_DEMAND_COPY_IS_RE' ).
    lo_parameter->set_is_nullable( ).

    lo_parameter = lo_function->create_parameter( 'ENT_PROJ_SETTLMT_RULE_CPY' ).
    lo_parameter->set_edm_name( 'EntProjSettlmtRuleCpyIsReqd' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'ENT_PROJ_SETTLMT_RULE_CPY' ).
    lo_parameter->set_is_nullable( ).

    lo_parameter = lo_function->create_parameter( 'PROJECT' ).
    lo_parameter->set_edm_name( 'Project' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'PROJECT' ).
    lo_parameter->set_is_nullable( ).

    lo_parameter = lo_function->create_parameter( 'PROJECT_NAME' ).
    lo_parameter->set_edm_name( 'ProjectName' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'PROJECT_NAME' ).
    lo_parameter->set_is_nullable( ).

    lo_parameter = lo_function->create_parameter( 'PROJECT_START_DATE' ).
    lo_parameter->set_edm_name( 'ProjectStartDate' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'PROJECT_START_DATE' ).
    lo_parameter->set_is_nullable( ).

    lo_parameter = lo_function->create_parameter( 'PROJECT_END_DATE' ).
    lo_parameter->set_edm_name( 'ProjectEndDate' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'PROJECT_END_DATE' ).
    lo_parameter->set_is_nullable( ).

    lo_parameter = lo_function->create_parameter( 'CUSTOMER_UUID' ).
    lo_parameter->set_edm_name( 'CustomerUUID' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'CUSTOMER_UUID' ).
    lo_parameter->set_is_nullable( ).

    lo_parameter = lo_function->create_parameter( 'ENTERPRISE_PROJECT_SERVICE' ).
    lo_parameter->set_edm_name( 'EnterpriseProjectServiceOrg' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'ENTERPRISE_PROJECT_SERVICE' ).
    lo_parameter->set_is_nullable( ).

    lo_parameter = lo_function->create_parameter( 'RESPONSIBLE_COST_CENTER' ).
    lo_parameter->set_edm_name( 'ResponsibleCostCenter' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'RESPONSIBLE_COST_CENTER' ).
    lo_parameter->set_is_nullable( ).

    lo_parameter = lo_function->create_parameter( 'PROJECT_MANAGER_UUID' ).
    lo_parameter->set_edm_name( 'ProjectManagerUUID' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'PROJECT_MANAGER_UUID' ).
    lo_parameter->set_is_nullable( ).

    lo_parameter = lo_function->create_parameter( 'PROJECT_CURRENCY' ).
    lo_parameter->set_edm_name( 'ProjectCurrency' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'PROJECT_CURRENCY' ).
    lo_parameter->set_is_nullable( ).

    lo_parameter = lo_function->create_parameter( 'ENT_PROJECT_IS_CONFIDENTIA' ).
    lo_parameter->set_edm_name( 'EntProjectIsConfidential' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'ENT_PROJECT_IS_CONFIDENTIA' ).
    lo_parameter->set_is_nullable( ).

    lo_parameter = lo_function->create_parameter( 'RESTRICTED_TIME_POSTING' ).
    lo_parameter->set_edm_name( 'RestrictedTimePosting' ) ##NO_TEXT.
    lo_parameter->set_primitive_type( 'RESTRICTED_TIME_POSTING' ).
    lo_parameter->set_is_nullable( ).

    lo_return = lo_function->create_return( ).
    lo_return->set_entity_type( 'A_ENTERPRISE_PROJECT_TYPE' ).

  ENDMETHOD.
ENDCLASS.
