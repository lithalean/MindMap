import SwiftUI

// MARK: - Main Content View (Adaptive Container)
struct ContentView: View {
    @Bindable var document: MindMapDocument
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State private var selectedTab: NavigationTab = .mindmaps
    @State private var sidebarVisible = true
    @State private var showingCanvasView = false
    
    var body: some View {
        GeometryReader { geometry in
            if showingCanvasView {
                // Full Canvas Mode
                AdaptiveMindMapCanvasView(document: document)
                    .background(.black)
                    .preferredColorScheme(.dark)
                    .navigationBarHidden(true)
            } else {
                // Document Browser Mode
                if shouldShowSidebar(for: geometry.size) {
                    SidebarLayout(
                        selectedTab: $selectedTab,
                        sidebarVisible: $sidebarVisible,
                        document: document,
                        onOpenCanvas: { showingCanvasView = true }
                    )
                } else {
                    TabBarLayout(
                        selectedTab: $selectedTab,
                        document: document,
                        onOpenCanvas: { showingCanvasView = true }
                    )
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: horizontalSizeClass)
        .onAppear {
            // If document has content, show canvas immediately
            if !document.nodes.isEmpty {
                showingCanvasView = true
            }
        }
    }
    
    private func shouldShowSidebar(for size: CGSize) -> Bool {
        // iPad landscape or macOS
        return size.width > 768 && size.height < size.width * 1.2
    }
}

// MARK: - Sidebar Layout (Landscape/macOS)
struct SidebarLayout: View {
    @Binding var selectedTab: NavigationTab
    @Binding var sidebarVisible: Bool
    let document: MindMapDocument
    let onOpenCanvas: () -> Void
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            FloatingSidebar(selectedTab: $selectedTab, sidebarVisible: $sidebarVisible)
                .navigationSplitViewColumnWidth(min: 250, ideal: 280, max: 320)
        } detail: {
            MainContentArea(
                selectedTab: selectedTab,
                document: document,
                onOpenCanvas: onOpenCanvas
            )
        }
        .navigationSplitViewStyle(.balanced)
    }
}

// MARK: - Tab Bar Layout (Portrait/iPhone)
struct TabBarLayout: View {
    @Binding var selectedTab: NavigationTab
    let document: MindMapDocument
    let onOpenCanvas: () -> Void
    
    var body: some View {
        ZStack {
            MainContentArea(
                selectedTab: selectedTab,
                document: document,
                onOpenCanvas: onOpenCanvas
            )
            
            VStack {
                Spacer()
                FloatingTabBar(selectedTab: $selectedTab)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 34)
            }
        }
    }
}

// MARK: - Adaptive MindMap Canvas View
struct AdaptiveMindMapCanvasView: View {
    @Bindable var document: MindMapDocument
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Your existing canvas implementation
                MindMapCanvasView(document: document)
                
                // Adaptive Toolbar Overlay
                VStack {
                    if shouldShowTopToolbar(for: geometry.size) {
                        AdaptiveTopToolbar(
                            document: document,
                            onBack: { dismiss() }
                        )
                        .padding(.top, getSafeAreaTop())
                    }
                    
                    Spacer()
                    
                    if shouldShowBottomToolbar(for: geometry.size) {
                        AdaptiveBottomToolbar(document: document)
                            .padding(.bottom, getSafeAreaBottom())
                    }
                }
                
                // Floating Action Button (iPhone Portrait)
                if shouldShowFloatingActions(for: geometry.size) {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            FloatingActionMenu(document: document)
                                .padding(.trailing, 20)
                                .padding(.bottom, 100)
                        }
                    }
                }
                
                // Back button for compact layouts
                if !shouldShowTopToolbar(for: geometry.size) {
                    VStack {
                        HStack {
                            Button(action: { dismiss() }) {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(.ultraThinMaterial, in: Circle())
                            }
                            .padding(.leading, 20)
                            .padding(.top, getSafeAreaTop() + 10)
                            
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: horizontalSizeClass)
    }
    
    private func shouldShowTopToolbar(for size: CGSize) -> Bool {
        return size.width > 768
    }
    
    private func shouldShowBottomToolbar(for size: CGSize) -> Bool {
        return size.width > 667 || size.width > size.height
    }
    
    private func shouldShowFloatingActions(for size: CGSize) -> Bool {
        return size.width <= 428 && size.height > size.width
    }
    
    private func getSafeAreaTop() -> CGFloat {
        #if os(iOS)
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.top ?? 0
        #else
        return 0
        #endif
    }
    
    private func getSafeAreaBottom() -> CGFloat {
        #if os(iOS)
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.bottom ?? 0
        #else
        return 0
        #endif
    }
}

// MARK: - Enhanced MindMap Canvas View (Your existing implementation enhanced)
struct MindMapCanvasView: View {
    @Bindable var document: MindMapDocument
    @State private var dragOffset: CGSize = .zero
    @State private var isDraggingCanvas = false
    @State private var isDraggingNode = false
    @State private var draggedNodeID: UUID?
    @State private var lastDragOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Enhanced dark background with subtle grid
                EnhancedCanvasBackground()
                
                // Connections layer
                Canvas { context, size in
                    drawConnections(context: context, canvasSize: size)
                }
                
                // Nodes layer
                ForEach(document.nodes) { node in
                    EnhancedNodeView(
                        node: node,
                        isSelected: document.selectedNodeIDs.contains(node.id),
                        onTap: { handleNodeTap(node.id) },
                        onDragChanged: { value in handleNodeDrag(node.id, value) },
                        onDragEnded: { _ in handleNodeDragEnd() },
                        onEdit: { newText in
                            if let index = document.nodes.firstIndex(where: { $0.id == node.id }) {
                                document.nodes[index].text = newText
                            }
                        }
                    )
                    .position(
                        x: (node.position.x * document.canvasState.zoom) + document.canvasState.panOffset.width + geometry.size.width / 2,
                        y: (node.position.y * document.canvasState.zoom) + document.canvasState.panOffset.height + geometry.size.height / 2
                    )
                    .scaleEffect(document.canvasState.zoom)
                }
            }
        }
        .clipped()
        .gesture(
            SimultaneousGesture(
                // Pan gesture for canvas
                DragGesture(minimumDistance: 5)
                    .onChanged { value in
                        if !isDraggingNode {
                            handleCanvasPan(value)
                        }
                    }
                    .onEnded { _ in
                        document.canvasState.endDrag()
                        isDraggingCanvas = false
                    },
                
                // Magnification gesture for zoom
                MagnificationGesture()
                    .onChanged { value in
                        document.canvasState.updateZoom(value, at: .zero)
                    }
            )
        )
        .onTapGesture { location in
            handleCanvasTap(at: location)
        }
        .onKeyPress(.space) {
            addNodeAtCenter()
            return .handled
        }
        .focusable()
    }
    
    // MARK: - Drawing Functions (Enhanced)
    
    private func drawConnections(context: GraphicsContext, canvasSize: CGSize) {
        for connection in document.connections {
            guard let fromNode = document.nodes.first(where: { $0.id == connection.fromNodeID }),
                  let toNode = document.nodes.first(where: { $0.id == connection.toNodeID }) else {
                continue
            }
            
            // Transform node positions to screen coordinates
            let fromPoint = transformedPosition(fromNode.centerPoint, canvasSize: canvasSize)
            let toPoint = transformedPosition(toNode.centerPoint, canvasSize: canvasSize)
            
            // Create smooth bezier curve with enhanced styling
            let controlPoint1 = CGPoint(
                x: fromPoint.x + (toPoint.x - fromPoint.x) * 0.3,
                y: fromPoint.y
            )
            let controlPoint2 = CGPoint(
                x: toPoint.x - (toPoint.x - fromPoint.x) * 0.3,
                y: toPoint.y
            )
            
            var path = Path()
            path.move(to: fromPoint)
            path.addCurve(to: toPoint, control1: controlPoint1, control2: controlPoint2)
            
            // Enhanced connection styling
            context.stroke(
                path,
                with: .color(connection.style.color.opacity(0.8)),
                style: StrokeStyle(
                    lineWidth: connection.style.lineWidth * document.canvasState.zoom,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
            
            // Add subtle glow effect
            context.stroke(
                path,
                with: .color(connection.style.color.opacity(0.3)),
                style: StrokeStyle(
                    lineWidth: (connection.style.lineWidth + 2) * document.canvasState.zoom,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
        }
    }
    
    private func transformedPosition(_ point: CGPoint, canvasSize: CGSize) -> CGPoint {
        CGPoint(
            x: (point.x * document.canvasState.zoom) + document.canvasState.panOffset.width + canvasSize.width / 2,
            y: (point.y * document.canvasState.zoom) + document.canvasState.panOffset.height + canvasSize.height / 2
        )
    }
    
    // MARK: - Gesture Handlers (Same as your implementation)
    
    private func handleCanvasPan(_ value: DragGesture.Value) {
        if !isDraggingCanvas {
            document.canvasState.startDrag()
            isDraggingCanvas = true
        }
        document.canvasState.updateDrag(with: value.translation)
    }
    
    private func handleNodeTap(_ nodeID: UUID) {
        document.selectNode(nodeID, exclusive: !isMultiSelectActive())
    }
    
    private func handleNodeDrag(_ nodeID: UUID, _ value: DragGesture.Value) {
        if !isDraggingNode {
            isDraggingNode = true
            draggedNodeID = nodeID
            
            if !document.selectedNodeIDs.contains(nodeID) {
                document.selectNode(nodeID, exclusive: !isMultiSelectActive())
            }
        }
        
        let scaledOffset = CGSize(
            width: (value.translation.width - lastDragOffset.width) / document.canvasState.zoom,
            height: (value.translation.height - lastDragOffset.height) / document.canvasState.zoom
        )
        document.moveSelectedNodes(by: scaledOffset)
        lastDragOffset = value.translation
    }
    
    private func handleNodeDragEnd() {
        isDraggingNode = false
        draggedNodeID = nil
        lastDragOffset = .zero
    }
    
    private func handleCanvasTap(at location: CGPoint) {
        let canvasLocation = CGPoint(
            x: (location.x - document.canvasState.panOffset.width) / document.canvasState.zoom,
            y: (location.y - document.canvasState.panOffset.height) / document.canvasState.zoom
        )
        
        let hitNode = document.nodes.first { node in
            let nodeFrame = CGRect(
                origin: CGPoint(
                    x: node.position.x - node.size.width / 2,
                    y: node.position.y - node.size.height / 2
                ),
                size: node.size
            )
            return nodeFrame.contains(canvasLocation)
        }
        
        if hitNode == nil {
            document.clearSelection()
        }
    }
    
    private func addNodeAtCenter() {
        let centerPoint = CGPoint(x: 0, y: 0)
        document.addNode(text: "New Node", at: centerPoint)
    }
    
    private func isMultiSelectActive() -> Bool {
        return false // Simplified for now
    }
}

// MARK: - Enhanced Node View
struct EnhancedNodeView: View {
    let node: MindMapNode
    let isSelected: Bool
    let onTap: () -> Void
    let onDragChanged: (DragGesture.Value) -> Void
    let onDragEnded: (DragGesture.Value) -> Void
    let onEdit: (String) -> Void
    
    @State private var isEditing = false
    @State private var editText = ""
    @State private var isHovered = false
    
    var body: some View {
        Group {
            if isEditing {
                TextField("Node text", text: $editText)
                    .textFieldStyle(.roundedBorder)
                    .frame(minWidth: 100)
                    .onSubmit {
                        onEdit(editText)
                        isEditing = false
                    }
                    .onAppear {
                        editText = node.text
                    }
            } else {
                Text(node.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .foregroundColor(node.style.textColor)
                    .font(.system(.body, design: .rounded, weight: .medium))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(minWidth: 80, minHeight: 40)
        .background(
            RoundedRectangle(cornerRadius: node.style.cornerRadius)
                .fill(
                    isSelected ?
                    node.style.backgroundColor.opacity(0.9) :
                    node.style.backgroundColor.opacity(isHovered ? 0.8 : 0.7)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: node.style.cornerRadius)
                        .stroke(
                            isSelected ? Color.blue : node.style.borderColor.opacity(0.5),
                            lineWidth: isSelected ? 3 : node.style.borderWidth
                        )
                )
                .shadow(
                    color: isSelected ? .blue.opacity(0.4) : .black.opacity(0.3),
                    radius: isSelected ? 12 : (isHovered ? 8 : 4),
                    x: 0,
                    y: isSelected ? 4 : 2
                )
        )
        .scaleEffect(isSelected ? 1.05 : (isHovered ? 1.02 : 1.0))
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .animation(.easeInOut(duration: 0.2), value: isHovered)
        .onTapGesture(count: 2) {
            isEditing = true
        }
        .onTapGesture {
            onTap()
        }
        .onHover { hovering in
            isHovered = hovering
        }
        .gesture(
            DragGesture()
                .onChanged(onDragChanged)
                .onEnded(onDragEnded)
        )
    }
}

// MARK: - Enhanced Canvas Background
struct EnhancedCanvasBackground: View {
    var body: some View {
        ZStack {
            // Deep dark background with subtle gradient
            LinearGradient(
                colors: [
                    Color.black,
                    Color.black.opacity(0.95)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Enhanced grid pattern
            Canvas { context, size in
                let gridSize: CGFloat = 50
                let smallGridSize: CGFloat = 10
                
                // Small grid (subtle)
                context.stroke(
                    Path { path in
                        for x in stride(from: 0, through: size.width, by: smallGridSize) {
                            path.move(to: CGPoint(x: x, y: 0))
                            path.addLine(to: CGPoint(x: x, y: size.height))
                        }
                        for y in stride(from: 0, through: size.height, by: smallGridSize) {
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: size.width, y: y))
                        }
                    },
                    with: .color(.white.opacity(0.02)),
                    lineWidth: 0.5
                )
                
                // Major grid (slightly more visible)
                context.stroke(
                    Path { path in
                        for x in stride(from: 0, through: size.width, by: gridSize) {
                            path.move(to: CGPoint(x: x, y: 0))
                            path.addLine(to: CGPoint(x: x, y: size.height))
                        }
                        for y in stride(from: 0, through: size.height, by: gridSize) {
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: size.width, y: y))
                        }
                    },
                    with: .color(.white.opacity(0.06)),
                    lineWidth: 0.8
                )
            }
        }
    }
}

// MARK: - Navigation Types (from previous implementation)
enum NavigationTab: String, CaseIterable, Identifiable {
    case mindmaps = "mindmaps"
    case templates = "templates"
    case recent = "recent"
    case settings = "settings"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .mindmaps: return "Mind Maps"
        case .templates: return "Templates"
        case .recent: return "Recent"
        case .settings: return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .mindmaps: return "brain.head.profile"
        case .templates: return "doc.on.doc"
        case .recent: return "clock"
        case .settings: return "gear"
        }
    }
}

// MARK: - Main Content Area
struct MainContentArea: View {
    let selectedTab: NavigationTab
    let document: MindMapDocument
    let onOpenCanvas: () -> Void
    
    var body: some View {
        Group {
            switch selectedTab {
            case .mindmaps:
                CurrentMindMapView(document: document, onOpenCanvas: onOpenCanvas)
            case .templates:
                TemplatesView()
            case .recent:
                RecentMindMapsView()
            case .settings:
                SettingsView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.systemBackground)
    }
}

// MARK: - Current Mind Map View
struct CurrentMindMapView: View {
    let document: MindMapDocument
    let onOpenCanvas: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(document.title.isEmpty ? "Untitled Mind Map" : document.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button("Edit Title") {
                        // Edit title functionality
                    }
                    .buttonStyle(.bordered)
                }
                
                HStack {
                    Text("\(document.nodes.count) nodes")
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("Last modified \(Date(), style: .relative)")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            .padding(.horizontal, 20)
            
            // Preview or Empty State
            if document.nodes.isEmpty {
                EmptyMindMapView(onCreateNode: onOpenCanvas)
            } else {
                MindMapPreviewCard(document: document, onOpen: onOpenCanvas)
            }
            
            Spacer()
        }
        .navigationTitle("Current Mind Map")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Open Canvas") {
                    onOpenCanvas()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

// MARK: - Empty Mind Map View
struct EmptyMindMapView: View {
    let onCreateNode: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 64))
                .foregroundColor(.secondary.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("Your mind map is empty")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Create your first node to get started")
                    .foregroundColor(.secondary)
            }
            
            Button("Create First Node") {
                onCreateNode()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 20)
    }
}

// MARK: - Mind Map Preview Card
struct MindMapPreviewCard: View {
    let document: MindMapDocument
    let onOpen: () -> Void
    @State private var isHovered = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Preview area
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.black)
                    .frame(height: 300)
                
                // Mini version of your canvas
                MiniCanvasPreview(document: document)
                    .clipped()
                    .cornerRadius(12)
            }
            
            // Action button
            Button("Open Canvas") {
                onOpen()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.quaternary, lineWidth: 0.5)
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .shadow(
            color: .black.opacity(isHovered ? 0.15 : 0.08),
            radius: isHovered ? 20 : 10,
            x: 0,
            y: isHovered ? 12 : 6
        )
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Mini Canvas Preview
struct MiniCanvasPreview: View {
    let document: MindMapDocument
    
    var body: some View {
        Canvas { context, size in
            // Dark background
            context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(.black))
            
            // Scale down and center the preview
            let scale: CGFloat = 0.1
            let centerX = size.width / 2
            let centerY = size.height / 2
            
            // Draw simplified nodes
            for (index, node) in document.nodes.enumerated() {
                let x = centerX + (node.position.x * scale)
                let y = centerY + (node.position.y * scale)
                
                // Draw node as small circle
                let nodeRect = CGRect(x: x - 4, y: y - 4, width: 8, height: 8)
                context.fill(
                    Path(ellipseIn: nodeRect),
                    with: .color(node.style.backgroundColor.opacity(0.8))
                )
            }
            
            // Draw connections
            for connection in document.connections {
                guard let fromNode = document.nodes.first(where: { $0.id == connection.fromNodeID }),
                      let toNode = document.nodes.first(where: { $0.id == connection.toNodeID }) else {
                    continue
                }
                
                let fromPoint = CGPoint(
                    x: centerX + (fromNode.position.x * scale),
                    y: centerY + (fromNode.position.y * scale)
                )
                let toPoint = CGPoint(
                    x: centerX + (toNode.position.x * scale),
                    y: centerY + (toNode.position.y * scale)
                )
                
                var path = Path()
                path.move(to: fromPoint)
                path.addLine(to: toPoint)
                
                context.stroke(
                    path,
                    with: .color(connection.style.color.opacity(0.6)),
                    lineWidth: 1
                )
            }
        }
    }
}

#Preview {
    ContentView(document: MindMapDocument())
        .preferredColorScheme(.dark)
}
