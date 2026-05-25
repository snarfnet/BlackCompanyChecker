import SwiftUI

struct ResultView: View {
    let engine: DiagnosisEngine

    var body: some View {
        let result = engine.buildResult()

        ScrollView {
            VStack(spacing: 20) {
                Spacer(minLength: 20)

                // Rank badge
                ZStack {
                    Circle()
                        .fill(rankGradient(result.rank))
                        .frame(width: 140, height: 140)
                        .shadow(color: rankColor(result.rank).opacity(0.4), radius: 20)
                    VStack(spacing: 2) {
                        Text(result.rank)
                            .font(.system(size: 60, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                        Text("ランク")
                            .font(.caption2.bold())
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }

                Text(result.rankTitle)
                    .font(.title.bold())

                Text("\(result.totalScore) / \(result.maxScore) 点")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                // Score bar
                VStack(spacing: 4) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray5))
                            RoundedRectangle(cornerRadius: 8)
                                .fill(rankGradient(result.rank))
                                .frame(width: geo.size.width * result.percentage / 100)
                        }
                    }
                    .frame(height: 16)

                    HStack {
                        Text("ホワイト")
                            .font(.caption2)
                            .foregroundStyle(.green)
                        Spacer()
                        Text(String(format: "%.0f%%", result.percentage))
                            .font(.caption.bold())
                        Spacer()
                        Text("ブラック")
                            .font(.caption2)
                            .foregroundStyle(.red)
                    }
                }
                .padding(.horizontal)

                // Radar chart
                RadarChartView(
                    scores: result.categoryScores.map { cs in
                        (label: String(cs.category.name.prefix(5)),
                         value: cs.maxScore > 0 ? Double(cs.score) / Double(cs.maxScore) : 0)
                    },
                    accentColor: rankColor(result.rank)
                )
                .frame(height: 260)
                .padding(.horizontal)

                // Category breakdown
                VStack(spacing: 8) {
                    Text("カテゴリ別スコア")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ForEach(result.categoryScores, id: \.category.id) { cs in
                        let pct = cs.maxScore > 0 ? Double(cs.score) / Double(cs.maxScore) : 0
                        HStack(spacing: 10) {
                            Image(systemName: cs.category.icon)
                                .frame(width: 24)
                                .foregroundStyle(barColor(pct))
                            Text(cs.category.name)
                                .font(.caption)
                                .frame(width: 90, alignment: .leading)
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(.systemGray5))
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(barColor(pct))
                                        .frame(width: geo.size.width * pct)
                                }
                            }
                            .frame(height: 10)
                            Text("\(cs.score)/\(cs.maxScore)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .frame(width: 40, alignment: .trailing)
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                // Advice
                VStack(alignment: .leading, spacing: 8) {
                    Label("アドバイス", systemImage: "lightbulb.fill")
                        .font(.headline)
                        .foregroundStyle(.orange)
                    Text(result.advice)
                        .font(.subheadline)
                        .lineSpacing(4)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.orange.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                // Share & Retry
                HStack(spacing: 16) {
                    ShareLink(item: shareText(result)) {
                        Label("共有", systemImage: "square.and.arrow.up")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.bordered)

                    Button {
                        withAnimation { engine.reset() }
                    } label: {
                        Label("もう一度", systemImage: "arrow.counterclockwise")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
                .padding(.horizontal)

                Spacer(minLength: 80)
            }
        }
        .background(Color(.systemGroupedBackground))
    }

    private func shareText(_ result: DiagnosisResult) -> String {
        "うちの会社のブラック度は【\(result.rank)ランク】（\(result.rankTitle)）！ \(result.totalScore)/\(result.maxScore)点 - ブラック企業診断"
    }

    private func rankColor(_ rank: String) -> Color {
        switch rank {
        case "S": return .green
        case "A": return .mint
        case "B": return .teal
        case "C": return .yellow
        case "D": return .orange
        case "E": return .red
        default: return .purple
        }
    }

    private func rankGradient(_ rank: String) -> LinearGradient {
        let c = rankColor(rank)
        return LinearGradient(colors: [c, c.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    private func barColor(_ pct: Double) -> Color {
        switch pct {
        case 0..<0.25: return .green
        case 0.25..<0.5: return .yellow
        case 0.5..<0.75: return .orange
        default: return .red
        }
    }
}
