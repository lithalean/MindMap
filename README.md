# MindMap

**A modern, developer-focused mind mapping application built with SwiftUI for macOS, iOS, and iPadOS.**

![Platform Support](https://img.shields.io/badge/platform-macOS%20%7C%20iOS%20%7C%20iPadOS-blue)
![Swift Version](https://img.shields.io/badge/swift-5.9+-orange)
![iOS Version](https://img.shields.io/badge/iOS-18.0+-green)
![License](https://img.shields.io/badge/license-MIT-blue)

## Overview

MindMap is the first component of the **DarwinCodex** suite - a collection of productivity tools designed specifically for developers. It provides an infinite canvas for visual thinking, architectural planning, and idea organization with a clean, dark-mode interface optimized for technical workflows.

## Features

### 🎨 **Visual Mind Mapping**
- Infinite canvas with smooth pan and zoom
- Bezier curve connections between nodes
- Dark mode optimized with subtle grid background
- Professional shadows and animations

### 🧠 **Developer-Focused Design**
- Clean, modern interface built for technical workflows
- Keyboard shortcuts for rapid node creation
- Multi-select and drag operations
- Double-tap to edit node content

### 💾 **Document Management**
- Document-based app architecture
- Automatic save/restore functionality
- JSON-based file format for portability
- iCloud sync support (planned)

### 🔧 **Modern Architecture**
- Built with iOS 18+ and modern SwiftUI
- `@Observable` state management
- `ReferenceFileDocument` for proper document handling
- Cross-platform support (iPhone, iPad, Mac Catalyst)

## Roadmap

### Phase 1: Core Foundation ✅
- [x] Modern SwiftUI architecture with `@Observable`
- [x] Document-based app structure
- [x] Basic node creation and editing
- [x] Infinite canvas with pan/zoom
- [x] Node connections with bezier curves
- [x] Cross-platform deployment

### Phase 2: Enhanced Visual Experience 🚧
- [ ] Improved node styling and themes
- [ ] Connection arrows and labels
- [ ] Node shapes (rectangles, circles, diamonds)
- [ ] Color coding and visual hierarchy
- [ ] Smooth animations and transitions
- [ ] Grid snapping and alignment tools

### Phase 3: Developer Productivity Features 🔮
- [ ] Code syntax highlighting in nodes
- [ ] Integration with GitHub Issues/PRs
- [ ] Link to Linear tickets
- [ ] Markdown support in node content
- [ ] Export to various formats (PNG, SVG, PDF)
- [ ] Template library for common architectures

### Phase 4: Collaboration & Sync 🌐
- [ ] iCloud document sync
- [ ] Real-time collaboration
- [ ] Version history
- [ ] Comment and annotation system
- [ ] Share via link functionality

### Phase 5: Advanced Features 🚀
- [ ] AI-powered node suggestions
- [ ] Auto-layout algorithms
- [ ] Plugin system for extensions
- [ ] Integration with other DarwinCodex tools
- [ ] Advanced search and filtering
- [ ] Presentation mode

### Phase 6: DarwinCodex Integration 🔗
- [ ] Unified interface with CodeSnippets
- [ ] Cross-linking with DevNotes
- [ ] Shared data models and sync
- [ ] Workflow automation between tools

## DarwinCodex Suite

MindMap is part of the larger **DarwinCodex** project - a unified productivity suite for developers:

1. **MindMap** (this project) - Visual thinking and architecture planning
2. **CodeSnippets** (planned) - Swift/C++ code fragment management
3. **DevNotes** (planned) - Markdown-based documentation system
4. **DarwinCodex** (planned) - Unified interface combining all tools

## Technical Requirements

- **iOS/iPadOS:** 18.0+
- **macOS:** 15.0+ (via Mac Catalyst)
- **Xcode:** 16.0+
- **Swift:** 5.9+

## Architecture

### Modern SwiftUI Stack
- `@Observable` for reactive state management
- `ReferenceFileDocument` for document handling
- `Canvas` for high-performance drawing
- Gesture recognition for intuitive interactions

### Key Components
- **MindMapDocument**: Core observable data model
- **MindMapCanvasView**: Infinite canvas implementation
- **NodeView**: Individual node rendering and interaction
- **CanvasState**: Pan, zoom, and viewport management

## Installation

### Prerequisites
- Xcode 16.0 or later
- macOS 15.0+ for development

### Building
```bash
git clone https://github.com/lithalean/MindMap.git
cd MindMap
open MindMap.xcodeproj
```

Build and run for your desired platform (iPhone, iPad, or Mac).

## Usage

### Basic Operations
- **Create Node**: Press Space bar or double-tap empty canvas
- **Edit Node**: Double-tap existing node
- **Move Nodes**: Drag nodes around the canvas
- **Pan Canvas**: Drag on empty canvas area
- **Zoom**: Pinch gesture or scroll wheel
- **Select Multiple**: Command+click (planned)

### Keyboard Shortcuts
- `Space`: Create new node at center
- `Cmd+N`: New document
- `Cmd+S`: Save document
- `Cmd+Z`: Undo (planned)

## Contributing

We welcome contributions to MindMap! Please see our contributing guidelines and feel free to submit issues or pull requests.

### Development Setup
1. Clone the repository
2. Open in Xcode 16+
3. Ensure iOS 18+ deployment target
4. Build and run

### Areas for Contribution
- UI/UX improvements
- Performance optimizations
- New node types and shapes
- Export functionality
- Documentation and examples

## License

MindMap is released under the MIT License. See [LICENSE](LICENSE) for details.

## Acknowledgments

- Inspired by tools like Freeform, XMind, and MindNode
- Built with modern SwiftUI and iOS 18+ technologies
- Part of the broader vision for developer productivity tools

---

**Part of the DarwinCodex Suite** | [DarwinHost](https://github.com/lithalean/DarwinHost) | [Other Projects](https://github.com/lithalean)

*Building the future of developer productivity, one tool at a time.*