import SwiftUI

struct IntroView: View {
    let engine: DiagnosisEngine

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer(minLength: 40)

                Image(systemName: "building.2.crop.circle")
                    .font(.system(size: 80))
                    .foregroundStyle(.red.opacity(0.8))
                    .padding(.bottom, 8)

                Text("ブラック企業\n診断")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .multilineTextAlignment(.center)

                Text("10カテゴリ・全\(engine.totalQuestions)問の本格診断。\nあなたの会社のブラック度を判定します。")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    ForEach(engine.categories) { cat in
                        HStack(spacing: 12) {
                            Image(systemName: cat.icon)
                                .frame(width: 28)
                                .foregroundStyle(.red.opacity(0.7))
                            Text(cat.name)
                                .font(.subheadline)
                            Spacer()
                            Text("\(cat.questions.count)問")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 16)
                        .background(Color(.tertiarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.horizontal)

                Button {
                    withAnimation { engine.phase = .diagnosis }
                } label: {
                    Text("診断スタート")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .padding(.horizontal, 32)

                Text("データは端末内のみで処理されます。\n外部には一切送信しません。")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)

                Spacer(minLength: 80)
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}
