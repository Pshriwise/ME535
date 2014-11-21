function HW3_6c()
N = 4;
EPS = 0.00000001;
tp32BezierPatch;
CtrlPt=zeros(4,4,3);
xyz=zeros((N+1),(N+1),3);
bu=zeros(1, 4);
bv=zeros(1, 4);
smooth(1:32,1:4,1:4,1:4)=[0.0];
pt0=zeros(1,3);
ptl1=zeros(1,3);
ptr1=zeros(1,3);
pttmp=zeros(1,3);
smoothness = 0.0;
 
for k=1:32
    for i=1:4
        for j=1:4
            for l=1:3
            CtrlPt(i,j,l)=verts(quads(i,j,k),l);
            end
        end
    end
 
    for i=1:N+1
        for j=1:N+1
            u= 0.0 + (i-1)*1.0/N;
            v= 0.0 + (j-1)*1.0/N;
            
            u_ = 1.0 - u;
            u2=u*u;
            bu(1)=u*u2;
            bu(2)=3.0*u2*u_;
            bu(3)=3.0*u*u_*u_;
            bu(4)=u_*u_*u_;
            v_ = 1.0 - v;
            v2=v*v;
            bv(1)=v*v2;
            bv(2)=3.0*v2*v_;
            bv(3)=3.0*v*v_*v_;
            bv(4)=v_*v_*v_;
            
            for kk=1:3    
                tmp = 0.0;
                for ii = 1:4
                    for jj = 1:4
                        tmp = tmp + bu(ii) * bv(jj) * CtrlPt(ii,jj,kk);
                    end
                end
                xyz(i,j,kk) = tmp;
                smooth(k,i,j,kk)=tmp;
            end
            if (i==1 || i==N+1 || j==1 || j==N+1)
                smooth(k,i,j,4)= 2.0;
            else
                smooth(k,i,j,4)= 3.0;
            end
        end
    end  
end

for k=1:32
    
    for n=1:32
        if (n == k )
            for i=1:4
                if (quads(i,1,k) == quads(i,4,k))
                    smooth(k,i,1,4)= 2.0;
                    smooth(k,i,4,4)= 2.0; 
                end
            end
            for j=1:4
                if (quads(1,j,k) == quads(4,j,k))
                    smooth(k,1,j,4)= 2.0;
                    smooth(k,4,j,4)= 2.0; 
                end
            end
        end
    end
end
for k=1:32
    for n=1:32
        if (n == k )
            continue;
        end
        
        
        bool =0.0;
        smoothness = 3.0;
        
        for i=1:4
            j=1; %1: j=1+
            
            %2:j cases
            for ii=1:4
            %2:j positive
                jj=1;  %2:j=1
                if (quads(i,j,k) == quads(ii,jj,n))
                    for l=1:3
                        pt0(l) =verts(quads(i,j,k),l);
                        ptl1(l) =verts(quads(i,j+1,k),l);
                        ptr1(l) = verts(quads(ii,jj+1,n),l);
                    end
                    [smoothness]=smspt(pt0,ptl1,ptr1);
                    if (smoothness < smooth(k,i,j,4))
                        fprintf('\nPatch:%i u=%i, v=%i+ connects with patch:%i u=%i, v=%i+, C%i smoothness',k,i,j,n,ii,jj,smoothness)
                        smooth(k,i,j,4) = smoothness;
                    end
                end
            % 2:j negative
                jj=4;  %2:j=4
                if (quads(i,j,k) == quads(ii,jj,n))
                    for l=1:3
                        pt0(l) =verts(quads(i,j,k),l);
                        ptl1(l) =verts(quads(i,j+1,k),l);
                        ptr1(l) = verts(quads(ii,jj-1,n),l);
                    end
                    [smoothness]=smspt(pt0,ptl1,ptr1);
                    if (smoothness < smooth(k,i,j,4))
                        fprintf('\nPatch:%i u=%i, v=%i+ connects with patch:%i u=%i, v=%i-, C%i smoothness',k,i,j,n,ii,jj,smoothness)
                        smooth(k,i,j,4) = smoothness;
                    end
                end
            end
            
            %2:i cases
            for jj=1:4
            %2:1 positive
                ii=1;  %2:j=1
                if (quads(i,j,k) == quads(ii,jj,n))
                    for l=1:3
                        pt0(l) =verts(quads(i,j,k),l);
                        ptl1(l) =verts(quads(i,j+1,k),l);
                        ptr1(l) = verts(quads(ii+1,jj,n),l);
                    end
                    [smoothness]=smspt(pt0,ptl1,ptr1);
                    if (smoothness < smooth(k,i,j,4))
                        fprintf('\nPatch:%i u=%i, v=%i+ connects with patch:%i u=%i+, v=%i, C%i smoothness',k,i,j,n,ii,jj,smoothness)
                        smooth(k,i,j,4) = smoothness;
                    end
                end
            % 2:j negative
                ii=4;  %2:j=4
                if (quads(i,j,k) == quads(ii,jj,n))
                    for l=1:3
                        pt0(l) =verts(quads(i,j,k),l);
                        ptl1(l) =verts(quads(i,j+1,k),l);
                        ptr1(l) = verts(quads(ii-1,jj,n),l);
                    end
                    [smoothness]=smspt(pt0,ptl1,ptr1);
                    if (smoothness < smooth(k,i,j,4))
                        fprintf('\nPatch:%i u=%i, v=%i+ connects with patch:%i u=%i-, v=%i, C%i smoothness',k,i,j,n,ii,jj,smoothness)
                        smooth(k,i,j,4) = smoothness;
                    end
                end
            end
            
            j=4; %1: j=1+
            %2:j cases
            for ii=1:4
            %2:j positive
                jj=1;  %2:j=1
                if (quads(i,j,k) == quads(ii,jj,n))
                    for l=1:3
                        pt0(l) =verts(quads(i,j,k),l);
                        ptl1(l) =verts(quads(i,j-1,k),l);
                        ptr1(l) = verts(quads(ii,jj+1,n),l);
                    end
                    [smoothness]=smspt(pt0,ptl1,ptr1);
                    if (smoothness < smooth(k,i,j,4))
                        fprintf('\nPatch:%i u=%i, v=%i- connects with patch:%i u=%i, v=%i+, C%i smoothness',k,i,j,n,ii,jj,smoothness)
                        smooth(k,i,j,4) = smoothness;
                    end
                end
            % 2:j negative
                jj=4;  %2:j=4
                if (quads(i,j,k) == quads(ii,jj,n))
                    for l=1:3
                        pt0(l) =verts(quads(i,j,k),l);
                        ptl1(l) =verts(quads(i,j-1,k),l);
                        ptr1(l) = verts(quads(ii,jj-1,n),l);
                    end
                    [smoothness]=smspt(pt0,ptl1,ptr1);
                    if (smoothness < smooth(k,i,j,4))
                        fprintf('\nPatch:%i u=%i, v=%i- connects with patch:%i u=%i, v=%i-, C%i smoothness',k,i,j,n,ii,jj,smoothness)
                        smooth(k,i,j,4) = smoothness;
                    end
                end
            end
            
            %2:i cases
            for jj=1:4
            %2:1 positive
                ii=1;  %2:j=1
                if (quads(i,j,k) == quads(ii,jj,n))
                    for l=1:3
                        pt0(l) =verts(quads(i,j,k),l);
                        ptl1(l) =verts(quads(i,j-1,k),l);
                        ptr1(l) = verts(quads(ii+1,jj,n),l);
                    end
                    [smoothness]=smspt(pt0,ptl1,ptr1);
                    if (smoothness < smooth(k,i,j,4))
                        fprintf('\nPatch:%i u=%i, v=%i- connects with patch:%i u=%i+, v=%i, C%i smoothness',k,i,j,n,ii,jj,smoothness)
                        smooth(k,i,j,4) = smoothness;
                    end
                end
            % 2:j negative
                ii=4;  %2:j=4
                if (quads(i,j,k) == quads(ii,jj,n))
                    for l=1:3
                        pt0(l) =verts(quads(i,j,k),l);
                        ptl1(l) =verts(quads(i,j-1,k),l);
                        ptr1(l) = verts(quads(ii-1,jj,n),l);
                    end
                    [smoothness]=smspt(pt0,ptl1,ptr1);
                    if (smoothness < smooth(k,i,j,4))
                        fprintf('\nPatch:%i u=%i, v=%i- connects with patch:%i u=%i-, v=%i, C%i smoothness',k,i,j,n,ii,jj,smoothness)
                        smooth(k,i,j,4) = smoothness;
                    end
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for j=1:4
            i=1; %1: i=1+
            %2:j cases
            for ii=1:4
            %2:j positive
                jj=1;  %2:j=1
                if (quads(i,j,k) == quads(ii,jj,n))
                    for l=1:3
                        pt0(l) =verts(quads(i,j,k),l);
                        ptl1(l) =verts(quads(i+1,j,k),l);
                        ptr1(l) = verts(quads(ii,jj+1,n),l);
                    end
                    [smoothness]=smspt(pt0,ptl1,ptr1);
                    if (smoothness < smooth(k,i,j,4))
                        fprintf('\nPatch:%i u=%i+, v=%i connects with patch:%i u=%i, v=%i+, C%i smoothness',k,i,j,n,ii,jj,smoothness)
                        smooth(k,i,j,4) = smoothness;
                    end
                end
            % 2:j negative
                jj=4;  %2:j=4
                if (quads(i,j,k) == quads(ii,jj,n))
                    for l=1:3
                        pt0(l) =verts(quads(i,j,k),l);
                        ptl1(l) =verts(quads(i+1,j,k),l);
                        ptr1(l) = verts(quads(ii,jj-1,n),l);
                    end
                    [smoothness]=smspt(pt0,ptl1,ptr1);
                    if (smoothness < smooth(k,i,j,4))
                        fprintf('\nPatch:%i u=%i+, v=%i connects with patch:%i u=%i, v=%i-, C%i smoothness',k,i,j,n,ii,jj,smoothness)
                        smooth(k,i,j,4) = smoothness;
                    end
                end
            end
            
            %2:i cases
            for jj=1:4
            %2:1 positive
                ii=1;  %2:j=1
                if (quads(i,j,k) == quads(ii,jj,n))
                    for l=1:3
                        pt0(l) =verts(quads(i,j,k),l);
                        ptl1(l) =verts(quads(i+1,j,k),l);
                        ptr1(l) = verts(quads(ii+1,jj,n),l);
                    end
                    [smoothness]=smspt(pt0,ptl1,ptr1);
                    if (smoothness < smooth(k,i,j,4))
                        fprintf('\nPatch:%i u=%i+, v=%i connects with patch:%i u=%i+, v=%i, C%i smoothness',k,i,j,n,ii,jj,smoothness)
                        smooth(k,i,j,4) = smoothness;
                    end
                end
            % 2:j negative
                ii=4;  %2:j=4
                if (quads(i,j,k) == quads(ii,jj,n))
                    for l=1:3
                        pt0(l) =verts(quads(i,j,k),l);
                        ptl1(l) =verts(quads(i+1,j,k),l);
                        ptr1(l) = verts(quads(ii-1,jj,n),l);
                    end
                    [smoothness]=smspt(pt0,ptl1,ptr1);
                    if (smoothness < smooth(k,i,j,4))
                        fprintf('\nPatch:%i u=%i+, v=%i connects with patch:%i u=%i-, v=%i, C%i smoothness',k,i,j,n,ii,jj,smoothness)
                        smooth(k,i,j,4) = smoothness;
                    end
                end
            end
            
            i=4; %1-: j
            %2:j cases
            for ii=1:4
            %2:j positive
                jj=1;  %2:j=1
                if (quads(i,j,k) == quads(ii,jj,n))
                    for l=1:3
                        pt0(l) =verts(quads(i,j,k),l);
                        ptl1(l) =verts(quads(i-1,j,k),l);
                        ptr1(l) = verts(quads(ii,jj+1,n),l);
                    end
                    [smoothness]=smspt(pt0,ptl1,ptr1);
                    if (smoothness < smooth(k,i,j,4))
                        fprintf('\nPatch:%i u=%i-, v=%i connects with patch:%i u=%i, v=%i+, C%i smoothness',k,i,j,n,ii,jj,smoothness)
                        smooth(k,i,j,4) = smoothness;
                    end
                end
            % 2:j negative
                jj=4;  %2:j=4
                if (quads(i,j,k) == quads(ii,jj,n))
                    for l=1:3
                        pt0(l) =verts(quads(i,j,k),l);
                        ptl1(l) =verts(quads(i-1,j,k),l);
                        ptr1(l) = verts(quads(ii,jj-1,n),l);
                    end
                    [smoothness]=smspt(pt0,ptl1,ptr1);
                    if (smoothness < smooth(k,i,j,4))
                        fprintf('\nPatch:%i u=%i-, v=%i connects with patch:%i u=%i, v=%i-, C%i smoothness',k,i,j,n,ii,jj,smoothness)
                        smooth(k,i,j,4) = smoothness;
                    end
                end
            end
            
            %2:i cases
            for jj=1:4
            %2:i positive
                ii=1;  %2:j=1
                if (quads(i,j,k) == quads(ii,jj,n))
                    for l=1:3
                        pt0(l) =verts(quads(i,j,k),l);
                        ptl1(l) =verts(quads(i-1,j,k),l);
                        ptr1(l) = verts(quads(ii+1,jj,n),l);
                    end
                    [smoothness]=smspt(pt0,ptl1,ptr1);
                    if (smoothness < smooth(k,i,j,4))
                        fprintf('\nPatch:%i u=%i-, v=%i connects with patch:%i u=%i+, v=%i, C%i smoothness',k,i,j,n,ii,jj,smoothness)
                        smooth(k,i,j,4) = smoothness;
                    end
                end
            % 2:i negative
                ii=4;  %2:j=4
                if (quads(i,j,k) == quads(ii,jj,n))
                    for l=1:3
                        pt0(l) =verts(quads(i,j,k),l);
                        ptl1(l) =verts(quads(i-1,j,k),l);
                        ptr1(l) = verts(quads(ii-1,jj,n),l);
                    end
                    [smoothness]=smspt(pt0,ptl1,ptr1);
                    if (smoothness < smooth(k,i,j,4))
                        fprintf('\nPatch:%i u=%i-, v=%i connects with patch:%i u=%i-, v=%i, C%i smoothness',k,i,j,n,ii,jj,smoothness)
                        smooth(k,i,j,4) = smoothness;
                    end
                end
            end
        end
    end  
end

for k=1:32
    smooth(k,1,1,4) = smooth(k,2,1,4);
    if smooth(k,1,2,4) < smooth(k,1,1,4)
        smooth(k,1,1,4) = smooth(k,1,2,4);
    end
    smooth(k,4,4,4) = smooth(k,4,3,4);
    if smooth(k,3,4,4) < smooth(k,4,4,4)
        smooth(k,4,4,4) = smooth(k,3,4,4);
    end
    smooth(k,1,4,4) = smooth(k,1,3,4);
    if smooth(k,2,4,4) < smooth(k,1,4,4)
        smooth(k,1,4,4) = smooth(k,2,4,4);
    end
    smooth(k,4,1,4) = smooth(k,3,1,4);
    if smooth(k,4,2,4) < smooth(k,4,1,4)
        smooth(k,4,1,4) = smooth(k,4,2,4);
    end
end
 
hold on;
axis equal;
for k=1:32
    for i=1:N+1
        for j=1:N+1
            for kk=1:4
                 xyz(i,j,kk) = smooth(k,i,j,kk);
            end
        end
    end
 
    surf(xyz(:,:,1),xyz(:,:,2),xyz(:,:,3),xyz(:,:,4));
end
%shading interp
%colormap(bone);
hold off;
grid on;
end

