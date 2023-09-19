# COMSOL-MATLAB-livelink
These are the .m file of COMSOL optimization study automated by MATLAB livelink.

Since in the paper, a sweep is performed across different piezoresistor aspect ratio with fixed area.
The length and width of the piezoresistor is calculated by the function defined in calcRectangleDims.m.

The main script will first generate a list of parameter list based on specified area and provided list of aspect ratio, it then feeds the parameters from the list into the COMSOL optimization function, generating optimized designs with specified geometry constraints.

To use these files, please put them in the same folder as the .mph files, after specifying path name variables, run the runParOptimization.m script.
