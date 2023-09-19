function runParOptimization(model, jobSequence, storage, jobIndex)

    numOfJobs = length(jobSequence);
    fprintf("Optimizing %d/%d ...\n", jobIndex, numOfJobs);
    
    % Extract geometry dimensions for the current job
    [l, w, h] = jobSequence{jobIndex,:};

    % Initialize COMSOL server
    initializeComsolServer();

    % Set model parameters and run optimization
    model1 = loadAndSetupModel(model, string(l), string(w), string(h));
    
    % Run and verify the model
    runAndVerifyModel(model1, jobIndex, numOfJobs);
    
    % Export results and save the model
    exportResultsAndSaveModel(model1, storage, num2str(jobIndex), string(l), string(w), string(h));
end

function initializeComsolServer()
    comsolPort = [2036 2037];
    task = getCurrentTask();
    labIndex = task.ID;
    currentDir = pwd;
    cd("S:\COMSOL\COMSOL61\Multiphysics\mli")
    try
        mphstart(comsolPort(labIndex));
    catch
        fprintf("Something went wrong!\n");
    end
    cd(currentDir);
end

function model = loadAndSetupModel(modelName, l, w, h)
    import('com.comsol.model.*');
    import('com.comsol.model.util.*');
    model = mphload(modelName, 'model1');
    model.param.set('legl', l);
    model.param.set('legw', w);
    model.param.set('tmesh', h);
end

function runAndVerifyModel(model, jobIndex, numOfJobs)
    model.study('std2').run;
    model.mesh('mpart1').feature('imp1').importData;
    fprintf("Verifying TO %d/%d ...\n", jobIndex, numOfJobs);
    try
        model.study('std5').run;
    catch
        fprintf("Extrude function failed, skipped.\n");
    end
end

function exportResultsAndSaveModel(model, storage, jobIndex, l, w, h)
    exportTags = ["img1","img2","img3","img4","img5","tbl1","tbl2"];
    postfixes = ["_sol.png","_out.png","_sx.png","_sy.png","_disp.png","_accu.csv","_veri.csv"];
    numOfExports = length(postfixes);
    for exportIndex = 1:numOfExports
        fileName = storage + num2str(jobIndex) + "_" + num2str(exportIndex) + "_" + l + "_" + w + "_" + h + postfixes(exportIndex);
        model.result.export(exportTags(exportIndex)).set("filename", fileName);
        model.result.export(exportTags(exportIndex)).run;
        if exportIndex == numOfExports
            writematrix([jobIndex, l, w, h, readmatrix(fileName)], storage + "TO_data.csv",'WriteMode','append');
        end
    end
    %mphsave(model, storage + "TO_"  + num2str(jobIndex), 'copy', 'on');
end