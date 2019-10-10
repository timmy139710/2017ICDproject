redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
clearClockDomains
setClockDomains -all
timeDesign -prePlace -idealClock -pathReports -drvReports -slackReports -numPaths 50 -prefix SET_prePlace -outDir timingReports
setPlaceMode -fp false
placeDesign -inPlaceOpt -noPrePlaceOpt
refinePlace -checkRoute 0 -honorSoftBlockage 0 -preserveRouting 0 -rmAffectedRouting 0 -swapEEQ 0 -checkPinLayerForAccess 1
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
clearClockDomains
setClockDomains -all
timeDesign -preCTS -idealClock -pathReports -drvReports -slackReports -numPaths 50 -prefix SET_preCTS -outDir timingReports
