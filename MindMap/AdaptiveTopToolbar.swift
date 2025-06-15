//
//  AdaptiveTopToolbar.swift
//  MindMap
//
//  Created by Tyler Allen on 6/15/25.
//


import SwiftUI

// MARK: - Adaptive Top Toolbar
struct AdaptiveTopToolbar: View {
    @Bindable var document: MindMapDocument
    let onBack: () -> Void
    @State private var showingDocumentSettings = false
    @State private var showingExportOptions = false
    
    var body: some View {
        HStack {
            // Back button and document info
            HStack(spacing: 12) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                .buttonStyle(CanvasToolButtonStyle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(document.title.isEmpty ? "Untitled Mind Map" : document.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
                        Text("\(document.nodes.count) nodes")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Circle()
                            .fill(.white.opacity(0.3))
                            .frame(width: 3, height: 3)
                        
                        Text("\(document.selectedNodeIDs.count) selected")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
            
            Spacer()
            
            // Tool buttons
            HStack(spacing: 8) {
                // Add Node
                Button(action: addNodeAtCenter) {
                    Image(systemName: "plus")
                        .font(.title3)
                }
                .buttonStyle(CanvasToolButtonStyle())
                .help("Add Node (Space)")
                
                // Fit to Screen
                Button(action: fitToScreen) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.title3)
                }
                .buttonStyle(CanvasToolButtonStyle())
                .help("Fit to Screen")
                
                // Zoom Controls
                HStack(spacing: 4) {
                    Button("-") {
                        document.canvasState.zoom = max(0.1, document.canvasState.zoom - 0.2)
                    }
                    .buttonStyle(ZoomButtonStyle())
                    
                    Text("\(Int(document.canvasState.zoom * 100))%")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .frame(width: 40)
                    
                    Button("+") {
                        document.canvasState.zoom = min(3.0, document.canvasState.zoom + 0.2)
                    }
                    .buttonStyle(ZoomButtonStyle())
                }
                .padding(.horizontal, 8)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                
                // Export
                Button(action: { showingExportOptions = true }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                }
                .buttonStyle(CanvasToolButtonStyle())
                .help("Export")
                
                // More Options
                Menu {
                    Button("Document Settings") {
                        showingDocumentSettings = true
                    }
                    
                    Button("Save as Template") {
                        // Save as template
                    }
                    
                    Divider()
                    
                    Button("Clear Selection") {
                        document.clearSelection()
                    }
                    .disabled(document.selectedNodeIDs.isEmpty)
                    
                    Button("Select All") {
                        document.selectAllNodes()
                    }
                    
                    Divider()
                    
                    Button("Help") {
                        // Show help
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title3)
                }
                .buttonStyle(CanvasToolButtonStyle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.1), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
        .padding(.horizontal, 20)
        .sheet(isPresented: $showingDocumentSettings) {
            DocumentSettingsSheet(document: document)
        }
        .sheet(isPresented: $showingExportOptions) {
            ExportOptionsSheet(document: document)
        }
    }
    
    private func addNodeAtCenter() {
        let centerPoint = CGPoint(x: 0, y: 0)
        document.addNode(text: "New Node", at: centerPoint)
    }
    
    private func fitToScreen() {
        withAnimation(.easeInOut(duration: 0.5)) {
            document.canvasState.zoom = 1.0
            document.canvasState.panOffset = .zero
        }
    }
}

// MARK: - Adaptive Bottom Toolbar
struct AdaptiveBottomToolbar: View {
    @Bindable var document: MindMapDocument
    @State private var selectedTool: CanvasTool = .select
    
    var body: some View {
        HStack {
            if !document.selectedNodeIDs.isEmpty {
                // Selection-specific toolbar
                SelectionToolbar(document: document)
            } else {
                // General tools
                GeneralToolbar(document: document, selectedTool: $selectedTool)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.1), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: -8)
        .padding(.horizontal, 20)
        .animation(.easeInOut(duration: 0.2), value: document.selectedNodeIDs.isEmpty)
    }
}

// MARK: - Selection Toolbar
struct SelectionToolbar: View {
    @Bindable var document: MindMapDocument
    @State private var showingStyleOptions = false
    
    var body: some View {
        HStack {
            // Selection count
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title3)
                
                Text("\(document.selectedNodeIDs.count) selected")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // Selection actions
            HStack(spacing: 12) {
                // Connect nodes
                Button(action: connectSelectedNodes) {
                    Image(systemName: "link")
                        .font(.title3)
                }
                .buttonStyle(CanvasToolButtonStyle())
                .help("Connect Selected Nodes")
                .disabled(document.selectedNodeIDs.count < 2)
                
                // Style nodes
                Button(action: { showingStyleOptions = true }) {
                    Image(systemName: "paintbrush")
                        .font(.title3)
                }
                .buttonStyle(CanvasToolButtonStyle())
                .help("Style Nodes")
                
                // Duplicate nodes
                Button(action: duplicateSelectedNodes) {
                    Image(systemName: "doc.on.doc")
                        .font(.title3)
                }
                .buttonStyle(CanvasToolButtonStyle())
                .help("Duplicate Nodes")
                
                // Delete nodes
                Button(action: deleteSelectedNodes) {
                    Image(systemName: "trash")
                        .font(.title3)
                        .foregroundColor(.red)
                }
                .buttonStyle(CanvasToolButtonStyle())
                .help("Delete Selected Nodes")
                
                // Clear selection
                Button(action: { document.clearSelection() }) {
                    Image(systemName: "xmark.circle")
                        .font(.title3)
                }
                .buttonStyle(CanvasToolButtonStyle())
                .help("Clear Selection")
            }
        }
        .sheet(isPresented: $showingStyleOptions) {
            NodeStyleSheet(document: document)
        }
    }
    
    private func connectSelectedNodes() {
        let selectedNodes = document.nodes.filter { document.selectedNodeIDs.contains($0.id) }
        guard selectedNodes.count >= 2 else { return }
        
        // Connect all selected nodes in sequence
        for i in 0..<selectedNodes.count - 1 {
            let connection = NodeConnection(
                fromNodeID: selectedNodes[i].id,
                toNodeID: selectedNodes[i + 1].id
            )
            document.connections.append(connection)
        }
    }
    
    private func duplicateSelectedNodes() {
        let selectedNodes = document.nodes.filter { document.selectedNodeIDs.contains($0.id) }
        var newNodeIDs: Set<UUID> = []
        
        for node in selectedNodes {
            let newNode = MindMapNode(
                text: node.text,
                position: CGPoint(x: node.position.x + 50, y: node.position.y + 50),
                size: node.size,
                style: node.style
            )
            document.nodes.append(newNode)
            newNodeIDs.insert(newNode.id)
        }
        
        // Select the new nodes
        document.selectedNodeIDs = newNodeIDs
    }
    
    private func deleteSelectedNodes() {
        withAnimation(.easeInOut(duration: 0.2)) {
            // Remove connections involving selected nodes
            document.connections.removeAll { connection in
                document.selectedNodeIDs.contains(connection.fromNodeID) ||
                document.selectedNodeIDs.contains(connection.toNodeID)
            }
            
            // Remove selected nodes
            document.nodes.removeAll { document.selectedNodeIDs.contains($0.id) }
            
            // Clear selection
            document.selectedNodeIDs.removeAll()
        }
    }
}

// MARK: - General Toolbar
struct GeneralToolbar: View {
    @Bindable var document: MindMapDocument
    @Binding var selectedTool: CanvasTool
    
    var body: some View {
        HStack {
            // Tool selection
            HStack(spacing: 8) {
                ForEach(CanvasTool.allCases, id: \.self) { tool in
                    Button(action: { selectedTool = tool }) {
                        Image(systemName: tool.icon)
                            .font(.title3)
                            .foregroundColor(selectedTool == tool ? .blue : .white)
                    }
                    .buttonStyle(CanvasToolButtonStyle(isSelected: selectedTool == tool))
                    .help(tool.title)
                }
            }
            
            Spacer()
            
            // Canvas controls
            HStack(spacing: 12) {
                // Undo/Redo (placeholder)
                Button(action: {}) {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.title3)
                }
                .buttonStyle(CanvasToolButtonStyle())
                .help("Undo")
                .disabled(true) // Implement undo system
                
                Button(action: {}) {
                    Image(systemName: "arrow.uturn.forward")
                        .font(.title3)
                }
                .buttonStyle(CanvasToolButtonStyle())
                .help("Redo")
                .disabled(true) // Implement redo system
                
                // Grid toggle
                Button(action: {}) {
                    Image(systemName: "grid")
                        .font(.title3)
                }
                .buttonStyle(CanvasToolButtonStyle())
                .help("Toggle Grid")
                
                // Snap to grid
                Button(action: {}) {
                    Image(systemName: "grid.circle")
                        .font(.title3)
                }
                .buttonStyle(CanvasToolButtonStyle())
                .help("Snap to Grid")
            }
        }
    }
}

// MARK: - Floating Action Menu
struct FloatingActionMenu: View {
    @Bindable var document: MindMapDocument
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 12) {
            if isExpanded {
                // Secondary actions
                FloatingActionButton(
                    icon: "link",
                    color: .blue,
                    title: "Connect"
                ) {
                    // Switch to connection tool
                }
                
                FloatingActionButton(
                    icon: "paintbrush",
                    color: .purple,
                    title: "Style"
                ) {
                    // Open style options
                }
                
                FloatingActionButton(
                    icon: "square.and.arrow.up",
                    color: .green,
                    title: "Export"
                ) {
                    // Export options
                }
                
                FloatingActionButton(
                    icon: "arrow.up.left.and.arrow.down.right",
                    color: .orange,
                    title: "Fit Screen"
                ) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        document.canvasState.zoom = 1.0
                        document.canvasState.panOffset = .zero
                    }
                }
            }
            
            // Main FAB - Add Node
            Button(action: {
                if isExpanded {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isExpanded = false
                    }
                } else {
                    // Add node at center
                    let centerPoint = CGPoint(x: 0, y: 0)
                    document.addNode(text: "New Node", at: centerPoint)
                }
            }) {
                Image(systemName: isExpanded ? "xmark" : "plus")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(.blue, in: Circle())
                    .rotationEffect(.degrees(isExpanded ? 45 : 0))
            }
            .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
            .gesture(
                LongPressGesture(minimumDuration: 0.3)
                    .onEnded { _ in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            isExpanded.toggle()
                        }
                    }
            )
        }
    }
}

// MARK: - Floating Action Button
struct FloatingActionButton: View {
    let icon: String
    let color: Color
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(color, in: Circle())
        }
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
        .transition(.scale.combined(with: .opacity))
        .help(title)
    }
}

// MARK: - Canvas Tool Button Style
struct CanvasToolButtonStyle: ButtonStyle {
    let isSelected: Bool
    
    init(isSelected: Bool = false) {
        self.isSelected = isSelected
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(isSelected ? .blue : .white)
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? .white.opacity(0.2) : .clear)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Zoom Button Style
struct ZoomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(width: 28, height: 28)
            .background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 6))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Canvas Tool Enum
enum CanvasTool: CaseIterable {
    case select
    case addNode
    case connect
    case pan
    
    var icon: String {
        switch self {
        case .select: return "hand.draw"
        case .addNode: return "plus.circle"
        case .connect: return "line.diagonal"
        case .pan: return "hand.raised"
        }
    }
    
    var title: String {
        switch self {
        case .select: return "Select"
        case .addNode: return "Add Node"
        case .connect: return "Connect"
        case .pan: return "Pan"
        }
    }
}

// MARK: - Floating Sidebar (from previous implementation)
struct FloatingSidebar: View {
    @Binding var selectedTab: NavigationTab
    @Binding var sidebarVisible: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "brain.head.profile")
                        .font(.title2)
                        .foregroundColor(.accentColor)
                    
                    Text("MindMap")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: { sidebarVisible.toggle() }) {
                        Image(systemName: "sidebar.left")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Text("DarwinCodex Suite")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            Divider()
                .padding(.horizontal, 16)
            
            // Navigation Items
            VStack(spacing: 4) {
                ForEach(NavigationTab.allCases) { tab in
                    SidebarNavigationItem(
                        tab: tab,
                        isSelected: selectedTab == tab
                    ) {
                        selectedTab = tab
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)
            
            Spacer()
            
            // Footer Actions
            VStack(spacing: 8) {
                Divider()
                    .padding(.horizontal, 16)
                
                HStack {
                    Button(action: {}) {
                        Label("New Mind Map", systemImage: "plus")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
        }
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.quaternary, lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 8)
        .padding(16)
    }
}

// MARK: - Sidebar Navigation Item
struct SidebarNavigationItem: View {
    let tab: NavigationTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: tab.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? .accentColor : .secondary)
                    .frame(width: 20, height: 20)
                
                Text(tab.title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(isSelected ? .primary : .secondary)
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? .accent.opacity(0.1) : .clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Floating Tab Bar
struct FloatingTabBar: View {
    @Binding var selectedTab: NavigationTab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(NavigationTab.allCases) { tab in
                TabBarItem(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    selectedTab = tab
                }
                
                if tab != NavigationTab.allCases.last {
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(.quaternary, lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 8)
    }
}

// MARK: - Tab Bar Item
struct TabBarItem: View {
    let tab: NavigationTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? .accentColor : .secondary)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .accentColor : .secondary)
            }
            .frame(minWidth: 60)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Document Settings Sheet
struct DocumentSettingsSheet: View {
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
                    // Canvas background options, grid settings, etc.
                    Toggle("Show Grid", isOn: .constant(true))
                    Toggle("Snap to Grid", isOn: .constant(false))
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
        .onAppear {
            editableTitle = document.title
        }
        .presentationDetents([.medium, .large])
    }
}

// MARK: - Export Options Sheet
struct ExportOptionsSheet: View {
    let document: MindMapDocument
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("Image Formats") {
                    Button("Export as PNG") {
                        // Export PNG
                        dismiss()
                    }
                    
                    Button("Export as PDF") {
                        // Export PDF
                        dismiss()
                    }
                    
                    Button("Export as SVG") {
                        // Export SVG
                        dismiss()
                    }
                }
                
                Section("Data Formats") {
                    Button("Export as JSON") {
                        // Export JSON
                        dismiss()
                    }
                    
                    Button("Export as Markdown") {
                        // Export Markdown
                        dismiss()
                    }
                }
            }
            .navigationTitle("Export Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

// MARK: - Node Style Sheet
struct NodeStyleSheet: View {
    @Bindable var document: MindMapDocument
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Node Style") {
                    // Color picker, font options, etc.
                    ColorPicker("Background Color", selection: .constant(.blue))
                    ColorPicker("Text Color", selection: .constant(.white))
                    ColorPicker("Border Color", selection: .constant(.gray))
                }
                
                Section("Shape") {
                    // Shape selection
                    Text("Rectangle") // Placeholder
                }
            }
            .navigationTitle("Style Nodes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        // Apply styles to selected nodes
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

// MARK: - Additional placeholder views
struct TemplatesView: View {
    var body: some View {
        Text("Templates")
            .font(.largeTitle)
            .navigationTitle("Templates")
    }
}

struct RecentMindMapsView: View {
    var body: some View {
        Text("Recent Mind Maps")
            .font(.largeTitle)
            .navigationTitle("Recent")
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings")
            .font(.largeTitle)
            .navigationTitle("Settings")
    }
}