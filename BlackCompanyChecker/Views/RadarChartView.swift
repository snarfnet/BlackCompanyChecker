import SwiftUI

struct RadarChartView: View {
    let scores: [(label: String, value: Double)] // 0.0 ~ 1.0
    let accentColor: Color

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2 - 30
            let count = scores.count
            guard count >= 3 else { return }

            let angleStep = (2 * Double.pi) / Double(count)
            let startAngle = -Double.pi / 2

            // Grid circles
            for level in 1...4 {
                let r = radius * Double(level) / 4.0
                var gridPath = Path()
                for i in 0..<count {
                    let angle = startAngle + angleStep * Double(i)
                    let pt = CGPoint(x: center.x + r * cos(angle), y: center.y + r * sin(angle))
                    if i == 0 { gridPath.move(to: pt) } else { gridPath.addLine(to: pt) }
                }
                gridPath.closeSubpath()
                context.stroke(gridPath, with: .color(.gray.opacity(0.2)), lineWidth: 0.5)
            }

            // Axis lines
            for i in 0..<count {
                let angle = startAngle + angleStep * Double(i)
                let pt = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
                var axisPath = Path()
                axisPath.move(to: center)
                axisPath.addLine(to: pt)
                context.stroke(axisPath, with: .color(.gray.opacity(0.15)), lineWidth: 0.5)
            }

            // Data polygon
            var dataPath = Path()
            for i in 0..<count {
                let angle = startAngle + angleStep * Double(i)
                let r = radius * scores[i].value
                let pt = CGPoint(x: center.x + r * cos(angle), y: center.y + r * sin(angle))
                if i == 0 { dataPath.move(to: pt) } else { dataPath.addLine(to: pt) }
            }
            dataPath.closeSubpath()
            context.fill(dataPath, with: .color(accentColor.opacity(0.2)))
            context.stroke(dataPath, with: .color(accentColor), lineWidth: 2)

            // Dots and labels
            for i in 0..<count {
                let angle = startAngle + angleStep * Double(i)
                let r = radius * scores[i].value
                let dataPt = CGPoint(x: center.x + r * cos(angle), y: center.y + r * sin(angle))
                let dotRect = CGRect(x: dataPt.x - 4, y: dataPt.y - 4, width: 8, height: 8)
                context.fill(Path(ellipseIn: dotRect), with: .color(accentColor))

                // Label
                let labelR = radius + 18
                let labelPt = CGPoint(x: center.x + labelR * cos(angle), y: center.y + labelR * sin(angle))
                let text = Text(scores[i].label).font(.system(size: 9, weight: .medium))
                context.draw(context.resolve(text), at: labelPt, anchor: .center)
            }
        }
    }
}
