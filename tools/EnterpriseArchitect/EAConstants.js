/*
 * Script Name: EAConstants-JScript.js
 * Author: Sparx Systems
 * Purpose: Provides constant values for the Enterprise Architect automation API. 
 * Date: 2010-05-31
 */

// =================================================================================================
// ObjectType
// See http://www.sparxsystems.com/uml_tool_guide/sdk_for_enterprise_architect/objecttypeenum.htm
// =================================================================================================
var otNone 							= 0;
var otProject 						= 1;
var otRepository 					= 2;
var otCollection 					= 3;
var otElement 						= 4;
var otPackage 						= 5;
var otModel 						= 6;
var otConnector 					= 7;
var otDiagram 						= 8;
var otRequirement 					= 9;
var otScenario 						= 10;
var otConstraint 					= 11;
var otTaggedValue 					= 12;
var otFile 							= 13;
var otEffort 						= 14;
var otMetric 						= 15;
var otIssue 						= 16;
var otRisk 							= 17;
var otTest 							= 18;
var otDiagramObject 				= 19;
var otDiagramLink 					= 20;
var otResource 						= 21;
var otConnectorEnd 					= 22;
var otAttribute 					= 23;
var otMethod 						= 24;
var otParameter 					= 25;
var otClient 						= 26;
var otAuthor 						= 27;
var otDatatype 						= 28;
var otStereotype 					= 29;
var otTask 							= 30;
var otTerm 							= 31;
var otProjectIssues 				= 32;
var otAttributeConstraint 			= 33;
var otAttributeTag 					= 34;
var otMethodConstraint 				= 35;
var otMethodTag 					= 36;
var otConnectorConstraint 			= 37;
var otConnectorTag 					= 38;
var otProjectResource 				= 39;
var otReference 					= 40;
var otRoleTag						= 41;
var otCustomProperty 				= 42;
var otPartition 					= 43;
var otTransition 					= 44;
var otEventProperty 				= 45;
var otEventProperties 				= 46;
var otPropertyType 					= 47;
var otProperties 					= 48;
var otProperty 						= 49;
var otSwimlaneDef 					= 50;
var otSwimlanes 					= 51;
var otSwimlane 						= 52;
var otModelWatcher 					= 53;
var otScenarioStep 					= 54;
var otScenarioExtension 			= 55;

// =================================================================================================
// MDGMenus
// See http://www.sparxsystems.com/uml_tool_guide/sdk_for_enterprise_architect/mdgmenusenum.htm
// =================================================================================================
var mgMerge 						= 1;
var mgBuildProject 					= 2;
var mgRun 							= 4;

// =================================================================================================
// EnumXMIType
// See http://www.sparxsystems.com/uml_tool_guide/sdk_for_enterprise_architect/xmitypeenum.htm
// =================================================================================================
var xmiEADefault 					= 0;
var xmiRoseDefault 					= 1;
var xmiEA10 						= 2;
var xmiEA11 						= 3;
var xmiEA12 						= 4;
var xmiRose10 						= 5;
var xmiRose11 						= 6;
var xmiRose12 						= 7;
var xmiMOF13 						= 8;
var xmiMOF14 						= 9;
var xmiEA20 						= 10;
var xmiEA21 						= 11;

// =================================================================================================
// EnumMVErrorType
// See http://www.sparxsystems.com/uml_tool_guide/sdk_for_enterprise_architect/project_2.htm
// =================================================================================================
var mvError 						= 0;
var mvWarning 						= 1;
var mvInformation 					= 2;
var mvErrorCritical 				= 3;

// =================================================================================================
// CreateModelType
// See http://www.sparxsystems.com/uml_tool_guide/sdk_for_enterprise_architect/createmodelitype_enum.htm
// =================================================================================================
var cmEAPFromBase 					= 0;
var cmEAPFromSQLRepository 			= 1;

// =================================================================================================
// EAEditionTypes
// See http://www.sparxsystems.com/uml_tool_guide/sdk_for_enterprise_architect/eaeditiontypes_enum.htm
// =================================================================================================
var piLite 							= -1;
var piDesktop 						= 0;
var piProfessional 					= 1;
var piCorporate 					= 2;
var piBusiness 						= 3;
var piSystemEng 					= 4;
var piUltimate 						= 5;

// =================================================================================================
// ScenarioStepType
// See http://www.sparxsystems.com/uml_tool_guide/sdk_for_enterprise_architect/scenariosteptype.htm
// =================================================================================================
var stSystem 						= 0;
var stActor 						= 1;

// =================================================================================================
// ExportPackageXMIFlag
// See http://www.sparxsystems.com/uml_tool_guide/sdk_for_enterprise_architect/exportpackagexmiflag.htm
// =================================================================================================
var epSaveToStub					= 1;

// =================================================================================================
// CreateBaselineFlag
// See http://www.sparxsystems.com/uml_tool_guide/sdk_for_enterprise_architect/createbaselineflag.htm
// =================================================================================================
var cbSaveToStub					= 1;

// =================================================================================================
// EnumScenarioDiagramType
// See http://www.sparxsystems.com/uml_tool_guide/sdk_for_enterprise_architect/project_2.htm
// =================================================================================================
var sdActivity 						= 0;
var sdActivityWithActivityParameter	= 1;
var sdActivityWithAction			= 2;
var sdActivityhWithActionPin 		= 3;
var sdRuleFlow						= 4;
var sdState							= 5;
var sdSequence						= 6;
var sdRobustness					= 7;

// =================================================================================================
// EnumScenarioTestType
// See http://www.sparxsystems.com/uml_tool_guide/sdk_for_enterprise_architect/project_2.htm
// =================================================================================================
var stInternal						= 0;
var stExternal						= 1;

// =================================================================================================
// EnumCodeSection
// =================================================================================================
var cpWhole 						= 0;
var cpNotes 						= 1;
var cpText 							= 2;

// =================================================================================================
// EnumRelationSetType
// See http://www.sparxsystems.com/uml_tool_guide/sdk_for_enterprise_architect/enumrelationsettypeenum.htm
// =================================================================================================
var rsGeneralizeStart				= 0;
var rsGeneralizeEnd					= 1;
var rsRealizeStart					= 2;
var rsRealizeEnd					= 3;
var rsDependStart					= 4;
var rsDependEnd						= 5;
var rsParents						= 6;

// =================================================================================================
// EnumCodeElementType
// =================================================================================================
var ctInvalid						= 0;
var ctNamespace						= 1;
var ctClass							= 2;
var ctAttribute						= 3;
var ctOperation						= 4;
var ctOperationParam				= 5;

// =================================================================================================
// PropType
// See http://www.sparxsystems.com/uml_tool_guide/sdk_for_enterprise_architect/proptype_enum.htm
// =================================================================================================
var ptString						= 0;
var ptInteger						= 1;
var ptFloatingPoint					= 2;
var ptBoolean						= 3;
var ptEnum							= 4;
var ptArray							= 5;

// =================================================================================================
// SwimlaneOrientationType
// =================================================================================================
var soVertical						= 0;
var soHorizontal					= 1;

// =================================================================================================
// ReloadType
// See http://www.sparxsystems.com/uml_tool_guide/sdk_for_enterprise_architect/reloadtype_enum.htm
// =================================================================================================
var rtNone							= 0;
var rtEntireModel					= 1;
var rtPackage						= 2;
var rtElement						= 3;

// =================================================================================================
// ConstLayoutStyles
// See http://www.sparxsystems.com/uml_tool_guide/sdk_for_enterprise_architect/constlayoutstylesenum.htm
// =================================================================================================
var lsDiagramDefault				= 0x00000000;
var lsProgramDefault				= 0xFFFFFFFF;
var lsCycleRemoveGreedy				= 0x80000000;
var lsCycleRemoveDFS				= 0x40000000;
var lsLayeringLongestPathSink		= 0x30000000;
var lsLayeringLongestPathSource		= 0x20000000;
var lsLayeringOptimalLinkLength		= 0x10000000;
var lsInitializeNaive				= 0x08000000;
var lsInitializeDFSOut				= 0x04000000;
var lsInitializeDFSIn				= 0x0C000000;
var lsCrossReduceAggressive			= 0x02000000;
var lsLayoutDirectionUp				= 0x00010000;
var lsLayoutDirectionDown			= 0x00020000;
var lsLayoutDirectionLeft			= 0x00040000;
var lsLayoutDirectionRight			= 0x00080000;

// =================================================================================================
// WorkFlowConstants
// =================================================================================================
var MaxWorkFlowUsers				= 50;
var MaxWorkFlowItems				= 100;

// =================================================================================================
// PromptType
// =================================================================================================
var promptOK						= 1;
var promptYESNO						= 2;
var promptYESNOCANCEL				= 3;
var promptOKCANCEL					= 4;

// =================================================================================================
// PromptResult
// =================================================================================================
var resultOK						= 1;
var resultCancel					= 2;
var resultYes						= 3;
var resultNo						= 4;

// =================================================================================================
// WorkFlowResult
// =================================================================================================
var WorkFlowSucceeded				= 1;
var WorkFlowError					= 2;
var WorkFlowExists					= 3;
var WorkFlowNotFound				= 4;
var WorkFlowLimitReached			= 5;
var WorkFlowDenied					= 6;
var WorkFlowPermitted				= 7;
var WorkFlowIsMember				= 8;
var WorkFlowIsNotMember				= 9;
var WorkFlowBadParam				= 10;
