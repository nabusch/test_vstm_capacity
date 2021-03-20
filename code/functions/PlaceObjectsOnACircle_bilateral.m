function [rects, xcoords, ycoords, rects_l, xcoords_l, ycoords_l, rects_r, xcoords_r, ycoords_r] = PlaceObjectsOnACircle_bilateral(radii, NObjects, width, height, CenterX, CenterY, offset);
% function rects = PlaceObjectsOnACircle_bilateral(radii, nobjects);
% computes rects for multiple objects place on one or more concentric
% circles. Objects are placed such that they are lateralized, meaning they
% are not presented on the vertical and left and right half are offset by a
% variable angle.
%
% radii: number or vector of radii, one radius per circle. Values indicate
% pixels.
% nobjects: how many objects per circle. 
% width: horizontal extension of each object.
% height: vertical extension of each object.
% centerx: horizontal center of the circles in screen coordinates.
% centery: vertical center of the circles in screen coordinates
% offset: distance between vertical and next object.
%
% Number of elements in radii and nobjects must match.
% 
% Example: 
% rects = PlaceObjectsOnACircle([50,100],[2,6],15,15, 100, 100);
% rects = PlaceObjectsOnACircle([50,100],[2,6],P.ImWidth,P.ImHeight, P.CenterX, P.CenterY);

%%
% Example parameters for testing
% radii = [100];
% NObjects = [6];
% width = 15;
% height = 15;
% CenterX = 100;
% CenterY = -30;
% offset = 40;

if length(radii) ~= length(NObjects)
    disp('Number of elements in radii and nobjects does not match')
    return
end

ncircles = length(radii);
xcoords = [];
ycoords = [];

for icircle = 1:ncircles
    
    angles_l = linspace(0+offset, 180-offset, NObjects(icircle)/2);
    angles_r = linspace(180+offset, 360-offset, NObjects(icircle)/2);
    angles_all   = [angles_l angles_r];
        
    for iobject=1:NObjects(icircle)
        xcoords(end+1) = (sind(angles_all(iobject)) * radii(icircle)) + CenterX;
        ycoords(end+1) = (cosd(angles_all(iobject)) * radii(icircle)) + CenterY;
    end
end

rects = [xcoords-width/2; ycoords-height/2; xcoords+width/2; ycoords+height/2];
rects_r = rects(:,1:NObjects/2);
rects_l = rects(:,(NObjects/2)+1:end);

xcoords_r = xcoords(1:NObjects/2);
xcoords_l = xcoords((NObjects/2)+1:end);

ycoords_r = ycoords(1:NObjects/2);
ycoords_l = ycoords((NObjects/2)+1:end);
%% Fgire for testing results
% 
% figure;
%     xs = 1:360;
%     sinx = sind(xs);
%     cosx = cosd(xs);
%     
%     scatter(xcoords,ycoords); hold on;
%     for irad = 1:length(radii)
%         plot(radii(irad).*sinx+CenterX, radii(1).*cosx+CenterY, '.'); hold on;
%     end
%     
%     for i = 1:NObjects/2
%         fill(rects_l([1,3, 3, 1],i), rects_l([2,2, 4, 4],i), 'b'); hold on
%         fill(rects_r([1,3, 3, 1],i), rects_r([2,2, 4, 4],i), 'r'); hold on
%     end
% %     gridxy([CenterX],[CenterY]);
%     axis square
%     
%     