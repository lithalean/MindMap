import SwiftUI

struct ContentView: View {
    @Bindable var document: MindMapDocument
    
    var body: some View {
        VStack {
            Text("Modern MindMap - Working!")
                .font(.largeTitle)
                .foregroundColor(.white)
            
            Text("Nodes: \(document.nodes.count)")
                .foregroundColor(.white)
            Text("Connections: \(document.connections.count)")
                .foregroundColor(.white)
            
            Spacer()
            
            if !document.nodes.isEmpty {
                Text("Ready for modern canvas!")
                    .foregroundColor(.green)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}

#Preview {
    ContentView(document: MindMapDocument())
}
