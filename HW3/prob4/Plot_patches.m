

%Plots all Bezier Surfaces in the hw file 
clear all;
close all; 

tp32BezierPatch;
patches = get_patches( verts, quads );
[m,n,o,p] = size(patches);
hold on; 
for i = 1:p
    patch = patches(:,:,:,i);
    pnts = bezier_bicubic_patch( patch, 0.1 );
    
    for j = 1:size(pnts,2)
        plot3(squeeze(pnts(1,j,:)),squeeze(pnts(2,j,:)),squeeze(pnts(3,j,:)));
        plot3(squeeze(pnts(1,:,j)),squeeze(pnts(2,:,j)),squeeze(pnts(3,:,j))); 
    end
    
    [end_pnts strt_pnts] = bezier_bicubic_derivs( patch ); 
    for k = 1:size(end_pnts, 2);
        if mod(i,2) == 0
            color = 'green';
        else
            color = 'red';
        end
        plot3([strt_pnts(1,k);end_pnts(1,k)],[strt_pnts(2,k);end_pnts(2,k)],[strt_pnts(3,k);end_pnts(3,k)],color)
    end
end
