import Foundation

struct Question: Identifiable, Codable {
    let id: Int
    let text: String
    let textEn: String
    let choices: [Choice]
}

struct Choice: Identifiable, Codable {
    let id: Int
    let text: String
    let textEn: String
    let score: Int // 0=ホワイト 1=やや灰色 2=グレー 3=ブラック寄り 4=真っ黒
}

struct Category: Identifiable {
    let id: String
    let name: String
    let nameEn: String
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

    var rankTitleEn: String {
        switch rank {
        case "S": return "Ultra White Company"
        case "A": return "White Company"
        case "B": return "Mostly White"
        case "C": return "Gray Zone"
        case "D": return "Leaning Black"
        case "E": return "Black Company"
        default: return "Pitch Black"
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
        id: "overtime", name: "残業・労働時間", nameEn: "Overtime & Working Hours", icon: "clock.badge.exclamationmark",
        questions: [
            Question(id: 100, text: "月の平均残業時間は？",
                     textEn: "Average monthly overtime hours?",
                     choices: [
                        Choice(id: 0, text: "20時間以下", textEn: "20 hours or less", score: 0),
                        Choice(id: 1, text: "20〜40時間", textEn: "20-40 hours", score: 1),
                        Choice(id: 2, text: "40〜60時間", textEn: "40-60 hours", score: 2),
                        Choice(id: 3, text: "60〜80時間", textEn: "60-80 hours", score: 3),
                        Choice(id: 4, text: "80時間超", textEn: "Over 80 hours", score: 4),
                     ]),
            Question(id: 101, text: "サービス残業（無給の残業）はある？",
                     textEn: "Is there unpaid overtime?",
                     choices: [
                        Choice(id: 0, text: "一切ない", textEn: "Never", score: 0),
                        Choice(id: 1, text: "たまにある（月数時間）", textEn: "Occasionally (few hours/month)", score: 1),
                        Choice(id: 2, text: "日常的にある", textEn: "Regularly", score: 2),
                        Choice(id: 3, text: "残業代の概念がない", textEn: "No concept of overtime pay", score: 3),
                        Choice(id: 4, text: "定時退社がそもそも不可能", textEn: "Leaving on time is impossible", score: 4),
                     ]),
            Question(id: 102, text: "タイムカードの管理は？",
                     textEn: "How is time tracking managed?",
                     choices: [
                        Choice(id: 0, text: "正確に記録される", textEn: "Accurately recorded", score: 0),
                        Choice(id: 1, text: "自己申告制", textEn: "Self-reported", score: 1),
                        Choice(id: 2, text: "上司の承認が必要で削られる", textEn: "Needs approval, often reduced", score: 2),
                        Choice(id: 3, text: "定時で打刻してから働く", textEn: "Clock out on time, then keep working", score: 3),
                        Choice(id: 4, text: "タイムカード自体がない", textEn: "No time tracking exists", score: 4),
                     ]),
            Question(id: 103, text: "深夜・早朝の勤務は？",
                     textEn: "Late night / early morning work?",
                     choices: [
                        Choice(id: 0, text: "ない", textEn: "Never", score: 0),
                        Choice(id: 1, text: "繁忙期のみ", textEn: "Only during busy periods", score: 1),
                        Choice(id: 2, text: "月に数回ある", textEn: "Several times a month", score: 2),
                        Choice(id: 3, text: "週に何度もある", textEn: "Multiple times a week", score: 3),
                        Choice(id: 4, text: "ほぼ毎日", textEn: "Almost every day", score: 4),
                     ]),
            Question(id: 104, text: "「帰りにくい雰囲気」はある？",
                     textEn: "Is there pressure to stay late?",
                     choices: [
                        Choice(id: 0, text: "定時退社が当たり前", textEn: "Leaving on time is normal", score: 0),
                        Choice(id: 1, text: "少し気まずい", textEn: "Slightly awkward", score: 1),
                        Choice(id: 2, text: "上司より先に帰れない", textEn: "Can't leave before your boss", score: 2),
                        Choice(id: 3, text: "帰ろうとすると嫌味を言われる", textEn: "Sarcastic remarks when leaving", score: 3),
                        Choice(id: 4, text: "帰宅は「甘え」扱い", textEn: "Going home is seen as weakness", score: 4),
                     ]),
            Question(id: 105, text: "休日出勤の頻度は？",
                     textEn: "How often do you work on days off?",
                     choices: [
                        Choice(id: 0, text: "ない", textEn: "Never", score: 0),
                        Choice(id: 1, text: "年に数回", textEn: "A few times a year", score: 1),
                        Choice(id: 2, text: "月に1〜2回", textEn: "1-2 times a month", score: 2),
                        Choice(id: 3, text: "ほぼ毎週", textEn: "Almost every week", score: 3),
                        Choice(id: 4, text: "休日の概念がない", textEn: "No concept of days off", score: 4),
                     ]),
        ]
    ),
    Category(
        id: "salary", name: "給与・待遇", nameEn: "Salary & Benefits", icon: "yensign.circle",
        questions: [
            Question(id: 200, text: "給与の支払いは？",
                     textEn: "Is salary paid on time?",
                     choices: [
                        Choice(id: 0, text: "毎月決まった日に振り込まれる", textEn: "Deposited on a fixed date monthly", score: 0),
                        Choice(id: 1, text: "数日遅れることがたまにある", textEn: "Occasionally delayed by a few days", score: 1),
                        Choice(id: 2, text: "遅れることが頻繁にある", textEn: "Frequently delayed", score: 2),
                        Choice(id: 3, text: "理由なく減額されたことがある", textEn: "Reduced without explanation", score: 3),
                        Choice(id: 4, text: "未払いが発生したことがある", textEn: "Non-payment has occurred", score: 4),
                     ]),
            Question(id: 201, text: "昇給の仕組みは？",
                     textEn: "How does the raise system work?",
                     choices: [
                        Choice(id: 0, text: "明確な評価基準と定期昇給がある", textEn: "Clear criteria with regular raises", score: 0),
                        Choice(id: 1, text: "一応あるが基準が曖昧", textEn: "Exists but criteria are vague", score: 1),
                        Choice(id: 2, text: "社長の気分次第", textEn: "Depends on the boss's mood", score: 2),
                        Choice(id: 3, text: "何年も昇給がない", textEn: "No raise for years", score: 3),
                        Choice(id: 4, text: "昇給の話をすると怒られる", textEn: "Asking about raises gets you yelled at", score: 4),
                     ]),
            Question(id: 202, text: "賞与（ボーナス）は？",
                     textEn: "How about bonuses?",
                     choices: [
                        Choice(id: 0, text: "年2回以上、安定して支給", textEn: "Twice a year or more, stable", score: 0),
                        Choice(id: 1, text: "年1〜2回だが変動が大きい", textEn: "1-2 times but highly variable", score: 1),
                        Choice(id: 2, text: "業績次第で出ないこともある", textEn: "Depends on performance, sometimes none", score: 2),
                        Choice(id: 3, text: "求人には書いてあったが実際はない", textEn: "Listed in job posting but never paid", score: 3),
                        Choice(id: 4, text: "ボーナスという概念がない", textEn: "No concept of bonuses", score: 4),
                     ]),
            Question(id: 203, text: "残業代の計算は？",
                     textEn: "How is overtime pay calculated?",
                     choices: [
                        Choice(id: 0, text: "1分単位で正確に計算", textEn: "Calculated by the minute", score: 0),
                        Choice(id: 1, text: "15〜30分単位で切り捨て", textEn: "Rounded down in 15-30 min blocks", score: 1),
                        Choice(id: 2, text: "みなし残業制で超過分は曖昧", textEn: "Fixed overtime, excess is vague", score: 2),
                        Choice(id: 3, text: "みなし残業が実態とかけ離れている", textEn: "Fixed overtime far below actual", score: 3),
                        Choice(id: 4, text: "残業代が出ない", textEn: "No overtime pay", score: 4),
                     ]),
            Question(id: 204, text: "交通費・経費の精算は？",
                     textEn: "Transportation/expense reimbursement?",
                     choices: [
                        Choice(id: 0, text: "全額支給、経費も速やかに精算", textEn: "Fully covered, expenses promptly reimbursed", score: 0),
                        Choice(id: 1, text: "上限付きだが支給される", textEn: "Covered with a cap", score: 1),
                        Choice(id: 2, text: "申請が面倒で自腹のことも", textEn: "Complicated process, sometimes out of pocket", score: 2),
                        Choice(id: 3, text: "自腹が多い", textEn: "Often out of pocket", score: 3),
                        Choice(id: 4, text: "交通費すら出ない", textEn: "Not even transportation is covered", score: 4),
                     ]),
            Question(id: 205, text: "社会保険の加入状況は？",
                     textEn: "Social insurance enrollment?",
                     choices: [
                        Choice(id: 0, text: "健保・厚生年金・雇用・労災すべて完備", textEn: "All insurance fully covered", score: 0),
                        Choice(id: 1, text: "基本的にあるが説明が少ない", textEn: "Mostly covered but poorly explained", score: 1),
                        Choice(id: 2, text: "一部未加入", textEn: "Partially enrolled", score: 2),
                        Choice(id: 3, text: "加入を渋られた", textEn: "Company reluctant to enroll", score: 3),
                        Choice(id: 4, text: "未加入・違法状態", textEn: "Not enrolled, illegal", score: 4),
                     ]),
        ]
    ),
    Category(
        id: "leave", name: "休暇・有給", nameEn: "Leave & Paid Days Off", icon: "calendar.badge.clock",
        questions: [
            Question(id: 300, text: "有給休暇は取れる？",
                     textEn: "Can you take paid leave?",
                     choices: [
                        Choice(id: 0, text: "自由に取れる", textEn: "Freely taken", score: 0),
                        Choice(id: 1, text: "事前申請で取れる", textEn: "Can take with advance notice", score: 1),
                        Choice(id: 2, text: "上司の機嫌による", textEn: "Depends on boss's mood", score: 2),
                        Choice(id: 3, text: "取ると評価が下がる", textEn: "Taking it hurts your evaluation", score: 3),
                        Choice(id: 4, text: "有給は「飾り」", textEn: "Paid leave is just decoration", score: 4),
                     ]),
            Question(id: 301, text: "年間の有給消化率は？",
                     textEn: "Annual paid leave usage rate?",
                     choices: [
                        Choice(id: 0, text: "80%以上", textEn: "Over 80%", score: 0),
                        Choice(id: 1, text: "50〜80%", textEn: "50-80%", score: 1),
                        Choice(id: 2, text: "30〜50%", textEn: "30-50%", score: 2),
                        Choice(id: 3, text: "10〜30%", textEn: "10-30%", score: 3),
                        Choice(id: 4, text: "10%以下", textEn: "Under 10%", score: 4),
                     ]),
            Question(id: 302, text: "体調不良での休みは？",
                     textEn: "Taking sick days?",
                     choices: [
                        Choice(id: 0, text: "「休んで」と言ってもらえる", textEn: "Told to take rest", score: 0),
                        Choice(id: 1, text: "休めるが気を遣う", textEn: "Can rest but feel guilty", score: 1),
                        Choice(id: 2, text: "這ってでも出社する空気", textEn: "Expected to come even when sick", score: 2),
                        Choice(id: 3, text: "インフルでも出社させられた", textEn: "Forced to work with the flu", score: 3),
                        Choice(id: 4, text: "休むと始末書を書かされる", textEn: "Written up for taking sick days", score: 4),
                     ]),
            Question(id: 303, text: "産休・育休の取得実績は？",
                     textEn: "Maternity/paternity leave track record?",
                     choices: [
                        Choice(id: 0, text: "男女とも取得実績あり", textEn: "Both men and women have taken it", score: 0),
                        Choice(id: 1, text: "女性は取れるが男性は難しい", textEn: "Women can, men struggle", score: 1),
                        Choice(id: 2, text: "取れるが復帰後の待遇が悪い", textEn: "Can take it but worse treatment after", score: 2),
                        Choice(id: 3, text: "暗に退職を勧められる", textEn: "Subtly pushed to resign", score: 3),
                        Choice(id: 4, text: "取得した人がいない", textEn: "Nobody has ever taken it", score: 4),
                     ]),
            Question(id: 304, text: "連休（GW・年末年始）は？",
                     textEn: "Long holidays (national holidays)?",
                     choices: [
                        Choice(id: 0, text: "カレンダー通り＋有給奨励", textEn: "Calendar holidays + encouraged PTO", score: 0),
                        Choice(id: 1, text: "カレンダー通り", textEn: "Calendar holidays observed", score: 1),
                        Choice(id: 2, text: "一部出勤がある", textEn: "Some work days during holidays", score: 2),
                        Choice(id: 3, text: "連休が3日以下に削られる", textEn: "Holidays cut to 3 days or less", score: 3),
                        Choice(id: 4, text: "連休は存在しない", textEn: "No long holidays exist", score: 4),
                     ]),
            Question(id: 305, text: "休日のメール・電話対応は？",
                     textEn: "Responding to messages on days off?",
                     choices: [
                        Choice(id: 0, text: "一切不要", textEn: "Not required at all", score: 0),
                        Choice(id: 1, text: "緊急時のみ", textEn: "Only in emergencies", score: 1),
                        Choice(id: 2, text: "チャットは見ておく暗黙のルール", textEn: "Unspoken rule to check messages", score: 2),
                        Choice(id: 3, text: "即レス必須", textEn: "Immediate response required", score: 3),
                        Choice(id: 4, text: "電話に出ないと翌日説教", textEn: "Not answering means a lecture next day", score: 4),
                     ]),
        ]
    ),
    Category(
        id: "harassment", name: "ハラスメント", nameEn: "Harassment", icon: "exclamationmark.shield",
        questions: [
            Question(id: 400, text: "パワハラの有無は？",
                     textEn: "Is there power harassment?",
                     choices: [
                        Choice(id: 0, text: "見たことがない", textEn: "Never seen it", score: 0),
                        Choice(id: 1, text: "軽い叱責はある", textEn: "Mild scolding occurs", score: 1),
                        Choice(id: 2, text: "特定の上司が高圧的", textEn: "Certain managers are overbearing", score: 2),
                        Choice(id: 3, text: "怒鳴る・物を投げるがある", textEn: "Shouting or throwing things occurs", score: 3),
                        Choice(id: 4, text: "人格否定・暴力がある", textEn: "Personal attacks or violence", score: 4),
                     ]),
            Question(id: 401, text: "セクハラへの対応は？",
                     textEn: "How is sexual harassment handled?",
                     choices: [
                        Choice(id: 0, text: "相談窓口があり厳正に対処", textEn: "Reporting system with strict action", score: 0),
                        Choice(id: 1, text: "窓口はあるが形骸化", textEn: "System exists but barely used", score: 1),
                        Choice(id: 2, text: "セクハラが冗談扱い", textEn: "Sexual harassment treated as jokes", score: 2),
                        Choice(id: 3, text: "被害者が悪い空気になる", textEn: "Victim is blamed", score: 3),
                        Choice(id: 4, text: "経営層がセクハラの加害者", textEn: "Management are the perpetrators", score: 4),
                     ]),
            Question(id: 402, text: "精神的に追い詰める行為は？",
                     textEn: "Psychological pressure tactics?",
                     choices: [
                        Choice(id: 0, text: "ない", textEn: "None", score: 0),
                        Choice(id: 1, text: "たまにプレッシャーを感じる", textEn: "Occasional pressure", score: 1),
                        Choice(id: 2, text: "無視・仲間外れがある", textEn: "Ignoring/exclusion happens", score: 2),
                        Choice(id: 3, text: "退職に追い込む行為がある", textEn: "Actions to force resignation", score: 3),
                        Choice(id: 4, text: "メンタル疾患になった人がいる", textEn: "People have developed mental illness", score: 4),
                     ]),
            Question(id: 403, text: "飲み会・社内行事への参加は？",
                     textEn: "Company parties and events?",
                     choices: [
                        Choice(id: 0, text: "任意で断っても問題なし", textEn: "Optional, no issue declining", score: 0),
                        Choice(id: 1, text: "参加推奨だが強制ではない", textEn: "Encouraged but not forced", score: 1),
                        Choice(id: 2, text: "不参加だと空気が悪くなる", textEn: "Not attending creates tension", score: 2),
                        Choice(id: 3, text: "実質強制参加", textEn: "Effectively mandatory", score: 3),
                        Choice(id: 4, text: "強制参加＋費用自腹", textEn: "Mandatory + pay your own way", score: 4),
                     ]),
            Question(id: 404, text: "プライベートへの干渉は？",
                     textEn: "Intrusion into personal life?",
                     choices: [
                        Choice(id: 0, text: "一切ない", textEn: "None at all", score: 0),
                        Choice(id: 1, text: "世間話程度に聞かれる", textEn: "Asked about in small talk", score: 1),
                        Choice(id: 2, text: "恋愛・結婚について詮索される", textEn: "Prying about relationships/marriage", score: 2),
                        Choice(id: 3, text: "休日の過ごし方を管理される", textEn: "Days off activities are monitored", score: 3),
                        Choice(id: 4, text: "SNSの監視・私物チェックがある", textEn: "SNS monitoring or personal item checks", score: 4),
                     ]),
        ]
    ),
    Category(
        id: "turnover", name: "離職率・定着率", nameEn: "Turnover Rate", icon: "person.badge.minus",
        questions: [
            Question(id: 500, text: "新入社員の3年以内の離職率は？",
                     textEn: "New hire turnover within 3 years?",
                     choices: [
                        Choice(id: 0, text: "10%以下", textEn: "Under 10%", score: 0),
                        Choice(id: 1, text: "10〜20%", textEn: "10-20%", score: 1),
                        Choice(id: 2, text: "20〜40%", textEn: "20-40%", score: 2),
                        Choice(id: 3, text: "40〜60%", textEn: "40-60%", score: 3),
                        Choice(id: 4, text: "60%以上", textEn: "Over 60%", score: 4),
                     ]),
            Question(id: 501, text: "常に求人を出している？",
                     textEn: "Always hiring?",
                     choices: [
                        Choice(id: 0, text: "事業拡大時のみ採用", textEn: "Only when expanding", score: 0),
                        Choice(id: 1, text: "欠員補充が年に数回", textEn: "Replacement hiring a few times/year", score: 1),
                        Choice(id: 2, text: "常に求人が出ている", textEn: "Always posting job listings", score: 2),
                        Choice(id: 3, text: "入っては辞めるの繰り返し", textEn: "Constant cycle of hiring and quitting", score: 3),
                        Choice(id: 4, text: "年中大量採用している", textEn: "Mass hiring year-round", score: 4),
                     ]),
            Question(id: 502, text: "退職時の対応は？",
                     textEn: "How is resignation handled?",
                     choices: [
                        Choice(id: 0, text: "円満退職が普通", textEn: "Amicable departure is normal", score: 0),
                        Choice(id: 1, text: "引き止めはあるが最終的に承認", textEn: "Some resistance but ultimately accepted", score: 1),
                        Choice(id: 2, text: "しつこく引き止められる", textEn: "Persistent attempts to retain", score: 2),
                        Choice(id: 3, text: "退職届を受け取らない", textEn: "Resignation letter not accepted", score: 3),
                        Choice(id: 4, text: "損害賠償をちらつかせる", textEn: "Threatened with lawsuits", score: 4),
                     ]),
            Question(id: 503, text: "前任者からの引き継ぎは？",
                     textEn: "Knowledge transfer from predecessors?",
                     choices: [
                        Choice(id: 0, text: "マニュアルがあり丁寧に引き継ぎ", textEn: "Manuals and thorough handover", score: 0),
                        Choice(id: 1, text: "口頭で一通り説明", textEn: "Verbal explanation provided", score: 1),
                        Choice(id: 2, text: "前任者が突然辞めて引き継ぎなし", textEn: "Predecessor quit suddenly, no handover", score: 2),
                        Choice(id: 3, text: "引き継ぎの文化自体がない", textEn: "No handover culture", score: 3),
                        Choice(id: 4, text: "前任者が何人も連続で辞めている", textEn: "Multiple predecessors quit in a row", score: 4),
                     ]),
            Question(id: 504, text: "社員の平均勤続年数は？",
                     textEn: "Average employee tenure?",
                     choices: [
                        Choice(id: 0, text: "10年以上", textEn: "Over 10 years", score: 0),
                        Choice(id: 1, text: "5〜10年", textEn: "5-10 years", score: 1),
                        Choice(id: 2, text: "3〜5年", textEn: "3-5 years", score: 2),
                        Choice(id: 3, text: "1〜3年", textEn: "1-3 years", score: 3),
                        Choice(id: 4, text: "1年未満", textEn: "Less than 1 year", score: 4),
                     ]),
        ]
    ),
    Category(
        id: "recruitment", name: "求人・採用", nameEn: "Recruitment", icon: "doc.text.magnifyingglass",
        questions: [
            Question(id: 600, text: "求人票の内容と実態の一致度は？",
                     textEn: "Do job postings match reality?",
                     choices: [
                        Choice(id: 0, text: "正確に一致", textEn: "Accurately matches", score: 0),
                        Choice(id: 1, text: "ほぼ一致するが細部に差", textEn: "Mostly matches with minor differences", score: 1),
                        Choice(id: 2, text: "残業時間や給与に差がある", textEn: "Discrepancies in overtime/salary", score: 2),
                        Choice(id: 3, text: "大幅に違う", textEn: "Significantly different", score: 3),
                        Choice(id: 4, text: "完全に嘘だった", textEn: "Completely false", score: 4),
                     ]),
            Question(id: 601, text: "面接時の印象と入社後のギャップは？",
                     textEn: "Gap between interview impression and reality?",
                     choices: [
                        Choice(id: 0, text: "聞いていた通り", textEn: "Exactly as described", score: 0),
                        Choice(id: 1, text: "少しギャップあり", textEn: "Slight gap", score: 1),
                        Choice(id: 2, text: "かなり違った", textEn: "Quite different", score: 2),
                        Choice(id: 3, text: "騙された感がある", textEn: "Feel deceived", score: 3),
                        Choice(id: 4, text: "詐欺レベル", textEn: "Borderline fraud", score: 4),
                     ]),
            Question(id: 602, text: "求人に「アットホームな職場」と書いてある？",
                     textEn: "Job posting says 'family-like workplace'?",
                     choices: [
                        Choice(id: 0, text: "書いていない", textEn: "Not written", score: 0),
                        Choice(id: 1, text: "書いてあるが実際もアットホーム", textEn: "Written and actually true", score: 1),
                        Choice(id: 2, text: "書いてあるが普通の職場", textEn: "Written but just a normal workplace", score: 2),
                        Choice(id: 3, text: "書いてあるが私生活も管理される意味", textEn: "Written but means they control your life", score: 3),
                        Choice(id: 4, text: "「やりがい」「成長」「感謝」ワードの嵐", textEn: "Flood of buzzwords: passion, growth, gratitude", score: 4),
                     ]),
            Question(id: 603, text: "試用期間の扱いは？",
                     textEn: "How is the probation period handled?",
                     choices: [
                        Choice(id: 0, text: "正社員と同じ待遇", textEn: "Same treatment as regular employees", score: 0),
                        Choice(id: 1, text: "若干低い給与だが妥当", textEn: "Slightly lower salary but fair", score: 1),
                        Choice(id: 2, text: "試用期間が異常に長い（6ヶ月超）", textEn: "Abnormally long (over 6 months)", score: 2),
                        Choice(id: 3, text: "社会保険に入れてもらえない", textEn: "Not enrolled in social insurance", score: 3),
                        Choice(id: 4, text: "試用期間を繰り返し延長される", textEn: "Probation repeatedly extended", score: 4),
                     ]),
        ]
    ),
    Category(
        id: "management", name: "経営・組織体質", nameEn: "Management Culture", icon: "building.2",
        questions: [
            Question(id: 700, text: "経営者のワンマン度は？",
                     textEn: "How autocratic is management?",
                     choices: [
                        Choice(id: 0, text: "合議制で意思決定", textEn: "Decisions made by consensus", score: 0),
                        Choice(id: 1, text: "トップダウンだが意見は聞く", textEn: "Top-down but listens to input", score: 1),
                        Choice(id: 2, text: "社長の一声で全部決まる", textEn: "CEO's word decides everything", score: 2),
                        Choice(id: 3, text: "社長に逆らうと干される", textEn: "Opposing the CEO gets you sidelined", score: 3),
                        Choice(id: 4, text: "社長＝神、社訓の唱和あり", textEn: "CEO = God, company creed recitation", score: 4),
                     ]),
            Question(id: 701, text: "会社の将来性をどう感じる？",
                     textEn: "How do you feel about the company's future?",
                     choices: [
                        Choice(id: 0, text: "成長が見込める", textEn: "Growth expected", score: 0),
                        Choice(id: 1, text: "安定している", textEn: "Stable", score: 1),
                        Choice(id: 2, text: "やや不安", textEn: "Somewhat uneasy", score: 2),
                        Choice(id: 3, text: "かなり危ない", textEn: "Quite risky", score: 3),
                        Choice(id: 4, text: "いつ潰れてもおかしくない", textEn: "Could go bankrupt any day", score: 4),
                     ]),
            Question(id: 702, text: "情報共有の透明性は？",
                     textEn: "Transparency of information sharing?",
                     choices: [
                        Choice(id: 0, text: "経営状況も含め共有される", textEn: "Business status openly shared", score: 0),
                        Choice(id: 1, text: "必要な情報は伝えられる", textEn: "Necessary info is communicated", score: 1),
                        Choice(id: 2, text: "知らされないことが多い", textEn: "Often kept in the dark", score: 2),
                        Choice(id: 3, text: "重要事項が事後報告", textEn: "Important matters told after the fact", score: 3),
                        Choice(id: 4, text: "嘘の情報が流れる", textEn: "False information circulated", score: 4),
                     ]),
            Question(id: 703, text: "コンプライアンス意識は？",
                     textEn: "Compliance awareness?",
                     choices: [
                        Choice(id: 0, text: "研修があり徹底されている", textEn: "Training provided, strictly enforced", score: 0),
                        Choice(id: 1, text: "一応ルールはある", textEn: "Rules exist at least on paper", score: 1),
                        Choice(id: 2, text: "グレーなことをやっている", textEn: "Operating in gray areas", score: 2),
                        Choice(id: 3, text: "違法行為を見て見ぬふり", textEn: "Illegal activities ignored", score: 3),
                        Choice(id: 4, text: "違法行為を強要される", textEn: "Forced to commit illegal acts", score: 4),
                     ]),
        ]
    ),
    Category(
        id: "growth", name: "教育・キャリア", nameEn: "Training & Career", icon: "graduationcap",
        questions: [
            Question(id: 800, text: "新人教育は？",
                     textEn: "New employee training?",
                     choices: [
                        Choice(id: 0, text: "体系的な研修プログラムがある", textEn: "Structured training program", score: 0),
                        Choice(id: 1, text: "OJTで先輩が教えてくれる", textEn: "OJT with senior mentoring", score: 1),
                        Choice(id: 2, text: "「見て覚えろ」スタイル", textEn: "Watch and learn style", score: 2),
                        Choice(id: 3, text: "教育なしでいきなり現場", textEn: "No training, thrown into work", score: 3),
                        Choice(id: 4, text: "質問すると怒られる", textEn: "Asking questions gets you yelled at", score: 4),
                     ]),
            Question(id: 801, text: "スキルアップの支援は？",
                     textEn: "Support for skill development?",
                     choices: [
                        Choice(id: 0, text: "資格取得支援・外部研修あり", textEn: "Certification support, external training", score: 0),
                        Choice(id: 1, text: "自主的に学ぶのは歓迎される", textEn: "Self-study is welcomed", score: 1),
                        Choice(id: 2, text: "勉強する時間がない", textEn: "No time to study", score: 2),
                        Choice(id: 3, text: "スキルアップに興味がない社風", textEn: "Company culture ignores skill growth", score: 3),
                        Choice(id: 4, text: "転職に使える技術を学ぶなと言われる", textEn: "Told not to learn transferable skills", score: 4),
                     ]),
            Question(id: 802, text: "キャリアパスは明確？",
                     textEn: "Is the career path clear?",
                     choices: [
                        Choice(id: 0, text: "昇進ルートが明確", textEn: "Clear promotion path", score: 0),
                        Choice(id: 1, text: "なんとなく見えている", textEn: "Somewhat visible", score: 1),
                        Choice(id: 2, text: "不透明", textEn: "Opaque", score: 2),
                        Choice(id: 3, text: "年功序列で実力は関係ない", textEn: "Seniority-based, merit irrelevant", score: 3),
                        Choice(id: 4, text: "万年平社員しかいない", textEn: "Everyone stays entry-level forever", score: 4),
                     ]),
        ]
    ),
    Category(
        id: "health", name: "健康・メンタル", nameEn: "Health & Mental Wellness", icon: "heart.text.clipboard",
        questions: [
            Question(id: 900, text: "健康診断は？",
                     textEn: "Health check-ups?",
                     choices: [
                        Choice(id: 0, text: "年1回以上、就業時間内に受診", textEn: "Annual+, during work hours", score: 0),
                        Choice(id: 1, text: "年1回だが自分で予約する必要あり", textEn: "Annual but self-scheduled", score: 1),
                        Choice(id: 2, text: "案内はあるが受ける時間がない", textEn: "Notified but no time to go", score: 2),
                        Choice(id: 3, text: "そもそも案内がない", textEn: "No notification provided", score: 3),
                        Choice(id: 4, text: "健康診断がない", textEn: "No health check-ups", score: 4),
                     ]),
            Question(id: 901, text: "ストレスチェックは実施されている？",
                     textEn: "Is stress checking conducted?",
                     choices: [
                        Choice(id: 0, text: "実施され結果に基づくフォローもある", textEn: "Conducted with follow-up support", score: 0),
                        Choice(id: 1, text: "実施されるが形だけ", textEn: "Conducted but just formality", score: 1),
                        Choice(id: 2, text: "実施されていない", textEn: "Not conducted", score: 2),
                        Choice(id: 3, text: "ストレスを訴えると弱い人扱い", textEn: "Reporting stress = seen as weak", score: 3),
                        Choice(id: 4, text: "メンタル不調は自己責任", textEn: "Mental issues are your own fault", score: 4),
                     ]),
            Question(id: 902, text: "職場の雰囲気は？",
                     textEn: "Workplace atmosphere?",
                     choices: [
                        Choice(id: 0, text: "明るく風通しが良い", textEn: "Bright and open", score: 0),
                        Choice(id: 1, text: "普通", textEn: "Normal", score: 1),
                        Choice(id: 2, text: "ピリピリしている", textEn: "Tense", score: 2),
                        Choice(id: 3, text: "常に誰かが怒っている", textEn: "Someone is always angry", score: 3),
                        Choice(id: 4, text: "恐怖で支配されている", textEn: "Ruled by fear", score: 4),
                     ]),
            Question(id: 903, text: "休職者はいる？",
                     textEn: "Are there employees on leave?",
                     choices: [
                        Choice(id: 0, text: "ほぼいない", textEn: "Almost none", score: 0),
                        Choice(id: 1, text: "たまにいるが復帰できている", textEn: "Occasionally, but they return", score: 1),
                        Choice(id: 2, text: "メンタル不調の休職者が定期的に出る", textEn: "Regular mental health leave cases", score: 2),
                        Choice(id: 3, text: "休職→退職のパターンが多い", textEn: "Leave often leads to resignation", score: 3),
                        Choice(id: 4, text: "休職が認められない", textEn: "Leave not permitted", score: 4),
                     ]),
        ]
    ),
    Category(
        id: "workstyle", name: "働き方・制度", nameEn: "Work Style & Systems", icon: "laptopcomputer.and.arrow.down",
        questions: [
            Question(id: 1000, text: "リモートワーク・在宅勤務は？",
                     textEn: "Remote work options?",
                     choices: [
                        Choice(id: 0, text: "自由に選択できる", textEn: "Freely available", score: 0),
                        Choice(id: 1, text: "週数日可能", textEn: "A few days per week", score: 1),
                        Choice(id: 2, text: "制度はあるが使いにくい", textEn: "Available but hard to use", score: 2),
                        Choice(id: 3, text: "出社が絶対", textEn: "Office attendance mandatory", score: 3),
                        Choice(id: 4, text: "リモートを提案すると怒られる", textEn: "Suggesting remote gets you yelled at", score: 4),
                     ]),
            Question(id: 1001, text: "副業は認められている？",
                     textEn: "Are side jobs allowed?",
                     choices: [
                        Choice(id: 0, text: "自由に副業OK", textEn: "Side jobs freely allowed", score: 0),
                        Choice(id: 1, text: "届出制で可能", textEn: "Allowed with notification", score: 1),
                        Choice(id: 2, text: "原則禁止だが黙認", textEn: "Officially banned but tolerated", score: 2),
                        Choice(id: 3, text: "禁止で監視されている", textEn: "Banned and monitored", score: 3),
                        Choice(id: 4, text: "副業がバレたら懲戒処分", textEn: "Disciplinary action if discovered", score: 4),
                     ]),
            Question(id: 1002, text: "業務ツール・設備は？",
                     textEn: "Work tools and equipment?",
                     choices: [
                        Choice(id: 0, text: "最新のPC・ツールが支給される", textEn: "Latest PC/tools provided", score: 0),
                        Choice(id: 1, text: "普通の環境が整っている", textEn: "Standard setup available", score: 1),
                        Choice(id: 2, text: "古いPCで動作が遅い", textEn: "Old PCs, slow performance", score: 2),
                        Choice(id: 3, text: "自分のPCを持ち込んでいる", textEn: "Bring your own PC", score: 3),
                        Choice(id: 4, text: "必要なツールの購入すら認められない", textEn: "Can't even get necessary tools approved", score: 4),
                     ]),
            Question(id: 1003, text: "フレックスタイム制度は？",
                     textEn: "Flextime system?",
                     choices: [
                        Choice(id: 0, text: "コアタイムなしのフルフレックス", textEn: "Full flex with no core hours", score: 0),
                        Choice(id: 1, text: "コアタイムありのフレックス", textEn: "Flex with core hours", score: 1),
                        Choice(id: 2, text: "固定時間だが柔軟に対応", textEn: "Fixed hours but flexible", score: 2),
                        Choice(id: 3, text: "1分でも遅刻すると厳しい叱責", textEn: "Even 1 minute late gets harsh scolding", score: 3),
                        Choice(id: 4, text: "始業30分前に来るのが暗黙のルール", textEn: "Unspoken rule to arrive 30 min early", score: 4),
                     ]),
        ]
    ),
]
