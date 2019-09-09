
package com.maochunjie.mbaichuan;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.ali.auth.third.core.model.Session;
import com.ali.auth.third.ui.context.CallbackContext;
import com.alibaba.baichuan.android.trade.AlibcTrade;
import com.alibaba.baichuan.android.trade.AlibcTradeSDK;
import com.alibaba.baichuan.android.trade.callback.AlibcTradeCallback;
import com.alibaba.baichuan.android.trade.callback.AlibcTradeInitCallback;
import com.alibaba.baichuan.android.trade.model.AlibcShowParams;
import com.alibaba.baichuan.android.trade.model.OpenType;
import com.alibaba.baichuan.android.trade.page.*;
import com.alibaba.baichuan.trade.biz.AlibcConstants;
import com.alibaba.baichuan.trade.biz.applink.adapter.AlibcFailModeType;
import com.alibaba.baichuan.trade.biz.context.AlibcTradeResult;
import com.alibaba.baichuan.trade.biz.core.taoke.AlibcTaokeParams;
import com.alibaba.baichuan.trade.biz.login.AlibcLogin;
import com.alibaba.baichuan.trade.biz.login.AlibcLoginCallback;
import com.facebook.react.bridge.*;
import com.facebook.react.uimanager.events.RCTEventEmitter;

import java.util.HashMap;
import java.util.Map;

public class RNReactNativeMbaichuanModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    private static final String TAG = "RNReactNativeMbaichuanModule";
    private final static String NOT_LOGIN = "not login";
    private final static String INVALID_TRADE_RESULT = "invalid trade result";
    private final static String INVALID_PARAM = "invalid";

    private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {
        @Override
        public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent intent) {
            CallbackContext.onActivityResult(requestCode, resultCode, intent);
        }
    };

    static private RNReactNativeMbaichuanModule mRNAlibcSdkModule = null;

    static public RNReactNativeMbaichuanModule sharedInstance(ReactApplicationContext context) {
        if (mRNAlibcSdkModule == null) {
            return new RNReactNativeMbaichuanModule(context);
        } else {
            return mRNAlibcSdkModule;
        }
    }


    public RNReactNativeMbaichuanModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        reactContext.addActivityEventListener(mActivityEventListener);
    }

    @Override
    public String getName() {
        return "RNReactNativeMbaichuan";
    }


    /**
     * 初始化SDK---无参数传入
     */
    @ReactMethod
    public void initSDK(final Promise p) {
        AlibcTradeSDK.asyncInit(reactContext.getCurrentActivity().getApplication(), new AlibcTradeInitCallback() {
            @Override
            public void onSuccess() {
                WritableMap map = Arguments.createMap();
                map.putString("message", "success");
                map.putString("code", Integer.toString(0));
                p.resolve(map);
            }

            @Override
            public void onFailure(int code, String msg) {
                WritableMap map = Arguments.createMap();
                map.putString("message", msg);
                map.putString("code", Integer.toString(code));
                p.resolve(map);
            }
        });
    }

    /**
     * 打开登录---无参数传入
     */
    @ReactMethod
    public void showLogin(final Promise p) {
        if (AlibcLogin.getInstance().getSession() != null && AlibcLogin.getInstance().isLogin()) {
            WritableMap map = Arguments.createMap();
            Session localSession = AlibcLogin.getInstance().getSession();
            map.putString("isLogin", "true");
            map.putString("openId", localSession.openId);
            map.putString("avatarUrl", localSession.avatarUrl);
            map.putString("userNick", localSession.nick);
            p.resolve(map);
        } else {
            AlibcLogin alibcLogin = AlibcLogin.getInstance();
            alibcLogin.showLogin(new AlibcLoginCallback() {
                @Override
                public void onSuccess(int i, String s, String s1) {
                    Session session = AlibcLogin.getInstance().getSession();
                    WritableMap map = Arguments.createMap();
                    map.putString("isLogin", "true");
                    map.putString("openId", session.openId);
                    map.putString("avatarUrl", session.avatarUrl);
                    map.putString("userNick", session.nick);
                    p.resolve(map);
                }

                @Override
                public void onFailure(int i, String s) {
                    WritableMap map = Arguments.createMap();
                    map.putString("code", Integer.toString(i));
                    map.putString("message", s);
                    p.resolve(map);
                }
            });
        }
    }

    /**
     * 获取已登录的用户信息---无参数传入
     */
    @ReactMethod
    public void getUserInfo(final Promise p) {
        if (AlibcLogin.getInstance().isLogin()) {
            Session session = AlibcLogin.getInstance().getSession();
            WritableMap map = Arguments.createMap();
            map.putString("isLogin", "true");
            map.putString("openId", session.openId);
            map.putString("avatarUrl", session.avatarUrl);
            map.putString("userNick", session.nick);
            p.resolve(map);
        } else {
            WritableMap map = Arguments.createMap();
            map.putString("message", "Not logged in");
            map.putString("code", "90000");
        }
    }

    /**
     * 退出登录---无参数传入
     */
    @ReactMethod
    public void logout(final Promise p) {
        if (AlibcLogin.getInstance().getSession() != null
                && AlibcLogin.getInstance().isLogin()) {
            AlibcLogin alibcLogin = AlibcLogin.getInstance();

            alibcLogin.logout(new AlibcLoginCallback() {
                @Override
                public void onSuccess(int i, String s, String s1) {
                    WritableMap map = Arguments.createMap();
                    map.putString("code", "0");
                    map.putString("message", "success");
                    p.resolve(map);
                }

                @Override
                public void onFailure(int i, String s) {
                    WritableMap map = Arguments.createMap();
                    map.putString("code", Integer.toString(i));
                    map.putString("message", s);
                    p.resolve(map);
                }
            });
        } else {
            WritableMap map = Arguments.createMap();
            map.putString("code", "90000");
            map.putString("message", "Not logged in");
            p.resolve(map);
        }
    }

    /**
     * 展示
     */
    @ReactMethod
    public void show(final ReadableMap param, final Promise p) {
        String type = param.getString("type");
        ReadableMap payload = param.getMap("payload");
        switch (type) {
            case "detail":
                this._show(new AlibcDetailPage(payload.getString("itemid")), "detail", param, p);
                break;
            case "url":
                this._showUrl(payload.getString("url"), param, p);
                break;
            case "shop":
                this._show(new AlibcShopPage(payload.getString("shopid")), "shop", param, p);
                break;
            case "orders":
                this._show(new AlibcMyOrdersPage(payload.getInt("orderStatus"), payload.getBoolean("allOrder")), "orders", param, p);
                break;
            case "addCard":
                this._show(new AlibcAddCartPage(param.getString("itemid")), "addCart", param, p);
                break;
            case "mycard":
                this._show(new AlibcMyCartsPage(), "cart", param, p);
                break;
            default:
                WritableMap map = Arguments.createMap();
                map.putString("type", INVALID_PARAM);
                p.resolve(map);
                break;
        }
    }

    public void showInWebView(final WebView webview, WebViewClient webViewClient, final ReadableMap param) {
        String type = param.getString("type");
        ReadableMap payload = param.getMap("payload");
        switch (type) {
            case "detail":
                this._showInWebView(webview, webViewClient, new AlibcDetailPage(payload.getString("itemid")), "detail", param);
                break;
            case "url":
                this._showUrlInWebView(webview, webViewClient, payload.getString("url"), param);
                break;
            case "shop":
                this._showInWebView(webview, webViewClient, new AlibcShopPage(payload.getString("shopid")), "shop", param);
                break;
            case "orders":
                this._showInWebView(webview, webViewClient, new AlibcMyOrdersPage(payload.getInt("orderStatus"), payload.getBoolean("allOrder")), "orders", param);
                break;
            case "addCard":
                this._showInWebView(webview, webViewClient, new AlibcAddCartPage(payload.getString("itemid")), "addCart", param);
                break;
            case "mycard":
                this._showInWebView(webview, webViewClient, new AlibcMyCartsPage(), "cart", param);
                break;
            default:
                WritableMap map = Arguments.createMap();
                map.putString("type", INVALID_PARAM);
                reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(webview.getId(), "onTradeResult", map);
                break;
        }
    }


    private void _showInWebView(final WebView webview, WebViewClient webViewClient, final AlibcBasePage page, String bizCode, final ReadableMap param) {
        // 处理参数
        AlibcShowParams showParams = this.dealShowParams(param);
        AlibcTaokeParams taokeParams = this.dealTaokeParams(param);
        Map<String, String> trackParams = this.dealTrackParams(param);

        AlibcTrade.openByBizCode(getCurrentActivity(), page, webview, webViewClient, null, bizCode, showParams, taokeParams, trackParams, new AlibcTradeCallback() {
            @Override
            public void onTradeSuccess(AlibcTradeResult alibcTradeResult) {
                Log.v("ReactNative", TAG + ":onTradeSuccess");
                WritableMap map = Arguments.createMap();
                map.putString("orderid", "" + alibcTradeResult.payResult.paySuccessOrders);
                map.putString("message", "success");
                map.putString("code", "0");
                reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(webview.getId(), "onTradeResult", map);
            }

            @Override
            public void onFailure(int i, String s) {
                WritableMap map = Arguments.createMap();
                map.putString("message", s);
                map.putString("code", Integer.toString(i));
                reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(webview.getId(), "onTradeResult", map);
            }
        });
    }

    private void _showUrlInWebView(final WebView webview, WebViewClient webViewClient, String url, final ReadableMap param) {
        // 处理参数
        AlibcShowParams showParams = this.dealShowParams(param);
        AlibcTaokeParams taokeParams = this.dealTaokeParams(param);
        Map<String, String> trackParams = this.dealTrackParams(param);

        AlibcTrade.openByUrl(getCurrentActivity(), "", url, webview, webViewClient, null, showParams, taokeParams, trackParams, new AlibcTradeCallback() {
            @Override
            public void onTradeSuccess(AlibcTradeResult alibcTradeResult) {
                Log.v("ReactNative", TAG + ":onTradeSuccess");
                WritableMap map = Arguments.createMap();
                map.putString("orderid", "" + alibcTradeResult.payResult.paySuccessOrders);
                map.putString("message", "success");
                map.putString("code", "0");
                reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(webview.getId(), "onTradeResult", map);
            }

            @Override
            public void onFailure(int i, String s) {
                WritableMap map = Arguments.createMap();
                map.putString("message", s);
                map.putString("code", Integer.toString(i));
                reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(webview.getId(), "onTradeResult", map);
            }
        });
    }

    private void _show(AlibcBasePage page,String bizCode, final ReadableMap param, final Promise p) {
        // 处理参数
        AlibcShowParams showParams = this.dealShowParams(param);
        AlibcTaokeParams taokeParams = this.dealTaokeParams(param);
        Map<String, String> trackParams = this.dealTrackParams(param);

        AlibcTrade.openByBizCode(getCurrentActivity(), page, null, null, null, bizCode, showParams, taokeParams, trackParams, new AlibcTradeCallback() {
            @Override
            public void onTradeSuccess(AlibcTradeResult alibcTradeResult) {
                Log.v("ReactNative", TAG + ":onTradeSuccess");
                //打开电商组件，用户操作中成功信息回调。tradeResult：成功信息（结果类型：加购，支付；支付结果）
                WritableMap map = Arguments.createMap();
                map.putString("orderid", "" + alibcTradeResult.payResult.paySuccessOrders);
                map.putString("message", "success");
                map.putString("code", "0");
                p.resolve(map);
            }

            @Override
            public void onFailure(int i, String s) {
                WritableMap map = Arguments.createMap();
                map.putString("message", s);
                map.putString("code", Integer.toString(i));
                p.resolve(map);
            }
        });
    }

    private void _showUrl(String url, final ReadableMap param, final Promise p) {
        // 处理参数
        AlibcShowParams showParams = this.dealShowParams(param);
        AlibcTaokeParams taokeParams = this.dealTaokeParams(param);
        Map<String, String> trackParams = this.dealTrackParams(param);
        AlibcTrade.openByUrl(getCurrentActivity(), "", url, null, null, null, showParams, taokeParams, trackParams, new AlibcTradeCallback() {
            @Override
            public void onTradeSuccess(AlibcTradeResult alibcTradeResult) {
                Log.v("ReactNative", TAG + ":onTradeSuccess");
                //打开电商组件，用户操作中成功信息回调。tradeResult：成功信息（结果类型：加购，支付；支付结果）
                WritableMap map = Arguments.createMap();
                map.putString("orderid", "" + alibcTradeResult.payResult.paySuccessOrders);
                map.putString("message", "success");
                map.putString("code", "0");
                p.resolve(map);
            }

            @Override
            public void onFailure(int i, String s) {
                WritableMap map = Arguments.createMap();
                map.putString("message", s);
                map.putString("code", Integer.toString(i));
                p.resolve(map);
            }
        });
    }

    /**
     * 处理showParams公用参数
     */
    private AlibcShowParams dealShowParams(final ReadableMap param) {
        ReadableMap payload = param.getMap("payload");
        // 初始化参数
        String opentype = "html5";

        AlibcShowParams showParams = new AlibcShowParams();

        if (payload.getString("opentype") != null
                || !payload.getString("opentype").equals("")) {
            opentype = payload.getString("opentype");
        }

        if (opentype.equals("html5")) {
            showParams.setOpenType(OpenType.Auto);
        } else {
            showParams.setOpenType(OpenType.Native);
        }

        showParams.setClientType("taobao");
        showParams.setBackUrl("");
        showParams.setNativeOpenFailedMode(AlibcFailModeType.AlibcNativeFailModeJumpH5);

        return showParams;
    }

    /**
     * 处理taokeParams公用参数
     */
    private AlibcTaokeParams dealTaokeParams(final ReadableMap param) {
        ReadableMap payload = param.getMap("payload");
        // 初始化参数
        String mmpid = "mm_114988374_16864682_45439350353";
        String adzoneid = "45439350353";
        String tkkey = "23488271";

        // 设置mmpid
        if (payload.hasKey("mmpid") && (payload.getString("mmpid") != null || !payload.getString("mmpid").equals(""))) {
            mmpid = payload.getString("mmpid");
        }

        // 设置adzoneid
        if (payload.hasKey("adzoneid") && (payload.getString("adzoneid") != null || !payload.getString("adzoneid").equals(""))) {
            adzoneid = payload.getString("adzoneid");
        }

        // 设置tkkey
        if (payload.hasKey("tkkey") && (payload.getString("tkkey") != null || !payload.getString("tkkey").equals(""))) {
            tkkey = payload.getString("tkkey");
        }

        AlibcTaokeParams taokeParams = new AlibcTaokeParams("", "", "");
        taokeParams.setPid(mmpid);
        taokeParams.setAdzoneid(adzoneid);

        Map<String, String> taokeExParams = new HashMap<String, String>();
        taokeExParams.put("taokeAppkey", tkkey);
        taokeParams.setExtraParams(taokeExParams);

        return taokeParams;
    }

    /**
     * 处理trackParams公用参数
     */
    private Map<String, String> dealTrackParams(final ReadableMap param) {
        ReadableMap payload = param.getMap("payload");
        // 初始化参数
        Map<String, String> trackParams = new HashMap<String, String>();
        String isvcode = "app";
        // 设置tkkey
        if (payload.hasKey("tkkey") && (payload.getString("isvcode") != null || !payload.getString("isvcode").equals(""))) {
            isvcode = payload.getString("isvcode");
        }
        trackParams.put(AlibcConstants.ISV_CODE, isvcode);
        return trackParams;
    }
}