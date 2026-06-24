import 'package:flutter/widgets.dart';

import 'app_locale.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final localization = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    assert(localization != null, 'AppLocalizations not found in context');
    return localization!;
  }

  static final supportedLocales = AppLocale.supported
      .map((item) => item.locale)
      .toList(growable: false);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'FlickoVideo',
      'enterApp': 'Enter App',
      'settings': 'Settings',
      'language': 'Language',
      'chooseLanguage': 'Choose Language',
      'userPrivacy': 'User Privacy',
      'privacyPolicy': 'Privacy Policy',
      'aboutApp': 'About App',
      'version': 'Version',
      'logOut': 'Log Out',
      'cancel': 'Cancel',
      'retry': 'Retry',
      'comingSoon': '{title} is coming soon',
      'logoutConfirmTitle': 'Log Out',
      'logoutConfirmContent': 'Are you sure you want to log out?',
      'logoutSuccess': 'Logged out successfully',
      'deleteAccount': 'Delete Account',
      'confirmDeleteAccount': 'Confirm Deletion',
      'deleteAccountReadAgreementHint':
          'Please read the account deletion agreement before confirming.',
      'deleteAccountAgreementLoadFailed':
          'Failed to load the account deletion agreement.',
      'deleteAccountConfirmTitle': 'Delete account?',
      'deleteAccountConfirmContent':
          'After deletion, your account data may not be recoverable. Are you sure you want to continue?',
      'deleteAccountSuccess':
          'Account deleted. You have been signed in as a guest.',
      'deleteAccountFailed': 'Failed to delete account',
      'me': 'Me',
      'copy': 'Copy',
      'pullUpToLoadMore': 'Pull up to load more',
      'loadFailed': 'Load failed',
      'releaseToLoadMore': 'Release to load more',
      'creation': 'Creation',
      'effects': 'Effects',
      'discover': 'Discover',
      'create': 'Create',
      'explore': 'Explore',
      'describeYourVideo': 'What video do you want to create?',
      'imageToVideo': 'Image to Video',
      'textToVideo': 'Text to Video',
      'aiModel': 'AI Model',
      'duration': 'Duration',
      'styleGuide': 'Style (Choose one for best results 🔥)',
      'auto': 'Auto',
      'all': 'All',
      'vip': 'VIP',
      'pro': 'PRO',
      'works': 'Works',
      'noWorks': 'No works yet',
      'startCreating': 'Start Creating',
      'upgradeNow': 'Upgrade Now',
      'expirationDate': 'Expiration date',
      'addImage': 'Add Image',
      'newBadge': 'NEW',
      'hotBadge': 'HOT',
      'idLabel': 'ID',
      'promptBackground': 'Prompt background',
      'generationCount': 'Generation Count',
      'durationUnitSec': 'sec',
      'tryForFree': 'Try for Free',
      'emailAddress': 'Email address',
      'password': 'Password',
      'signIn': 'Sign In',
      'signInWithGoogle': 'Sign in with Google',
      'signInWithApple': 'Sign in with Apple',
      'agreeToThe': 'I agree to the',
      'userAgreement': 'User Agreement',
      'and': 'and',
      'termsOfService': 'Terms of Service',
      'pleaseAgreeToTerms': 'Please agree to the terms first',
      'termsConsentContent':
          'Please agree to the Privacy Policy and Terms of Service before signing in.',
      'readAndAgreeToTerms':
          'Please carefully read and agree to the Privacy Policy and Terms of Service above first.',
      'agree': 'Agree',
      'disagree': 'Disagree',
      'uploadImage': 'Upload Image',
      'selectVideoEffects': 'Select Video Effects',
      'submit': 'Submit',
      'selectTemplateFirst': 'Please select a template',
      'selectImageFirst': 'Please select an image',
      'enterPromptFirst': 'Please enter a prompt',
      'selectDurationFirst': 'Please select a duration',
      'createTaskSubmitted': 'Generation task submitted',
      'createTaskFailed': 'Failed to submit generation task',
      'templateCreateSubmitted': 'Template generation task submitted',
      'templateCreateFailed': 'Failed to submit template generation task',
      'monthlyPlan': 'Monthly Plan',
      'quarterlyPlan': 'Quarterly Plan',
      'annualPlan': 'Annual Plan',
      'lifetimePlan': 'Annual Plan',
      'oneTimePayment': 'Subscription {price}',
      'unlockAllPremiumFeatures': 'Unlock All Premium Features',
      'instantBonus': 'Instant Bonus',
      'refreshWeekly': 'Refresh Weekly',
      'unlockAllTemplates': 'Unlock Full Access to All Templates',
      'skipQueueNoWatermark':
          'Skip the Queue & Get Videos Faster, No Watermark',
      'standardMediaBenefits': '5,382+ Standard Images/ 1,346+ Standard Videos',
      'untilPriceGoesUp': '{time} until price goes up',
      'unlockVipService': 'Unlock VIP Service',
      'myCredits': 'My Credits',
      'recharge': 'Recharge',
      'moreCreditFeatures': 'More credit features are coming soon, stay tuned.',
      'creditPurchaseSummary': '{credits} credits • {price}',
      'creditPurchaseDisclosure':
          'Credits are a one-time consumable purchase and can be used to generate videos in FlickoVideo.',
      'orderResultTitle': 'Order Result',
      'paymentChecking': 'Checking Payment',
      'paymentSuccess': 'Payment Successful',
      'paymentFailed': 'Payment Failed',
      'paymentCheckingDesc':
          'We are confirming your order. This usually takes a few seconds.',
      'paymentSuccessDesc':
          'Your purchase has been confirmed. You can start creating now.',
      'paymentFailedDesc':
          'We could not confirm this payment. Please try again later.',
      'orderId': 'Order ID',
      'backHome': 'Back Home',
      'termsOfUseEula': 'Terms of Use (EULA)',
      'viewDetails': 'View Details',
      'prompt': 'Prompt',
      'creationTime': 'Creation Time',
      'createSimilar': 'Create Similar',
      'share': 'Share',
      'report': 'Report',
      'blockUser': 'Block User',
      'blockUserSuccess': 'User blocked',
      'blockUserFailed': 'Failed to block user',
      'delete': 'Delete',
      'deleteVideoTitle': 'Delete video?',
      'deleteVideoContent': 'This work will be removed from your creations.',
      'deleteComplete': 'Deleted',
      'deleteFailed': 'Delete failed',
      'download': 'Download',
      'downloadWithWatermark': 'Download with Watermark',
      'downloadWithoutWatermark': 'Download without Watermark',
      'downloadingVideo': 'Downloading video',
      'downloadComplete': 'Download complete',
      'downloadFailed': 'Download failed',
      'videoUnavailable': 'Video unavailable',
      'noPrompt': 'No prompt',
      'shareVideoText': 'Created with FlickoVideo',
      'feedback': 'Feedback',
      'feedbackSubtitle': "We'd love to hear your thoughts!",
      'feedbackEmailHint': 'Your email address (optional)',
      'feedbackContentHint':
          "You can write any suggestions here, for example: I'm handsome, I'd like to apply for a discount. But remember to leave your contact information.",
      'reportTypeHint': 'Select report type (optional)',
      'reportTypeMembershipBilling': 'Membership & Billing',
      'reportTypeSensitivePornographic': 'Sensitive or Pornographic',
      'reportTypeSuicideSelfHarm': 'Suicide or Self-harm',
      'reportTypeHateViolence': 'Hate or Violence',
      'reportTypeHarassmentBullying': 'Harassment or Bullying',
      'reportTypeFraudScam': 'Fraud or Scam',
      'reportTypeHarmfulMinors': 'Harmful to Minors',
      'reportTypePrivacyInvasion': 'Privacy Invasion',
      'reportTypeOther': 'Other',
      'enterFeedbackFirst': 'Please enter your feedback',
      'enterValidEmail': 'Please enter a valid email address',
      'feedbackSubmitted': 'Feedback submitted',
      'feedbackSubmitFailed': 'Failed to submit feedback',
    },
    'zh-Hans': {
      'appTitle': 'FlickoVideo',
      'enterApp': '进入 App',
      'settings': '设置',
      'language': '语言',
      'chooseLanguage': '选择语言',
      'userPrivacy': '用户隐私',
      'privacyPolicy': '隐私政策',
      'aboutApp': '关于 App',
      'version': '版本号',
      'logOut': '退出登录',
      'cancel': '取消',
      'retry': '重试',
      'comingSoon': '{title} 敬请期待',
      'logoutConfirmTitle': '退出登录',
      'logoutConfirmContent': '确定要退出登录吗？',
      'logoutSuccess': '已成功退出登录',
      'deleteAccount': '注销账号',
      'confirmDeleteAccount': '确认注销',
      'deleteAccountReadAgreementHint': '请先阅读账号注销协议，再确认注销账号。',
      'deleteAccountAgreementLoadFailed': '账号注销协议加载失败',
      'deleteAccountConfirmTitle': '确认注销账号？',
      'deleteAccountConfirmContent': '注销后，账号相关数据可能无法恢复。确定要继续吗？',
      'deleteAccountSuccess': '账号已注销，已为你重新登录游客账号',
      'deleteAccountFailed': '注销账号失败',
      'me': '我的',
      'copy': '复制',
      'pullUpToLoadMore': '上拉加载更多',
      'loadFailed': '加载失败',
      'releaseToLoadMore': '松开加载更多',
      'creation': '创作',
      'effects': '特效',
      'discover': '发现',
      'create': '创建',
      'explore': '探索',
      'describeYourVideo': '你想创建什么视频？',
      'imageToVideo': '图片转视频',
      'textToVideo': '文本转视频',
      'aiModel': 'AI 模型',
      'duration': '时长',
      'styleGuide': '风格（选择一种效果更佳 🔥）',
      'auto': '自动',
      'all': '全部',
      'vip': '会员',
      'pro': '专业版',
      'works': '作品',
      'noWorks': '暂无作品',
      'startCreating': '去创作',
      'upgradeNow': '立即升级',
      'expirationDate': '到期时间',
      'addImage': '添加图片',
      'newBadge': '新',
      'hotBadge': '热门',
      'idLabel': 'ID',
      'promptBackground': '提示背景',
      'generationCount': '生成数量',
      'durationUnitSec': '秒',
      'tryForFree': '免费试用',
      'emailAddress': '邮箱地址',
      'password': '密码',
      'signIn': '登录',
      'signInWithGoogle': '使用 Google 登录',
      'signInWithApple': '使用 Apple 登录',
      'agreeToThe': '我同意',
      'userAgreement': '用户协议',
      'and': '和',
      'termsOfService': '服务条款',
      'pleaseAgreeToTerms': '请先同意条款',
      'termsConsentContent': '继续登录前，请先同意隐私政策和服务条款。',
      'readAndAgreeToTerms': '请先仔细阅读并同意以上隐私政策和服务条款。',
      'agree': '同意',
      'disagree': '不同意',
      'uploadImage': '上传图片',
      'selectVideoEffects': '选择视频特效',
      'submit': '提交',
      'selectTemplateFirst': '请选择模板',
      'selectImageFirst': '请选择图片',
      'enterPromptFirst': '请输入提示词',
      'selectDurationFirst': '请选择时长',
      'createTaskSubmitted': '生成任务已提交',
      'createTaskFailed': '生成任务提交失败',
      'templateCreateSubmitted': '模板生成任务已提交',
      'templateCreateFailed': '模板生成任务提交失败',
      'monthlyPlan': '月度会员',
      'quarterlyPlan': '季度会员',
      'annualPlan': '年度会员',
      'lifetimePlan': '年度会员',
      'oneTimePayment': '订阅价格 {price}',
      'unlockAllPremiumFeatures': '解锁全部高级功能',
      'instantBonus': '即时奖励',
      'refreshWeekly': '每周刷新',
      'unlockAllTemplates': '解锁全部模板访问权限',
      'skipQueueNoWatermark': '跳过排队，更快生成视频，无水印',
      'standardMediaBenefits': '5,382+ 标准图片 / 1,346+ 标准视频',
      'untilPriceGoesUp': '{time} 后价格上涨',
      'unlockVipService': '解锁 VIP 服务',
      'myCredits': '我的积分',
      'recharge': '充值',
      'moreCreditFeatures': '更多积分功能即将上线，敬请期待。',
      'creditPurchaseSummary': '{credits} 积分 • {price}',
      'creditPurchaseDisclosure': '积分为一次性消耗型购买，可用于在 FlickoVideo 中生成视频。',
      'orderResultTitle': '订单结果',
      'paymentChecking': '正在确认支付',
      'paymentSuccess': '支付成功',
      'paymentFailed': '支付失败',
      'paymentCheckingDesc': '正在确认你的订单，通常只需要几秒钟。',
      'paymentSuccessDesc': '你的购买已确认，现在可以开始创作。',
      'paymentFailedDesc': '暂未确认支付成功，请稍后重试。',
      'orderId': '订单号',
      'backHome': '返回首页',
      'termsOfUseEula': '使用条款 (EULA)',
      'viewDetails': '查看详情',
      'prompt': '提示词',
      'creationTime': '创建时间',
      'createSimilar': '创作同款',
      'share': '分享',
      'report': '举报',
      'blockUser': '屏蔽用户',
      'blockUserSuccess': '屏蔽成功',
      'blockUserFailed': '屏蔽失败',
      'delete': '删除',
      'deleteVideoTitle': '删除视频？',
      'deleteVideoContent': '该作品将从你的创作列表中移除。',
      'deleteComplete': '已删除',
      'deleteFailed': '删除失败',
      'download': '下载',
      'downloadWithWatermark': '下载带水印视频',
      'downloadWithoutWatermark': '下载无水印视频',
      'downloadingVideo': '视频下载中',
      'downloadComplete': '下载完成',
      'downloadFailed': '下载失败',
      'videoUnavailable': '视频不可用',
      'noPrompt': '暂无提示词',
      'shareVideoText': '来自 FlickoVideo 的创作',
      'feedback': '反馈',
      'feedbackSubtitle': '我们很想听听你的想法！',
      'feedbackEmailHint': '你的邮箱地址（选填）',
      'feedbackContentHint': '你可以在这里填写任何建议，例如：我很帅，我想申请一个折扣。记得留下你的联系方式。',
      'reportTypeHint': '选择举报类型（选填）',
      'reportTypeMembershipBilling': '会员与账单',
      'reportTypeSensitivePornographic': '敏感或色情内容',
      'reportTypeSuicideSelfHarm': '自杀或自残',
      'reportTypeHateViolence': '仇恨或暴力',
      'reportTypeHarassmentBullying': '骚扰或霸凌',
      'reportTypeFraudScam': '欺诈或诈骗',
      'reportTypeHarmfulMinors': '危害未成年人',
      'reportTypePrivacyInvasion': '侵犯隐私',
      'reportTypeOther': '其他',
      'enterFeedbackFirst': '请输入反馈内容',
      'enterValidEmail': '请输入正确的邮箱地址',
      'feedbackSubmitted': '反馈已提交',
      'feedbackSubmitFailed': '反馈提交失败',
    },
    'zh-Hant': {
      'appTitle': 'FlickoVideo',
      'enterApp': '進入 App',
      'settings': '設定',
      'language': '語言',
      'chooseLanguage': '選擇語言',
      'userPrivacy': '用戶隱私',
      'privacyPolicy': '隱私政策',
      'aboutApp': '關於 App',
      'version': '版本號',
      'logOut': '登出',
      'cancel': '取消',
      'retry': '重試',
      'comingSoon': '{title} 即將推出',
      'logoutConfirmTitle': '登出',
      'logoutConfirmContent': '確定要登出嗎？',
      'logoutSuccess': '已成功登出',
      'deleteAccount': '註銷帳號',
      'confirmDeleteAccount': '確認註銷',
      'deleteAccountReadAgreementHint': '請先閱讀帳號註銷協議，再確認註銷帳號。',
      'deleteAccountAgreementLoadFailed': '帳號註銷協議載入失敗',
      'deleteAccountConfirmTitle': '確認註銷帳號？',
      'deleteAccountConfirmContent': '註銷後，帳號相關資料可能無法恢復。確定要繼續嗎？',
      'deleteAccountSuccess': '帳號已註銷，已為你重新登入遊客帳號',
      'deleteAccountFailed': '註銷帳號失敗',
      'me': '我的',
      'copy': '複製',
      'pullUpToLoadMore': '上拉載入更多',
      'loadFailed': '載入失敗',
      'releaseToLoadMore': '鬆開載入更多',
      'creation': '創作',
      'effects': '特效',
      'discover': '發現',
      'create': '建立',
      'explore': '探索',
      'describeYourVideo': '你想建立什麼影片？',
      'imageToVideo': '圖片轉影片',
      'textToVideo': '文字轉影片',
      'aiModel': 'AI 模型',
      'duration': '時長',
      'styleGuide': '風格（選擇一種效果更佳 🔥）',
      'auto': '自動',
      'all': '全部',
      'vip': '會員',
      'pro': '專業版',
      'works': '作品',
      'noWorks': '暫無作品',
      'startCreating': '去創作',
      'upgradeNow': '立即升級',
      'expirationDate': '到期時間',
      'addImage': '新增圖片',
      'newBadge': '新',
      'hotBadge': '熱門',
      'idLabel': 'ID',
      'promptBackground': '提示背景',
      'generationCount': '生成數量',
      'durationUnitSec': '秒',
      'tryForFree': '免費試用',
      'emailAddress': '電子郵件地址',
      'password': '密碼',
      'signIn': '登入',
      'signInWithGoogle': '使用 Google 登入',
      'signInWithApple': '使用 Apple 登入',
      'agreeToThe': '我同意',
      'userAgreement': '用戶協議',
      'and': '和',
      'termsOfService': '服務條款',
      'pleaseAgreeToTerms': '請先同意條款',
      'termsConsentContent': '繼續登入前，請先同意隱私政策和服務條款。',
      'readAndAgreeToTerms': '請先仔細閱讀並同意以上隱私政策和服務條款。',
      'agree': '同意',
      'disagree': '不同意',
      'uploadImage': '上傳圖片',
      'selectVideoEffects': '選擇影片特效',
      'submit': '提交',
      'selectTemplateFirst': '請選擇模板',
      'selectImageFirst': '請選擇圖片',
      'enterPromptFirst': '請輸入提示詞',
      'selectDurationFirst': '請選擇時長',
      'createTaskSubmitted': '生成任務已提交',
      'createTaskFailed': '生成任務提交失敗',
      'templateCreateSubmitted': '模板生成任務已提交',
      'templateCreateFailed': '模板生成任務提交失敗',
      'monthlyPlan': '月度會員',
      'quarterlyPlan': '季度會員',
      'annualPlan': '年度會員',
      'lifetimePlan': '年度會員',
      'oneTimePayment': '訂閱價格 {price}',
      'unlockAllPremiumFeatures': '解鎖全部高級功能',
      'instantBonus': '即時獎勵',
      'refreshWeekly': '每週刷新',
      'unlockAllTemplates': '解鎖全部模板存取權限',
      'skipQueueNoWatermark': '跳過排隊，更快生成影片，無浮水印',
      'standardMediaBenefits': '5,382+ 標準圖片 / 1,346+ 標準影片',
      'untilPriceGoesUp': '{time} 後價格上漲',
      'unlockVipService': '解鎖 VIP 服務',
      'myCredits': '我的積分',
      'recharge': '充值',
      'moreCreditFeatures': '更多積分功能即將上線，敬請期待。',
      'creditPurchaseSummary': '{credits} 積分 • {price}',
      'creditPurchaseDisclosure': '積分為一次性消耗型購買，可用於在 FlickoVideo 中生成影片。',
      'orderResultTitle': '訂單結果',
      'paymentChecking': '正在確認支付',
      'paymentSuccess': '支付成功',
      'paymentFailed': '支付失敗',
      'paymentCheckingDesc': '正在確認你的訂單，通常只需要幾秒鐘。',
      'paymentSuccessDesc': '你的購買已確認，現在可以開始創作。',
      'paymentFailedDesc': '暫未確認支付成功，請稍後重試。',
      'orderId': '訂單號',
      'backHome': '返回首頁',
      'termsOfUseEula': '使用條款 (EULA)',
      'viewDetails': '查看詳情',
      'prompt': '提示詞',
      'creationTime': '建立時間',
      'createSimilar': '創作同款',
      'share': '分享',
      'report': '檢舉',
      'blockUser': '封鎖用戶',
      'blockUserSuccess': '已封鎖',
      'blockUserFailed': '封鎖失敗',
      'delete': '刪除',
      'deleteVideoTitle': '刪除影片？',
      'deleteVideoContent': '該作品將從你的創作列表中移除。',
      'deleteComplete': '已刪除',
      'deleteFailed': '刪除失敗',
      'download': '下載',
      'downloadWithWatermark': '下載帶浮水印影片',
      'downloadWithoutWatermark': '下載無浮水印影片',
      'downloadingVideo': '影片下載中',
      'downloadComplete': '下載完成',
      'downloadFailed': '下載失敗',
      'videoUnavailable': '影片不可用',
      'noPrompt': '暫無提示詞',
      'shareVideoText': '來自 FlickoVideo 的創作',
      'feedback': '意見回饋',
      'feedbackSubtitle': '我們很想聽聽你的想法！',
      'feedbackEmailHint': '你的電子郵件地址（選填）',
      'feedbackContentHint': '你可以在這裡填寫任何建議，例如：我很帥，我想申請一個折扣。記得留下你的聯絡方式。',
      'reportTypeHint': '選擇檢舉類型（選填）',
      'reportTypeMembershipBilling': '會員與帳單',
      'reportTypeSensitivePornographic': '敏感或色情內容',
      'reportTypeSuicideSelfHarm': '自殺或自殘',
      'reportTypeHateViolence': '仇恨或暴力',
      'reportTypeHarassmentBullying': '騷擾或霸凌',
      'reportTypeFraudScam': '詐欺或詐騙',
      'reportTypeHarmfulMinors': '危害未成年人',
      'reportTypePrivacyInvasion': '侵犯隱私',
      'reportTypeOther': '其他',
      'enterFeedbackFirst': '請輸入回饋內容',
      'enterValidEmail': '請輸入正確的電子郵件地址',
      'feedbackSubmitted': '回饋已提交',
      'feedbackSubmitFailed': '回饋提交失敗',
    },
    'ja': {
      'appTitle': 'FlickoVideo',
      'enterApp': 'アプリを開く',
      'settings': '設定',
      'language': '言語',
      'chooseLanguage': '言語を選択',
      'userPrivacy': 'ユーザープライバシー',
      'privacyPolicy': 'プライバシーポリシー',
      'aboutApp': 'アプリについて',
      'version': 'バージョン',
      'logOut': 'ログアウト',
      'cancel': 'キャンセル',
      'retry': '再試行',
      'comingSoon': '{title} は近日公開予定です',
      'logoutConfirmTitle': 'ログアウト',
      'logoutConfirmContent': 'ログアウトしてもよろしいですか？',
      'logoutSuccess': 'ログアウトしました',
      'deleteAccount': 'アカウントを削除',
      'confirmDeleteAccount': '削除を確認',
      'deleteAccountReadAgreementHint': 'アカウント削除規約を読んでから確認してください。',
      'deleteAccountAgreementLoadFailed': 'アカウント削除規約を読み込めませんでした。',
      'deleteAccountConfirmTitle': 'アカウントを削除しますか？',
      'deleteAccountConfirmContent': '削除後、アカウント関連データは復元できない場合があります。続行しますか？',
      'deleteAccountSuccess': 'アカウントを削除しました。ゲストとしてサインインしました。',
      'deleteAccountFailed': 'アカウントの削除に失敗しました',
      'me': 'マイ',
      'copy': 'コピー',
      'pullUpToLoadMore': '上にスワイプしてさらに読み込む',
      'loadFailed': '読み込みに失敗しました',
      'releaseToLoadMore': '離してさらに読み込む',
      'creation': '作成',
      'effects': 'エフェクト',
      'discover': '発見',
      'create': '作成',
      'explore': '探索',
      'describeYourVideo': 'どんな動画を作成したいですか？',
      'imageToVideo': '画像から動画',
      'textToVideo': 'テキストから動画',
      'aiModel': 'AI モデル',
      'duration': '長さ',
      'styleGuide': 'スタイル（最適な結果のために1つ選択 🔥）',
      'auto': '自動',
      'all': 'すべて',
      'vip': 'VIP',
      'pro': 'PRO',
      'works': '作品',
      'noWorks': '作品はまだありません',
      'startCreating': '作成する',
      'upgradeNow': '今すぐアップグレード',
      'expirationDate': '有効期限',
      'addImage': '画像を追加',
      'newBadge': '新着',
      'hotBadge': '人気',
      'idLabel': 'ID',
      'promptBackground': '背景プロンプト',
      'generationCount': '生成数',
      'durationUnitSec': '秒',
      'tryForFree': '無料でお試し',
      'emailAddress': 'メールアドレス',
      'password': 'パスワード',
      'signIn': 'サインイン',
      'signInWithGoogle': 'Google でサインイン',
      'signInWithApple': 'Apple でサインイン',
      'agreeToThe': '同意します：',
      'userAgreement': '利用規約',
      'and': 'と',
      'termsOfService': 'サービス利用規約',
      'pleaseAgreeToTerms': '利用規約に同意してください',
      'termsConsentContent': 'サインインする前にプライバシーポリシーとサービス利用規約に同意してください。',
      'readAndAgreeToTerms': '上記のプライバシーポリシーとサービス利用規約をよく読み、同意してください。',
      'agree': '同意する',
      'disagree': '同意しない',
      'uploadImage': '画像をアップロード',
      'selectVideoEffects': 'ビデオエフェクトを選択',
      'submit': '送信',
      'selectTemplateFirst': 'テンプレートを選択してください',
      'selectImageFirst': '画像を選択してください',
      'enterPromptFirst': 'プロンプトを入力してください',
      'selectDurationFirst': '長さを選択してください',
      'createTaskSubmitted': '生成タスクを送信しました',
      'createTaskFailed': '生成タスクの送信に失敗しました',
      'templateCreateSubmitted': 'テンプレート生成タスクを送信しました',
      'templateCreateFailed': 'テンプレート生成タスクの送信に失敗しました',
      'monthlyPlan': '月額プラン',
      'quarterlyPlan': '四半期プラン',
      'annualPlan': '年間プラン',
      'lifetimePlan': '年間プラン',
      'oneTimePayment': 'サブスクリプション {price}',
      'unlockAllPremiumFeatures': 'すべてのプレミアム機能を解放',
      'instantBonus': '即時ボーナス',
      'refreshWeekly': '毎週更新',
      'unlockAllTemplates': 'すべてのテンプレートを利用可能',
      'skipQueueNoWatermark': '待ち時間を短縮し、高速生成、透かしなし',
      'standardMediaBenefits': '5,382+ 標準画像 / 1,346+ 標準動画',
      'untilPriceGoesUp': '{time} 後に値上げ',
      'unlockVipService': 'VIP サービスを解放',
      'myCredits': 'マイクレジット',
      'recharge': 'チャージ',
      'moreCreditFeatures': 'クレジット機能は近日公開予定です。',
      'creditPurchaseSummary': '{credits} クレジット • {price}',
      'creditPurchaseDisclosure': 'クレジットは一回限りの消耗型購入で、FlickoVideo で動画生成に使用できます。',
      'orderResultTitle': '注文結果',
      'paymentChecking': 'お支払いを確認中',
      'paymentSuccess': 'お支払いが完了しました',
      'paymentFailed': 'お支払いに失敗しました',
      'paymentCheckingDesc': '注文を確認しています。通常は数秒で完了します。',
      'paymentSuccessDesc': '購入が確認されました。今すぐ作成を始められます。',
      'paymentFailedDesc': 'お支払いを確認できませんでした。後でもう一度お試しください。',
      'orderId': '注文ID',
      'backHome': 'ホームへ戻る',
      'termsOfUseEula': '利用規約 (EULA)',
      'viewDetails': '詳細を見る',
      'prompt': 'プロンプト',
      'creationTime': '作成日時',
      'createSimilar': '似た動画を作成',
      'share': '共有',
      'report': '報告',
      'blockUser': 'ユーザーをブロック',
      'blockUserSuccess': 'ユーザーをブロックしました',
      'blockUserFailed': 'ユーザーをブロックできませんでした',
      'delete': '削除',
      'deleteVideoTitle': '動画を削除しますか？',
      'deleteVideoContent': 'この作品は作成リストから削除されます。',
      'deleteComplete': '削除しました',
      'deleteFailed': '削除に失敗しました',
      'download': 'ダウンロード',
      'downloadWithWatermark': '透かし付きでダウンロード',
      'downloadWithoutWatermark': '透かしなしでダウンロード',
      'downloadingVideo': '動画をダウンロード中',
      'downloadComplete': 'ダウンロード完了',
      'downloadFailed': 'ダウンロードに失敗しました',
      'videoUnavailable': '動画を利用できません',
      'noPrompt': 'プロンプトはありません',
      'shareVideoText': 'FlickoVideo で作成',
      'feedback': 'フィードバック',
      'feedbackSubtitle': 'ぜひご意見をお聞かせください！',
      'feedbackEmailHint': 'メールアドレス（任意）',
      'feedbackContentHint': 'ご意見やご要望を自由にお書きください。例：割引を申請したいです。連絡先も忘れずにご記入ください。',
      'reportTypeHint': '報告タイプを選択（任意）',
      'reportTypeMembershipBilling': '会員・請求',
      'reportTypeSensitivePornographic': 'センシティブまたはポルノ',
      'reportTypeSuicideSelfHarm': '自殺または自傷',
      'reportTypeHateViolence': 'ヘイトまたは暴力',
      'reportTypeHarassmentBullying': '嫌がらせまたはいじめ',
      'reportTypeFraudScam': '不正または詐欺',
      'reportTypeHarmfulMinors': '未成年者への有害行為',
      'reportTypePrivacyInvasion': 'プライバシー侵害',
      'reportTypeOther': 'その他',
      'enterFeedbackFirst': 'フィードバックを入力してください',
      'enterValidEmail': '有効なメールアドレスを入力してください',
      'feedbackSubmitted': 'フィードバックを送信しました',
      'feedbackSubmitFailed': 'フィードバックの送信に失敗しました',
    },
    'ko': {
      'appTitle': 'FlickoVideo',
      'enterApp': '앱 시작하기',
      'settings': '설정',
      'language': '언어',
      'chooseLanguage': '언어 선택',
      'userPrivacy': '사용자 개인정보',
      'privacyPolicy': '개인정보 처리방침',
      'aboutApp': '앱 정보',
      'version': '버전',
      'logOut': '로그아웃',
      'cancel': '취소',
      'retry': '다시 시도',
      'comingSoon': '{title} 준비 중입니다',
      'logoutConfirmTitle': '로그아웃',
      'logoutConfirmContent': '로그아웃하시겠습니까?',
      'logoutSuccess': '로그아웃되었습니다',
      'deleteAccount': '계정 삭제',
      'confirmDeleteAccount': '삭제 확인',
      'deleteAccountReadAgreementHint': '계정 삭제 약관을 읽은 후 확인해주세요.',
      'deleteAccountAgreementLoadFailed': '계정 삭제 약관을 불러오지 못했습니다.',
      'deleteAccountConfirmTitle': '계정을 삭제하시겠습니까?',
      'deleteAccountConfirmContent':
          '삭제 후 계정 관련 데이터는 복구되지 않을 수 있습니다. 계속하시겠습니까?',
      'deleteAccountSuccess': '계정이 삭제되었습니다. 게스트로 다시 로그인되었습니다.',
      'deleteAccountFailed': '계정 삭제 실패',
      'me': '내 정보',
      'copy': '복사',
      'pullUpToLoadMore': '위로 당겨 더 불러오기',
      'loadFailed': '불러오기에 실패했습니다',
      'releaseToLoadMore': '놓아서 더 불러오기',
      'creation': '제작',
      'effects': '효과',
      'discover': '탐색',
      'create': '생성',
      'explore': '탐색',
      'describeYourVideo': '어떤 영상을 만들고 싶으신가요?',
      'imageToVideo': '이미지로 비디오',
      'textToVideo': '텍스트로 비디오',
      'aiModel': 'AI 모델',
      'duration': '길이',
      'styleGuide': '스타일(최상의 결과를 위해 하나를 선택하세요 🔥)',
      'auto': '자동',
      'all': '전체',
      'vip': 'VIP',
      'pro': 'PRO',
      'works': '작품',
      'noWorks': '아직 작품이 없습니다',
      'startCreating': '제작하기',
      'upgradeNow': '지금 업그레이드',
      'expirationDate': '만료일',
      'addImage': '이미지 추가',
      'newBadge': '신규',
      'hotBadge': '인기',
      'idLabel': 'ID',
      'promptBackground': '배경 프롬프트',
      'generationCount': '생성 수량',
      'durationUnitSec': '초',
      'tryForFree': '무료 체험',
      'emailAddress': '이메일 주소',
      'password': '비밀번호',
      'signIn': '로그인',
      'signInWithGoogle': 'Google로 로그인',
      'signInWithApple': 'Apple로 로그인',
      'agreeToThe': '동의합니다: ',
      'userAgreement': '이용약관',
      'and': ' 및 ',
      'termsOfService': '서비스 약관',
      'pleaseAgreeToTerms': '약관에 동의해주세요',
      'termsConsentContent': '로그인하기 전에 개인정보 처리방침과 서비스 약관에 동의해주세요.',
      'readAndAgreeToTerms': '위 개인정보 처리방침 및 서비스 약관을 자세히 읽고 동의해주세요.',
      'agree': '동의',
      'disagree': '동의하지 않음',
      'uploadImage': '이미지 업로드',
      'selectVideoEffects': '비디오 효과 선택',
      'submit': '제출',
      'selectTemplateFirst': '템플릿을 선택해주세요',
      'selectImageFirst': '이미지를 선택해주세요',
      'enterPromptFirst': '프롬프트를 입력해주세요',
      'selectDurationFirst': '길이를 선택해주세요',
      'createTaskSubmitted': '생성 작업이 제출되었습니다',
      'createTaskFailed': '생성 작업 제출에 실패했습니다',
      'templateCreateSubmitted': '템플릿 생성 작업이 제출되었습니다',
      'templateCreateFailed': '템플릿 생성 작업 제출에 실패했습니다',
      'monthlyPlan': '월간 플랜',
      'quarterlyPlan': '분기 플랜',
      'annualPlan': '연간 플랜',
      'lifetimePlan': '연간 플랜',
      'oneTimePayment': '구독 {price}',
      'unlockAllPremiumFeatures': '모든 프리미엄 기능 잠금 해제',
      'instantBonus': '즉시 보너스',
      'refreshWeekly': '매주 새로고침',
      'unlockAllTemplates': '모든 템플릿 전체 이용',
      'skipQueueNoWatermark': '대기열 건너뛰기, 더 빠른 영상 생성, 워터마크 없음',
      'standardMediaBenefits': '5,382+ 표준 이미지 / 1,346+ 표준 비디오',
      'untilPriceGoesUp': '{time} 후 가격 인상',
      'unlockVipService': 'VIP 서비스 잠금 해제',
      'myCredits': '내 크레딧',
      'recharge': '충전',
      'moreCreditFeatures': '더 많은 크레딧 기능이 곧 출시됩니다.',
      'creditPurchaseSummary': '{credits} 크레딧 • {price}',
      'creditPurchaseDisclosure':
          '크레딧은 일회성 소모성 구매이며 FlickoVideo에서 비디오 생성에 사용할 수 있습니다.',
      'orderResultTitle': '주문 결과',
      'paymentChecking': '결제 확인 중',
      'paymentSuccess': '결제 성공',
      'paymentFailed': '결제 실패',
      'paymentCheckingDesc': '주문을 확인하고 있습니다. 보통 몇 초 안에 완료됩니다.',
      'paymentSuccessDesc': '구매가 확인되었습니다. 이제 제작을 시작할 수 있습니다.',
      'paymentFailedDesc': '결제를 확인하지 못했습니다. 잠시 후 다시 시도해주세요.',
      'orderId': '주문 ID',
      'backHome': '홈으로',
      'termsOfUseEula': '이용 약관 (EULA)',
      'viewDetails': '상세 보기',
      'prompt': '프롬프트',
      'creationTime': '생성 시간',
      'createSimilar': '비슷하게 만들기',
      'share': '공유',
      'report': '신고',
      'blockUser': '사용자 차단',
      'blockUserSuccess': '사용자가 차단되었습니다',
      'blockUserFailed': '사용자 차단 실패',
      'delete': '삭제',
      'deleteVideoTitle': '비디오를 삭제하시겠습니까?',
      'deleteVideoContent': '이 작품이 내 생성 목록에서 제거됩니다.',
      'deleteComplete': '삭제되었습니다',
      'deleteFailed': '삭제 실패',
      'download': '다운로드',
      'downloadWithWatermark': '워터마크 포함 다운로드',
      'downloadWithoutWatermark': '워터마크 없이 다운로드',
      'downloadingVideo': '비디오 다운로드 중',
      'downloadComplete': '다운로드 완료',
      'downloadFailed': '다운로드 실패',
      'videoUnavailable': '비디오를 사용할 수 없습니다',
      'noPrompt': '프롬프트 없음',
      'shareVideoText': 'FlickoVideo로 제작',
      'feedback': '피드백',
      'feedbackSubtitle': '여러분의 의견을 듣고 싶습니다!',
      'feedbackEmailHint': '이메일 주소(선택 사항)',
      'feedbackContentHint':
          '여기에 제안 사항을 자유롭게 적어주세요. 예: 할인을 신청하고 싶습니다. 연락처를 남겨주세요.',
      'reportTypeHint': '신고 유형 선택(선택 사항)',
      'reportTypeMembershipBilling': '멤버십 및 결제',
      'reportTypeSensitivePornographic': '민감하거나 음란한 내용',
      'reportTypeSuicideSelfHarm': '자살 또는 자해',
      'reportTypeHateViolence': '혐오 또는 폭력',
      'reportTypeHarassmentBullying': '괴롭힘 또는 따돌림',
      'reportTypeFraudScam': '사기 또는 스캠',
      'reportTypeHarmfulMinors': '미성년자에게 유해함',
      'reportTypePrivacyInvasion': '개인정보 침해',
      'reportTypeOther': '기타',
      'enterFeedbackFirst': '피드백 내용을 입력해주세요',
      'enterValidEmail': '올바른 이메일 주소를 입력해주세요',
      'feedbackSubmitted': '피드백이 제출되었습니다',
      'feedbackSubmitFailed': '피드백 제출에 실패했습니다',
    },
    'fr': {
      'appTitle': 'FlickoVideo',
      'enterApp': 'Entrer dans l’app',
      'settings': 'Paramètres',
      'language': 'Langue',
      'chooseLanguage': 'Choisir la langue',
      'userPrivacy': 'Confidentialité utilisateur',
      'privacyPolicy': 'Politique de confidentialité',
      'aboutApp': 'À propos de l’app',
      'version': 'Version',
      'logOut': 'Se déconnecter',
      'cancel': 'Annuler',
      'retry': 'Réessayer',
      'comingSoon': '{title} arrive bientôt',
      'logoutConfirmTitle': 'Se déconnecter',
      'logoutConfirmContent': 'Voulez-vous vraiment vous déconnecter ?',
      'logoutSuccess': 'Déconnexion réussie',
      'deleteAccount': 'Supprimer le compte',
      'confirmDeleteAccount': 'Confirmer la suppression',
      'deleteAccountReadAgreementHint':
          'Veuillez lire l’accord de suppression du compte avant de confirmer.',
      'deleteAccountAgreementLoadFailed':
          'Impossible de charger l’accord de suppression du compte.',
      'deleteAccountConfirmTitle': 'Supprimer le compte ?',
      'deleteAccountConfirmContent':
          'Après suppression, les données du compte peuvent être irrécupérables. Voulez-vous continuer ?',
      'deleteAccountSuccess':
          'Compte supprimé. Vous êtes connecté en tant qu’invité.',
      'deleteAccountFailed': 'Échec de la suppression du compte',
      'me': 'Moi',
      'copy': 'Copier',
      'pullUpToLoadMore': 'Tirez vers le haut pour charger plus',
      'loadFailed': 'Échec du chargement',
      'releaseToLoadMore': 'Relâchez pour charger plus',
      'creation': 'Création',
      'effects': 'Effets',
      'discover': 'Découvrir',
      'create': 'Créer',
      'explore': 'Explorer',
      'describeYourVideo': 'Décrivez votre vidéo...',
      'imageToVideo': 'Image vers vidéo',
      'textToVideo': 'Texte vers vidéo',
      'aiModel': 'Modèle IA',
      'duration': 'Durée',
      'styleGuide': 'Style (Choisissez-en un pour un meilleur résultat 🔥)',
      'auto': 'Auto',
      'all': 'Tout',
      'vip': 'VIP',
      'pro': 'PRO',
      'works': 'Œuvres',
      'noWorks': 'Aucune œuvre pour le moment',
      'startCreating': 'Créer',
      'upgradeNow': 'Mettre à niveau',
      'expirationDate': 'Date d’expiration',
      'addImage': 'Ajouter une image',
      'newBadge': 'NOUVEAU',
      'hotBadge': 'HOT',
      'idLabel': 'ID',
      'promptBackground': 'Arrière-plan du prompt',
      'generationCount': 'Nombre de générations',
      'durationUnitSec': 's',
      'tryForFree': 'Essai gratuit',
      'emailAddress': 'Adresse e-mail',
      'password': 'Mot de passe',
      'signIn': 'Se connecter',
      'signInWithGoogle': 'Se connecter avec Google',
      'signInWithApple': 'Se connecter avec Apple',
      'agreeToThe': 'J\'accepte les ',
      'userAgreement': 'Conditions d\'utilisation',
      'and': ' et ',
      'termsOfService': 'Conditions de service',
      'pleaseAgreeToTerms': 'Veuillez accepter les conditions',
      'termsConsentContent':
          'Veuillez accepter la Politique de confidentialité et les Conditions de service avant de vous connecter.',
      'readAndAgreeToTerms':
          'Veuillez lire attentivement et accepter la Politique de confidentialité et les Conditions de service ci-dessus.',
      'agree': 'Accepter',
      'disagree': 'Refuser',
      'uploadImage': 'Télécharger une image',
      'selectVideoEffects': 'Sélectionner les effets vidéo',
      'submit': 'Soumettre',
      'selectTemplateFirst': 'Veuillez sélectionner un modèle',
      'selectImageFirst': 'Veuillez sélectionner une image',
      'enterPromptFirst': 'Veuillez saisir un prompt',
      'selectDurationFirst': 'Veuillez sélectionner une durée',
      'createTaskSubmitted': 'Tâche de génération envoyée',
      'createTaskFailed': 'Échec de l’envoi de la tâche de génération',
      'templateCreateSubmitted': 'Tâche de génération du modèle envoyée',
      'templateCreateFailed': 'Échec de l’envoi de la tâche de génération',
      'monthlyPlan': 'Forfait mensuel',
      'quarterlyPlan': 'Forfait trimestriel',
      'annualPlan': 'Forfait annuel',
      'lifetimePlan': 'Forfait annuel',
      'oneTimePayment': 'Abonnement {price}',
      'unlockAllPremiumFeatures':
          'Débloquer toutes les fonctionnalités premium',
      'instantBonus': 'Bonus instantané',
      'refreshWeekly': 'Actualisation hebdomadaire',
      'unlockAllTemplates': 'Accès complet à tous les modèles',
      'skipQueueNoWatermark':
          'Passez la file, générez plus vite, sans filigrane',
      'standardMediaBenefits':
          '5 382+ images standard / 1 346+ vidéos standard',
      'untilPriceGoesUp': '{time} avant l’augmentation du prix',
      'unlockVipService': 'Débloquer le service VIP',
      'myCredits': 'Mes crédits',
      'recharge': 'Recharger',
      'moreCreditFeatures':
          'Plus de fonctionnalités de crédit arrivent bientôt.',
      'creditPurchaseSummary': '{credits} crédits • {price}',
      'creditPurchaseDisclosure':
          'Les crédits sont un achat consommable unique et peuvent être utilisés pour générer des vidéos dans FlickoVideo.',
      'orderResultTitle': 'Résultat de commande',
      'paymentChecking': 'Vérification du paiement',
      'paymentSuccess': 'Paiement réussi',
      'paymentFailed': 'Paiement échoué',
      'paymentCheckingDesc':
          'Nous confirmons votre commande. Cela prend généralement quelques secondes.',
      'paymentSuccessDesc':
          'Votre achat est confirmé. Vous pouvez commencer à créer.',
      'paymentFailedDesc':
          'Nous n’avons pas pu confirmer ce paiement. Veuillez réessayer plus tard.',
      'orderId': 'ID de commande',
      'backHome': 'Retour à l’accueil',
      'termsOfUseEula': 'Conditions d’utilisation (EULA)',
      'viewDetails': 'Voir les détails',
      'prompt': 'Prompt',
      'creationTime': 'Date de création',
      'createSimilar': 'Créer similaire',
      'share': 'Partager',
      'report': 'Signaler',
      'blockUser': 'Bloquer l’utilisateur',
      'blockUserSuccess': 'Utilisateur bloqué',
      'blockUserFailed': 'Échec du blocage',
      'delete': 'Supprimer',
      'deleteVideoTitle': 'Supprimer la vidéo ?',
      'deleteVideoContent': 'Cette création sera retirée de votre liste.',
      'deleteComplete': 'Supprimé',
      'deleteFailed': 'Échec de la suppression',
      'download': 'Télécharger',
      'downloadWithWatermark': 'Télécharger avec filigrane',
      'downloadWithoutWatermark': 'Télécharger sans filigrane',
      'downloadingVideo': 'Téléchargement de la vidéo',
      'downloadComplete': 'Téléchargement terminé',
      'downloadFailed': 'Échec du téléchargement',
      'videoUnavailable': 'Vidéo indisponible',
      'noPrompt': 'Aucun prompt',
      'shareVideoText': 'Créé avec FlickoVideo',
      'feedback': 'Feedback',
      'feedbackSubtitle': 'Nous aimerions connaître votre avis !',
      'feedbackEmailHint': 'Votre adresse e-mail (facultatif)',
      'feedbackContentHint':
          'Vous pouvez écrire vos suggestions ici. Par exemple : je souhaite demander une réduction. Pensez à laisser vos coordonnées.',
      'reportTypeHint': 'Sélectionnez un type de signalement (facultatif)',
      'reportTypeMembershipBilling': 'Abonnement et facturation',
      'reportTypeSensitivePornographic': 'Sensible ou pornographique',
      'reportTypeSuicideSelfHarm': 'Suicide ou automutilation',
      'reportTypeHateViolence': 'Haine ou violence',
      'reportTypeHarassmentBullying': 'Harcèlement ou intimidation',
      'reportTypeFraudScam': 'Fraude ou arnaque',
      'reportTypeHarmfulMinors': 'Nuisible aux mineurs',
      'reportTypePrivacyInvasion': 'Atteinte à la vie privée',
      'reportTypeOther': 'Autre',
      'enterFeedbackFirst': 'Veuillez saisir votre feedback',
      'enterValidEmail': 'Veuillez saisir une adresse e-mail valide',
      'feedbackSubmitted': 'Feedback envoyé',
      'feedbackSubmitFailed': 'Échec de l’envoi du feedback',
    },
  };

  String get _languageCode => AppLocale.resolve(locale).code;

  String _text(String key) {
    return _localizedValues[_languageCode]?[key] ??
        _localizedValues[AppLocale.english.code]![key] ??
        key;
  }

  String get appTitle => _text('appTitle');
  String get enterApp => _text('enterApp');
  String get settings => _text('settings');
  String get language => _text('language');
  String get chooseLanguage => _text('chooseLanguage');
  String get userPrivacy => _text('userPrivacy');
  String get privacyPolicy => _text('privacyPolicy');
  String get aboutApp => _text('aboutApp');
  String get version => _text('version');
  String get logOut => _text('logOut');
  String get cancel => _text('cancel');
  String get retry => _text('retry');
  String get logoutConfirmTitle => _text('logoutConfirmTitle');
  String get logoutConfirmContent => _text('logoutConfirmContent');
  String get logoutSuccess => _text('logoutSuccess');
  String get deleteAccount => _text('deleteAccount');
  String get confirmDeleteAccount => _text('confirmDeleteAccount');
  String get deleteAccountReadAgreementHint =>
      _text('deleteAccountReadAgreementHint');
  String get deleteAccountAgreementLoadFailed =>
      _text('deleteAccountAgreementLoadFailed');
  String get deleteAccountConfirmTitle => _text('deleteAccountConfirmTitle');
  String get deleteAccountConfirmContent =>
      _text('deleteAccountConfirmContent');
  String get deleteAccountSuccess => _text('deleteAccountSuccess');
  String get deleteAccountFailed => _text('deleteAccountFailed');
  String get me => _text('me');
  String get copy => _text('copy');
  String get pullUpToLoadMore => _text('pullUpToLoadMore');
  String get loadFailed => _text('loadFailed');
  String get releaseToLoadMore => _text('releaseToLoadMore');
  String get creation => _text('creation');
  String get effects => _text('effects');
  String get discover => _text('discover');
  String get create => _text('create');
  String get explore => _text('explore');
  String get describeYourVideo => _text('describeYourVideo');
  String get imageToVideo => _text('imageToVideo');
  String get textToVideo => _text('textToVideo');
  String get aiModel => _text('aiModel');
  String get duration => _text('duration');
  String get styleGuide => _text('styleGuide');
  String get auto => _text('auto');
  String get all => _text('all');
  String get vip => _text('vip');
  String get pro => _text('pro');
  String get works => _text('works');
  String get noWorks => _text('noWorks');
  String get startCreating => _text('startCreating');
  String get upgradeNow => _text('upgradeNow');
  String get expirationDate => _text('expirationDate');
  String get addImage => _text('addImage');
  String get newBadge => _text('newBadge');
  String get hotBadge => _text('hotBadge');
  String get idLabel => _text('idLabel');
  String get promptBackground => _text('promptBackground');
  String get generationCount => _text('generationCount');
  String get durationUnitSec => _text('durationUnitSec');
  String get tryForFree => _text('tryForFree');
  String get emailAddress => _text('emailAddress');
  String get password => _text('password');
  String get signIn => _text('signIn');
  String get signInWithGoogle => _text('signInWithGoogle');
  String get signInWithApple => _text('signInWithApple');
  String get agreeToThe => _text('agreeToThe');
  String get userAgreement => _text('userAgreement');
  String get and => _text('and');
  String get termsOfService => _text('termsOfService');
  String get pleaseAgreeToTerms => _text('pleaseAgreeToTerms');
  String get termsConsentContent => _text('termsConsentContent');
  String get readAndAgreeToTerms => _text('readAndAgreeToTerms');
  String get agree => _text('agree');
  String get disagree => _text('disagree');
  String get uploadImage => _text('uploadImage');
  String get selectVideoEffects => _text('selectVideoEffects');
  String get submit => _text('submit');
  String get selectTemplateFirst => _text('selectTemplateFirst');
  String get selectImageFirst => _text('selectImageFirst');
  String get enterPromptFirst => _text('enterPromptFirst');
  String get selectDurationFirst => _text('selectDurationFirst');
  String get createTaskSubmitted => _text('createTaskSubmitted');
  String get createTaskFailed => _text('createTaskFailed');
  String get templateCreateSubmitted => _text('templateCreateSubmitted');
  String get templateCreateFailed => _text('templateCreateFailed');
  String get monthlyPlan => _text('monthlyPlan');
  String get quarterlyPlan => _text('quarterlyPlan');
  String get annualPlan => _text('annualPlan');
  String get lifetimePlan => _text('lifetimePlan');
  String get unlockAllPremiumFeatures => _text('unlockAllPremiumFeatures');
  String get instantBonus => _text('instantBonus');
  String get refreshWeekly => _text('refreshWeekly');
  String get unlockAllTemplates => _text('unlockAllTemplates');
  String get skipQueueNoWatermark => _text('skipQueueNoWatermark');
  String get standardMediaBenefits => _text('standardMediaBenefits');
  String get unlockVipService => _text('unlockVipService');
  String get myCredits => _text('myCredits');
  String get recharge => _text('recharge');
  String get moreCreditFeatures => _text('moreCreditFeatures');
  String get creditPurchaseDisclosure => _text('creditPurchaseDisclosure');
  String get orderResultTitle => _text('orderResultTitle');
  String get paymentChecking => _text('paymentChecking');
  String get paymentSuccess => _text('paymentSuccess');
  String get paymentFailed => _text('paymentFailed');
  String get paymentCheckingDesc => _text('paymentCheckingDesc');
  String get paymentSuccessDesc => _text('paymentSuccessDesc');
  String get paymentFailedDesc => _text('paymentFailedDesc');
  String get orderId => _text('orderId');
  String get backHome => _text('backHome');
  String get termsOfUseEula => _text('termsOfUseEula');
  String get viewDetails => _text('viewDetails');
  String get prompt => _text('prompt');
  String get creationTime => _text('creationTime');
  String get createSimilar => _text('createSimilar');
  String get share => _text('share');
  String get report => _text('report');
  String get blockUser => _text('blockUser');
  String get blockUserSuccess => _text('blockUserSuccess');
  String get blockUserFailed => _text('blockUserFailed');
  String get delete => _text('delete');
  String get deleteVideoTitle => _text('deleteVideoTitle');
  String get deleteVideoContent => _text('deleteVideoContent');
  String get deleteComplete => _text('deleteComplete');
  String get deleteFailed => _text('deleteFailed');
  String get download => _text('download');
  String get downloadWithWatermark => _text('downloadWithWatermark');
  String get downloadWithoutWatermark => _text('downloadWithoutWatermark');
  String get downloadingVideo => _text('downloadingVideo');
  String get downloadComplete => _text('downloadComplete');
  String get downloadFailed => _text('downloadFailed');
  String get videoUnavailable => _text('videoUnavailable');
  String get noPrompt => _text('noPrompt');
  String get shareVideoText => _text('shareVideoText');
  String get feedback => _text('feedback');
  String get feedbackSubtitle => _text('feedbackSubtitle');
  String get feedbackEmailHint => _text('feedbackEmailHint');
  String get feedbackContentHint => _text('feedbackContentHint');
  String get reportTypeHint => _text('reportTypeHint');
  List<String> get reportTypeLabels => [
    _text('reportTypeMembershipBilling'),
    _text('reportTypeSensitivePornographic'),
    _text('reportTypeSuicideSelfHarm'),
    _text('reportTypeHateViolence'),
    _text('reportTypeHarassmentBullying'),
    _text('reportTypeFraudScam'),
    _text('reportTypeHarmfulMinors'),
    _text('reportTypePrivacyInvasion'),
    _text('reportTypeOther'),
  ];
  String get enterFeedbackFirst => _text('enterFeedbackFirst');
  String get enterValidEmail => _text('enterValidEmail');
  String get feedbackSubmitted => _text('feedbackSubmitted');
  String get feedbackSubmitFailed => _text('feedbackSubmitFailed');

  String comingSoon(String title) =>
      _text('comingSoon').replaceAll('{title}', title);

  String oneTimePayment(String price) =>
      _text('oneTimePayment').replaceAll('{price}', price);

  String creditPurchaseSummary(String credits, String price) => _text(
    'creditPurchaseSummary',
  ).replaceAll('{credits}', credits).replaceAll('{price}', price);

  String untilPriceGoesUp(String time) =>
      _text('untilPriceGoesUp').replaceAll('{time}', time);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    final resolved = AppLocale.resolve(locale);
    return AppLocale.supported.any((item) => item.code == resolved.code);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
