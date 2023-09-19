% Define paths and parameters
comsolPath = "E:\COMSOL\COMSOL61\Multiphysics\bin\win64";
storage = "E:\comsolStorage\";
model = "TO-mss";
edgeLength = 40;
aspectRatio = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1,2,3,4,5,6,7,8,9];
position = 0;

% Start COMSOL server
startComsolServer(comsolPath);

% Prepare job sequence
jobSequence = calcRectangleDims(edgeLength, aspectRatio, position);

% Initialize output file
initDataFile(storage + "TO_data.csv");

% Measure the execution time
tStart = tic;

% Start parallel pool
pool = startParallelPool();

% Run optimization for each job
parfor i = 1:length(jobSequence)
    runParOptimization(model, jobSequence, storage, i);
end

% Print total execution time and clean up
cleanupAfterRun(tStart, pool);

function initDataFile(fileName)
    writematrix([], fileName);
end

function startComsolServer(comsolPath)
    currentDir = pwd;
    cd(comsolPath);
    system('comsolmphserver.exe &');
    pause(10);
    system('comsolmphserver.exe &');
    cd(currentDir);
end

function pool = startParallelPool()
    if isempty(gcp('nocreate'))
        pool = parpool(2);
    else
        pool = gcp;
    end
end

function cleanupAfterRun(tStart, pool)
    tEnd = toc(tStart);
    fprintf("All Done, tea time!\nThis run takes %d h %d min.\n", floor(tEnd/3600), floor(rem(tEnd,3600)/60));
    delete(pool);
end
