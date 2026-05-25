import SwiftUI

struct ContentView: View {
    @State private var engine = DiagnosisEngine()

    var body: some View {
        ZStack(alignment: .bottom) {
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

            BannerAdView(adUnitID: "ca-app-pub-9404799280370656/4170256437")
                .frame(height: 50)
        }
        .ignoresSafeArea(.keyboard)
    }
}
