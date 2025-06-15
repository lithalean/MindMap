# MindMap
*An Open Source, modern Darwin ARM64 MindMapping Application following WWDC25 iPadOS Design Principles*

![Platform Support](https://img.shields.io/badge/platform-macOS%20%7C%20iOS%20%7C%20iPadOS-blue)
![Swift Version](https://img.shields.io/badge/swift-5.9+-orange)
![iOS Version](https://img.shields.io/badge/iOS-18.0+-green)
![License](https://img.shields.io/badge/license-MIT-blue)

## ✨ Current Status: **WORKING BUILD**

## 🎯 Project Vision

Building a modern, developer-focused mind mapping tool that scales beautifully across Apple platforms

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

### 🎨 **Core Experience**
- **Infinite Canvas** with smooth pan and zoom (pinch gestures, scroll wheel)
- **Beautiful Bezier Connections** between nodes with smooth curves
- **Dark Mode Optimized** with subtle grid background and professional shadows
- **Node Editing** - Double-tap any node to edit text inline
- **Multi-Selection** - Select and move multiple nodes together
- **Animated Interactions** - Spring animations and hover effects

### 🧠 **Darwin ARM64 Developer-Focused Design**
- **Clean, Modern Interface** built for technical workflows
- **Keyboard Shortcuts** - Space bar shortcuts and standard key commands
- **Document Browser** with live previews
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

### 📱 **Adaptive Interface (WWDC25 Principles)**
- **iPad Landscape**: Full sidebar with document browser and tools
- **iPad Portrait**: Floating toolbars and streamlined interface  
- **iPhone**: Compact interface with floating action buttons
- **Mac Catalyst**: Native Mac styling with proper window management

## Current Implementation Status

### ✅ **Phase 1: Core Foundation - COMPLETE**
- [x] Modern SwiftUI architecture with `@Observable`
- [x] Document-based app structure with save/load
- [x] Interactive core functionality
- [x] Infinite canvas with smooth pan/zoom
- [x] Cross-platform deployment (iPhone, iPad, Mac)

### ✅ **Phase 2: Visual Experience - COMPLETE**
- [x] **Mac Catalyst Support**: Native Mac interface with proper styling
- [x] **Material Design System**: Consistent use of `.ultraThinMaterial`
- [x] **Enhanced Styling**: Hover states, selection feedback, animations
- [x] **Adaptive Layouts**: Different interfaces for different screen sizes
- [x] **Document Browser**: Visual grid with live previews
- [x] **Gesture System**: Multi-touch, mouse, and trackpad support

### 🚧 **Phase 3: Advanced Features - IN PROGRESS**
- [ ] Enhanced interaction system with advanced controls
- [ ] Advanced styling options and customization
- [ ] Undo/Redo system with command pattern
- [ ] Grid and snapping functionality
- [ ] Export system for multiple formats
- [ ] Search and filter capabilities

### 🔮 **Phase 4: Developer Productivity - PLANNED**
- [ ] Rich text support with markdown rendering
- [ ] Template system for common workflows
- [ ] External integrations with development tools
- [ ] Collaborative features for team workflows
- [ ] AI-powered suggestions and automation

## Installation & Setup

### Prerequisites
- **Xcode 16.0+** 
- **iOS/iPadOS 18.0+** or **macOS 15.0+**
- **Swift 5.9+**
- **Darwin ARM64** architecture (Apple Silicon optimized)

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
1. **Launch the app** - You'll see the document browser interface
2. **Create or open** - Start with a new document or open existing
3. **Start creating** - Use intuitive gestures and controls

### ⌨️ **Controls**
- **Primary Action**: Tap/click to interact with elements
- **Secondary Action**: Double-tap for detailed editing
- **Navigation**: Drag to pan, pinch/scroll to zoom
- **Multi-Select**: Use modifier keys for multiple selection

### 🖥️ **Platform-Specific Features**
- **iPad**: Full toolbar with controls and document info
- **iPhone**: Floating action buttons for compact interface
- **Mac**: Native Mac toolbar with proper window management

### 💾 **Documents**
- **Auto-save**: Documents save automatically as you work
- **File Format**: Human-readable JSON for version control
- **Sharing**: Standard iOS/macOS sharing for export
- **Templates**: Built-in templates for common use cases

## Technical Architecture

### Modern SwiftUI Stack
- **`@Observable`** for reactive state management
- **`ReferenceFileDocument`** for document persistence  
- **`Canvas`** for high-performance rendering
- **`GeometryReader`** for adaptive layouts
- **`NavigationSplitView`** for native platform navigation

### Key Components
```
MindMap/
├── App/
│   └── MindMapApp.swift       # DocumentGroup app entry point
├── Models/
│   ├── MindMapDocument.swift  # Core observable document model
│   ├── CanvasState.swift            # View state management
│   └── StyleDefinitions.swift       # Visual styling definitions
└── Views/
	├── ContentView.swift            # Adaptive container view
	├── MainCanvasView.swift         # Primary interface implementation
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
1. **Enhanced Interactions**: Advanced gesture recognition and controls
2. **Visual Polish**: Improved animations and visual feedback
3. **Export System**: Multiple format support with high quality
4. **Search Functionality**: Full-text search and filtering
5. **Performance**: Optimization for large datasets and complex operations

### 🎯 **Medium Term (Phase 4)**
1. **Rich Content**: Advanced text rendering and media support
2. **Template System**: Pre-built templates for common workflows
3. **Integrations**: Connect with popular development and productivity tools
4. **Collaboration**: Real-time multi-user capabilities
5. **AI Features**: Smart suggestions and automated optimization

### 🚀 **Long Term (Phase 5+)**
1. **DarwinCodex Integration**: Unified suite with development tools
2. **Advanced Analytics**: Usage insights and performance patterns
3. **Plugin Architecture**: Third-party extensions and customizations
4. **Web Export**: Share content as interactive web experiences
5. **Enterprise Features**: Team workspaces and advanced permissions

## 🤖 Claude.ai Integration

> **For AI Collaboration**: This project uses Claude.ai assistance for development, architecture decisions, and feature planning. The `.claude/` directory contains detailed context files for AI collaboration continuity.

**Quick Context**: SwiftUI mind mapping app with document-based architecture, infinite canvas, and WWDC25 design principles

**Key AI Collaboration Areas**:
- 🏗️ **Architecture**: SwiftUI + @Observable patterns, document-based design
- 🎨 **Design**: WWDC25 principles, adaptive layouts, material design
- 🔧 **Development**: Darwin ARM64 optimization, cross-platform compatibility
- 📋 **Planning**: Feature roadmap, technical debt tracking, performance optimization

**AI Context Files**: See `.claude/context.md` for detailed project state, architecture decisions, and ongoing development context.

## License

MindMap is released under the MIT License. See [LICENSE](LICENSE) for details.

## Acknowledgments

- **SwiftUI Team** for the amazing declarative UI framework
- **iOS/macOS Engineering** for the robust document architecture
- **Design Inspiration**: Modern productivity and development tools
- **Darwin ARM64 Community** for performance optimization insights
- **Claude.ai** for architectural guidance and development assistance