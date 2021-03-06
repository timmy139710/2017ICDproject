saveNetlist imgproc_APR.v
write_sdf imgproc_APR.sdf
setNanoRouteMode -quiet -routeAntennaCellName {}
setStreamOutMode -specifyViaName default -SEvianames false -virtualConnection false -uniquifyCellNamesPrefix false -snapToMGrid false -textSize 1 -version 3
setTieHiLoMode -reset
setTieHiLoMode -cell {TIEHI TIELO} -maxDistance 100 -maxFanOut 10 -honorDontTouch false -createHierPort false
streamOut imgproc.gds -mapFile ../library/streamOut.map -libName DesignLib -merge { ../library/gds/tpz013g3_v1.1.gds ../library/gds/tsmc13gfsg_fram.gds } -outputMacros -units 1000 -mode ALL
