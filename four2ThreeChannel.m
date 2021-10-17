D='Datase_edge/Frog';
S=dir(fullfile(D,'*.tif'));
for k=1:numel(S)
    F=fullfile(D,S(k).name);
    I=imread(F);
    I2=I(:,:,1:3);
    F2=fullfile(D,S(k).name);
    imwrite(I2, F2);
end
