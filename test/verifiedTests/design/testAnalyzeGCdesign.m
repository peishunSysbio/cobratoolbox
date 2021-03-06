% The COBRAToolbox: testAnalyzeGCdesign.m
%
% Purpose:
%     - test the analyzeGCdesign function
%
% Authors:
%     - Jacek Wachowiak

% save the current path
currentDir = pwd;

% initialize the test
fileDir = fileparts(which('testAnalyzeGCdesign'));
cd(fileDir);

% test variables
model = getDistributedModel('ecoli_core_model.mat');
modelRed = reduceModel(model);
selectedRxns = modelRed.rxns(22:25);
target = modelRed.rxns(20); % 'EX_ac(e)'
deletions = modelRed.rxns(21);
improvedRxnsM = {};
intermediateSlnsM = {};

% function outputs
% solver change due to instability of qpng
% to be changed with gurobi
changeCobraSolver('gurobi', 'QP');
[improvedRxns, intermediateSlns] = analyzeGCdesign(modelRed, selectedRxns, target, deletions);

for i=2:8;
      [improvedRxns2, intermediateSlns2] = analyzeGCdesign(modelRed, selectedRxns, target, deletions, i, i);
      improvedRxnsM{end+1} = improvedRxns2;
      intermediateSlnsM{end+1} = intermediateSlns2;
end

% tests
assert(isequal({'EX_akg(e)', 'EX_co2(e)'}, improvedRxns));
assert(isequal({'EX_acald(e)'}, improvedRxnsM{7}));
assert(isequal({'EX_acald(e)'}, intermediateSlnsM{7}{1}));


% change to old directory
cd(currentDir);
