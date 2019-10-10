redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
clearClockDomains
setClockDomains -all
timeDesign -preCTS -idealClock -pathReports -drvReports -slackReports -numPaths 50 -prefix SET_preCTS -outDir timingReports
setTieHiLoMode -reset
setTieHiLoMode -cell {  TIEHI TIELO } -maxDistance 100 -maxFanOut 10 -honorDontTouch false -createHierPort false
addTieHiLo -cell {TIEHI TIELO} -prefix LTIE
