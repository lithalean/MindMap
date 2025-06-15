# MindMap
*An Open Source, modern, developer-focused Darwin ARM64 MindMapping Application following WWDC25 iPadOS Design Principles*

![Platform Support](https://img.shields.io/badge/platform-macOS%20%7C%20iOS%20%7C%20iPadOS-blue)
![Swift Version](https://img.shields.io/badge/swift-5.9+-orange)
![iOS Version](https://img.shields.io/badge/iOS-18.0+-green)
![License](https://img.shields.io/badge/license-MIT-blue)


## ✨ Current Status: **WORKING BUILD**

## 🎯 Project Vision

The app is now fully functional with a modern SwiftUI architecture! 🎉

### 🚀 **What's Working Right Now:**
- ✅ **Interactive Mind Map Canvas** - Pan, zoom, create and edit nodes
- ✅ **Document-based Architecture** - Proper save/load with JSON format
- ✅ **Cross-Platform Support** - Native iPad, iPhone, and Mac Catalyst
- ✅ **Modern SwiftUI** - Built with iOS 18+ and `@Observable` architecture
- ✅ **Real-time Connections** - Bezier curve connections between nodes
- ✅ **Gesture Support** - Touch, mouse, and trackpad optimized
- ✅ **Adaptive Interface** - Different UI layouts for different screen sizes

## Features

### 🎨 **Visual Mind Mapping**
- **Infinite Canvas** with smooth pan and zoom (pinch gestures, scroll wheel)
- **Beautiful Bezier Connections** between nodes with smooth curves
- **Dark Mode Optimized** with subtle grid background and professional shadows
- **Node Editing** - Double-tap any node to edit text inline
- **Multi-Selection** - Select and move multiple nodes together
- **Animated Interactions** - Spring animations and hover effects

### 🧠 **Developer-Focused Design**
- **Clean, Modern Interface** built for technical workflows
- **Keyboard Shortcuts** - Space bar to add nodes, standard shortcuts
- **Document Browser** with live canvas previews
- **JSON-Based Storage** for portability and version control
- **Git-Friendly Format** - Text-based storage that works with version control

### 💾 **Document Management**
- **Document-based App** architecture with proper iOS/macOS integration
- **Automatic Save/Restore** functionality
- **JSON Export/Import** for data portability
- **Document Browser** with visual previews
- **File Sharing** support through standard iOS/macOS sharing

### 🔧 **Modern Architecture**
- **iOS 18+ and SwiftUI** with latest APIs
- **`@Observable` State Management** for reactive updates
- **`ReferenceFileDocument`** for proper document handling
- **Cross-Platform Codebase** - Single codebase for iPhone, iPad, and Mac
- **Mac Catalyst Optimized** - Native-feeling Mac experience

### 📱 **Adaptive Interface**
- **iPad Landscape**: Full sidebar with document browser and canvas tools
- **iPad Portrait**: Floating toolbars and streamlined interface  
- **iPhone**: Compact interface with floating action buttons
- **Mac Catalyst**: Native Mac styling with proper window management

## Current Implementation Status

### ✅ **Phase 1: Core Foundation - COMPLETE**
- [x] Modern SwiftUI architecture with `@Observable`
- [x] Document-based app structure with save/load
- [x] Interactive node creation, editing, and movement
- [x] Infinite canvas with smooth pan/zoom
- [x] Node connections with bezier curves
- [x] Cross-platform deployment (iPhone, iPad, Mac)

### ✅ **Phase 2: Visual Experience - COMPLETE**
- [x] **Mac Catalyst Support**: Native Mac interface with proper styling
- [x] **Material Design System**: Consistent use of `.ultraThinMaterial`
- [x] **Enhanced Node Styling**: Hover states, selection feedback, animations
- [x] **Adaptive Layouts**: Different interfaces for different screen sizes
- [x] **Document Browser**: Visual grid with live canvas previews
- [x] **Gesture System**: Multi-touch, mouse, and trackpad support

### 🚧 **Phase 3: Advanced Features - IN PROGRESS**
- [ ] **Enhanced Connection System**: Directional arrows, connection labels
- [ ] **Advanced Node Shapes**: Rectangles, circles, diamonds, custom shapes
- [ ] **Undo/Redo System**: Full command pattern implementation
- [ ] **Grid and Snapping**: Toggle grid visibility, snap-to-grid
- [ ] **Export System**: PNG, SVG, PDF export with high-quality rendering
- [ ] **Search and Filter**: Full-text search across nodes

### 🔮 **Phase 4: Developer Productivity - PLANNED**
- [ ] **Rich Text Support**: Markdown rendering in nodes
- [ ] **Code Syntax Highlighting**: Language-specific highlighting
- [ ] **External Integrations**: GitHub Issues/PRs, Linear tickets
- [ ] **Template System**: Pre-built templates for architecture, planning
- [ ] **Collaborative Features**: Real-time collaboration and sharing

## Installation & Setup

### Prerequisites
- **Xcode 16.0+** 
- **iOS/iPadOS 18.0+** or **macOS 15.0+**
- **Swift 5.9+**

### Quick Start
```bash
git clone https://github.com/lithalean/MindMap.git
cd MindMap
open MindMap.xcodeproj
```

**Build and run** for your desired platform:
- **iPhone/iPad**: Select iOS Simulator or device
- **Mac**: Select "My Mac (Designed for iPad)" for Mac Catalyst

## Usage

### 🎯 **Getting Started**
1. **Launch the app** - You'll see a document browser with sample data
2. **Tap "Open Canvas"** to enter the interactive mind map
3. **Start creating** - Use the + button to add your first node

### ⌨️ **Controls**
- **Create Node**: Tap + button, press Space bar, or double-tap empty canvas
- **Edit Node**: Double-tap any existing node
- **Move Nodes**: Drag nodes around the canvas
- **Pan Canvas**: Drag on empty areas (or use trackpad)
- **Zoom**: Pinch gestures, scroll wheel, or zoom buttons
- **Select Multiple**: Tap nodes while holding modifier keys (planned)

### 🖥️ **Platform-Specific Features**
- **iPad**: Full toolbar with zoom controls and document info
- **iPhone**: Floating action buttons for compact interface
- **Mac**: Native Mac toolbar with proper window management

### 💾 **Documents**
- **Auto-save**: Documents save automatically as you work
- **File Format**: Human-readable JSON for version control
- **Sharing**: Standard iOS/macOS sharing for export
- **Templates**: Built-in templates for common use cases (planned)

## Technical Architecture

### Modern SwiftUI Stack
- **`@Observable`** for reactive state management
- **`ReferenceFileDocument`** for document persistence  
- **`Canvas`** for high-performance connection drawing
- **`GeometryReader`** for adaptive layouts
- **`NavigationSplitView`** for native platform navigation

### Key Components
```
MindMap/
├── App/
│   └── MindMapApp.swift              # DocumentGroup app entry point
├── Models/
│   ├── MindMapDocument.swift         # Core observable document model
│   ├── CanvasState.swift            # Zoom, pan, and view state
│   └── NodeStyle.swift              # Visual styling definitions
└── Views/
	├── ContentView.swift            # Adaptive container view
	├── MindMapCanvasView.swift      # Interactive canvas implementation
	├── DocumentBrowserView.swift    # Document management UI
	└── AdaptiveToolbar.swift        # Platform-specific toolbars
```

### Design Patterns
- **MVVM Architecture**: Clear separation between models and views
- **Reactive Programming**: `@Observable` for automatic UI updates
- **Platform Adaptation**: Conditional UI based on device capabilities
- **Document-Driven**: Native iOS/macOS document lifecycle

## Development Roadmap

### 🔜 **Next Up (Phase 3)**
1. **Connection Enhancements**: Arrow heads, labels, different line styles
2. **Node Shape Library**: Beyond rectangles - circles, diamonds, custom shapes  
3. **Undo/Redo System**: Command pattern for all user actions
4. **Export System**: High-quality PNG, SVG, and PDF export
5. **Performance**: Optimization for large mind maps (1000+ nodes)

### 🎯 **Medium Term (Phase 4)**
1. **Rich Text**: Markdown support within nodes
2. **Templates**: Pre-built mind maps for common developer workflows
3. **Integrations**: Connect to GitHub, Linear, Jira for live data
4. **Collaboration**: Real-time multi-user editing
5. **AI Features**: Smart node suggestions and auto-layout

### 🚀 **Long Term (Phase 5+)**
1. **DarwinCodex Integration**: Unified suite with code snippets and docs
2. **Advanced Analytics**: Mind map insights and usage patterns
3. **Plugin Architecture**: Third-party extensions and customizations
4. **Web Export**: Share mind maps as interactive web pages
5. **Enterprise Features**: Team workspaces and advanced permissions


## License

MindMap is released under the MIT License. See [LICENSE](LICENSE) for details.

## Acknowledgments

- **SwiftUI Team** for the amazing declarative UI framework
- **iOS/macOS Engineering** for the robust document architecture
- **Design Inspiration**: Freeform, XMind, MindNode, and Miro
- **Developer Community** for feedback and testing
