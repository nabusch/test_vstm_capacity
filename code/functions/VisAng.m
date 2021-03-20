function [pixperdeg, degperpix]=VisAng(params)
% function [pixperdeg, degperpix]=VisAng(params)
%
% Takes as input a structure containing:
% struct.res - the resolution of the monitor
% struct.sz - the size of the monitor in cm
% (these values can either be along a single dimension or
% for both the width and height)
% struct.vdist - the viewing distance in cm.
%
% Calculates the visual angle subtended by a single pixel
%
% Returns the pixels per degree
% and it's reciprocal - the degrees per pixel (in degrees, not radians)
%
% written by IF 7/2000
params.sz = params.screen.size;
params.res = [params.screen.width, params.screen.height];
params.vdist = params.screen.viewdist;

pix=params.sz./params.res; %calculates the size of a pixel in cm
degperpix=(2*atan(pix./(2*params.vdist))).*(180/pi);
pixperdeg=1./degperpix;