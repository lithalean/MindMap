// STEP 1: Create this folder structure in your Xcode project:
//
// MindMap/
// ├── App/
// │   └── MindMapApp.swift
// ├── Models/
// │   ├── MindMapDocument.swift
// │   ├── MindMapNode.swift
// │   ├── NodeConnection.swift
// │   ├── CanvasState.swift
// │   └── NodeStyle.swift
// └── Views/
//     └── ContentView.swift (your existing view)

// ============================================================================
// FILE 1: Models/MindMapDocument.swift
// ============================================================================

import SwiftUI
import Foundation

@Observable
class MindMapDocument {
	var nodes: [MindMapNode] = []
	var connections: [NodeConnection] = []
	var canvasState = CanvasState()
	var selectedNodeIDs: Set<UUID> = []
	
	init() {
		// Start with some sample data for testing
		addSampleData()
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
	
	// MARK: - Sample Data for Testing
	
	private func addSampleData() {
		let centerNode = addNode(text: "Core Idea", at: CGPoint(x: 400, y: 300))
		let featureA = addNode(text: "Feature A", at: CGPoint(x: 600, y: 200))
		let featureB = addNode(text: "Feature B", at: CGPoint(x: 600, y: 400))
		
		connectNodes(from: centerNode.id, to: featureA.id)
		connectNodes(from: centerNode.id, to: featureB.id)
	}
}

// ============================================================================
// FILE 2: Models/MindMapNode.swift
// ============================================================================

import SwiftUI
import Foundation

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

// ============================================================================
// FILE 3: Models/NodeConnection.swift
// ============================================================================

import SwiftUI
import Foundation

struct NodeConnection: Identifiable, Equatable {
	let id = UUID()
	let fromNodeID: UUID
	let toNodeID: UUID
	var style: ConnectionStyle = .default
	var createdAt = Date()
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

// ============================================================================
// FILE 4: Models/CanvasState.swift
// ============================================================================

import SwiftUI
import Foundation

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

// ============================================================================
// FILE 5: Models/NodeStyle.swift
// ============================================================================

import SwiftUI

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

// ============================================================================
// FILE 6: App/MindMapApp.swift (Update your existing App file)
// ============================================================================

import SwiftUI

@main
struct MindMapApp: App {
	var body: some Scene {
		DocumentGroup(newDocument: MindMapDocument()) { file in
			ContentView(document: file.$document)
		}
	}
}

// ============================================================================
// FILE 7: Views/ContentView.swift (Update to accept document)
// ============================================================================

import SwiftUI

struct ContentView: View {
	@Bindable var document: MindMapDocument
	
	var body: some View {
		VStack {
			Text("Modern MindMap")
				.font(.largeTitle)
				.padding()
			
			Text("Nodes: \(document.nodes.count)")
			Text("Connections: \(document.connections.count)")
			Text("Selected: \(document.selectedNodeIDs.count)")
			
			// Your existing UI goes here
			// We'll replace this in Step 2
			
			Spacer()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.black)
		.foregroundColor(.white)
	}
}

#Preview {
	ContentView(document: MindMapDocument())
}