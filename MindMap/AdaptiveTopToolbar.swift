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
                        // Save as template - placeholder
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
                        // Show help - placeholder
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
                        .disabled(true) // Placeholder
                    Toggle("Snap to Grid", isOn: .constant(false))
                        .disabled(true) // Placeholder
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
                        // Export PNG - placeholder
                        dismiss()
                    }
                    
                    Button("Export as PDF") {
                        // Export PDF - placeholder
                        dismiss()
                    }
                    
                    Button("Export as SVG") {
                        // Export SVG - placeholder
                        dismiss()
                    }
                }
                
                Section("Data Formats") {
                    Button("Export as JSON") {
                        // Export JSON - placeholder
                        dismiss()
                    }
                    
                    Button("Export as Markdown") {
                        // Export Markdown - placeholder
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
