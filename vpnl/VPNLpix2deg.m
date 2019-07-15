function [degVal,ppd] = VPNLpix2deg(pixVal,display,pixWidth)
% conversion from pixel to degree values for common VPNL monitors
% inputs display name for stable measurements, and rect(3) pixWidth
switch display
    case '16ch'
        cmWidth = 104; viewDist = 265;
    case '32ch'
        cmWidth = 104; viewDist = 272;
    case 'eyetrack'
        cmWidth = 38.528; viewDist = 54;
    case 'laptop'
        cmWidth = 27.5; viewDist = 44;
end
[degVal,ppd] = pix2deg(pixVal,pixWidth,cmWidth,viewDist);
end

