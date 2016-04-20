function t1w_acpcfile = feAutoACPCalign(rawT1File, t1w_acpcfile)
% Automatically align an T1-weighted image to AC-PC plane
% 
% INPUTS:
%  rawT1File - full path to nifti file that needs to be aligned
%  t1w_acpc  - string used as name for the AC-PC aligned file 
%
% Copyright 2014-2015 Franco Pestilli, Indiana University, pestillifranco@gmail.com

% Load the file from disk
ni = readFileNifti(rawT1File);

% Make sure the file is aligned properly
ni = niftiApplyCannonicalXform(ni);

% Load a standard template from vistasoft
template =  fullfile(mrDiffusionDir, 'templates', 'MNI_T1.nii.gz');

% Compute the spatial normalization to align the current raw data to the template
sn = mrAnatComputeSpmSpatialNorm(ni.data, ni.qto_xyz, template);

% Assume that the AC-PC coordinates int he template are in a specific location:
% X, Y, Z = [0,0,0; 0,-16,0; 0,-8,40]
% Use this assumption and the spatial normalization to extract the corresponding AC-PC location on the raw data
c = mrAnatGetImageCoordsFromSn(sn, tal2mni([0,0,0; 0,-16,0; 0,-8,40])', true)';

% Now we assume that c contains the AC-PC coordinates that we need for the Raw data. 
% We will use them to compute the AC_PC alignement automatically. The new file will be saved to disk. 
% Check the alignement.
mrAnatAverageAcpcNifti(ni, t1w_acpcfile, c, [], [], [], false);
