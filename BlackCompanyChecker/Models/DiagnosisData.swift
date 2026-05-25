import Foundation

struct Question: Identifiable, Codable {
    let id: Int
    let text: String
    let choices: [Choice]
}

struct Choice: Identifiable, Codable {
    let id: Int
    let text: String
    let score: Int
}

struct Category: Identifiable {
    let id: String
    let name: String
    let icon: String
    let questions: [Question]
}

struct CategoryScore: Identifiable {
    let category: Category
    let score: Int
    let maxScore: Int

    var id: String { category.id }
    var ratio: Double { maxScore == 0 ? 0 : Double(score) / Double(maxScore) }
}

struct DiagnosisResult {
    let totalScore: Int
    let maxScore: Int
    let categoryScores: [CategoryScore]

    var percentage: Double {
        maxScore == 0 ? 0 : Double(totalScore) / Double(maxScore) * 100
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
        case "S": return "健全経営レベル"
        case "A": return "良好な職場"
        case "B": return "軽微な改善余地"
        case "C": return "要観察ゾーン"
        case "D": return "高リスク職場"
        case "E": return "重大リスク職場"
        default: return "危険水域"
        }
    }

    var executiveSummary: String {
        switch rank {
        case "S":
            return "労務・組織運営は安定しています。今の基準を文書化し、採用や教育でも再現できる状態にしましょう。"
        case "A":
            return "大きな懸念は少ない状態です。小さな不満が蓄積しないよう、給与・休暇・心理的安全性を定期点検してください。"
        case "B":
            return "一部に運用の粗さがあります。属人的な判断を減らし、勤怠・評価・相談窓口のルールを見直す価値があります。"
        case "C":
            return "複数のカテゴリでリスクが見えています。放置すると離職や採用難につながるため、優先順位を決めて改善を始めてください。"
        case "D":
            return "従業員体験と法務リスクの両面で注意が必要です。勤怠、給与、ハラスメント対応から早急に確認しましょう。"
        case "E":
            return "重大な職場リスクが疑われます。社内だけで抱えず、労務の専門家や相談機関への相談を検討してください。"
        default:
            return "危険な兆候が強く出ています。記録を残し、健康と安全を最優先に、外部相談を含めた対応を進めてください。"
        }
    }

    var topRiskCategories: [CategoryScore] {
        Array(categoryScores.sorted { $0.ratio > $1.ratio }.prefix(3))
    }
}

private func choices(_ safe: String, _ low: String, _ medium: String, _ high: String, _ critical: String) -> [Choice] {
    [
        Choice(id: 0, text: safe, score: 0),
        Choice(id: 1, text: low, score: 1),
        Choice(id: 2, text: medium, score: 2),
        Choice(id: 3, text: high, score: 3),
        Choice(id: 4, text: critical, score: 4)
    ]
}

let allCategories: [Category] = [
    Category(id: "overtime", name: "残業・労働時間", icon: "clock.badge.exclamationmark", questions: [
        Question(id: 100, text: "月の平均残業時間はどの程度ですか？", choices: choices("20時間未満", "20〜40時間", "40〜60時間", "60〜80時間", "80時間以上")),
        Question(id: 101, text: "残業代は正しく支払われていますか？", choices: choices("1分単位で支給", "概ね支給される", "固定残業代で説明が曖昧", "未払いがある", "残業代の概念がない")),
        Question(id: 102, text: "勤怠記録は実態に合っていますか？", choices: choices("打刻と実態が一致", "自己申告だが修正できる", "上長承認で削られることがある", "定時打刻後に働く", "勤怠管理がない")),
        Question(id: 103, text: "深夜・早朝・休日の勤務はありますか？", choices: choices("ほぼない", "繁忙期のみ", "月に数回", "週に何度もある", "常態化している")),
        Question(id: 104, text: "退勤しにくい雰囲気はありますか？", choices: choices("定時退勤しやすい", "少し気まずい", "上司より先に帰りにくい", "帰ろうとすると嫌味を言われる", "帰ること自体が責められる")),
        Question(id: 105, text: "休日出勤の扱いは明確ですか？", choices: choices("代休・手当が明確", "概ね処理される", "申請が通りにくい", "サービス出勤がある", "休日の概念が崩れている"))
    ]),
    Category(id: "salary", name: "給与・待遇", icon: "yensign.circle", questions: [
        Question(id: 200, text: "給与は毎月決まった日に支払われますか？", choices: choices("必ず支払われる", "まれに遅れる", "遅延が何度かある", "理由なく減額された", "未払いが発生した")),
        Question(id: 201, text: "昇給や評価の基準は明確ですか？", choices: choices("基準と面談がある", "基準はあるが曖昧", "上司の印象で決まる", "何年も昇給がない", "話題にすると嫌がられる")),
        Question(id: 202, text: "賞与やインセンティブの説明は実態と合っていますか？", choices: choices("説明通りに支給", "変動はあるが納得できる", "業績理由でよく削られる", "求人と実態が違う", "制度が形だけ")),
        Question(id: 203, text: "社会保険や福利厚生は整っていますか？", choices: choices("法定分は完備", "説明不足だが加入済み", "一部が曖昧", "加入を渋られる", "未加入・違法状態")),
        Question(id: 204, text: "経費や交通費の精算は適切ですか？", choices: choices("速やかに精算", "少額の自己負担がある", "申請が通りにくい", "自己負担が多い", "精算されない")),
        Question(id: 205, text: "雇用契約書や労働条件通知書は交付されていますか？", choices: choices("入社時に明示", "後日交付された", "内容が一部違う", "請求しても出ない", "書面が存在しない"))
    ]),
    Category(id: "leave", name: "休暇・有給", icon: "calendar.badge.clock", questions: [
        Question(id: 300, text: "有給休暇は取りやすいですか？", choices: choices("自由に取得できる", "事前申請で取れる", "上司次第", "取ると評価が下がる", "有給は飾り扱い")),
        Question(id: 301, text: "有給消化率はどの程度ですか？", choices: choices("80%以上", "50〜80%", "30〜50%", "10〜30%", "10%未満")),
        Question(id: 302, text: "体調不良時に休めますか？", choices: choices("休むよう促される", "休めるが気を遣う", "出社を求められがち", "病欠でも責められる", "診断書を過剰に要求される")),
        Question(id: 303, text: "産休・育休・介護休暇の実績はありますか？", choices: choices("男女とも実績あり", "一部実績あり", "制度はあるが戻りにくい", "取得すると退職を促される", "取得者がいない")),
        Question(id: 304, text: "連休や年末年始の休みは確保されていますか？", choices: choices("カレンダー通り", "業務都合で一部出勤", "連休が短い", "直前まで決まらない", "連休がほぼない")),
        Question(id: 305, text: "休暇中の連絡ルールは守られていますか？", choices: choices("緊急時以外なし", "必要な連絡のみ", "チャット確認が暗黙", "即レスを求められる", "電話に出ないと叱責される"))
    ]),
    Category(id: "harassment", name: "ハラスメント", icon: "exclamationmark.shield", questions: [
        Question(id: 400, text: "人格否定や威圧的な叱責はありますか？", choices: choices("見聞きしない", "きつい言い方がまれにある", "特定の人が標的になる", "怒鳴る・物に当たる", "暴言や暴力がある")),
        Question(id: 401, text: "セクハラや不適切な言動への対応は機能していますか？", choices: choices("相談窓口が動く", "注意はされる", "笑い話で済まされる", "被害者が不利になる", "経営層が加害側")),
        Question(id: 402, text: "精神的に追い詰める行為はありますか？", choices: choices("ない", "まれに圧を感じる", "無視や仲間外れがある", "退職に追い込む行為がある", "メンタル不調者が複数いる")),
        Question(id: 403, text: "飲み会や社内行事の参加は任意ですか？", choices: choices("完全に任意", "推奨だが断れる", "断ると空気が悪い", "実質強制", "費用自己負担で強制")),
        Question(id: 404, text: "プライベートへの干渉はありますか？", choices: choices("ない", "雑談程度", "恋愛・家族を詮索される", "休日の行動を管理される", "SNS監視がある")),
        Question(id: 405, text: "相談した人が守られる仕組みはありますか？", choices: choices("匿名相談と保護がある", "相談先はある", "相談後の対応が不透明", "相談者が悪者にされる", "報復が起きる"))
    ]),
    Category(id: "turnover", name: "離職率・定着", icon: "person.badge.minus", questions: [
        Question(id: 500, text: "新入社員の3年以内離職率はどの程度ですか？", choices: choices("10%未満", "10〜20%", "20〜40%", "40〜60%", "60%以上")),
        Question(id: 501, text: "常に求人を出している状態ですか？", choices: choices("必要時のみ採用", "年に数回補充", "常に募集中", "入っては辞める", "大量採用を続けている")),
        Question(id: 502, text: "退職時の対応は適切ですか？", choices: choices("円満退職が多い", "引き止めはあるが適切", "しつこく引き止める", "退職届を受け取らない", "損害賠償をちらつかせる")),
        Question(id: 503, text: "引き継ぎやナレッジ管理はありますか？", choices: choices("文書化されている", "口頭説明が中心", "人によってばらつく", "退職で業務が止まる", "担当者しか分からない")),
        Question(id: 504, text: "社員の平均勤続年数はどの程度ですか？", choices: choices("10年以上", "5〜10年", "3〜5年", "1〜3年", "1年未満")),
        Question(id: 505, text: "退職理由の分析や改善は行われていますか？", choices: choices("定期的に改善している", "面談はしている", "記録だけ残す", "原因を個人の問題にする", "退職理由を聞かない"))
    ]),
    Category(id: "recruitment", name: "求人・採用", icon: "doc.text.magnifyingglass", questions: [
        Question(id: 600, text: "求人票と実際の労働条件は一致していますか？", choices: choices("正確に一致", "細部に差がある", "残業や給与に差がある", "大きく違う", "意図的に隠している")),
        Question(id: 601, text: "面接時の説明と入社後の実態にギャップはありますか？", choices: choices("説明通り", "少しある", "かなりある", "騙された感がある", "虚偽説明レベル")),
        Question(id: 602, text: "求人で誇張表現を使っていますか？", choices: choices("使っていない", "一般的な表現のみ", "実態より良く見せている", "曖昧な美辞麗句が多い", "具体条件を隠す")),
        Question(id: 603, text: "試用期間の扱いは明確ですか？", choices: choices("期間・待遇が明確", "説明はある", "延長条件が曖昧", "社会保険を渋られる", "何度も延長される")),
        Question(id: 604, text: "採用後のオンボーディングは整っていますか？", choices: choices("計画と担当者がある", "最低限の説明あり", "現場任せ", "放置される", "即戦力前提で責められる"))
    ]),
    Category(id: "management", name: "経営・組織体質", icon: "building.2", questions: [
        Question(id: 700, text: "意思決定は透明ですか？", choices: choices("会議体で決まる", "説明はある", "トップ判断が多い", "急な方針転換が多い", "社長の一声ですべて変わる")),
        Question(id: 701, text: "会社の将来性をどう感じますか？", choices: choices("成長が見込める", "安定している", "やや不安", "かなり不安", "いつ潰れてもおかしくない")),
        Question(id: 702, text: "情報共有は十分ですか？", choices: choices("必要情報が共有される", "最低限は届く", "知らされないことが多い", "後出しが多い", "噂だけが流れる")),
        Question(id: 703, text: "コンプライアンス意識はありますか？", choices: choices("研修と運用がある", "ルールはある", "グレーな運用がある", "違法行為を黙認", "違法行為を強要される")),
        Question(id: 704, text: "現場の意見は経営に届きますか？", choices: choices("改善に反映される", "聞く姿勢はある", "届いているか不明", "言うと不利になる", "意見を言えない"))
    ]),
    Category(id: "growth", name: "教育・キャリア", icon: "graduationcap", questions: [
        Question(id: 800, text: "新人教育は体系化されていますか？", choices: choices("研修計画がある", "OJTで教える", "見て覚える文化", "教育なしで任される", "質問すると責められる")),
        Question(id: 801, text: "スキルアップ支援はありますか？", choices: choices("費用補助や研修あり", "学習は奨励される", "時間が取りにくい", "支援がほぼない", "学ぶことを否定される")),
        Question(id: 802, text: "キャリアパスは明確ですか？", choices: choices("昇進ルートが明確", "大枠は見える", "不透明", "年功序列で実力と無関係", "長く働く未来が見えない")),
        Question(id: 803, text: "上司からのフィードバックは建設的ですか？", choices: choices("具体的で役立つ", "人による", "抽象的で分かりにくい", "否定中心", "人格攻撃になる")),
        Question(id: 804, text: "失敗から学ぶ文化はありますか？", choices: choices("振り返りで改善する", "大きな失敗だけ確認", "責任者探しになりがち", "失敗が許されない", "隠蔽が起きる"))
    ]),
    Category(id: "health", name: "健康・メンタル", icon: "heart.text.clipboard", questions: [
        Question(id: 900, text: "健康診断は適切に受けられますか？", choices: choices("就業時間内に受診", "年1回受けられる", "予約が自己責任", "案内が曖昧", "健康診断がない")),
        Question(id: 901, text: "ストレスチェックや相談体制はありますか？", choices: choices("実施後フォローあり", "実施のみ", "制度が形だけ", "相談しにくい", "不調は自己責任扱い")),
        Question(id: 902, text: "職場の雰囲気は心理的に安全ですか？", choices: choices("意見を言いやすい", "普通", "ピリピリしている", "常に誰かが怖がっている", "恐怖で支配されている")),
        Question(id: 903, text: "休職者への対応は適切ですか？", choices: choices("復帰支援がある", "最低限の対応あり", "休職者が定期的に出る", "休職から退職が多い", "休職が認められない")),
        Question(id: 904, text: "業務量は健康を保てる範囲ですか？", choices: choices("余裕を持てる", "繁忙期は厳しい", "常に多い", "睡眠を削る", "健康被害が出ている"))
    ]),
    Category(id: "workstyle", name: "働き方・制度", icon: "laptopcomputer.and.arrow.down", questions: [
        Question(id: 1000, text: "リモートワークや在宅勤務は使えますか？", choices: choices("自由に選べる", "週数日可能", "制度はあるが使いにくい", "原則出社", "提案すると否定される")),
        Question(id: 1001, text: "副業や兼業の扱いは明確ですか？", choices: choices("申請ルールが明確", "届け出で可能", "曖昧", "原則禁止", "発覚すると懲戒扱い")),
        Question(id: 1002, text: "業務ツールや設備は整っていますか？", choices: choices("必要なものが支給される", "概ね整っている", "古い環境で効率が悪い", "自費購入がある", "必要な道具すらない")),
        Question(id: 1003, text: "フレックスタイムや時差出勤は使えますか？", choices: choices("柔軟に使える", "条件付きで使える", "制度はあるが形だけ", "1分遅刻でも厳しい", "早出が暗黙ルール")),
        Question(id: 1004, text: "業務範囲や責任は明確ですか？", choices: choices("職務範囲が明確", "大枠は分かる", "何でも頼まれる", "責任だけ増える", "契約外業務が常態化"))
    ])
]
