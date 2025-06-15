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
- Adaptive interface following WWDC25 iPadOS design principles

### 🧠 **Developer-Focused Design**
- Clean, modern interface built for technical workflows
- Keyboard shortcuts for rapid node creation
- Multi-select and drag operations
- Double-tap to edit node content
- Context-aware toolbars that adapt to selection state

### 💾 **Document Management**
- Document-based app architecture
- Automatic save/restore functionality
- JSON-based file format for portability
- Document browser with live previews
- iCloud sync support (planned)

### 🔧 **Modern Architecture**
- Built with iOS 18+ and modern SwiftUI
- `@Observable` state management
- `ReferenceFileDocument` for proper document handling
- Cross-platform support (iPhone, iPad, Mac Catalyst)
- Adaptive interface that scales from iPhone to macOS

## Roadmap

### Phase 1: Core Foundation ✅
- [x] Modern SwiftUI architecture with `@Observable`
- [x] Document-based app structure
- [x] Basic node creation and editing
- [x] Infinite canvas with pan/zoom
- [x] Node connections with bezier curves
- [x] Cross-platform deployment

### Phase 2: Enhanced Visual Experience ✅
- [x] **WWDC25 Adaptive Interface**: Sidebar for iPad/macOS, floating tab bar for portrait, responsive design
- [x] **Material Design System**: Consistent use of `.ultraThinMaterial` and proper shadow hierarchy
- [x] **Enhanced Node Styling**: Improved hover states, selection feedback, and visual hierarchy
- [x] **Context-Aware Toolbars**: Different toolbars for selection vs. general editing modes
- [x] **Document Browser**: Grid view with live canvas previews and template support
- [x] **Floating Action Menu**: iPhone-optimized expandable FAB with secondary actions
- [ ] Connection arrows and labels
- [ ] Node shapes (rectangles, circles, diamonds)
- [ ] Color coding and visual hierarchy
- [ ] Grid snapping and alignment tools

### Phase 3: Advanced Canvas Features 🚧
- [ ] **Enhanced Connection System**: Directional arrows, connection labels, multiple connection types
- [ ] **Node Shape Library**: Rectangles, circles, diamonds, custom shapes
- [ ] **Advanced Selection**: Multi-select with Command+click, selection rectangles
- [ ] **Undo/Redo System**: Full command pattern implementation
- [ ] **Grid and Snapping**: Toggle grid visibility, snap-to-grid functionality
- [ ] **Zoom and Navigation**: Minimap, fit-to-screen, zoom to selection
- [ ] **Node Styling Panel**: Color picker, font options, border styles

### Phase 4: Developer Productivity Features 🔮
- [ ] **Rich Text Support**: Markdown rendering in nodes, text formatting options
- [ ] **Code Syntax Highlighting**: Language-specific highlighting for code blocks in nodes
- [ ] **External Integrations**: GitHub Issues/PRs, Linear tickets, Jira cards
- [ ] **Template System**: Pre-built templates for system architecture, user flows, project planning
- [ ] **Export System**: PNG, SVG, PDF export with high-quality rendering
- [ ] **Search and Filter**: Full-text search across nodes, filter by tags or types

### Phase 5: Collaboration & Sync 🌐
- [ ] **iCloud Document Sync**: Seamless sync across devices
- [ ] **Real-time Collaboration**: Multiple users editing simultaneously
- [ ] **Version History**: Document versioning with restore capability
- [ ] **Comment System**: Annotations and discussion threads on nodes
- [ ] **Share Links**: Public sharing with view/edit permissions
- [ ] **Team Workspaces**: Shared spaces for collaborative projects

### Phase 6: Advanced Features 🚀
- [ ] **AI-Powered Assistance**: Node suggestions, auto-layout, content generation
- [ ] **Auto-Layout Algorithms**: Force-directed, hierarchical, circular layouts
- [ ] **Plugin Architecture**: Third-party extensions and integrations
- [ ] **Advanced Search**: Semantic search, graph queries, relationship mapping
- [ ] **Presentation Mode**: Full-screen presentation with navigation
- [ ] **Performance Optimization**: Large document handling, virtualization

### Phase 7: DarwinCodex Integration 🔗
- [ ] **Unified Suite Interface**: Common navigation and design language
- [ ] **Cross-App Linking**: Link mind maps to code snippets and documentation
- [ ] **Shared Data Models**: Common entities across all DarwinCodex tools
- [ ] **Workflow Automation**: Automated workflows between tools
- [ ] **Universal Search**: Search across all DarwinCodex applications

## Current Implementation Status

### ✅ **Completed (Phase 2)**
- **Adaptive Interface System**: Complete responsive design following WWDC25 principles
- **Document Browser**: Grid layout with live previews and template cards
- **Enhanced Canvas**: Improved visual hierarchy with professional shadows and materials
- **Context-Aware Toolbars**: Selection-specific vs. general editing toolbars
- **Cross-Platform Support**: Single codebase scaling from iPhone to macOS
- **Material Design**: Consistent floating elements with proper elevation

### 🚧 **In Progress (Phase 3)**
- Connection system enhancements
- Advanced node shapes and styling
- Undo/redo implementation
- Grid and snapping features

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
- Adaptive interface components following WWDC25 design principles

### Key Components
- **ContentView**: Adaptive container that switches between sidebar and tab layouts
- **MindMapDocument**: Core observable data model with connection support
- **AdaptiveMindMapCanvasView**: Full-screen canvas with context-aware toolbars
- **FloatingSidebar**: Material-based navigation for larger screens
- **FloatingTabBar**: Bottom navigation for compact layouts
- **DocumentBrowser**: Grid-based document management with live previews

### Design System
- **Material Hierarchy**: Consistent use of `.ultraThinMaterial` and `.regularMaterial`
- **Shadow System**: Proper elevation with context-appropriate shadows
- **Animation Framework**: Spring-based animations with 0.3s easeInOut timing
- **Responsive Breakpoints**: 768px width threshold for layout switching
- **Color Scheme**: Dark-mode optimized with accent color highlights

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
- **Create Node**: Press Space bar, double-tap empty canvas, or use floating action button
- **Edit Node**: Double-tap existing node
- **Move Nodes**: Drag nodes around the canvas
- **Pan Canvas**: Drag on empty canvas area
- **Zoom**: Pinch gesture, scroll wheel, or toolbar zoom controls
- **Select Multiple**: Tap multiple nodes (multi-select with modifiers planned)

### Adaptive Interface
- **iPad Landscape/macOS**: Persistent sidebar with document browser
- **iPad Portrait/iPhone Landscape**: Floating bottom toolbar
- **iPhone Portrait**: Floating action menu with expandable secondary actions

### Keyboard Shortcuts
- `Space`: Create new node at center
- `Cmd+N`: New document
- `Cmd+S`: Save document
- `Cmd+Z`: Undo (planned)
- `Cmd+A`: Select all nodes


### Development Setup
1. Clone the repository
2. Open in Xcode 16+
3. Ensure iOS 18+ deployment target
4. Build and run

### Current Focus Areas
- Connection system improvements (arrows, labels)
- Node shape library implementation
- Undo/redo system development
- Export functionality
- Performance optimizations for large documents

### Future Contribution Areas
- AI integration features
- Plugin architecture
- Collaboration features
- Advanced layout algorithms

## License

MindMap is released under the MIT License. 

## Acknowledgments

- Inspired by tools like Freeform, XMind, and MindNode
- Built with modern SwiftUI and iOS 18+ technologies
- Following WWDC25 iPadOS design principles
- Part of the broader vision for developer productivity tools
