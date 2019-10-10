clearGlobalNets
globalNetConnect VDD -type pgpin -pin VDD -inst *
globalNetConnect VSS -type pgpin -pin VSS -inst *
globalNetConnect VDD -type tiehi -pin VSS -inst *
globalNetConnect VSS -type tielo -pin VSS -inst *
