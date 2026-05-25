import Foundation

struct Question: Identifiable, Codable {
    let id: Int
    let text: String
    let choices: [Choice]
}

struct Choice: Identifiable, Codable {
    let id: Int
    let text: String
    let score: Int // 0=ホワイト 1=やや灰色 2=グレー 3=ブラック寄り 4=真っ黒
}

struct Category: Identifiable {
    let id: String
    let name: String
    let icon: String
    let questions: [Question]
}

struct DiagnosisResult {
    let totalScore: Int
    let maxScore: Int
    let categoryScores: [(category: Category, score: Int, maxScore: Int)]

    var percentage: Double {
        guard maxScore > 0 else { return 0 }
        return Double(totalScore) / Double(maxScore) * 100
    }

    var rank: String {
        switch percentage {
        case 0..<15: return "S"
        case 15..<30: return "A"
        case 30..<45: return "B"
        case 45..<60: return "C"
        case 60..<75: return "D"
        case 75..<90: return "E"
        default: return "F"
        }
    }

    var rankTitle: String {
        switch rank {
        case "S": return "超ホワイト企業"
        case "A": return "ホワイト企業"
        case "B": return "ややホワイト"
        case "C": return "グレーゾーン"
        case "D": return "ブラック寄り"
        case "E": return "ブラック企業"
        default: return "漆黒のブラック"
        }
    }

    var rankColor: String {
        switch rank {
        case "S": return "rankS"
        case "A": return "rankA"
        case "B": return "rankB"
        case "C": return "rankC"
        case "D": return "rankD"
        case "E": return "rankE"
        default: return "rankF"
        }
    }

    var advice: String {
        switch rank {
        case "S": return "素晴らしい職場環境です。この会社を大切にしましょう。"
        case "A": return "良好な職場です。細かい改善点はあるかもしれませんが、恵まれた環境と言えます。"
        case "B": return "概ね良い職場ですが、いくつか気になる点があります。改善を提案してみるのも良いでしょう。"
        case "C": return "グレーな部分が目立ちます。労働基準監督署の相談窓口を知っておくと安心です。"
        case "D": return "危険信号が出ています。転職活動を視野に入れつつ、記録を残すことをお勧めします。"
        case "E": return "深刻な状況です。労働基準監督署への相談、弁護士への相談を検討してください。"
        default: return "今すぐ逃げてください。証拠を確保し、労働基準監督署・弁護士に相談を。あなたの健康が最優先です。"
        }
    }
}

// MARK: - All Categories & Questions

let allCategories: [Category] = [
    Category(
        id: "overtime", name: "残業・労働時間", icon: "clock.badge.exclamationmark",
        questions: [
            Question(id: 100, text: "月の平均残業時間は？",
                     choices: [
                        Choice(id: 0, text: "20時間以下", score: 0),
                        Choice(id: 1, text: "20〜40時間", score: 1),
                        Choice(id: 2, text: "40〜60時間", score: 2),
                        Choice(id: 3, text: "60〜80時間", score: 3),
                        Choice(id: 4, text: "80時間超", score: 4),
                     ]),
            Question(id: 101, text: "サービス残業（無給の残業）はある？",
                     choices: [
                        Choice(id: 0, text: "一切ない", score: 0),
                        Choice(id: 1, text: "たまにある（月数時間）", score: 1),
                        Choice(id: 2, text: "日常的にある", score: 2),
                        Choice(id: 3, text: "残業代の概念がない", score: 3),
                        Choice(id: 4, text: "定時退社がそもそも不可能", score: 4),
                     ]),
            Question(id: 102, text: "タイムカードの管理は？",
                     choices: [
                        Choice(id: 0, text: "正確に記録される", score: 0),
                        Choice(id: 1, text: "自己申告制", score: 1),
                        Choice(id: 2, text: "上司の承認が必要で削られる", score: 2),
                        Choice(id: 3, text: "定時で打刻してから働く", score: 3),
                        Choice(id: 4, text: "タイムカード自体がない", score: 4),
                     ]),
            Question(id: 103, text: "深夜・早朝の勤務は？",
                     choices: [
                        Choice(id: 0, text: "ない", score: 0),
                        Choice(id: 1, text: "繁忙期のみ", score: 1),
                        Choice(id: 2, text: "月に数回ある", score: 2),
                        Choice(id: 3, text: "週に何度もある", score: 3),
                        Choice(id: 4, text: "ほぼ毎日", score: 4),
                     ]),
            Question(id: 104, text: "「帰りにくい雰囲気」はある？",
                     choices: [
                        Choice(id: 0, text: "定時退社が当たり前", score: 0),
                        Choice(id: 1, text: "少し気まずい", score: 1),
                        Choice(id: 2, text: "上司より先に帰れない", score: 2),
                        Choice(id: 3, text: "帰ろうとすると嫌味を言われる", score: 3),
                        Choice(id: 4, text: "帰宅は「甘え」扱い", score: 4),
                     ]),
            Question(id: 105, text: "休日出勤の頻度は？",
                     choices: [
                        Choice(id: 0, text: "ない", score: 0),
                        Choice(id: 1, text: "年に数回", score: 1),
                        Choice(id: 2, text: "月に1〜2回", score: 2),
                        Choice(id: 3, text: "ほぼ毎週", score: 3),
                        Choice(id: 4, text: "休日の概念がない", score: 4),
                     ]),
        ]
    ),
    Category(
        id: "salary", name: "給与・待遇", icon: "yensign.circle",
        questions: [
            Question(id: 200, text: "給与の支払いは？",
                     choices: [
                        Choice(id: 0, text: "毎月決まった日に振り込まれる", score: 0),
                        Choice(id: 1, text: "数日遅れることがたまにある", score: 1),
                        Choice(id: 2, text: "遅れることが頻繁にある", score: 2),
                        Choice(id: 3, text: "理由なく減額されたことがある", score: 3),
                        Choice(id: 4, text: "未払いが発生したことがある", score: 4),
                     ]),
            Question(id: 201, text: "昇給の仕組みは？",
                     choices: [
                        Choice(id: 0, text: "明確な評価基準と定期昇給がある", score: 0),
                        Choice(id: 1, text: "一応あるが基準が曖昧", score: 1),
                        Choice(id: 2, text: "社長の気分次第", score: 2),
                        Choice(id: 3, text: "何年も昇給がない", score: 3),
                        Choice(id: 4, text: "昇給の話をすると怒られる", score: 4),
                     ]),
            Question(id: 202, text: "賞与（ボーナス）は？",
                     choices: [
                        Choice(id: 0, text: "年2回以上、安定して支給", score: 0),
                        Choice(id: 1, text: "年1〜2回だが変動が大きい", score: 1),
                        Choice(id: 2, text: "業績次第で出ないこともある", score: 2),
                        Choice(id: 3, text: "求人には書いてあったが実際はない", score: 3),
                        Choice(id: 4, text: "ボーナスという概念がない", score: 4),
                     ]),
            Question(id: 203, text: "残業代の計算は？",
                     choices: [
                        Choice(id: 0, text: "1分単位で正確に計算", score: 0),
                        Choice(id: 1, text: "15〜30分単位で切り捨て", score: 1),
                        Choice(id: 2, text: "みなし残業制で超過分は曖昧", score: 2),
                        Choice(id: 3, text: "みなし残業が実態とかけ離れている", score: 3),
                        Choice(id: 4, text: "残業代が出ない", score: 4),
                     ]),
            Question(id: 204, text: "交通費・経費の精算は？",
                     choices: [
                        Choice(id: 0, text: "全額支給、経費も速やかに精算", score: 0),
                        Choice(id: 1, text: "上限付きだが支給される", score: 1),
                        Choice(id: 2, text: "申請が面倒で自腹のことも", score: 2),
                        Choice(id: 3, text: "自腹が多い", score: 3),
                        Choice(id: 4, text: "交通費すら出ない", score: 4),
                     ]),
            Question(id: 205, text: "社会保険の加入状況は？",
                     choices: [
                        Choice(id: 0, text: "健保・厚生年金・雇用・労災すべて完備", score: 0),
                        Choice(id: 1, text: "基本的にあるが説明が少ない", score: 1),
                        Choice(id: 2, text: "一部未加入", score: 2),
                        Choice(id: 3, text: "加入を渋られた", score: 3),
                        Choice(id: 4, text: "未加入・違法状態", score: 4),
                     ]),
        ]
    ),
    Category(
        id: "leave", name: "休暇・有給", icon: "calendar.badge.clock",
        questions: [
            Question(id: 300, text: "有給休暇は取れる？",
                     choices: [
                        Choice(id: 0, text: "自由に取れる", score: 0),
                        Choice(id: 1, text: "事前申請で取れる", score: 1),
                        Choice(id: 2, text: "上司の機嫌による", score: 2),
                        Choice(id: 3, text: "取ると評価が下がる", score: 3),
                        Choice(id: 4, text: "有給は「飾り」", score: 4),
                     ]),
            Question(id: 301, text: "年間の有給消化率は？",
                     choices: [
                        Choice(id: 0, text: "80%以上", score: 0),
                        Choice(id: 1, text: "50〜80%", score: 1),
                        Choice(id: 2, text: "30〜50%", score: 2),
                        Choice(id: 3, text: "10〜30%", score: 3),
                        Choice(id: 4, text: "10%以下", score: 4),
                     ]),
            Question(id: 302, text: "体調不良での休みは？",
                     choices: [
                        Choice(id: 0, text: "「休んで」と言ってもらえる", score: 0),
                        Choice(id: 1, text: "休めるが気を遣う", score: 1),
                        Choice(id: 2, text: "這ってでも出社する空気", score: 2),
                        Choice(id: 3, text: "インフルでも出社させられた", score: 3),
                        Choice(id: 4, text: "休むと始末書を書かされる", score: 4),
                     ]),
            Question(id: 303, text: "産休・育休の取得実績は？",
                     choices: [
                        Choice(id: 0, text: "男女とも取得実績あり", score: 0),
                        Choice(id: 1, text: "女性は取れるが男性は難しい", score: 1),
                        Choice(id: 2, text: "取れるが復帰後の待遇が悪い", score: 2),
                        Choice(id: 3, text: "暗に退職を勧められる", score: 3),
                        Choice(id: 4, text: "取得した人がいない", score: 4),
                     ]),
            Question(id: 304, text: "連休（GW・年末年始）は？",
                     choices: [
                        Choice(id: 0, text: "カレンダー通り＋有給奨励", score: 0),
                        Choice(id: 1, text: "カレンダー通り", score: 1),
                        Choice(id: 2, text: "一部出勤がある", score: 2),
                        Choice(id: 3, text: "連休が3日以下に削られる", score: 3),
                        Choice(id: 4, text: "連休は存在しない", score: 4),
                     ]),
            Question(id: 305, text: "休日のメール・電話対応は？",
                     choices: [
                        Choice(id: 0, text: "一切不要", score: 0),
                        Choice(id: 1, text: "緊急時のみ", score: 1),
                        Choice(id: 2, text: "チャットは見ておく暗黙のルール", score: 2),
                        Choice(id: 3, text: "即レス必須", score: 3),
                        Choice(id: 4, text: "電話に出ないと翌日説教", score: 4),
                     ]),
        ]
    ),
    Category(
        id: "harassment", name: "ハラスメント", icon: "exclamationmark.shield",
        questions: [
            Question(id: 400, text: "パワハラの有無は？",
                     choices: [
                        Choice(id: 0, text: "見たことがない", score: 0),
                        Choice(id: 1, text: "軽い叱責はある", score: 1),
                        Choice(id: 2, text: "特定の上司が高圧的", score: 2),
                        Choice(id: 3, text: "怒鳴る・物を投げるがある", score: 3),
                        Choice(id: 4, text: "人格否定・暴力がある", score: 4),
                     ]),
            Question(id: 401, text: "セクハラへの対応は？",
                     choices: [
                        Choice(id: 0, text: "相談窓口があり厳正に対処", score: 0),
                        Choice(id: 1, text: "窓口はあるが形骸化", score: 1),
                        Choice(id: 2, text: "セクハラが冗談扱い", score: 2),
                        Choice(id: 3, text: "被害者が悪い空気になる", score: 3),
                        Choice(id: 4, text: "経営層がセクハラの加害者", score: 4),
                     ]),
            Question(id: 402, text: "精神的に追い詰める行為は？",
                     choices: [
                        Choice(id: 0, text: "ない", score: 0),
                        Choice(id: 1, text: "たまにプレッシャーを感じる", score: 1),
                        Choice(id: 2, text: "無視・仲間外れがある", score: 2),
                        Choice(id: 3, text: "退職に追い込む行為がある", score: 3),
                        Choice(id: 4, text: "メンタル疾患になった人がいる", score: 4),
                     ]),
            Question(id: 403, text: "飲み会・社内行事への参加は？",
                     choices: [
                        Choice(id: 0, text: "任意で断っても問題なし", score: 0),
                        Choice(id: 1, text: "参加推奨だが強制ではない", score: 1),
                        Choice(id: 2, text: "不参加だと空気が悪くなる", score: 2),
                        Choice(id: 3, text: "実質強制参加", score: 3),
                        Choice(id: 4, text: "強制参加＋費用自腹", score: 4),
                     ]),
            Question(id: 404, text: "プライベートへの干渉は？",
                     choices: [
                        Choice(id: 0, text: "一切ない", score: 0),
                        Choice(id: 1, text: "世間話程度に聞かれる", score: 1),
                        Choice(id: 2, text: "恋愛・結婚について詮索される", score: 2),
                        Choice(id: 3, text: "休日の過ごし方を管理される", score: 3),
                        Choice(id: 4, text: "SNSの監視・私物チェックがある", score: 4),
                     ]),
        ]
    ),
    Category(
        id: "turnover", name: "離職率・定着率", icon: "person.badge.minus",
        questions: [
            Question(id: 500, text: "新入社員の3年以内の離職率は？",
                     choices: [
                        Choice(id: 0, text: "10%以下", score: 0),
                        Choice(id: 1, text: "10〜20%", score: 1),
                        Choice(id: 2, text: "20〜40%", score: 2),
                        Choice(id: 3, text: "40〜60%", score: 3),
                        Choice(id: 4, text: "60%以上", score: 4),
                     ]),
            Question(id: 501, text: "常に求人を出している？",
                     choices: [
                        Choice(id: 0, text: "事業拡大時のみ採用", score: 0),
                        Choice(id: 1, text: "欠員補充が年に数回", score: 1),
                        Choice(id: 2, text: "常に求人が出ている", score: 2),
                        Choice(id: 3, text: "入っては辞めるの繰り返し", score: 3),
                        Choice(id: 4, text: "年中大量採用している", score: 4),
                     ]),
            Question(id: 502, text: "退職時の対応は？",
                     choices: [
                        Choice(id: 0, text: "円満退職が普通", score: 0),
                        Choice(id: 1, text: "引き止めはあるが最終的に承認", score: 1),
                        Choice(id: 2, text: "しつこく引き止められる", score: 2),
                        Choice(id: 3, text: "退職届を受け取らない", score: 3),
                        Choice(id: 4, text: "損害賠償をちらつかせる", score: 4),
                     ]),
            Question(id: 503, text: "前任者からの引き継ぎは？",
                     choices: [
                        Choice(id: 0, text: "マニュアルがあり丁寧に引き継ぎ", score: 0),
                        Choice(id: 1, text: "口頭で一通り説明", score: 1),
                        Choice(id: 2, text: "前任者が突然辞めて引き継ぎなし", score: 2),
                        Choice(id: 3, text: "引き継ぎの文化自体がない", score: 3),
                        Choice(id: 4, text: "前任者が何人も連続で辞めている", score: 4),
                     ]),
            Question(id: 504, text: "社員の平均勤続年数は？",
                     choices: [
                        Choice(id: 0, text: "10年以上", score: 0),
                        Choice(id: 1, text: "5〜10年", score: 1),
                        Choice(id: 2, text: "3〜5年", score: 2),
                        Choice(id: 3, text: "1〜3年", score: 3),
                        Choice(id: 4, text: "1年未満", score: 4),
                     ]),
        ]
    ),
    Category(
        id: "recruitment", name: "求人・採用", icon: "doc.text.magnifyingglass",
        questions: [
            Question(id: 600, text: "求人票の内容と実態の一致度は？",
                     choices: [
                        Choice(id: 0, text: "正確に一致", score: 0),
                        Choice(id: 1, text: "ほぼ一致するが細部に差", score: 1),
                        Choice(id: 2, text: "残業時間や給与に差がある", score: 2),
                        Choice(id: 3, text: "大幅に違う", score: 3),
                        Choice(id: 4, text: "完全に嘘だった", score: 4),
                     ]),
            Question(id: 601, text: "面接時の印象と入社後のギャップは？",
                     choices: [
                        Choice(id: 0, text: "聞いていた通り", score: 0),
                        Choice(id: 1, text: "少しギャップあり", score: 1),
                        Choice(id: 2, text: "かなり違った", score: 2),
                        Choice(id: 3, text: "騙された感がある", score: 3),
                        Choice(id: 4, text: "詐欺レベル", score: 4),
                     ]),
            Question(id: 602, text: "求人に「アットホームな職場」と書いてある？",
                     choices: [
                        Choice(id: 0, text: "書いていない", score: 0),
                        Choice(id: 1, text: "書いてあるが実際もアットホーム", score: 1),
                        Choice(id: 2, text: "書いてあるが普通の職場", score: 2),
                        Choice(id: 3, text: "書いてあるが私生活も管理される意味", score: 3),
                        Choice(id: 4, text: "「やりがい」「成長」「感謝」ワードの嵐", score: 4),
                     ]),
            Question(id: 603, text: "試用期間の扱いは？",
                     choices: [
                        Choice(id: 0, text: "正社員と同じ待遇", score: 0),
                        Choice(id: 1, text: "若干低い給与だが妥当", score: 1),
                        Choice(id: 2, text: "試用期間が異常に長い（6ヶ月超）", score: 2),
                        Choice(id: 3, text: "社会保険に入れてもらえない", score: 3),
                        Choice(id: 4, text: "試用期間を繰り返し延長される", score: 4),
                     ]),
        ]
    ),
    Category(
        id: "management", name: "経営・組織体質", icon: "building.2",
        questions: [
            Question(id: 700, text: "経営者のワンマン度は？",
                     choices: [
                        Choice(id: 0, text: "合議制で意思決定", score: 0),
                        Choice(id: 1, text: "トップダウンだが意見は聞く", score: 1),
                        Choice(id: 2, text: "社長の一声で全部決まる", score: 2),
                        Choice(id: 3, text: "社長に逆らうと干される", score: 3),
                        Choice(id: 4, text: "社長＝神、社訓の唱和あり", score: 4),
                     ]),
            Question(id: 701, text: "会社の将来性をどう感じる？",
                     choices: [
                        Choice(id: 0, text: "成長が見込める", score: 0),
                        Choice(id: 1, text: "安定している", score: 1),
                        Choice(id: 2, text: "やや不安", score: 2),
                        Choice(id: 3, text: "かなり危ない", score: 3),
                        Choice(id: 4, text: "いつ潰れてもおかしくない", score: 4),
                     ]),
            Question(id: 702, text: "情報共有の透明性は？",
                     choices: [
                        Choice(id: 0, text: "経営状況も含め共有される", score: 0),
                        Choice(id: 1, text: "必要な情報は伝えられる", score: 1),
                        Choice(id: 2, text: "知らされないことが多い", score: 2),
                        Choice(id: 3, text: "重要事項が事後報告", score: 3),
                        Choice(id: 4, text: "嘘の情報が流れる", score: 4),
                     ]),
            Question(id: 703, text: "コンプライアンス意識は？",
                     choices: [
                        Choice(id: 0, text: "研修があり徹底されている", score: 0),
                        Choice(id: 1, text: "一応ルールはある", score: 1),
                        Choice(id: 2, text: "グレーなことをやっている", score: 2),
                        Choice(id: 3, text: "違法行為を見て見ぬふり", score: 3),
                        Choice(id: 4, text: "違法行為を強要される", score: 4),
                     ]),
        ]
    ),
    Category(
        id: "growth", name: "教育・キャリア", icon: "graduationcap",
        questions: [
            Question(id: 800, text: "新人教育は？",
                     choices: [
                        Choice(id: 0, text: "体系的な研修プログラムがある", score: 0),
                        Choice(id: 1, text: "OJTで先輩が教えてくれる", score: 1),
                        Choice(id: 2, text: "「見て覚えろ」スタイル", score: 2),
                        Choice(id: 3, text: "教育なしでいきなり現場", score: 3),
                        Choice(id: 4, text: "質問すると怒られる", score: 4),
                     ]),
            Question(id: 801, text: "スキルアップの支援は？",
                     choices: [
                        Choice(id: 0, text: "資格取得支援・外部研修あり", score: 0),
                        Choice(id: 1, text: "自主的に学ぶのは歓迎される", score: 1),
                        Choice(id: 2, text: "勉強する時間がない", score: 2),
                        Choice(id: 3, text: "スキルアップに興味がない社風", score: 3),
                        Choice(id: 4, text: "転職に使える技術を学ぶなと言われる", score: 4),
                     ]),
            Question(id: 802, text: "キャリアパスは明確？",
                     choices: [
                        Choice(id: 0, text: "昇進ルートが明確", score: 0),
                        Choice(id: 1, text: "なんとなく見えている", score: 1),
                        Choice(id: 2, text: "不透明", score: 2),
                        Choice(id: 3, text: "年功序列で実力は関係ない", score: 3),
                        Choice(id: 4, text: "万年平社員しかいない", score: 4),
                     ]),
        ]
    ),
    Category(
        id: "health", name: "健康・メンタル", icon: "heart.text.clipboard",
        questions: [
            Question(id: 900, text: "健康診断は？",
                     choices: [
                        Choice(id: 0, text: "年1回以上、就業時間内に受診", score: 0),
                        Choice(id: 1, text: "年1回だが自分で予約する必要あり", score: 1),
                        Choice(id: 2, text: "案内はあるが受ける時間がない", score: 2),
                        Choice(id: 3, text: "そもそも案内がない", score: 3),
                        Choice(id: 4, text: "健康診断がない", score: 4),
                     ]),
            Question(id: 901, text: "ストレスチェックは実施されている？",
                     choices: [
                        Choice(id: 0, text: "実施され結果に基づくフォローもある", score: 0),
                        Choice(id: 1, text: "実施されるが形だけ", score: 1),
                        Choice(id: 2, text: "実施されていない", score: 2),
                        Choice(id: 3, text: "ストレスを訴えると弱い人扱い", score: 3),
                        Choice(id: 4, text: "メンタル不調は自己責任", score: 4),
                     ]),
            Question(id: 902, text: "職場の雰囲気は？",
                     choices: [
                        Choice(id: 0, text: "明るく風通しが良い", score: 0),
                        Choice(id: 1, text: "普通", score: 1),
                        Choice(id: 2, text: "ピリピリしている", score: 2),
                        Choice(id: 3, text: "常に誰かが怒っている", score: 3),
                        Choice(id: 4, text: "恐怖で支配されている", score: 4),
                     ]),
            Question(id: 903, text: "休職者はいる？",
                     choices: [
                        Choice(id: 0, text: "ほぼいない", score: 0),
                        Choice(id: 1, text: "たまにいるが復帰できている", score: 1),
                        Choice(id: 2, text: "メンタル不調の休職者が定期的に出る", score: 2),
                        Choice(id: 3, text: "休職→退職のパターンが多い", score: 3),
                        Choice(id: 4, text: "休職が認められない", score: 4),
                     ]),
        ]
    ),
    Category(
        id: "workstyle", name: "働き方・制度", icon: "laptopcomputer.and.arrow.down",
        questions: [
            Question(id: 1000, text: "リモートワーク・在宅勤務は？",
                     choices: [
                        Choice(id: 0, text: "自由に選択できる", score: 0),
                        Choice(id: 1, text: "週数日可能", score: 1),
                        Choice(id: 2, text: "制度はあるが使いにくい", score: 2),
                        Choice(id: 3, text: "出社が絶対", score: 3),
                        Choice(id: 4, text: "リモートを提案すると怒られる", score: 4),
                     ]),
            Question(id: 1001, text: "副業は認められている？",
                     choices: [
                        Choice(id: 0, text: "自由に副業OK", score: 0),
                        Choice(id: 1, text: "届出制で可能", score: 1),
                        Choice(id: 2, text: "原則禁止だが黙認", score: 2),
                        Choice(id: 3, text: "禁止で監視されている", score: 3),
                        Choice(id: 4, text: "副業がバレたら懲戒処分", score: 4),
                     ]),
            Question(id: 1002, text: "業務ツール・設備は？",
                     choices: [
                        Choice(id: 0, text: "最新のPC・ツールが支給される", score: 0),
                        Choice(id: 1, text: "普通の環境が整っている", score: 1),
                        Choice(id: 2, text: "古いPCで動作が遅い", score: 2),
                        Choice(id: 3, text: "自分のPCを持ち込んでいる", score: 3),
                        Choice(id: 4, text: "必要なツールの購入すら認められない", score: 4),
                     ]),
            Question(id: 1003, text: "フレックスタイム制度は？",
                     choices: [
                        Choice(id: 0, text: "コアタイムなしのフルフレックス", score: 0),
                        Choice(id: 1, text: "コアタイムありのフレックス", score: 1),
                        Choice(id: 2, text: "固定時間だが柔軟に対応", score: 2),
                        Choice(id: 3, text: "1分でも遅刻すると厳しい叱責", score: 3),
                        Choice(id: 4, text: "始業30分前に来るのが暗黙のルール", score: 4),
                     ]),
        ]
    ),
]
