# COMSOL-MATLAB-livelink
This repository contains MATLAB .m files that automate topology optimization in COMSOL using the LiveLink interface. These files are associated with the research presented in this [paper](https://dx.doi.org/10.1088/2632-959X/acef44) and in this [article](https://chaozhuang22.github.io/fea/to/).

## Why Is This Workflow Necessary?
In topology optimization, the slots usually reserved for parametric and auxiliary sweeps are already occupied by beta continuation and eta robust formulation. Therefore, an external control for parameter sweeping is required. This is particularly useful for handling cases with varying piezoresistor aspect ratios while maintaining a fixed area. The dimensions (length and width) of the piezoresistor are calculated using a separate [function](calcRectangleDims.m).

## Workflow Overview
The [main](main.m) script performs the following steps:
1. Generates a list of parameters based on a specified area and a provided list of aspect ratios.
2. Feeds these parameters into the COMSOL optimization function.
3. Produces optimized designs that meet the specified geometric constraints, using the function [runParOptimization](runParOptimization.m).
Note: The optimization function is embedded within a parfor loop, which requires MATLAB's Parallel Computing Toolbox.

## Usage
To use these scripts, place them in the same folder as your COMSOL .mph files. After specifying the path name variables, run the main.m script.

## Troubleshooting
The connection between COMSOL and MATLAB can be vulnerable, often resulting in ambiguous errors that are difficult to interpret. If an error occurs:
1. Verify if the parameters you are sweeping will cause errors in the original COMSOL .mph or not.
2. If the .mph model is fine, proceed to debug the MATLAB script.

For example, a common error looks like the following:
```
Error using parallel.internal.pool.deserialize (line 45)
Unable to read data stream because the data contains a bad version or endian-key

Error in distcomp.remoteparfor/deserialize (line 284)
            data = parallel.internal.pool.deserialize(...

Error in distcomp.remoteparfor>@(data)deserialize(obj,data) (line 242)
            [err, workerAborted] = iIntervalErrorDispatch(r, @(data) deserialize(obj, data));

Error in distcomp.remoteparfor>iIntervalErrorDispatch (line 547)
            origErr = deserFcn(intervalError);

Error in distcomp.remoteparfor/handleIntervalErrorResult (line 242)
            [err, workerAborted] = iIntervalErrorDispatch(r, @(data) deserialize(obj, data));

Error in distcomp.remoteparfor/getCompleteIntervals (line 395)
                            [r, err] = obj.handleIntervalErrorResult(r);

Error in scriptForAspectRatioAndPositionSweep (line 25)
parfor i = 1:length(jobSequence)
```
Solution: 
1. Check if variable names in loadAndSetupModel() match with the variables defined in the .mph file.
2. Check if the study nodes (e.g. std1) specified in runAndVerifyModel() match with the study node tag in the .mph file.
3. Make sure the generic COMSOL can build that specified geometry.
