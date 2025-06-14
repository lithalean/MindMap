import SwiftUI
import UniformTypeIdentifiers
import Foundation

// MARK: - Modern Observable Document with File Support

@Observable
class MindMapDocument: ReferenceFileDocument {
    // Use built-in JSON type instead of custom type
    static var readableContentTypes: [UTType] { [.json] }
    static var writableContentTypes: [UTType] { [.json] }
    
    // Data properties
    var nodes: [MindMapNode] = []
    var connections: [NodeConnection] = []
    var canvasState = CanvasState()
    var selectedNodeIDs: Set<UUID> = []
    
    // Required initializer for new documents
    required init() {
        // Add some sample data so you can see it working
        let centerNode = addNode(text: "Core Idea", at: CGPoint(x: 400, y: 300))
        let featureA = addNode(text: "Feature A", at: CGPoint(x: 600, y: 200))
        let featureB = addNode(text: "Feature B", at: CGPoint(x: 600, y: 400))
        
        connectNodes(from: centerNode.id, to: featureA.id)
        connectNodes(from: centerNode.id, to: featureB.id)
    }
    
    // Required for loading documents
    required init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            let decoder = JSONDecoder()
            let documentData = try decoder.decode(DocumentData.self, from: data)
            self.nodes = documentData.nodes
            self.connections = documentData.connections
        }
    }
    
    // Required for saving documents
    func snapshot(contentType: UTType) throws -> DocumentData {
        DocumentData(nodes: nodes, connections: connections)
    }
    
    // Required for writing documents
    func fileWrapper(snapshot: DocumentData, configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(snapshot)
        return FileWrapper(regularFileWithContents: data)
    }
    
    // MARK: - Node Management
    
    func addNode(text: String, at position: CGPoint) -> MindMapNode {
        let node = MindMapNode(text: text, position: position)
        nodes.append(node)
        return node
    }
    
    func deleteNode(id: UUID) {
        nodes.removeAll { $0.id == id }
        connections.removeAll { $0.fromNodeID == id || $0.toNodeID == id }
        selectedNodeIDs.remove(id)
    }
    
    func connectNodes(from: UUID, to: UUID) {
        let connection = NodeConnection(fromNodeID: from, toNodeID: to)
        if !connections.contains(where: { $0.fromNodeID == from && $0.toNodeID == to }) {
            connections.append(connection)
        }
    }
    
    // MARK: - Selection Management
    
    func selectNode(_ id: UUID, exclusive: Bool = true) {
        if exclusive {
            selectedNodeIDs.removeAll()
        }
        selectedNodeIDs.insert(id)
    }
    
    func toggleNodeSelection(_ id: UUID) {
        if selectedNodeIDs.contains(id) {
            selectedNodeIDs.remove(id)
        } else {
            selectedNodeIDs.insert(id)
        }
    }
    
    func clearSelection() {
        selectedNodeIDs.removeAll()
    }
    
    // MARK: - Canvas Operations
    
    func moveSelectedNodes(by offset: CGSize) {
        for nodeID in selectedNodeIDs {
            if let index = nodes.firstIndex(where: { $0.id == nodeID }) {
                nodes[index].position.x += offset.width
                nodes[index].position.y += offset.height
            }
        }
    }
}

// MARK: - Document Data (for saving/loading)
struct DocumentData: Codable {
    let nodes: [MindMapNode]
    let connections: [NodeConnection]
}

@Observable
class CanvasState {
    var zoom: CGFloat = 1.0
    var panOffset: CGSize = .zero
    var isDragging = false
    var dragStartOffset: CGSize = .zero
    
    var transform: CGAffineTransform {
        CGAffineTransform.identity
            .scaledBy(x: zoom, y: zoom)
            .translatedBy(x: panOffset.width, y: panOffset.height)
    }
    
    func startDrag() {
        isDragging = true
        dragStartOffset = panOffset
    }
    
    func updateDrag(with translation: CGSize) {
        panOffset = CGSize(
            width: dragStartOffset.width + translation.width / zoom,
            height: dragStartOffset.height + translation.height / zoom
        )
    }
    
    func endDrag() {
        isDragging = false
    }
    
    func updateZoom(_ newZoom: CGFloat, at point: CGPoint) {
        let clampedZoom = max(0.1, min(5.0, newZoom))
        zoom = clampedZoom
    }
}

// MARK: - Data Models

struct MindMapNode: Identifiable, Equatable, Codable {
    let id: UUID
    var text: String
    var position: CGPoint
    var size: CGSize
    var style: NodeStyle
    var createdAt: Date
    
    init(text: String, position: CGPoint) {
        self.id = UUID()
        self.text = text
        self.position = position
        self.size = CGSize(width: 120, height: 60)
        self.style = .default
        self.createdAt = Date()
    }
    
    var frame: CGRect {
        CGRect(origin: position, size: size)
    }
    
    var centerPoint: CGPoint {
        CGPoint(
            x: position.x + size.width / 2,
            y: position.y + size.height / 2
        )
    }
}

struct NodeConnection: Identifiable, Equatable, Codable {
    let id: UUID
    let fromNodeID: UUID
    let toNodeID: UUID
    var style: ConnectionStyle
    var createdAt: Date
    
    init(fromNodeID: UUID, toNodeID: UUID) {
        self.id = UUID()
        self.fromNodeID = fromNodeID
        self.toNodeID = toNodeID
        self.style = .default
        self.createdAt = Date()
    }
}

struct NodeStyle: Equatable, Codable {
    var styleType: String = "default"
    var borderWidth: CGFloat = 2
    var cornerRadius: CGFloat = 12
    
    var backgroundColor: Color {
        switch styleType {
        case "selected": return Color(.systemBlue).opacity(0.1)
        case "codeBlock": return Color(.systemGray6)
        default: return Color(.systemGray6)
        }
    }
    
    var borderColor: Color {
        switch styleType {
        case "selected": return Color(.systemBlue)
        case "codeBlock": return Color(.systemOrange)
        default: return Color(.systemBlue)
        }
    }
    
    var textColor: Color {
        return Color.primary
    }
    
    static let `default` = NodeStyle(styleType: "default")
    static let selected = NodeStyle(styleType: "selected", borderWidth: 3)
    static let codeBlock = NodeStyle(styleType: "codeBlock")
}

struct ConnectionStyle: Equatable, Codable {
    var styleType: String = "default"
    var lineWidth: CGFloat = 2
    var dashPattern: [CGFloat]?
    
    var color: Color {
        switch styleType {
        case "highlighted": return Color(.systemBlue)
        default: return Color(.systemGray)
        }
    }
    
    static let `default` = ConnectionStyle(styleType: "default")
    static let highlighted = ConnectionStyle(styleType: "highlighted", lineWidth: 3)
}
