import SwiftUI

struct QuestionView: View {
    @Bindable var engine: DiagnosisEngine

    var body: some View {
        VStack(spacing: 0) {
            // Progress
            VStack(spacing: 6) {
                ProgressView(value: engine.overallProgress)
                    .tint(.red)
                HStack {
                    Text(engine.currentCategory.name)
                        .font(.caption.bold())
                        .foregroundStyle(.red.opacity(0.8))
                    Spacer()
                    Text("\(engine.answeredCount)/\(engine.totalQuestions)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)

            // Category header
            HStack(spacing: 8) {
                Image(systemName: engine.currentCategory.icon)
                    .foregroundStyle(.red.opacity(0.7))
                Text(engine.currentCategory.name)
                    .font(.headline)
                Spacer()
                Text("Q\(engine.currentQuestionIndex + 1)/\(engine.currentCategory.questions.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()

            ScrollView {
                VStack(spacing: 16) {
                    // Question
                    Text(engine.currentQuestion.text)
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    // Choices
                    VStack(spacing: 10) {
                        ForEach(engine.currentQuestion.choices) { choice in
                            Button {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    engine.answer(choice.score)
                                }
                            } label: {
                                HStack(alignment: .top, spacing: 12) {
                                    scoreIndicator(choice.score)
                                    Text(choice.text)
                                        .font(.subheadline)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(14)
                                .background(
                                    choiceBackground(choice.score),
                                    in: RoundedRectangle(cornerRadius: 12)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(choiceBorder(choice.score), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 80)
                }
            }

            // Back button
            if engine.canGoBack {
                Button {
                    withAnimation { engine.goBack() }
                } label: {
                    Label("前の質問", systemImage: "chevron.left")
                        .font(.subheadline)
                }
                .padding(.bottom, 8)
            }
        }
        .background(Color(.systemGroupedBackground))
    }

    private func scoreIndicator(_ score: Int) -> some View {
        Circle()
            .fill(indicatorColor(score))
            .frame(width: 10, height: 10)
            .padding(.top, 4)
    }

    private func indicatorColor(_ score: Int) -> Color {
        switch score {
        case 0: return .green
        case 1: return .mint
        case 2: return .yellow
        case 3: return .orange
        default: return .red
        }
    }

    private func choiceBackground(_ score: Int) -> Color {
        switch score {
        case 0: return Color.green.opacity(0.05)
        case 1: return Color.mint.opacity(0.05)
        case 2: return Color.yellow.opacity(0.05)
        case 3: return Color.orange.opacity(0.05)
        default: return Color.red.opacity(0.05)
        }
    }

    private func choiceBorder(_ score: Int) -> Color {
        switch score {
        case 0: return .green.opacity(0.2)
        case 1: return .mint.opacity(0.2)
        case 2: return .yellow.opacity(0.3)
        case 3: return .orange.opacity(0.2)
        default: return .red.opacity(0.2)
        }
    }
}
