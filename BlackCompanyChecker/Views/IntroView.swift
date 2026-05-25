import SwiftUI

struct IntroView: View {
    let engine: DiagnosisEngine

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                metrics
                categories
                startButton
                privacyNote
            }
            .padding(20)
            .padding(.top, 18)
        }
        .background(Brand.background.ignoresSafeArea())
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "building.2.crop.circle")
                    .font(.system(size: 42, weight: .semibold))
                    .foregroundStyle(Brand.accent)
                Spacer()
                Text("B2B Risk Check")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Brand.muted)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Brand.panel, in: Capsule())
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("ブラック企業診断")
                    .font(.system(size: 34, weight: .black, design: .serif))
                    .foregroundStyle(Brand.text)
                Text("10領域・55問で、職場の労務リスクをスコア化。採用、定着、コンプライアンスの弱点を短時間で洗い出します。")
                    .font(.subheadline)
                    .lineSpacing(4)
                    .foregroundStyle(Brand.subtext)
            }
        }
    }

    private var metrics: some View {
        HStack(spacing: 10) {
            metric("10", "カテゴリ")
            metric("\(engine.totalQuestions)", "チェック項目")
            metric("S-F", "リスクランク")
        }
    }

    private func metric(_ value: String, _ label: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title2.bold())
                .foregroundStyle(Brand.text)
            Text(label)
                .font(.caption)
                .foregroundStyle(Brand.muted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Brand.panel, in: RoundedRectangle(cornerRadius: 8))
    }

    private var categories: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("診断領域")
                .font(.headline)
                .foregroundStyle(Brand.text)

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(engine.categories) { category in
                    HStack(spacing: 10) {
                        Image(systemName: category.icon)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Brand.accent)
                            .frame(width: 24)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(category.name)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Brand.text)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            Text("\(category.questions.count)問")
                                .font(.caption2)
                                .foregroundStyle(Brand.muted)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(12)
                    .frame(minHeight: 58)
                    .background(Brand.panel, in: RoundedRectangle(cornerRadius: 8))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Brand.border, lineWidth: 1))
                }
            }
        }
    }

    private var startButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.25)) {
                engine.phase = .diagnosis
            }
        } label: {
            Label("診断を開始", systemImage: "arrow.right.circle.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
        }
        .buttonStyle(.borderedProminent)
        .tint(Brand.accent)
        .controlSize(.large)
    }

    private var privacyNote: some View {
        Label("回答データは端末内で処理され、外部へ送信されません。", systemImage: "lock.shield")
            .font(.caption)
            .foregroundStyle(Brand.muted)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

enum Brand {
    static let background = Color(red: 0.965, green: 0.96, blue: 0.945)
    static let panel = Color.white
    static let text = Color(red: 0.12, green: 0.12, blue: 0.12)
    static let subtext = Color(red: 0.28, green: 0.28, blue: 0.27)
    static let muted = Color(red: 0.48, green: 0.47, blue: 0.43)
    static let accent = Color(red: 0.74, green: 0.21, blue: 0.14)
    static let amber = Color(red: 0.86, green: 0.56, blue: 0.18)
    static let border = Color.black.opacity(0.08)
}
