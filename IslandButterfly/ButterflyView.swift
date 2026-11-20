import SwiftUI

/// 扇翅膀的蝴蝶视图：TimelineView 每 0.5 秒在“翅膀张开 / 收起”
/// 两帧之间切换，做出扇翅膀的效果。
///
/// 本文件同时加入 App target 与 Widget Extension target，
/// 两边共用同一份定义（在 project.pbxproj 中是同一个 fileRef、
/// 两条 PBXBuildFile 记录）。两帧图片 butterfly-open /
/// butterfly-closed 在两个 target 的 Assets.xcassets 里各有一份。
///
/// 注意：Live Activity 里 TimelineView(.animation) 是否逐帧刷新
/// 取决于系统实现；即使系统不刷新，它也会稳定显示其中一帧，
/// 不会空白或报错，只是不扇翅膀。
struct ButterflyView: View {
    /// 显示边长（点）。
    var size: CGFloat

    var body: some View {
        TimelineView(.animation) { timeline in
            let frame = Int(timeline.date.timeIntervalSince1970 * 2) % 2
            Image(frame == 0 ? "butterfly-open" : "butterfly-closed")
                .resizable()
                .interpolation(.none) // 像素风不要插值模糊
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
        }
    }
}
