getIoFlowFlag
setIoFlowFlag 0
floorPlan -site TSM13SITE -r 1 0.8 40 40 40 40
uiSetTool select
getIoFlowFlag
fit
setIoFlowFlag 0
floorPlan -site TSM13SITE -r 0.953747789416 0.799991 40.02 40.18 40.0 40.0
uiSetTool select
getIoFlowFlag
fit
setPlaceMode -fp true
placeDesign -noPrePlaceOpt
setDrawView place
