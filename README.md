# COMSOL-MATLAB-livelink
This repository contains MATLAB .m files that automate topology optimization in COMSOL using the LiveLink interface. These files are associated with the research presented in this [paper](https://dx.doi.org/10.1088/2632-959X/acef44) and in this [article](https://chaozhuang22.github.io/fea/to/).

## Why Is This Workflow Necessary?
In topology optimization, the slots usually reserved for parametric and auxiliary sweeps are already occupied by beta continuation and eta robust formulation. Therefore, an external control for parameter sweeping is required. This is particularly useful for handling cases with varying piezoresistor aspect ratios while maintaining a fixed area. The dimensions (length and width) of the piezoresistor are calculated using a separate [function](calcRectangleDims.m).

## Main Script Workflow Overview
The [main](main.m) script performs the following steps:
1. Generates a list of parameters based on a specified area and a provided list of aspect ratios.
2. Feeds these parameters into the COMSOL optimization function.
3. Produces optimized designs that meet the specified geometric constraints, using the function [runParOptimization](runParOptimization.m).
Note: The optimization function is embedded within a parfor loop, which requires MATLAB's Parallel Computing Toolbox.

## Common Errors and Troubleshooting
The connection between COMSOL and MATLAB can be unreliable, often resulting in ambiguous errors that are difficult to interpret. If an error occurs:
1. Verify the compatibility of the original COMSOL .mph file with the parameters you are using.
2. If the .mph model is fine, proceed to debug the MATLAB code.
For a common error and its solutions, refer to the [common error](common-error.txt) file.

## Usage Instructions
To use these scripts, place them in the same folder as your COMSOL .mph files. After specifying the path name variables, run the main.m script.
