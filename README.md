# 简洁备忘录（HarmonyOS / ArkTS）

这是一个基于 DevEco Studio 的 HarmonyOS Stage 模型备忘录项目，使用 ArkTS 实现。

## 课程知识点覆盖

- `UIAbility`：`EntryAbility` 作为应用入口，加载 `pages/Index`。
- `CustomDialog`：通过自定义弹窗完成新增、编辑备忘录。
- `Toggle`：用于显示/隐藏已完成事项，以及切换备忘录完成状态。
- 自定义组件/构建函数：`MemoCard`、`StatCard`、`SectionHeader`、`EmptyState` 等组件与 `@Builder` 构建函数。

## 功能

- 新增备忘录
- 编辑备忘录
- 删除备忘录
- 标记完成/未完成
- 显示/隐藏已完成备忘录
- 顶部统计全部、待办、已完成数量

## 使用方式

1. 使用 DevEco Studio 打开本仓库根目录。
2. 等待工程同步完成。
3. 选择 `entry` 模块运行到模拟器或真机。

主要页面代码位于：

- `entry/src/main/ets/pages/Index.ets`
- `entry/src/main/ets/entryability/EntryAbility.ets`
