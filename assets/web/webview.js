/**
 * H5 与 iOS WKWebView 桥接工具。
 *
 * iOS 侧在 WKWebView 中通过 WKUserContentController 注册 messageHandlers。
 * Swift 对应实现：WKScriptMessageHandler，handler 名称与方法名一致。
 *
 * 使用说明：
 * 1. H5 主动调用原生能力时，使用 WebViewBridge.xxx()。
 * 2. 原生回调 H5 时，iOS 通过 evaluateJavaScript 直接调用全局函数：
 *    - getUserAgentCallback(data)
 *    - getAccountInfoCallback(data)
 * 3. 业务方可以通过 WebViewBridge.setUserAgentHandler(fn) / setAccountInfoHandler(fn)
 *    统一接收这两个回调，也可以直接覆写上面的全局函数。
 *
 * iOS Swift 端需注册的 handler 名称清单（与方法名一致）：
 *   setH5Status, setStatusBarFontColor, setStatusBarColor, showToast,
 *   getUserAgent, getAccountInfo, logEvent, closeActivity,
 *   requestPay, requestSingleSubsPay, requestSubsPay, requestNewSubsPay,
 *   h5ScriptSubSuccess, openPersonalAct, showLoginDialog,
 *   openWeb, openPrivacy, showWebview, showLogin
 */

(function (global) {
  'use strict';

  var userAgentHandler = null;
  var accountInfoHandler = null;
  var backHandler = null;

  /**
   * 判断当前是否运行在 iOS WKWebView 桥接环境中。
   */
  function isAvailable() {
    return !!(
      global.FlickoWebBridge ||
      (global.webkit && global.webkit.messageHandlers)
    );
  }

  /**
   * 安全调用 iOS 原生方法（通过 webkit.messageHandlers 发消息）。
   * iOS Swift 端需注册同名 handler：
   *   contentController.add(self, name: methodName)
   *
   * @param {string} methodName handler 名称，与 Swift 注册名一致
   * @param {...any} args 传给原生的参数，单参数直接传，多参数封装为数组
   */
  function invoke(methodName) {
    if (!isAvailable()) {
      console.warn('[WebViewBridge] 原生桥不存在，调用已忽略：' + methodName);
      return;
    }

    var args = Array.prototype.slice.call(arguments, 1);

    if (global.FlickoWebBridge && global.FlickoWebBridge.postMessage) {
      var payload = args.length === 0 ? null : (args.length === 1 ? args[0] : args);
      global.FlickoWebBridge.postMessage(JSON.stringify({
        method: methodName,
        payload: payload
      }));
      return;
    }

    var handler = global.webkit && global.webkit.messageHandlers
      ? global.webkit.messageHandlers[methodName]
      : null;
    if (!handler) {
      console.warn('[WebViewBridge] handler 未注册：' + methodName);
      return;
    }

    handler.postMessage(args.length === 0 ? null : (args.length === 1 ? args[0] : args));
  }

  var WebViewBridge = {

    /** 判断当前页面是否可使用 iOS WKWebView 桥接。@returns {boolean} */
    isAvailable: function () {
      return isAvailable();
    },

    /** 通知原生当前 H5 页面已挂载完成。@param {number} status 传 1 即可 */
    setH5Status: function (status) {
      invoke('setH5Status', status);
    },

    /** setH5Status(1) 的语义化封装。 */
    notifyPageMounted: function () {
      invoke('setH5Status', 1);
    },

    /** 设置状态栏字体颜色风格。@param {boolean} isDark true=深色字体 */
    setStatusBarFontColor: function (isDark) {
      invoke('setStatusBarFontColor', isDark);
    },

    /** 切换状态栏主题色风格。@param {boolean} isDark */
    setStatusBarColor: function (isDark) {
      invoke('setStatusBarColor', isDark);
    },

    /** 调用原生弹出 Toast 提示。@param {string} content */
    showToast: function (content) {
      invoke('showToast', content);
    },

    /**
     * 向原生请求设备/客户端信息。
     * 原生处理后通过 evaluateJavaScript("getUserAgentCallback(...)") 回调。
     */
    getUserAgent: function () {
      invoke('getUserAgent');
    },

    /** 设置"获取设备信息"回调处理函数。@param {Function} handler function(data){} */
    setUserAgentHandler: function (handler) {
      userAgentHandler = typeof handler === 'function' ? handler : null;
    },

    /**
     * 向原生请求当前登录用户信息。
     * 原生处理后通过 evaluateJavaScript("getAccountInfoCallback(...)") 回调。
     */
    getAccountInfo: function () {
      invoke('getAccountInfo');
    },

    /** 设置"获取账号信息"回调处理函数。@param {Function} handler function(data){} */
    setAccountInfoHandler: function (handler) {
      accountInfoHandler = typeof handler === 'function' ? handler : null;
    },

    /**
     * 设置"原生返回键"回调处理函数。
     * iOS 通过 evaluateJavaScript("gotoBack()") 触发。
     * @param {Function} handler function(){}
     */
    setBackHandler: function (handler) {
      backHandler = typeof handler === 'function' ? handler : null;
    },

    /** 上报埋点事件给原生。@param {Object|string} eventData */
    logEvent: function (eventData) {
      var payload = typeof eventData === 'string' ? eventData : JSON.stringify(eventData || {});
      invoke('logEvent', payload);
    },

    /** 关闭当前 WebView 所在页面。 */
    closeActivity: function () {
      invoke('closeActivity');
    },

    /** 发起普通商品支付。@param {string} goodsId */
    requestPay: function (goodsId) {
      invoke('requestPay', goodsId);
    },

    /** 发起单次订阅支付。@param {string} goodsId @param {string} targetId */
    requestSingleSubsPay: function (goodsId, targetId) {
      invoke('requestSingleSubsPay', goodsId, targetId);
    },

    /** 发起订阅支付。@param {string} goodsId @param {string} token */
    requestSubsPay: function (goodsId, token) {
      invoke('requestSubsPay', goodsId, token);
    },

    /** 发起新版订阅支付。@param {string} goodsId @param {string} token @param {string} targetId */
    requestNewSubsPay: function (goodsId, token, targetId) {
      invoke('requestNewSubsPay', goodsId, token, targetId);
    },

    /** 通知原生订阅成功，触发客户端状态刷新和埋点。@param {string} gid @param {number} price @param {boolean} first */
    h5ScriptSubSuccess: function (gid, price, first) {
      invoke('h5ScriptSubSuccess', gid, price, first);
    },

    /** 打开个人主页相关页面。@param {string} memberId */
    openPersonalAct: function (memberId) {
      invoke('openPersonalAct', memberId);
    },

    /** 弹出原生登录弹窗。 */
    showLoginDialog: function () {
      invoke('showLoginDialog');
    },

    /** 调用系统浏览器打开外部网页。@param {string} url */
    openWeb: function (url) {
      invoke('openWeb', url);
    },

    /** 在 App 内打开隐私协议等 Web 页面。@param {string} url */
    openPrivacy: function (url) {
      invoke('openPrivacy', url);
    },

    /** 唤起原生 WebView 页面。 */
    showWebview: function () {
      invoke('showWebview');
    },

    /** 跳转到原生登录页面。 */
    showLogin: function () {
      invoke('showLogin');
    }
  };

  /**
   * 原生回调 H5 的"设备信息返回"函数。
   * iOS 通过 evaluateJavaScript("getUserAgentCallback(JSON.stringify(data))") 触发。
   * @param {Object} data 原生返回的客户端信息对象
   */
  global.getUserAgentCallback = function (data) {
    if (typeof userAgentHandler === 'function') {
      userAgentHandler(data);
    }
  };

  /**
   * 原生回调 H5 的"账号信息返回"函数。
   * iOS 通过 evaluateJavaScript("getAccountInfoCallback(JSON.stringify(data))") 触发。
   * @param {Object} data 原生返回的账号信息对象，包含 memberId、token、isVip、source 等字段
   */
  global.getAccountInfoCallback = function (data) {
    if (typeof accountInfoHandler === 'function') {
      accountInfoHandler(data);
    }
  };

  /**
   * 原生回调 H5 的"页面返回"函数。
   * iOS 通过 evaluateJavaScript("gotoBack()") 触发。
   */
  global.gotoBack = function () {
    if (typeof backHandler === 'function') {
      backHandler();
    }
  };

  /** 将桥接对象暴露到全局，供页面任意位置直接调用。 */
  global.WebViewBridge = WebViewBridge;

})(typeof window !== 'undefined' ? window : this);
