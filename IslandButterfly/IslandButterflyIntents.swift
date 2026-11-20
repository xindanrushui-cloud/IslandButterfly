import ActivityKit
import AppIntents
import Foundation

/// 快捷指令动作：启动蝴蝶岛。
///
/// 供「快捷指令」自动化调用（例如定时触发，每 8 小时重开一次，
/// 绕过 iOS 实时活动 8 小时上限）。有活动在跑则更新它，不重复启动。
/// Intent 在后台运行，不打开 App。
struct StartButterflyIslandIntent: AppIntent {
    static var title: LocalizedStringResource = "启动蝴蝶岛"
    static var description = IntentDescription("启动岛蝶的灵动岛实时活动，岛上常驻一只蝴蝶。")

    func perform() async throws -> some IntentResult {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            throw ButterflyIntentError.activitiesNotEnabled
        }

        let content = ActivityContent(
            state: IslandButterflyAttributes.ContentState(startedAt: Date()),
            staleDate: nil)

        if let activity = Activity<IslandButterflyAttributes>.activities.first {
            await activity.update(content)
        } else {
            _ = try Activity<IslandButterflyAttributes>.request(
                attributes: IslandButterflyAttributes(),
                content: content,
                pushType: nil
            )
        }
        return .result()
    }
}

/// 快捷指令动作：停止蝴蝶岛。
struct StopButterflyIslandIntent: AppIntent {
    static var title: LocalizedStringResource = "停止蝴蝶岛"
    static var description = IntentDescription("结束岛蝶的灵动岛实时活动。")

    func perform() async throws -> some IntentResult {
        for activity in Activity<IslandButterflyAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
        return .result()
    }
}

/// 岛蝶快捷指令动作的报错。
enum ButterflyIntentError: Swift.Error, CustomLocalizedStringResourceConvertible {
    case activitiesNotEnabled

    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .activitiesNotEnabled:
            return "实时活动未开启，请在「设置 → 岛蝶 → 实时活动」中打开开关。"
        }
    }
}

/// 把两个动作暴露给快捷指令与 Siri。
struct IslandButterflyShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: StartButterflyIslandIntent(), phrases: [
            "用${applicationName}启动蝴蝶岛",
        ])
        AppShortcut(intent: StopButterflyIslandIntent(), phrases: [
            "用${applicationName}停止蝴蝶岛",
        ])
    }
}
