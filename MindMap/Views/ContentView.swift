import SwiftUI

struct ContentView: View {
    @Bindable var document: MindMapDocument
    @State private var showingCanvasView = false
    
    var isMacCatalyst: Bool {
        #if targetEnvironment(macCatalyst)
        return true
        #else
        return false
        #endif
    }
    
    var body: some View {
        GeometryReader { geometry in
            if showingCanvasView {
                // Full Canvas Mode with Mac Catalyst adjustments
                MindMapCanvasView(document: document)
                    .background(.black)
                    .preferredColorScheme(.dark)
                    .overlay(alignment: .topLeading) {
                        // Back button with Mac-appropriate styling
                        Button(action: { showingCanvasView = false }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(isMacCatalyst ? .body : .title2)
                                
                                if isMacCatalyst {
                                    Text("Back")
                                        .font(.body)
                                }
                            }
                            .foregroundColor(.white)
                            .padding(isMacCatalyst ? 8 : 12)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: isMacCatalyst ? 8 : 12))
                        }
                        .padding(isMacCatalyst ? 16 : 20)
                    }
                    .overlay(alignment: .topTrailing) {
                        // Add node button with Mac-appropriate styling
                        Button(action: addNodeAtCenter) {
                            HStack(spacing: 8) {
                                Image(systemName: "plus")
                                    .font(isMacCatalyst ? .body : .title2)
                                
                                if isMacCatalyst {
                                    Text("Add Node")
                                        .font(.body)
                                }
                            }
                            .foregroundColor(.white)
                            .padding(isMacCatalyst ? 8 : 12)
                            .background(.blue, in: RoundedRectangle(cornerRadius: isMacCatalyst ? 8 : 12))
                        }
                        .padding(isMacCatalyst ? 16 : 20)
                    }
                    .overlay(alignment: .top) {
                        // Mac-style toolbar when running on Mac
                        if isMacCatalyst {
                            MacCatalystToolbar(document: document)
                                .padding(.top, 8)
                        }
                    }
            } else {
                // Document Browser Mode with platform-appropriate layout
                if shouldShowSidebar(for: geometry.size) {
                    NavigationSplitView {
                        MacCatalystSidebar(onOpenCanvas: { showingCanvasView = true })
                            .navigationSplitViewColumnWidth(min: 250, ideal: 280, max: 320)
                    } detail: {
                        DocumentBrowserView(document: document, onOpenCanvas: { showingCanvasView = true })
                            .navigationBarHidden(isMacCatalyst)
                    }
                } else {
                    DocumentBrowserView(document: document, onOpenCanvas: { showingCanvasView = true })
                }
            }
        }
        .onAppear {
            if !document.nodes.isEmpty {
                showingCanvasView = true
            }
        }
    }
    
    private func shouldShowSidebar(for size: CGSize) -> Bool {
        // Always show sidebar on Mac Catalyst, or iPad landscape
        return isMacCatalyst || (size.width > 768 && size.height < size.width * 1.2)
    }
    
    private func addNodeAtCenter() {
        let centerPoint = CGPoint(x: 0, y: 0)
        document.addNode(text: "New Node", at: centerPoint)
    }
}

// MARK: - Document Browser View
struct DocumentBrowserView: View {
    let document: MindMapDocument
    let onOpenCanvas: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(document.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                
                HStack {
                    Text("\(document.nodes.count) nodes")
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text("\(document.connections.count) connections")
                        .foregroundColor(.secondary)
                    
                    Spacer()
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
        .navigationTitle("Mind Map")
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
            let scale: CGFloat = 0.5
            let centerX = size.width / 2
            let centerY = size.height / 2
            
            // Draw connections first
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
                    lineWidth: 2
                )
            }
            
            // Draw simplified nodes
            for node in document.nodes {
                let x = centerX + (node.position.x * scale)
                let y = centerY + (node.position.y * scale)
                
                // Draw node as rounded rectangle
                let nodeRect = CGRect(x: x - 30, y: y - 15, width: 60, height: 30)
                let roundedRect = Path(roundedRect: nodeRect, cornerRadius: 8)
                
                context.fill(
                    roundedRect,
                    with: .color(node.style.backgroundColor.opacity(0.8))
                )
                
                context.stroke(
                    roundedRect,
                    with: .color(node.style.borderColor.opacity(0.6)),
                    lineWidth: 1
                )
            }
        }
    }
}

// MARK: - Main Canvas View
struct MindMapCanvasView: View {
    @Bindable var document: MindMapDocument
    @State private var isDraggingCanvas = false
    @State private var isDraggingNode = false
    @State private var draggedNodeID: UUID?
    @State private var lastDragOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Enhanced dark background with subtle grid
                CanvasBackground()
                
                // Connections layer
                Canvas { context, size in
                    for connection in document.connections {
                        guard let fromNode = document.nodes.first(where: { $0.id == connection.fromNodeID }),
                              let toNode = document.nodes.first(where: { $0.id == connection.toNodeID }) else {
                            continue
                        }
                        
                        // Transform node positions to screen coordinates
                        let fromPoint = CGPoint(
                            x: (fromNode.centerPoint.x * document.canvasState.zoom) + document.canvasState.panOffset.width + size.width / 2,
                            y: (fromNode.centerPoint.y * document.canvasState.zoom) + document.canvasState.panOffset.height + size.height / 2
                        )
                        let toPoint = CGPoint(
                            x: (toNode.centerPoint.x * document.canvasState.zoom) + document.canvasState.panOffset.width + size.width / 2,
                            y: (toNode.centerPoint.y * document.canvasState.zoom) + document.canvasState.panOffset.height + size.height / 2
                        )
                        
                        // Create smooth bezier curve
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
                    }
                }
                
                // Nodes layer
                ForEach(document.nodes) { node in
                    NodeView(
                        node: node,
                        isSelected: document.selectedNodeIDs.contains(node.id),
                        onTap: {
                            document.selectNode(node.id, exclusive: true)
                        },
                        onDragChanged: { value in
                            if !isDraggingNode {
                                isDraggingNode = true
                                draggedNodeID = node.id
                                
                                if !document.selectedNodeIDs.contains(node.id) {
                                    document.selectNode(node.id, exclusive: true)
                                }
                            }
                            
                            let scaledOffset = CGSize(
                                width: (value.translation.width - lastDragOffset.width) / document.canvasState.zoom,
                                height: (value.translation.height - lastDragOffset.height) / document.canvasState.zoom
                            )
                            document.moveSelectedNodes(by: scaledOffset)
                            lastDragOffset = value.translation
                        },
                        onDragEnded: { _ in
                            isDraggingNode = false
                            draggedNodeID = nil
                            lastDragOffset = .zero
                        },
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
            .clipped()
            .gesture(
                SimultaneousGesture(
                    // Pan gesture for canvas
                    DragGesture(minimumDistance: 5)
                        .onChanged { value in
                            if !isDraggingNode {
                                if !isDraggingCanvas {
                                    document.canvasState.startDrag()
                                    isDraggingCanvas = true
                                }
                                document.canvasState.updateDrag(with: value.translation)
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
                let canvasLocation = CGPoint(
                    x: (location.x - geometry.size.width / 2 - document.canvasState.panOffset.width) / document.canvasState.zoom,
                    y: (location.y - geometry.size.height / 2 - document.canvasState.panOffset.height) / document.canvasState.zoom
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
        }
    }
}

// MARK: - Node View
struct NodeView: View {
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

// MARK: - Canvas Background
struct CanvasBackground: View {
    var body: some View {
        ZStack {
            // Deep dark background
            Color.black
            
            // Grid pattern
            Canvas { context, size in
                let gridSize: CGFloat = 50
                
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
                    with: .color(.white.opacity(0.05)),
                    lineWidth: 0.5
                )
            }
        }
    }
}

// MARK: - Mac Catalyst Toolbar
struct MacCatalystToolbar: View {
    @Bindable var document: MindMapDocument
    @State private var showingSettings = false
    
    var body: some View {
        HStack {
            // Document info
            HStack(spacing: 12) {
                Text(document.title.isEmpty ? "Untitled Mind Map" : document.title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(document.nodes.count) nodes, \(document.selectedNodeIDs.count) selected")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            // Mac-style controls
            HStack(spacing: 12) {
                // Zoom controls
                HStack(spacing: 4) {
                    Button("−") {
                        document.canvasState.zoom = max(0.1, document.canvasState.zoom - 0.2)
                    }
                    .buttonStyle(MacZoomButtonStyle())
                    
                    Text("\(Int(document.canvasState.zoom * 100))%")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .frame(width: 40)
                    
                    Button("+") {
                        document.canvasState.zoom = min(3.0, document.canvasState.zoom + 0.2)
                    }
                    .buttonStyle(MacZoomButtonStyle())
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 6))
                
                // Fit to screen
                Button(action: fitToScreen) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.body)
                }
                .buttonStyle(MacToolButtonStyle())
                
                // Settings
                Button(action: { showingSettings = true }) {
                    Image(systemName: "gear")
                        .font(.body)
                }
                .buttonStyle(MacToolButtonStyle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal, 20)
        .sheet(isPresented: $showingSettings) {
            MacDocumentSettingsSheet(document: document)
        }
    }
    
    private func fitToScreen() {
        withAnimation(.easeInOut(duration: 0.5)) {
            document.canvasState.zoom = 1.0
            document.canvasState.panOffset = .zero
        }
    }
}

// MARK: - Mac Catalyst Sidebar
struct MacCatalystSidebar: View {
    let onOpenCanvas: () -> Void
    
    var body: some View {
        List {
            Section("MindMap") {
                Button(action: onOpenCanvas) {
                    Label("Current Document", systemImage: "brain.head.profile")
                }
                
                NavigationLink(destination: Text("Templates Coming Soon")) {
                    Label("Templates", systemImage: "doc.on.doc")
                }
                
                NavigationLink(destination: Text("Recent Coming Soon")) {
                    Label("Recent", systemImage: "clock")
                }
            }
            
            Section("Tools") {
                Button(action: onOpenCanvas) {
                    Label("Open Canvas", systemImage: "pencil.and.scribble")
                }
                
                Button("New Document") {
                    // New document action - placeholder
                }
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("MindMap")
    }
}

// MARK: - Mac-specific Button Styles
struct MacToolButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(.white.opacity(configuration.isPressed ? 0.3 : 0.1))
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct MacZoomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .frame(width: 24, height: 24)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(.white.opacity(configuration.isPressed ? 0.3 : 0.1))
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Mac-optimized Document Settings
struct MacDocumentSettingsSheet: View {
    @Bindable var document: MindMapDocument
    @Environment(\.dismiss) private var dismiss
    @State private var editableTitle: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Document") {
                    TextField("Title", text: $editableTitle)
                        .textFieldStyle(.roundedBorder)
                }
                
                Section("Canvas Settings") {
                    Toggle("Show Grid", isOn: .constant(true))
                        .disabled(true)
                    Toggle("Snap to Grid", isOn: .constant(false))
                        .disabled(true)
                }
                
                Section("Statistics") {
                    HStack {
                        Text("Nodes")
                        Spacer()
                        Text("\(document.nodes.count)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Connections")
                        Spacer()
                        Text("\(document.connections.count)")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Document Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        document.title = editableTitle
                        dismiss()
                    }
                }
            }
        }
        .frame(minWidth: 500, minHeight: 400)
        .onAppear {
            editableTitle = document.title
        }
    }
}

#Preview {
    ContentView(document: MindMapDocument())
        .preferredColorScheme(.dark)
}
