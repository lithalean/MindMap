import SwiftUI

struct ContentView: View {
    @Bindable var document: MindMapDocument
    
    var body: some View {
        MindMapCanvasView(document: document)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
            .preferredColorScheme(.dark)
    }
}

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
                // Dark background with subtle grid
                CanvasBackground()
                
                // Connections layer
                Canvas { context, size in
                    drawConnections(context: context, canvasSize: size)
                }
                
                // Nodes layer
                ForEach(document.nodes) { node in
                    NodeView(
                        node: node,
                        isSelected: document.selectedNodeIDs.contains(node.id),
                        onTap: { handleNodeTap(node.id) },
                        onDragChanged: { value in handleNodeDrag(node.id, value) },
                        onDragEnded: { _ in handleNodeDragEnd() }
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
    
    // MARK: - Drawing Functions
    
    private func drawConnections(context: GraphicsContext, canvasSize: CGSize) {
        for connection in document.connections {
            guard let fromNode = document.nodes.first(where: { $0.id == connection.fromNodeID }),
                  let toNode = document.nodes.first(where: { $0.id == connection.toNodeID }) else {
                continue
            }
            
            // Transform node positions to screen coordinates
            let fromPoint = transformedPosition(fromNode.centerPoint, canvasSize: canvasSize)
            let toPoint = transformedPosition(toNode.centerPoint, canvasSize: canvasSize)
            
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
            
            context.stroke(
                path,
                with: .color(connection.style.color),
                lineWidth: connection.style.lineWidth * document.canvasState.zoom
            )
        }
    }
    
    private func transformedPosition(_ point: CGPoint, canvasSize: CGSize) -> CGPoint {
        CGPoint(
            x: (point.x * document.canvasState.zoom) + document.canvasState.panOffset.width + canvasSize.width / 2,
            y: (point.y * document.canvasState.zoom) + document.canvasState.panOffset.height + canvasSize.height / 2
        )
    }
    
    // MARK: - Gesture Handlers
    
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
            
            // Select the node if not already selected
            if !document.selectedNodeIDs.contains(nodeID) {
                document.selectNode(nodeID, exclusive: !isMultiSelectActive())
            }
        }
        
        // Move all selected nodes
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
        // Convert tap location to canvas coordinates
        let canvasLocation = CGPoint(
            x: (location.x - document.canvasState.panOffset.width) / document.canvasState.zoom,
            y: (location.y - document.canvasState.panOffset.height) / document.canvasState.zoom
        )
        
        // Check if tap hit any node
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
            // Tapped on empty canvas
            document.clearSelection()
        }
    }
    
    private func addNodeAtCenter() {
        let centerPoint = CGPoint(x: 0, y: 0) // Center of current view
        document.addNode(text: "New Node", at: centerPoint)
    }
    
    private func isMultiSelectActive() -> Bool {
        // Check for modifier keys (Command, Shift, etc.)
        return false // Simplified for now
    }
}

struct NodeView: View {
    let node: MindMapNode
    let isSelected: Bool
    let onTap: () -> Void
    let onDragChanged: (DragGesture.Value) -> Void
    let onDragEnded: (DragGesture.Value) -> Void
    
    @State private var isEditing = false
    @State private var editText = ""
    
    var body: some View {
        Group {
            if isEditing {
                TextField("Node text", text: $editText)
                    .textFieldStyle(.roundedBorder)
                    .frame(minWidth: 100)
                    .onSubmit {
                        // Update node text and exit editing
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
                .fill(isSelected ? node.style.backgroundColor.opacity(0.8) : node.style.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: node.style.cornerRadius)
                        .stroke(
                            isSelected ? Color.blue : node.style.borderColor,
                            lineWidth: isSelected ? 3 : node.style.borderWidth
                        )
                )
                .shadow(
                    color: isSelected ? .blue.opacity(0.3) : .black.opacity(0.2),
                    radius: isSelected ? 8 : 4,
                    x: 0,
                    y: 2
                )
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .onTapGesture(count: 2) {
            // Double tap to edit
            isEditing = true
        }
        .onTapGesture {
            onTap()
        }
        .gesture(
            DragGesture()
                .onChanged(onDragChanged)
                .onEnded(onDragEnded)
        )
    }
}

struct CanvasBackground: View {
    var body: some View {
        ZStack {
            // Base dark background
            Color.black
            
            // Subtle grid pattern
            Canvas { context, size in
                let gridSize: CGFloat = 50
                
                context.stroke(
                    Path { path in
                        // Vertical lines
                        for x in stride(from: 0, through: size.width, by: gridSize) {
                            path.move(to: CGPoint(x: x, y: 0))
                            path.addLine(to: CGPoint(x: x, y: size.height))
                        }
                        
                        // Horizontal lines
                        for y in stride(from: 0, through: size.height, by: gridSize) {
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: size.width, y: y))
                        }
                    },
                    with: .color(.gray.opacity(0.1)),
                    lineWidth: 0.5
                )
            }
        }
    }
}

#Preview {
    ContentView(document: MindMapDocument())
        .preferredColorScheme(.dark)
}
