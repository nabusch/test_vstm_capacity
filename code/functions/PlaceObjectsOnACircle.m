function [rects, xcoords, ycoords] = PlaceObjectsOnACircle(radii, NObjects, width, height, centerx, centery);
% function rects = PlaceObjectsOnACircle(radii, nobjects);
% computes rects for multiple objects place on one or more concentric
% circles.
% radii: number or vector of radii, one radius per circle. Values indicate
% pixels.
% nobjects: how many objects per circle. 
% width: horizontal extension of each object.
% height: vertical extension of each object.
% centerx: horizontal center of the circles in screen coordinates.
% centery: vertical center of the circles in screen coordinates
%
% Number of elements in radii and nobjects must match.
% 
% Example: 
% rects = PlaceObjectsOnACircle([50,100],[2,6],15,15, 100, 100);
% rects = PlaceObjectsOnACircle([50,100],[2,6],P.ImWidth,P.ImHeight, P.CenterX, P.CenterY);

%%
% Example parameters for testing
% radii = [50,100];
% NObjects = [4,6];
% width = 15;
% height = 15;
% CenterX = 100;
% CenterY = -30;

if length(radii) ~= length(NObjects)
    disp('Number of elements in radii and nobjects does not match')
    return
end

ncircles = length(radii);
xcoords = [];
ycoords = [];

for icircle = 1:ncircles
    anglesteps = 360/NObjects(icircle);
    offset = 0.5 * anglesteps;
    
    angles = linspace(0+offset, 360-anglesteps+offset, NObjects(icircle));
        
    for iobject=1:NObjects(icircle)
        xcoords(end+1) = sind(angles(iobject)) * radii(icircle);
        ycoords(end+1) = cosd(angles(iobject)) * radii(icircle);
    end
end

xcoords = xcoords + centerx;
ycoords = ycoords + centery;

rects = [xcoords-width/2; ycoords-height/2; xcoords+width/2; ycoords+height/2];
%% Figure for testing results
% CenterX = 0;
% CenterY = 0;
% figure; hold all
%     xs = 1:360;
%     sinx = sin(xs);
%     cosx = cos(xs);
%     
%     for ic = 1:length(radii)
%         plot(radii(ic).*sinx+CenterX, radii(1).*cosx+CenterY, '.'); hold on;
% 
%         for iob=1:NObjects(ic)
%             text(xcoords(iob), ycoords(iob), num2str(iob), 'fontsize', 14)
%         end
%     end
%     fill(rects([1,3],:), rects([2,4],:), 'r');
%     gridxy([CenterX],[CenterY]);
%     axis square