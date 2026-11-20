import ActivityKit
import SwiftUI
import UIKit

struct ContentView: View {
    @State private var currentActivity: Activity<IslandButterflyAttributes>?
    @State private var showPermissionAlert = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""

    private var isRunning: Bool { currentActivity != nil }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // 标题区
            VStack(spacing: 8) {
                ButterflyView(size: 96)
                Text("岛蝶")
                    .font(.largeTitle.bold())
                Text("灵动岛上常驻一只蝴蝶")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            // 蝴蝶卡片
            VStack(spacing: 6) {
                Text(isRunning ? "蝴蝶正在岛上陪着你" : "蝴蝶正在休息")
                    .font(.headline)
                if let activity = currentActivity {
                    Text("开始于 \(activity.content.state.startedAt, style: .time)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Text("点下方按钮，把蝴蝶放到灵动岛上")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.purple.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 32)

            // 启动 / 停止
            Button {
                Task {
                    if isRunning {
                        await stopActivity()
                    } else {
                        await startActivity()
                    }
                }
            } label: {
                Text(isRunning ? "停止蝴蝶岛" : "启动蝴蝶岛")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isRunning ? Color.red : Color.purple)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 32)

            Text(isRunning ? "实时活动运行中 · 灵动岛正在显示蝴蝶" : "实时活动未启动")
                .font(.footnote)
                .foregroundStyle(.secondary)

            Text("提示：iOS 的实时活动最长存活约 8 小时，到期后系统会自动结束。可用快捷指令自动化定时重新启动（见仓库 README）。")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
        }
        .onAppear {
            restoreActivity()
        }
        .alert("实时活动未开启", isPresented: $showPermissionAlert) {
            Button("去设置") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("取消", role: .cancel) {}
        } message: {
            Text("请在「设置 → 岛蝶 → 实时活动」中打开开关，再回到 App 启动蝴蝶岛。")
        }
        .alert("启动失败", isPresented: $showErrorAlert) {
            Button("好", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    // MARK: - Live Activity

    /// 启动蝴蝶岛。
    private func startActivity() async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            showPermissionAlert = true
            return
        }

        let content = ActivityContent(
            state: IslandButterflyAttributes.ContentState(startedAt: Date()),
            staleDate: nil)
        do {
            if let activity = currentActivity {
                await activity.update(content)
            } else {
                let activity = try Activity<IslandButterflyAttributes>.request(
                    attributes: IslandButterflyAttributes(),
                    content: content,
                    pushType: nil
                )
                currentActivity = activity
            }
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }

    /// 结束实时活动，灵动岛立即收起。
    private func stopActivity() async {
        await currentActivity?.end(nil, dismissalPolicy: .immediate)
        currentActivity = nil
    }

    /// App 重开后恢复已在运行的 Activity，避免重复启动。
    private func restoreActivity() {
        currentActivity = Activity<IslandButterflyAttributes>.activities.first
    }
}
