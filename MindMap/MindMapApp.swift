//
//  MindMapApp.swift
//  MindMap
//
//  Created by Tyler Allen on 6/14/25.
//

import SwiftUI

@main
struct MindMapApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: { MindMapDocument() }) { file in
            ContentView(document: file.document)
        }
    }
}
