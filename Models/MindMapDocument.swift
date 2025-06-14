//
//  MindMapDocument.swift
//  MindMap
//
//  Created by Tyler Allen on 6/14/25.
//


import SwiftUI
import Foundation

// MARK: - Modern Observable Data Models

@Observable
class MindMapDocument {
    var nodes: [MindMapNode] = []
    var connections: [NodeConnection] = []
    var canvasState = CanvasState()
    var selectedNodeIDs: Set<UUID> = []
    
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

struct MindMapNode: Identifiable, Equatable {
    let id = UUID()
    var text: String
    var position: CGPoint
    var size: CGSize = CGSize(width: 120, height: 60)
    var style: NodeStyle = .default
    var createdAt = Date()
    
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

struct NodeConnection: Identifiable, Equatable {
    let id = UUID()
    let fromNodeID: UUID
    let toNodeID: UUID
    var style: ConnectionStyle = .default
    var createdAt = Date()
}

struct NodeStyle: Equatable {
    var backgroundColor: Color
    var borderColor: Color
    var textColor: Color
    var borderWidth: CGFloat
    var cornerRadius: CGFloat
    
    static let `default` = NodeStyle(
        backgroundColor: Color(.systemGray6),
        borderColor: Color(.systemBlue),
        textColor: Color.primary,
        borderWidth: 2,
        cornerRadius: 12
    )
    
    static let selected = NodeStyle(
        backgroundColor: Color(.systemBlue).opacity(0.1),
        borderColor: Color(.systemBlue),
        textColor: Color.primary,
        borderWidth: 3,
        cornerRadius: 12
    )
    
    // Developer-focused theme
    static let codeBlock = NodeStyle(
        backgroundColor: Color(.systemGray6),
        borderColor: Color(.systemOrange),
        textColor: Color.primary,
        borderWidth: 2,
        cornerRadius: 8
    )
}

struct ConnectionStyle: Equatable {
    var color: Color
    var lineWidth: CGFloat
    var dashPattern: [CGFloat]?
    
    static let `default` = ConnectionStyle(
        color: Color(.systemGray),
        lineWidth: 2,
        dashPattern: nil
    )
    
    static let highlighted = ConnectionStyle(
        color: Color(.systemBlue),
        lineWidth: 3,
        dashPattern: nil
    )
}