import SwiftUI

@main
struct MindMapApp: App {
	var body: some Scene {
		DocumentGroup(newDocument: { MindMapDocument() }) { file in
			ContentView(document: file.$document)
		}
	}
}
