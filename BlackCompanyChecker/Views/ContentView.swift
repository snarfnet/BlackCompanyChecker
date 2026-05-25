import SwiftUI

struct ContentView: View {
    @State private var engine = DiagnosisEngine()

    var body: some View {
        Group {
            switch engine.phase {
            case .intro:
                IntroView(engine: engine)
            case .diagnosis:
                QuestionView(engine: engine)
            case .result:
                ResultView(engine: engine)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
