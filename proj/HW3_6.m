function HW3_6()
N = 10;
tp32BezierPatch;
CtrlPt=zeros(4,4,3);
xyz=zeros((N+1),(N+1),3);
bu=zeros(1, 4);
bv=zeros(1, 4);
hold on;
axis equal;
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
			end
		end
	end
	surf(xyz(:,:,1),xyz(:,:,2),xyz(:,:,3));
end
shading interp
colormap(bone);
hold off;
end