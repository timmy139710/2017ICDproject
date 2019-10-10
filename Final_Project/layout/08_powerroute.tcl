sroute -connect { corePin } -layerChangeRange { METAL1 METAL8 } -blockPinTarget { nearestTarget } -checkAlignedSecondaryPin 1 -allowJogging 1 -crossoverViaBottomLayer METAL1 -allowLayerChange 1 -targetViaTopLayer METAL8 -crossoverViaTopLayer METAL8 -targetViaBottomLayer METAL1 -nets { VSS VDD }
refinePlace -checkRoute 0 -honorSoftBlockage 0 -preserveRouting 0 -rmAffectedRouting 0 -swapEEQ 0 -checkPinLayerForAccess 1
verifyConnectivity -type special -noUnroutedNet -error 1000 -warning 50
