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
      'settings': 'Settings',
      'language': 'Language',
      'chooseLanguage': 'Choose Language',
      'userPrivacy': 'User Privacy',
      'privacyPolicy': 'Privacy Policy',
      'logOut': 'Log Out',
      'cancel': 'Cancel',
      'comingSoon': '{title} is coming soon',
      'logoutConfirmTitle': 'Log Out',
      'logoutConfirmContent': 'Are you sure you want to log out?',
      'logoutSuccess': 'Logged out successfully',
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
      'quarterlyPlan': 'Quarterly Plan',
      'annualPlan': 'Annual Plan',
      'lifetimePlan': 'Lifetime Plan',
      'oneTimePayment': 'One-time payment {price}',
      'unlockAllPremiumFeatures': 'Unlock All Premium Features',
      'instantBonus': 'Instant Bonus',
      'untilPriceGoesUp': '{time} until price goes up',
      'unlockVipService': 'Unlock VIP Service',
      'myCredits': 'My Credits',
      'recharge': 'Recharge',
      'moreCreditFeatures': 'More credit features are coming soon, stay tuned.',
      'viewDetails': 'View Details',
      'prompt': 'Prompt',
      'creationTime': 'Creation Time',
      'createSimilar': 'Create Similar',
      'share': 'Share',
      'report': 'Report',
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
      'enterFeedbackFirst': 'Please enter your feedback',
      'enterValidEmail': 'Please enter a valid email address',
      'feedbackSubmitted': 'Feedback submitted',
      'feedbackSubmitFailed': 'Failed to submit feedback',
    },
    'zh-Hans': {
      'appTitle': 'FlickoVideo',
      'settings': '设置',
      'language': '语言',
      'chooseLanguage': '选择语言',
      'userPrivacy': '用户隐私',
      'privacyPolicy': '隐私政策',
      'logOut': '退出登录',
      'cancel': '取消',
      'comingSoon': '{title} 敬请期待',
      'logoutConfirmTitle': '退出登录',
      'logoutConfirmContent': '确定要退出登录吗？',
      'logoutSuccess': '已成功退出登录',
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
      'quarterlyPlan': '季度会员',
      'annualPlan': '年度会员',
      'lifetimePlan': '终身会员',
      'oneTimePayment': '一次性支付 {price}',
      'unlockAllPremiumFeatures': '解锁全部高级功能',
      'instantBonus': '即时奖励',
      'untilPriceGoesUp': '{time} 后价格上涨',
      'unlockVipService': '解锁 VIP 服务',
      'myCredits': '我的积分',
      'recharge': '充值',
      'moreCreditFeatures': '更多积分功能即将上线，敬请期待。',
      'viewDetails': '查看详情',
      'prompt': '提示词',
      'creationTime': '创建时间',
      'createSimilar': '创作同款',
      'share': '分享',
      'report': '举报',
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
      'enterFeedbackFirst': '请输入反馈内容',
      'enterValidEmail': '请输入正确的邮箱地址',
      'feedbackSubmitted': '反馈已提交',
      'feedbackSubmitFailed': '反馈提交失败',
    },
    'zh-Hant': {
      'appTitle': 'FlickoVideo',
      'settings': '設定',
      'language': '語言',
      'chooseLanguage': '選擇語言',
      'userPrivacy': '用戶隱私',
      'privacyPolicy': '隱私政策',
      'logOut': '登出',
      'cancel': '取消',
      'comingSoon': '{title} 即將推出',
      'logoutConfirmTitle': '登出',
      'logoutConfirmContent': '確定要登出嗎？',
      'logoutSuccess': '已成功登出',
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
      'quarterlyPlan': '季度會員',
      'annualPlan': '年度會員',
      'lifetimePlan': '終身會員',
      'oneTimePayment': '一次性支付 {price}',
      'unlockAllPremiumFeatures': '解鎖全部高級功能',
      'instantBonus': '即時獎勵',
      'untilPriceGoesUp': '{time} 後價格上漲',
      'unlockVipService': '解鎖 VIP 服務',
      'myCredits': '我的積分',
      'recharge': '充值',
      'moreCreditFeatures': '更多積分功能即將上線，敬請期待。',
      'viewDetails': '查看詳情',
      'prompt': '提示詞',
      'creationTime': '建立時間',
      'createSimilar': '創作同款',
      'share': '分享',
      'report': '檢舉',
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
      'enterFeedbackFirst': '請輸入回饋內容',
      'enterValidEmail': '請輸入正確的電子郵件地址',
      'feedbackSubmitted': '回饋已提交',
      'feedbackSubmitFailed': '回饋提交失敗',
    },
    'ja': {
      'appTitle': 'FlickoVideo',
      'settings': '設定',
      'language': '言語',
      'chooseLanguage': '言語を選択',
      'userPrivacy': 'ユーザープライバシー',
      'privacyPolicy': 'プライバシーポリシー',
      'logOut': 'ログアウト',
      'cancel': 'キャンセル',
      'comingSoon': '{title} は近日公開予定です',
      'logoutConfirmTitle': 'ログアウト',
      'logoutConfirmContent': 'ログアウトしてもよろしいですか？',
      'logoutSuccess': 'ログアウトしました',
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
      'quarterlyPlan': '四半期プラン',
      'annualPlan': '年間プラン',
      'lifetimePlan': '永久プラン',
      'oneTimePayment': '一回払い {price}',
      'unlockAllPremiumFeatures': 'すべてのプレミアム機能を解放',
      'instantBonus': '即時ボーナス',
      'untilPriceGoesUp': '{time} 後に値上げ',
      'unlockVipService': 'VIP サービスを解放',
      'myCredits': 'マイクレジット',
      'recharge': 'チャージ',
      'moreCreditFeatures': 'クレジット機能は近日公開予定です。',
      'viewDetails': '詳細を見る',
      'prompt': 'プロンプト',
      'creationTime': '作成日時',
      'createSimilar': '似た動画を作成',
      'share': '共有',
      'report': '報告',
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
      'enterFeedbackFirst': 'フィードバックを入力してください',
      'enterValidEmail': '有効なメールアドレスを入力してください',
      'feedbackSubmitted': 'フィードバックを送信しました',
      'feedbackSubmitFailed': 'フィードバックの送信に失敗しました',
    },
    'ko': {
      'appTitle': 'FlickoVideo',
      'settings': '설정',
      'language': '언어',
      'chooseLanguage': '언어 선택',
      'userPrivacy': '사용자 개인정보',
      'privacyPolicy': '개인정보 처리방침',
      'logOut': '로그아웃',
      'cancel': '취소',
      'comingSoon': '{title} 준비 중입니다',
      'logoutConfirmTitle': '로그아웃',
      'logoutConfirmContent': '로그아웃하시겠습니까?',
      'logoutSuccess': '로그아웃되었습니다',
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
      'quarterlyPlan': '분기 플랜',
      'annualPlan': '연간 플랜',
      'lifetimePlan': '평생 플랜',
      'oneTimePayment': '일시불 결제 {price}',
      'unlockAllPremiumFeatures': '모든 프리미엄 기능 잠금 해제',
      'instantBonus': '즉시 보너스',
      'untilPriceGoesUp': '{time} 후 가격 인상',
      'unlockVipService': 'VIP 서비스 잠금 해제',
      'myCredits': '내 크레딧',
      'recharge': '충전',
      'moreCreditFeatures': '더 많은 크레딧 기능이 곧 출시됩니다.',
      'viewDetails': '상세 보기',
      'prompt': '프롬프트',
      'creationTime': '생성 시간',
      'createSimilar': '비슷하게 만들기',
      'share': '공유',
      'report': '신고',
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
      'enterFeedbackFirst': '피드백 내용을 입력해주세요',
      'enterValidEmail': '올바른 이메일 주소를 입력해주세요',
      'feedbackSubmitted': '피드백이 제출되었습니다',
      'feedbackSubmitFailed': '피드백 제출에 실패했습니다',
    },
    'fr': {
      'appTitle': 'FlickoVideo',
      'settings': 'Paramètres',
      'language': 'Langue',
      'chooseLanguage': 'Choisir la langue',
      'userPrivacy': 'Confidentialité utilisateur',
      'privacyPolicy': 'Politique de confidentialité',
      'logOut': 'Se déconnecter',
      'cancel': 'Annuler',
      'comingSoon': '{title} arrive bientôt',
      'logoutConfirmTitle': 'Se déconnecter',
      'logoutConfirmContent': 'Voulez-vous vraiment vous déconnecter ?',
      'logoutSuccess': 'Déconnexion réussie',
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
      'quarterlyPlan': 'Forfait trimestriel',
      'annualPlan': 'Forfait annuel',
      'lifetimePlan': 'Forfait à vie',
      'oneTimePayment': 'Paiement unique {price}',
      'unlockAllPremiumFeatures':
          'Débloquer toutes les fonctionnalités premium',
      'instantBonus': 'Bonus instantané',
      'untilPriceGoesUp': '{time} avant l’augmentation du prix',
      'unlockVipService': 'Débloquer le service VIP',
      'myCredits': 'Mes crédits',
      'recharge': 'Recharger',
      'moreCreditFeatures':
          'Plus de fonctionnalités de crédit arrivent bientôt.',
      'viewDetails': 'Voir les détails',
      'prompt': 'Prompt',
      'creationTime': 'Date de création',
      'createSimilar': 'Créer similaire',
      'share': 'Partager',
      'report': 'Signaler',
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
  String get settings => _text('settings');
  String get language => _text('language');
  String get chooseLanguage => _text('chooseLanguage');
  String get userPrivacy => _text('userPrivacy');
  String get privacyPolicy => _text('privacyPolicy');
  String get logOut => _text('logOut');
  String get cancel => _text('cancel');
  String get logoutConfirmTitle => _text('logoutConfirmTitle');
  String get logoutConfirmContent => _text('logoutConfirmContent');
  String get logoutSuccess => _text('logoutSuccess');
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
  String get quarterlyPlan => _text('quarterlyPlan');
  String get annualPlan => _text('annualPlan');
  String get lifetimePlan => _text('lifetimePlan');
  String get unlockAllPremiumFeatures => _text('unlockAllPremiumFeatures');
  String get instantBonus => _text('instantBonus');
  String get unlockVipService => _text('unlockVipService');
  String get myCredits => _text('myCredits');
  String get recharge => _text('recharge');
  String get moreCreditFeatures => _text('moreCreditFeatures');
  String get viewDetails => _text('viewDetails');
  String get prompt => _text('prompt');
  String get creationTime => _text('creationTime');
  String get createSimilar => _text('createSimilar');
  String get share => _text('share');
  String get report => _text('report');
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
  String get enterFeedbackFirst => _text('enterFeedbackFirst');
  String get enterValidEmail => _text('enterValidEmail');
  String get feedbackSubmitted => _text('feedbackSubmitted');
  String get feedbackSubmitFailed => _text('feedbackSubmitFailed');

  String comingSoon(String title) =>
      _text('comingSoon').replaceAll('{title}', title);

  String oneTimePayment(String price) =>
      _text('oneTimePayment').replaceAll('{price}', price);

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
