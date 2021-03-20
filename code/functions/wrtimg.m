function wrtimg(wPtr, P)

if P.setup.screenshots
    [~, ~] = mkdir('Screenshots');
    res = dir('Screenshots');
    N = sum(cell2mat(regexp({res.name}, "ROSA_\d+\.png")));
    fname = sprintf('Screenshots/ROSA_%i.png', N + 1);
    imageArray = Screen('GetImage', wPtr);
    imwrite(imageArray, fname);
end
end