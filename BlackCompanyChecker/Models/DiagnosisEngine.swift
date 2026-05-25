import SwiftUI

@Observable
final class DiagnosisEngine {
    var answers: [Int: Int] = [:] // questionId -> choiceScore
    var currentCategoryIndex = 0
    var currentQuestionIndex = 0
    var phase: Phase = .intro

    enum Phase {
        case intro
        case diagnosis
        case result
    }

    let categories = allCategories

    var currentCategory: Category {
        categories[currentCategoryIndex]
    }

    var currentQuestion: Question {
        currentCategory.questions[currentQuestionIndex]
    }

    var totalQuestions: Int {
        categories.reduce(0) { $0 + $1.questions.count }
    }

    var answeredCount: Int {
        answers.count
    }

    var overallProgress: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(answeredCount) / Double(totalQuestions)
    }

    func answer(_ score: Int) {
        answers[currentQuestion.id] = score

        if currentQuestionIndex < currentCategory.questions.count - 1 {
            currentQuestionIndex += 1
        } else if currentCategoryIndex < categories.count - 1 {
            currentCategoryIndex += 1
            currentQuestionIndex = 0
        } else {
            phase = .result
        }
    }

    func goBack() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
        } else if currentCategoryIndex > 0 {
            currentCategoryIndex -= 1
            currentQuestionIndex = categories[currentCategoryIndex].questions.count - 1
        }
    }

    var canGoBack: Bool {
        currentCategoryIndex > 0 || currentQuestionIndex > 0
    }

    func buildResult() -> DiagnosisResult {
        var totalScore = 0
        var maxScore = 0
        var categoryScores: [CategoryScore] = []

        for cat in categories {
            var catScore = 0
            let catMax = cat.questions.count * 4
            for q in cat.questions {
                catScore += answers[q.id] ?? 0
            }
            totalScore += catScore
            maxScore += catMax
            categoryScores.append(CategoryScore(category: cat, score: catScore, maxScore: catMax))
        }

        return DiagnosisResult(totalScore: totalScore, maxScore: maxScore, categoryScores: categoryScores)
    }

    func reset() {
        answers = [:]
        currentCategoryIndex = 0
        currentQuestionIndex = 0
        phase = .intro
    }
}
