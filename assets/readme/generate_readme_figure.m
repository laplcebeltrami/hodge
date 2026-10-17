function generate_readme_figure
% Generate the single README figure using the repository's Hodge functions.
% Run from the repository root:
%   addpath(fullfile(pwd,'assets','readme')); generate_readme_figure
% Deterministic synthetic example; no participant data or fitted results.

root = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(root);
outdir = fullfile(root,'assets','readme');
builddir = fullfile(root,'build','readme');
mkdir(outdir); mkdir(builddir);
navy = [0.10 0.18 0.29];
teal = [0.00 0.48 0.52];
amber = [0.79 0.38 0.10];
purple = [0.45 0.31 0.65];

% Triangulated annulus: six inner and six outer vertices, one open hole.
theta = (0:5)'*2*pi/6 + pi/6;
nodes = [0.85*cos(theta) 0.85*sin(theta); ...
         1.85*cos(theta) 1.85*sin(theta)];
A = zeros(12);
for k = 1:6
    j = mod(k,6)+1;
    pairs = [k j; k+6 j+6; k k+6; k j+6];
    for t = 1:4
        A(pairs(t,1),pairs(t,2)) = 1;
        A(pairs(t,2),pairs(t,1)) = 1;
    end
end
S = Hodge_2Skeleton(A);
I = Hodge_incidence(S);
B = {I{2},I{3}}; % Hodge_decompose uses cells 1 and 2.
B1 = B{1}; B2 = B{2};
Lgraph = Hodge_laplacian(I);
L1 = B1'*B1 + B2*B2';
[U,lambda] = Hodge_ker(L1);
[Ugraph,lambdaGraph] = Hodge_ker(Lgraph);

% Known components with prescribed squared norms (40%, 35%, 25%).
s0 = nodes(:,1) + 0.35*nodes(:,2) + 0.15*nodes(:,1).*nodes(:,2);
z0 = sin((1:size(B2,2))'*0.83) + 0.4*cos((1:size(B2,2))'*1.71);
g0 = B1'*s0; g0 = sqrt(0.40)*g0/norm(g0);
c0 = B2*z0; c0 = sqrt(0.35)*c0/norm(c0);
h0 = U(:,1);
% Fix the arbitrary eigenvector sign using counterclockwise inner-ring flow.
cycle = zeros(size(B1,2),1);
for k = 1:6
    j = mod(k,6)+1;
    e = find(all(S{2} == sort([k j]),2));
    cycle(e) = sign(j-k);
end
if cycle'*h0 < 0, h0 = -h0; end
h0 = sqrt(0.25)*h0/norm(h0);
x = g0+c0+h0;
[g,c,h,s,z] = Hodge_decompose(x,B);

checks.nodes = size(S{1},1);
checks.edges = size(S{2},1);
checks.faces = size(S{3},1);
checks.graph_nullity = size(Ugraph,2);
checks.complex_nullity = size(U,2);
checks.boundary_chain = norm(B1*B2,'fro');
checks.relative_reconstruction = norm(x-g-c-h)/norm(x);
checks.known_component_error = max([norm(g-g0),norm(c-c0),norm(h-h0)]);
checks.harmonic_divergence = norm(B1*h);
checks.harmonic_curl = norm(B2'*h);
checks.orthogonality = max(abs([g'*c,g'*h,c'*h]));
checks.energy_percent = 100*[norm(g)^2 norm(c)^2 norm(h)^2]/norm(x)^2;
assert(isequal([checks.nodes checks.edges checks.faces],[12 24 12]));
assert(isequal([checks.graph_nullity checks.complex_nullity],[13 1]));
assert(checks.boundary_chain == 0);
assert(checks.known_component_error < 1e-6);
assert(checks.harmonic_divergence < 1e-6 && checks.harmonic_curl < 1e-6);
assert(checks.orthogonality < 1e-6);

% Also execute the five-node quick start printed in README.md.
Y = [0 1 1 0 0; -1 0 2 1.5 0; -1 -2 0 0 1.5; ...
     0 -1.5 0 0 .5; 0 0 -1.5 -.5 0];
Sq = Hodge_2Skeleton(Y); Iq = Hodge_incidence(Sq);
Bq = {Iq{2},Iq{3}}; xq = Hodge_vec(Y);
[gq,cq,hq] = Hodge_decompose(xq,Bq);
Lq = Bq{1}'*Bq{1} + Bq{2}*Bq{2}';
[Uq,lambdaq] = Hodge_ker(Lq);
checks.quick_start.reconstruction = norm(xq-gq-cq-hq);
checks.quick_start.harmonic_divergence = norm(Bq{1}*hq);
checks.quick_start.harmonic_curl = norm(Bq{2}'*hq);
checks.quick_start.harmonic_modes = size(Uq,2);
assert(checks.quick_start.reconstruction < 1e-10);
assert(checks.quick_start.harmonic_divergence < 1e-6);
assert(checks.quick_start.harmonic_curl < 1e-6);
assert(checks.quick_start.harmonic_modes == 1);

f = figure('Visible','off','Color','white','Position',[80 80 1800 1120]);
set(f,'DefaultAxesFontName','Arial','DefaultTextFontName','Arial', ...
    'DefaultAxesColor','white','DefaultAxesXColor',navy, ...
    'DefaultAxesYColor',navy,'PaperPositionMode','auto','InvertHardcopy','off');
label(f,[0.03 0.939 0.94 0.045],'Hodge analysis: from network structure to interpretable flow components',25,navy,'left');
label(f,[0.03 0.893 0.94 0.038],'One synthetic example connects simplicial topology, boundary operators, spectral modes, and an orthogonal decomposition.',16,[.35 .41 .49],'left');
cols = [0.03 0.2775 0.525 0.7725];
titles = {'A  A network with one open hole','B  Oriented boundary operators', ...
    'C  Full edge Hodge Laplacian','D  Which cycles remain harmonic?'};
for k=1:4
    label(f,[cols(k) 0.838 0.225 0.041],titles{k},17,navy,'left');
end

ax = axes(f,'Position',[cols(1) 0.578 0.21 0.25]);
flowplot(ax,nodes,S{2},zeros(24,1),1,navy,S{3},true);
text(ax,0,0,{'Unfilled';'hole'},'Color',teal,'HorizontalAlignment','center', ...
    'FontSize',14,'FontWeight','bold');
label(f,[cols(1) 0.533 0.225 0.042],'12 nodes  |  24 edges  |  12 filled triangles',12,navy,'left');

ax = axes(f,'Position',[cols(2)+.018 0.725 0.182 0.081]);
imagesc(ax,B1); colormap(ax,diverging()); clim(ax,[-1 1]);
set(ax,'XTick',[],'YTick',[1 12],'FontSize',11,'TickLength',[0 0]);
title(ax,'B_1 : nodes \times edges (12 \times 24)','Color',navy,'FontSize',13,'FontWeight','normal');
ylabel(ax,'Node');
ax = axes(f,'Position',[cols(2)+.018 0.590 0.182 0.081]);
imagesc(ax,B2'); colormap(ax,diverging()); clim(ax,[-1 1]);
set(ax,'XTick',[1 12 24],'YTick',[1 12],'FontSize',11,'TickLength',[0 0]);
title(ax,'B_2^T : faces \times edges (12 \times 24)','Color',navy,'FontSize',13,'FontWeight','normal');
ylabel(ax,'Face');
hLabel = label(f,[cols(2) 0.533 0.225 0.042],'Blue = -1   white = 0   red = +1;   B_1 B_2 = 0',12,navy,'left');
set(hLabel,'Interpreter','tex');

ax = axes(f,'Position',[cols(3)+.013 0.591 0.174 0.226]);
imagesc(ax,L1); axis(ax,'image'); colormap(ax,diverging()); clim(ax,[-max(L1(:)) max(L1(:))]);
set(ax,'XTick',[1 12 24],'YTick',[1 12 24],'FontSize',11,'TickLength',[0 0]);
ylabel(ax,'Edge index');
cb = colorbar(ax); cb.Color = navy; cb.FontSize = 10;
hLabel = label(f,[cols(3) 0.533 0.225 0.042],'L_1 = B_1^T B_1 + B_2 B_2^T   (24 \times 24)',13,navy,'left');
set(hLabel,'Interpreter','tex');

ax = axes(f,'Position',[cols(4)+.022 0.607 0.181 0.193]); hold(ax,'on');
plot(ax,1:24,max(0,sort(lambdaGraph)),'o-','Color',[.55 .61 .68],'LineWidth',1.8,'MarkerSize',4);
plot(ax,1:24,max(0,sort(lambda)),'o-','Color',teal,'LineWidth',1.8,'MarkerSize',4);
set(ax,'FontSize',11,'Box','off','TickDir','out','XTick',[1 6 12 18 24]);
xlim(ax,[.5 24.5]); ylim(ax,[-.25 9]); grid(ax,'on');
xlabel(ax,'Ordered mode'); ylabel(ax,'Eigenvalue');
legend(ax,{'Edges only: 13 zero modes','With faces: 1 zero mode'},'Location','northwest', ...
    'FontSize',11,'Box','off','TextColor',navy,'Color','white');
label(f,[cols(4) 0.533 0.225 0.042],'Filling triangles removes 12 local cycle modes.',12,navy,'left');

annotation(f,'line',[.03 .97],[.517 .517],'Color',[.83 .87 .90]);
values = {x,g,c,h}; colors = {navy,amber,purple,teal};
names = {'E  Input edge flow','F  Gradient component','G  Curl component','H  Harmonic component'};
formulas = {'x = g + c + h','g = B_1^T s','c = B_2 z','B_1 h = 0   and   B_2^T h = 0'};
notes = {'All three components combined', ...
    sprintf('Node-potential variation  |  %.0f%% energy',checks.energy_percent(1)), ...
    sprintf('Circulation on filled faces  |  %.0f%% energy',checks.energy_percent(2)), ...
    sprintf('Circulation around the hole  |  %.0f%% energy',checks.energy_percent(3))};
scale = max(abs([x;g;c;h]));
for k=1:4
    label(f,[cols(k) .472 .225 .038],names{k},18,colors{k},'left');
    hLabel = label(f,[cols(k) .436 .225 .030],formulas{k},14,colors{k},'left');
    set(hLabel,'Interpreter','tex');
    ax = axes(f,'Position',[cols(k) .168 .21 .26]);
    flowplot(ax,nodes,S{2},values{k},scale,colors{k},S{3},false);
    label(f,[cols(k) .120 .225 .042],notes{k},12,navy,'left');
end
annotation(f,'line',[.03 .97],[.103 .103],'Color',[.83 .87 .90]);
label(f,[.03 .050 .94 .044], ...
    'Computed in MATLAB with Hodge_2Skeleton, Hodge_incidence, Hodge_laplacian, Hodge_ker, and Hodge_decompose.',14,navy,'left');
label(f,[.03 .013 .94 .040], ...
    'Shading marks filled triangles. Arrow widths use one shared magnitude scale; arrowheads show direction. Synthetic illustration; component energies are prescribed.',12,[.35 .41 .49],'left');
print(f,fullfile(outdir,'hodge-workflow.png'),'-dpng','-r170');
close(f);

checks.matlab = version;
checks.source_commit = '6e95cf7ff09fb16a0c5ee4a25b8837b6ec3585cc';
fid = fopen(fullfile(outdir,'numerical-checks.json'),'w');
fwrite(fid,jsonencode(checks,PrettyPrint=true)); fclose(fid);
save(fullfile(builddir,'figure-data.mat'),'nodes','S','B','L1','Lgraph', ...
    'x','g','c','h','s','z','lambda','lambdaGraph','checks');
disp(checks);
fprintf('Single README figure exported successfully.\n');
end

function hLabel = label(f,pos,str,sz,color,align)
hLabel = annotation(f,'textbox',pos,'String',str,'EdgeColor','none','FontName','Arial', ...
    'FontSize',sz,'Color',color,'HorizontalAlignment',align, ...
    'VerticalAlignment','middle','Interpreter','none');
end

function flowplot(ax,nodes,edges,weights,scale,color,faces,numberNodes)
hold(ax,'on');
for k=1:size(faces,1)
    patch(ax,nodes(faces(k,:),1),nodes(faces(k,:),2),[.94 .95 .97], ...
        'EdgeColor','none');
end
for k=1:size(edges,1)
    xy=nodes(edges(k,:),:);
    plot(ax,xy(:,1),xy(:,2),'-','Color',[.72 .77 .82],'LineWidth',1);
end
for k=1:size(edges,1)
    w=weights(k); if abs(w)<1e-9, continue; end
    ij=edges(k,:); if w<0, ij=fliplr(ij); end
    a=nodes(ij(1),:); b=nodes(ij(2),:);
    u=(b-a)/norm(b-a); v=[-u(2) u(1)];
    a=a+.07*u; b=b-.08*u;
    plot(ax,[a(1) b(1)],[a(2) b(2)],'-','Color',color,'LineWidth',.65+4.2*abs(w)/scale);
    head=.10+.04*abs(w)/scale; base=b-head*u;
    P=[b;base+.46*head*v;base-.46*head*v];
    patch(ax,P(:,1),P(:,2),color,'EdgeColor',color);
end
if numberNodes
    scatter(ax,nodes(:,1),nodes(:,2),230,'white','filled','MarkerEdgeColor',color,'LineWidth',1.3);
    for k=1:size(nodes,1)
        text(ax,nodes(k,1),nodes(k,2),num2str(k),'FontSize',11,'FontWeight','bold', ...
            'Color',color,'HorizontalAlignment','center','VerticalAlignment','middle');
    end
else
    scatter(ax,nodes(:,1),nodes(:,2),50,'white','filled','MarkerEdgeColor',color,'LineWidth',1.2);
end
axis(ax,'equal'); axis(ax,'off'); xlim(ax,[-2.03 2.03]); ylim(ax,[-2.03 2.03]);
end

function c=diverging
left=[.22 .35 .67]; mid=[.99 .99 .99]; right=[.77 .25 .17];
t=linspace(0,1,128)'; c=[left.*(1-t)+mid.*t;mid.*(1-t)+right.*t];
end
