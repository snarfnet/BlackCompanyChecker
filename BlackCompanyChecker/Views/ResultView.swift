import SwiftUI

struct ResultView: View {
    let engine: DiagnosisEngine

    var body: some View {
        let result = engine.buildResult()

        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                summary(result)
                radar(result)
                priorityRisks(result)
                categoryBreakdown(result)
                actions(result)
            }
            .padding(20)
        }
        .background(Brand.background.ignoresSafeArea())
    }

    private func summary(_ result: DiagnosisResult) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("診断レポート")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Brand.muted)
                    Text(result.rankTitle)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Brand.text)
                }

                Spacer()

                VStack(spacing: 0) {
                    Text(result.rank)
                        .font(.system(size: 46, weight: .black, design: .serif))
                        .foregroundStyle(.white)
                    Text("RANK")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.white.opacity(0.75))
                }
                .frame(width: 92, height: 92)
                .background(rankGradient(result.rank), in: RoundedRectangle(cornerRadius: 8))
                .shadow(color: rankColor(result.rank).opacity(0.25), radius: 14, y: 8)
            }

            Text(result.executiveSummary)
                .font(.subheadline)
                .foregroundStyle(Brand.subtext)
                .lineSpacing(4)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("リスクスコア")
                    Spacer()
                    Text("\(result.totalScore) / \(result.maxScore)")
                        .monospacedDigit()
                }
                .font(.caption.weight(.semibold))
                .foregroundStyle(Brand.muted)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4).fill(Color.black.opacity(0.08))
                        RoundedRectangle(cornerRadius: 4)
                            .fill(rankGradient(result.rank))
                            .frame(width: geo.size.width * result.percentage / 100)
                    }
                }
                .frame(height: 10)

                HStack {
                    Text("健全")
                    Spacer()
                    Text(String(format: "%.0f%%", result.percentage))
                        .monospacedDigit()
                    Spacer()
                    Text("危険")
                }
                .font(.caption2)
                .foregroundStyle(Brand.muted)
            }
        }
        .padding(18)
        .background(Brand.panel, in: RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Brand.border, lineWidth: 1))
    }

    private func radar(_ result: DiagnosisResult) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("リスク分布")
                .font(.headline)
                .foregroundStyle(Brand.text)

            RadarChartView(
                scores: result.categoryScores.map { score in
                    (label: String(score.category.name.prefix(4)), value: score.ratio)
                },
                accentColor: rankColor(result.rank)
            )
            .frame(height: 270)
        }
        .padding(18)
        .background(Brand.panel, in: RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Brand.border, lineWidth: 1))
    }

    private func priorityRisks(_ result: DiagnosisResult) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("優先して見るべき領域")
                .font(.headline)
                .foregroundStyle(Brand.text)

            ForEach(result.topRiskCategories) { score in
                HStack(spacing: 12) {
                    Image(systemName: score.category.icon)
                        .foregroundStyle(barColor(score.ratio))
                        .frame(width: 28)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(score.category.name)
                            .font(.subheadline.weight(.semibold))
                        Text(priorityAdvice(for: score.category.id))
                            .font(.caption)
                            .foregroundStyle(Brand.muted)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer()
                    Text("\(Int(score.ratio * 100))%")
                        .font(.subheadline.bold().monospacedDigit())
                        .foregroundStyle(barColor(score.ratio))
                }
                .padding(12)
                .background(barColor(score.ratio).opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(18)
        .background(Brand.panel, in: RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Brand.border, lineWidth: 1))
    }

    private func categoryBreakdown(_ result: DiagnosisResult) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("カテゴリ別スコア")
                .font(.headline)
                .foregroundStyle(Brand.text)

            ForEach(result.categoryScores) { score in
                HStack(spacing: 10) {
                    Image(systemName: score.category.icon)
                        .frame(width: 24)
                        .foregroundStyle(barColor(score.ratio))
                    Text(score.category.name)
                        .font(.caption)
                        .foregroundStyle(Brand.text)
                        .frame(width: 94, alignment: .leading)

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4).fill(Color.black.opacity(0.07))
                            RoundedRectangle(cornerRadius: 4)
                                .fill(barColor(score.ratio))
                                .frame(width: geo.size.width * score.ratio)
                        }
                    }
                    .frame(height: 9)

                    Text("\(score.score)/\(score.maxScore)")
                        .font(.caption2.monospacedDigit())
                        .foregroundStyle(Brand.muted)
                        .frame(width: 44, alignment: .trailing)
                }
            }
        }
        .padding(18)
        .background(Brand.panel, in: RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Brand.border, lineWidth: 1))
    }

    private func actions(_ result: DiagnosisResult) -> some View {
        HStack(spacing: 12) {
            ShareLink(item: shareText(result)) {
                Label("共有", systemImage: "square.and.arrow.up")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.bordered)
            .tint(Brand.text)

            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    engine.reset()
                }
            } label: {
                Label("再診断", systemImage: "arrow.counterclockwise")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .tint(Brand.accent)
        }
    }

    private func shareText(_ result: DiagnosisResult) -> String {
        "ブラック企業診断: \(result.rank)ランク（\(result.rankTitle)） \(result.totalScore)/\(result.maxScore)点"
    }

    private func priorityAdvice(for id: String) -> String {
        switch id {
        case "overtime": return "勤怠記録、残業申請、休日出勤の実態を確認。"
        case "salary": return "契約書、給与明細、未払いの有無を照合。"
        case "leave": return "有給取得率と休暇申請の心理的ハードルを確認。"
        case "harassment": return "相談窓口と報復防止の運用を点検。"
        case "turnover": return "離職理由と引き継ぎ不全を分析。"
        case "recruitment": return "求人票と実際の条件差を棚卸し。"
        case "management": return "意思決定とコンプライアンスの記録を確認。"
        case "growth": return "教育計画と評価基準を明文化。"
        case "health": return "健康診断、休職、メンタル相談の導線を確認。"
        default: return "制度が現場で使える状態か確認。"
        }
    }

    private func rankColor(_ rank: String) -> Color {
        switch rank {
        case "S": return .green
        case "A": return .teal
        case "B": return .cyan
        case "C": return Brand.amber
        case "D": return .orange
        case "E": return Brand.accent
        default: return .black
        }
    }

    private func rankGradient(_ rank: String) -> LinearGradient {
        let color = rankColor(rank)
        return LinearGradient(colors: [color, color.opacity(0.72)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    private func barColor(_ ratio: Double) -> Color {
        switch ratio {
        case 0..<0.25: return .green
        case 0.25..<0.5: return .teal
        case 0.5..<0.75: return Brand.amber
        default: return Brand.accent
        }
    }
}
