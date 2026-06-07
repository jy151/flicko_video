# Flicko Video 海外应用市场上架整改建议

适用范围：Apple App Store、Google Play、Samsung Galaxy Store、Amazon Appstore、Microsoft Store 及其他海外 Android 分发渠道；不包含中国大陆市场。

## 一、项目现状判断

Flicko Video 是一个 Flutter 视频/图片 AI 生成应用，当前包含游客激活、邮箱登录、Google 登录、Apple 登录、图片选择上传、AI 视频生成、发现页公开视频流、分享/下载、会员/VIP、积分充值、反馈等能力。

从代码看，项目已经具备多语言、OAuth 登录、iOS Apple Sign In entitlement、图片选择和基础反馈入口，但距离海外商店可稳定过审还有几类硬风险：

- 数字内容付费没有接入 Apple/Google 官方内购能力。
- 隐私政策、服务条款、账号删除入口尚未落地。
- AI 生成内容与公开视频流缺少明确的内容安全、举报、屏蔽、审核闭环。
- iOS 开启了全局任意网络加载，Android 申请了媒体读取权限，均需要收敛。
- Android 签名密钥明文写在仓库配置中，需立即迁移。

## 二、必须优先整改的问题

| 优先级 | 模块 | 当前项目证据 | 风险 | 整改建议 |
| --- | --- | --- | --- | --- |
| P0 | 内购/订阅/积分 | `pubspec.yaml` 只有 `google_sign_in`、`sign_in_with_apple`、`image_picker` 等依赖，未见 `in_app_purchase` 或平台 Billing SDK；`lib/page/member/controller.dart` 和 `lib/page/recharge/controller.dart` 仅模拟延迟；`lib/api/api.dart` 存在 `/config/order_create`、`/payment/subscribe` | Apple 和 Google 对 App 内数字内容、会员、积分、订阅通常要求使用官方 IAP/Play Billing。当前“VIP/充值/积分”如果上线真实收费，极易被拒 | 客户端接入 `in_app_purchase` 或 RevenueCat/Qonversion 等合规封装；iOS 使用 StoreKit 产品，Android 使用 Google Play Billing；服务端实现收据校验、订单幂等、退款/撤销同步；所有价格从商店产品返回，不要硬编码美元价 |
| P0 | 隐私政策/服务条款 | `lib/page/setting/view.dart` 中隐私政策和用户隐私点击后只是 coming soon；登录页条款点击空实现 | 海外商店要求隐私政策可访问，涉及登录、图片上传、生成内容、反馈邮箱、行为上报时尤其敏感 | 上架前提供公开 HTTPS 隐私政策和 Terms URL；App 内点击能打开；登录勾选前可查看；商店后台填写同一 URL；隐私政策覆盖账号、图片/视频、AI 输入提示词、生成结果、设备信息、日志、支付收据、反馈邮箱、数据保存与删除 |
| P0 | 账号删除 | 项目有账号登录和游客激活，`AuthBox.logout()` 只清本地 token；未见删除账号入口/API | Apple/Google 对支持创建账号的 App 通常要求用户能在 App 内发起账号删除，且说明删除数据范围 | 设置页新增“Delete Account”；二次确认；服务端提供删除或注销 API；删除 OAuth 绑定、会员资料、生成历史、上传素材、公开作品或匿名化；隐私政策说明处理时限 |
| P0 | AI 生成内容安全 | `HomeNotifier.submitCreateTask()` 直接提交 prompt/image；未见敏感内容拦截、年龄/违法内容提示、生成失败原因说明 | 生成式 AI App 需要防止违法、有害、成人、仇恨、侵权、深度伪造等内容；Google Play 对 AI 生成内容尤其关注用户举报和滥用防护 | 增加生成前规则提示和同意；服务端做 prompt/image 输入审核和输出审核；对人物肖像、未成年人、色情暴力、政治误导、商标版权素材建立拦截；失败时给用户合规提示；保留审核日志 |
| P0 | UGC/公开视频流治理 | Discover 公开展示作品；详情页 Report 只是打开通用反馈弹窗 | App Store 对 UGC 通常要求举报、屏蔽、审核、封禁机制；Google Play AI 生成内容也要求用户能举报或标记冒犯性内容 | Report 改成内容举报表单，至少包括作品 ID、举报类型、备注；服务端进入审核队列；提供隐藏/下架、封禁用户、屏蔽发布者能力；详情页增加 Block/Hide Creator；审核 SLA 建议 24 小时内处理高危内容 |
| P0 | Android 密钥安全 | `android/app/build.gradle.kts` 明文包含 `storePassword`、`keyPassword` | 密钥泄露后发布包可信链受损，也不符合基本发布安全要求 | 立即轮换 keystore；将密码迁移到环境变量、CI secret 或本地 `key.properties`；从仓库历史中清理密钥并更新发布证书策略 |
| P0 | iOS ATS | `ios/Runner/Info.plist` 中 `NSAllowsArbitraryLoads=true` | Apple 审核对全局关闭 ATS 很敏感，除非有充分说明；项目 API 本身是 HTTPS | 移除全局 `NSAllowsArbitraryLoads`；所有 API、图片、视频、政策链接使用 HTTPS/TLS 1.2+；如必须例外，只给具体域名配置 exception 并在审核备注解释 |

## 三、平台权限与隐私整改

### 1. Android 图片权限

当前 `android/app/src/main/AndroidManifest.xml` 申请：

- `READ_MEDIA_IMAGES`
- `READ_EXTERNAL_STORAGE`，maxSdkVersion 32

项目实际用途是用户主动从相册选择一张图片用于图生视频，代码在 `lib/page/tabs/home/view.dart` 使用 `ImagePicker().pickImage(source: ImageSource.gallery)`。

建议：

- Android 13+ 优先使用系统 Photo Picker，避免申请宽泛媒体读取权限。
- 如果确实保留 `READ_MEDIA_IMAGES`，需要在 Play Console 权限声明中说明仅用于用户选择图片生成视频，且不要后台扫描相册。
- 隐私政策和 Data Safety 要披露用户上传图片会发送到服务端用于 AI 生成。

### 2. iOS 相册权限

当前 `NSPhotoLibraryUsageDescription` 是英文且用途清楚，建议继续保留并补齐本地化：

- English: "Choose images for AI video generation."
- Japanese/Korean/French 等随商店地区补齐。

如后续需要保存视频到相册，还要新增 `NSPhotoLibraryAddUsageDescription`。

### 3. 数据安全申报

商店后台建议按实际情况准备以下数据分类：

- Account info：邮箱、OAuth 标识、会员 ID。
- User content：上传图片、prompt、生成视频、公开作品、头像/昵称。
- Purchase history：商店订单号、收据、订阅状态、退款状态。
- App activity：生成行为、点击行为、设备平台、版本、日志。
- Contact info：反馈邮箱。
- Diagnostics：崩溃日志、网络错误。

需要明确每类数据是否加密传输、是否可删除、是否与第三方共享、是否用于广告/分析/个性化。

## 四、支付与订阅整改细化

### 1. 产品模型建议

当前存在两类商业化：

- VIP/会员：季度、年度、Lifetime。
- Credits/diamonds：消耗型积分包。

建议拆分为：

- Auto-renewable subscription：季度、年度 VIP。
- Non-consumable IAP：Lifetime VIP。
- Consumable IAP：积分包。

不要使用服务端直接创建外部订单售卖 App 内数字权益；不要在 App 内引导用户去网页、第三方支付、客服转账等方式购买数字权益。

### 2. UI 必须补齐

订阅页需要展示：

- 产品名称、周期、价格、币种，价格来自商店。
- 自动续订说明、试用说明、续费时间、取消方式。
- Privacy Policy 和 Terms of Service 链接。
- Restore Purchases 按钮，尤其 iOS 必须有恢复购买。
- 订阅管理入口：iOS 跳 App Store 订阅管理，Android 跳 Play 订阅管理。

### 3. 服务端必须补齐

- Apple App Store Server Notifications V2。
- Google Real-time Developer Notifications。
- 收据校验和订单状态同步。
- 退款、撤销、订阅过期、宽限期、暂停、恢复处理。
- 消耗型积分防重复发放。

## 五、账号、登录与身份

当前登录方式包括邮箱、Google、Apple，并且启动时会自动游客激活：

- `AppController._ensureLoggedIn()` 在无 token 时调用 `AuthBox.login(source: 'guest')`。
- 登录页已有 Google 和 Apple 按钮。

建议：

- iOS 继续保留 Apple 登录，因为 App 提供 Google 登录时，Apple 审核通常要求提供 Sign in with Apple。
- Apple 登录按钮只在 iOS 显示；Android 可隐藏，避免用户困惑。
- 游客账号转正式账号时要能合并生成记录和积分。
- 登录错误提示全部纳入本地化，目前控制器里有大量中文硬编码。
- 提供退出登录、删除账号、恢复购买、联系客服四个基础入口。

## 六、AI 与内容安全落地方案

### 1. 生成前

- 在创作页或首次生成时展示 AI 使用规则。
- 明确禁止：未成年人性内容、色情裸露、血腥暴力、仇恨骚扰、诈骗、冒充真实人物、未经授权肖像/版权素材、政治误导和违法用途。
- 图生视频上传前提示用户确认拥有素材使用权。

### 2. 生成中

- 服务端审核 prompt 和上传图片。
- 服务端审核生成结果，未通过不返回公开视频。
- 对用户、设备、IP、支付状态设速率限制和风控。
- 对高风险模型或风格关闭公开发布默认开关。

### 3. 生成后/公开展示

- 公开视频必须可举报。
- 举报类型建议：Sexual content、Violence、Hate/harassment、Child safety、Impersonation/deepfake、Copyright/trademark、Spam/scam、Other。
- 被举报作品进入审核队列；高危多次举报先隐藏。
- 用户可以删除自己的作品；服务端已有 `deleteWork`，需要在 UI 和权限校验中落地。
- 公开作品建议标记为 AI-generated，降低误导风险。

## 七、网络、安全和发布工程

### 1. 网络安全

- 移除 iOS 全局 ATS 放开。
- 对 API 域名、图片域名、视频 CDN 统一 HTTPS。
- Dio 请求增加统一错误处理，不把服务端错误或异常堆栈原样展示给用户。
- token 建议从 Hive 明文迁移到 `flutter_secure_storage` 或平台 Keychain/Keystore。

### 2. 构建安全

- Android 签名配置移出仓库。
- 生产包关闭 debug 签名和调试能力。
- 建立 dev/staging/prod 环境隔离，避免审核包连到测试配置。
- Android 使用 Play App Signing；iOS 使用 App Store Connect 自动管理证书或 CI secret。

### 3. SDK 合规

当前依赖中重点关注：

- `google_sign_in`
- `sign_in_with_apple`
- `image_picker`
- `share_plus`
- `cached_network_image`
- `video_player`
- `dio`

建议：

- Apple 上架前检查第三方 SDK 隐私清单和签名要求。
- Google Play SDK Index 检查依赖版本是否有 policy issue。
- 如果后续接入 Adjust、Firebase、广告或归因 SDK，需同步更新 ATT、隐私政策和 Data Safety。

## 八、商店素材与后台配置

### Apple App Store

- App Privacy：按实际采集填写 Nutrition Label。
- Privacy Policy URL、Support URL、Marketing URL。
- Review Notes：提供测试账号、测试订阅产品说明、AI 生成审核说明。
- Age Rating：AI 生成/公开视频建议谨慎选择，若无法严格过滤成人/暴力内容，年龄分级需上调。
- IAP 产品：订阅、Lifetime、积分包分别创建，截图和本地化齐全。
- App Tracking Transparency：如接入广告归因或跨 App 追踪再申请；当前代码未见 ATT SDK，不建议无理由弹窗。

### Google Play

- Data Safety：按账号、图片、视频、prompt、购买、反馈、日志等如实申报。
- App Content：AI-generated content、Target audience、Ads、Privacy Policy。
- Payments：所有数字商品走 Play Billing。
- Account deletion：Play Console 填写网页删除链接，同时 App 内提供入口。
- Permissions declaration：如果保留媒体读取权限，需要提交用途说明；建议改系统 Photo Picker 降低申报风险。
- Closed testing：正式发布前按 Google Play 当期账号要求完成封闭测试和质量门槛。

### Samsung/Amazon/Microsoft 等

- 绝大多数渠道也要求隐私政策、内容分级、数字商品支付合规、举报处理、版权合规。
- 如果渠道要求使用自家 IAP，需做渠道包支付抽象；不要把 Google Play Billing 包直接提交到不支持的渠道。
- Android 海外非 Google 渠道建议独立 flavor：`googlePlay`、`samsung`、`amazon`、`generic`。

## 九、建议整改排期

### 第一阶段：过审底线，1-2 周

- 上线隐私政策、服务条款、支持页。
- 设置页接入政策链接、账号删除、恢复购买入口。
- 移除 iOS `NSAllowsArbitraryLoads`。
- Android 改 Photo Picker 或准备权限声明。
- 移除签名密钥明文并轮换 keystore。
- 支付页暂时隐藏或改为“coming soon”，直到官方 IAP 完成。
- 登录错误提示本地化。

### 第二阶段：商业化合规，2-4 周

- 接入 StoreKit/Google Play Billing。
- 建立服务端收据校验、通知、订单状态机。
- 订阅 UI 补齐自动续订、恢复购买、取消说明。
- 商店后台创建产品和沙盒测试。

### 第三阶段：AI/UGC 安全，2-4 周

- 输入/输出审核服务。
- 举报类型、审核后台、屏蔽/隐藏/封禁。
- 用户作品删除、公开开关、AI-generated 标识。
- 风控限频和违规记录。

### 第四阶段：全球化优化，持续

- 商店文案和截图本地化。
- 法务按 GDPR/UK GDPR/CCPA、韩国 PIPA、日本 APPI、欧盟 DSA 等地区要求审阅。
- 客服和举报处理 SLA。
- 监控崩溃率、ANR、启动耗时、支付失败率。

## 十、上架前检查清单

- [ ] App 内隐私政策、服务条款可打开，URL 是 HTTPS。
- [ ] 账号删除可在 App 内发起，服务端能删除/匿名化数据。
- [ ] 所有数字商品走 Apple IAP / Google Play Billing。
- [ ] 订阅页展示周期、价格、自动续订、取消、恢复购买。
- [ ] AI 生成前有规则提示，服务端有输入/输出审核。
- [ ] 公开作品可举报、可屏蔽、可下架，后台有处理流程。
- [ ] 用户可删除自己的生成作品。
- [ ] iOS 移除全局 ATS 放开。
- [ ] Android 图片选择尽量使用 Photo Picker，避免宽泛媒体权限。
- [ ] Android keystore 密码不在仓库，旧密钥已轮换。
- [ ] OAuth 配置、包名、Bundle ID、SHA-1/SHA-256 与商店包一致。
- [ ] App Store / Play Console 隐私、数据安全、AI、内容分级、权限声明填写一致。
- [ ] 提供审核测试账号、测试订阅说明和后端白名单。
- [ ] Release 包完成崩溃、支付、登录、生成、举报、删除账号回归测试。

## 十一、参考政策入口

- Apple App Store Review Guidelines: https://developer.apple.com/app-store/review/guidelines/
- Apple App Privacy Details: https://developer.apple.com/help/app-store-connect/reference/app-privacy-details
- Apple Third-party SDK Requirements: https://developer.apple.com/support/third-party-SDK-requirements/
- Google Play Developer Program Policies: https://support.google.com/googleplay/android-developer/topic/9858052
- Google Play Payments Policy: https://support.google.com/googleplay/android-developer/answer/9858738
- Google Play AI-generated Content Policy: https://support.google.com/googleplay/android-developer/answer/13985936
- Google Play User Data / Data Safety: https://support.google.com/googleplay/android-developer/answer/10144311
- Google Play Photo and Video Permissions: https://support.google.com/googleplay/android-developer/answer/14115180
