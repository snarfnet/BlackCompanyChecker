import SwiftUI

struct QuestionView: View {
    @Bindable var engine: DiagnosisEngine

    var body: some View {
        VStack(spacing: 0) {
            topBar

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    categoryHeader
                    questionCard
                    Spacer(minLength: 30)
                }
                .padding(20)
            }

            if engine.canGoBack {
                backButton
            }
        }
        .background(Brand.background.ignoresSafeArea())
    }

    private var topBar: some View {
        VStack(spacing: 10) {
            ProgressView(value: engine.overallProgress)
                .tint(Brand.accent)
                .scaleEffect(x: 1, y: 1.6, anchor: .center)

            HStack {
                Text(engine.currentCategory.name)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Brand.accent)
                Spacer()
                Text("\(engine.answeredCount)/\(engine.totalQuestions)")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(Brand.muted)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .padding(.bottom, 10)
        .background(Brand.panel)
    }

    private var categoryHeader: some View {
        HStack(spacing: 12) {
            Image(systemName: engine.currentCategory.icon)
                .font(.title3.weight(.semibold))
                .foregroundStyle(Brand.accent)
                .frame(width: 38, height: 38)
                .background(Brand.accent.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 3) {
                Text(engine.currentCategory.name)
                    .font(.headline)
                    .foregroundStyle(Brand.text)
                Text("Q\(engine.currentQuestionIndex + 1) / \(engine.currentCategory.questions.count)")
                    .font(.caption)
                    .foregroundStyle(Brand.muted)
            }
            Spacer()
        }
    }

    private var questionCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(engine.currentQuestion.text)
                .font(.title3.weight(.bold))
                .foregroundStyle(Brand.text)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: 10) {
                ForEach(engine.currentQuestion.choices) { choice in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            engine.answer(choice.score)
                        }
                    } label: {
                        HStack(alignment: .top, spacing: 12) {
                            Text("\(choice.score)")
                                .font(.caption.bold().monospacedDigit())
                                .foregroundStyle(choiceColor(choice.score))
                                .frame(width: 24, height: 24)
                                .background(choiceColor(choice.score).opacity(0.12), in: Circle())

                            Text(choice.text)
                                .font(.subheadline)
                                .foregroundStyle(Brand.text)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Image(systemName: "chevron.right")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(Brand.muted.opacity(0.7))
                                .padding(.top, 4)
                        }
                        .padding(14)
                        .background(Brand.panel, in: RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(choiceColor(choice.score).opacity(0.22), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(18)
        .background(Color.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Brand.border, lineWidth: 1))
    }

    private var backButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                engine.goBack()
            }
        } label: {
            Label("前の質問", systemImage: "chevron.left")
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
        }
        .buttonStyle(.bordered)
        .tint(Brand.text)
        .padding(.horizontal, 20)
        .padding(.bottom, 14)
        .background(Brand.background)
    }

    private func choiceColor(_ score: Int) -> Color {
        switch score {
        case 0: return .green
        case 1: return .teal
        case 2: return Brand.amber
        case 3: return .orange
        default: return Brand.accent
        }
    }
}
