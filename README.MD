# 纪念日 App

Flutter + Riverpod + Hive 的纪念日应用，用于记录重要日子并提供提醒。

## 主要特性
- Material 3 风格首页，卡片式列表展示。
- 添加/编辑纪念日（含日期选择、类型、提醒设置）。
- 日期计算服务（剩余/已过天数、生日闰年处理）。
- `flutter_local_notifications` 本地推送，自动在纪念日当天 09:00 提醒。
- Hive 本地数据库存储纪念日数据；`SharedPreferences` 记忆提醒默认值。

## 运行
1. 安装 Flutter 3.24+，并在项目根目录执行：
   ```bash
   flutter pub get
   ```
2. 生成 Hive 适配器（可选，如需重新生成）：
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
3. 运行：
   ```bash
   flutter run
   ```

如需调整通知，请在 `lib/services/notification_service.dart` 中修改通道配置。

# theday
