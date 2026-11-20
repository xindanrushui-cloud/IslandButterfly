import ActivityKit
import SwiftUI
import WidgetKit

/// 岛蝶的实时活动视图：锁屏横幅 + 灵动岛展开/紧凑/最小三种形态。
///
/// 蝴蝶用 ButterflyView 画：TimelineView 每 0.5 秒在“翅膀张开 / 收起”
/// 两帧之间切换，做出扇翅膀的效果。
struct IslandButterflyWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: IslandButterflyAttributes.self) { context in
            // 锁屏横幅视图
            HStack(spacing: 12) {
                ButterflyView(size: 44)
                VStack(alignment: .leading, spacing: 2) {
                    Text("岛蝶")
                        .font(.headline)
                    Text("岛蝶陪着你")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(context.state.startedAt, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        } dynamicIsland: { context in
            DynamicIsland {
                // 展开视图：左端大蝴蝶
                DynamicIslandExpandedRegion(.leading) {
                    ButterflyView(size: 60)
                }
                // 展开视图：右端标题
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("岛蝶")
                            .font(.headline)
                        Text("正在陪伴")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                // 展开视图：下方一句话 + 开始时间
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Text("岛蝶陪着你")
                            .font(.subheadline)
                        Spacer()
                        Text("自 \(context.state.startedAt, style: .time) 起")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            } compactLeading: {
                ButterflyView(size: 26)
            } compactTrailing: {
                Text("岛蝶")
                    .font(.caption2.weight(.semibold))
            } minimal: {
                ButterflyView(size: 24)
            }
            .keylineTint(Color(red: 166 / 255, green: 76 / 255, blue: 255 / 255))
        }
    }
}
