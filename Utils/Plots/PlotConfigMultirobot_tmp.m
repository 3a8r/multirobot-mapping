function PlotConfigMultirobot_tmp(labels,config,edges,dim,cR1,cR2,cR12,varargin)

%hold on;
if nargin>7
    if varargin{1}
        %plot nodes
        nPoses=size(config,1)/dim;
        p=reshape(config,dim,nPoses);
        plot(p(1,:),p(2,:),'Ok');
    end
end
%plot the edges
nEdges=size(edges,1);
p1{nEdges} = [];
p2{nEdges} = [];
for i=1:nEdges
    s1=edges(i,2); % The 2 poses linked by the constraint
    s2=edges(i,1);
    
    ndx1=(dim*s1)+(1:dim); % Index for the 2 poses
    ndx2=(dim*s2)+(1:dim);
    p1{i}=config(ndx1); % The estimation of the two poses
    p2{i}=config(ndx2);
    if labels(i)==1
        c=cR1;
    elseif labels(i)==2
        c=cR2;
    else
        c=cR12;
    end
    line([p1{i}(1) p2{i}(1)],[p1{i}(2) p2{i}(2)],'Color',c);
end

if nargin>8
    if nargin>9
        faxis=varargin{3};
        if strcmp(faxis,'off')
            axis off;
        else
            axis(faxis);
            axis off;
        end
        if nargin>10
            title(['\fontsize{16}' varargin{4}]);
            
            if nargin>11
                v = varargin{5};
                if ~isnan(v)
                    for i=1:nEdges
                        text((p1{i}(1)+p2{i}(1))/2, (p1{i}(2)+p2{i}(2))/2 , sprintf('%.3f',v(i)),'FontSize',16);
                    end
                end
            end
        end
    end
    h=gcf;
    %sdf(h, 'IROS')
    saveas(h,varargin{2},'png');
end
%hold off;