import ActivityKit
import Foundation

/// 岛蝶 Live Activity 的共享属性定义。
///
/// 本文件同时加入 App target 与 Widget Extension target，
/// 两边共用同一份定义（在 project.pbxproj 中是同一个 fileRef、
/// 两条 PBXBuildFile 记录）。
struct IslandButterflyAttributes: ActivityAttributes {

    /// 实时活动中会变化的状态。
    public struct ContentState: Codable, Hashable {
        /// 活动启动时间，岛上用来显示“陪伴自何时起”。
        var startedAt: Date
    }

    // 没有固定属性：蝴蝶是常驻装饰，全部状态都在 ContentState 里。
}
