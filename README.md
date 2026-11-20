# 岛蝶 IslandButterfly

一个带灵动岛实时活动（Live Activity）的蝴蝶 App。

打开 App 点「启动蝴蝶岛」，灵动岛上常驻一只像素风蝴蝶，翅膀一张一收地扇动；**长按灵动岛展开**，能看到大蝴蝶和「岛蝶陪着你」。锁屏上也会同步显示蝴蝶横幅。

蝴蝶是程序画的像素画（两帧：翅膀张开 / 收起），不是任何现成 App 的素材。

## 岛上显示什么

| 位置 | 内容 |
|---|---|
| 灵动岛紧凑视图（左侧） | 蝴蝶（扇翅膀） |
| 灵动岛紧凑视图（右侧） | “岛蝶” |
| 长按展开（左端） | 大蝴蝶 |
| 长按展开（右端） | “岛蝶 / 正在陪伴” |
| 长按展开（下方） | “岛蝶陪着你” + 开始时间 |
| 锁屏横幅 | 蝴蝶 + “岛蝶 / 岛蝶陪着你” + 开始时间 |

## 工程结构

```
IslandButterfly.xcodeproj/       Xcode 工程（手写 project.pbxproj，两个 target）
IslandButterfly/                 App target（SwiftUI）
  IslandButterflyApp.swift       @main 入口
  ContentView.swift              主界面：启动/停止蝴蝶岛、蝴蝶卡片
  ButterflyView.swift            扇翅膀的蝴蝶视图（TimelineView 两帧轮播，同时属于两个 target）
  IslandButterflyAttributes.swift 共享的 ActivityAttributes（同时属于两个 target）
  IslandButterflyIntents.swift   快捷指令动作：启动蝴蝶岛 / 停止蝴蝶岛
  Info.plist                     NSSupportsLiveActivities
  Assets.xcassets/               App 图标（紫底 + 自绘像素蝴蝶）+ 蝴蝶两帧图
IslandButterflyWidget/           Widget Extension target（WidgetKit）
  IslandButterflyWidgetBundle.swift @main WidgetBundle
  IslandButterflyWidget.swift    ActivityConfiguration + DynamicIsland 展开/紧凑/最小视图
  Info.plist                     NSExtensionPointIdentifier = com.apple.widgetkit-extension
  Assets.xcassets/               蝴蝶两帧图（Widget 扩展只能读自己的资源目录）
.github/workflows/build.yml     GitHub Actions 无签名编译，打包 IPA
```

- 最低系统 iOS 18.0，Swift 5，无第三方依赖，Xcode 16+ 可编译。
- Bundle ID：`com.xin.islandbutterfly`（占位，自签时会重签成自己的）。
- 不需要特殊 entitlements（本地启动的 Live Activity 不需要推送权限）。

## 蝴蝶怎么扇翅膀

蝴蝶有两帧图（`butterfly-open` / `butterfly-closed`），`ButterflyView` 用 `TimelineView(.animation)` 每 0.5 秒切换一帧。Live Activity 里 TimelineView 是否逐帧刷新取决于系统实现；即使系统不刷新，也会稳定显示其中一帧，不会空白，只是不扇翅膀。

## 8 小时过期与快捷指令自动化

iOS 的实时活动最长存活约 8 小时，到期后系统会自动结束，岛上的蝴蝶消失——这是苹果的限制，所有 App 都一样。

「岛蝶」在快捷指令里暴露了「启动蝴蝶岛」动作，可以配自动化定时重开：

1. 打开「快捷指令」App → 底部「自动化」→ 右上角 ＋ →「特定时间」。
2. 设一个时间（例如每天 07:00），下一步选「启动蝴蝶岛」动作，关闭「运行前询问」，保存。
3. 再建两个自动化，时间分别设为 15:00 和 23:00，同样运行「启动蝴蝶岛」。
4. 这样每天 7 点、15 点、23 点各重开一次，岛上的蝴蝶基本全天不断。

注意：自动化里跑的是后台动作，不打开 App。

## 用 GitHub Actions 编译（没有 Mac 也能编）

1. 在 GitHub 新建一个仓库，把整个工程推上去。
2. 推到 `main` 分支后，仓库的 **Actions** 页会自动跑 `Build IslandButterfly`（也可以点 **Run workflow** 手动跑）。
3. 跑完后在那次运行的页面底部 **Artifacts** 里下载 `IslandButterfly-unsigned-ipa`，解压得到 `IslandButterfly.ipa`（无签名版）。

## 用 SideStore / XSign 自签安装

1. 把 `IslandButterfly.ipa` 传到 iPhone（隔空投送 / 文件 App / 网盘都行）。
2. 用 SideStore 或 XSign 选自己的 Apple ID 签名安装。
3. 首次打开 App 时，系统会问是否允许实时活动，点允许；如果之前拒绝过，去「设置 → 岛蝶」里打开「实时活动」。
4. 打开 App 点「启动蝴蝶岛」，灵动岛上就能看到蝴蝶。

免费 Apple ID 签名 7 天过期，过期后用 SideStore 续签即可。
