import React, {
    PureComponent
} from 'react';
import {
    View,
    Platform,
    UIManager,
    NativeModules,
    requireNativeComponent,
    findNodeHandle,
} from 'react-native';

import PropTypes from 'prop-types';

const ALIBC_TRADEWEBVIEW_REF = 'ALIBCTRADEWEBVIEW_REF';

export class BCWebView extends PureComponent {
    constructor(props) {
        super(props);
        this._onTradeResult = this._onTradeResult.bind(this);
        this._onStateChange = this._onStateChange.bind(this);
        this.goForward = this.goForward.bind(this);
        this.goBack = this.goBack.bind(this);
        this.reload = this.reload.bind(this);
        this._getWebViewBridgeHandle = this._getWebViewBridgeHandle.bind(this);
    }

    _onTradeResult = (event) => {
        if (!this.props.onTradeResult) {
            return;
        }
        this.props.onTradeResult(event.nativeEvent);
    };

    _onStateChange = (event) => {
        if (!this.props.onStateChange) {
            return;
        }
        this.props.onStateChange(event.nativeEvent);
    };

    goForward = () => {
        UIManager.dispatchViewManagerCommand(
            this._getWebViewBridgeHandle(),
            UIManager.BCWebManager.Commands.goForward,
            null
        );
    };

    goBack = () => {
        UIManager.dispatchViewManagerCommand(
            this._getWebViewBridgeHandle(),
            UIManager.BCWebManager.Commands.goBack,
            null
        );
    };

    reload = () => {
        UIManager.dispatchViewManagerCommand(
            this._getWebViewBridgeHandle(),
            UIManager.BCWebManager.Commands.reload,
            null
        );
    };

    _getWebViewBridgeHandle = () => {
        return findNodeHandle(this.refs[ALIBC_TRADEWEBVIEW_REF]);
    };

    render = () => {
        return <NativeComponent
            ref={ALIBC_TRADEWEBVIEW_REF}
            {...this.props}
            onTradeResult={this._onTradeResult}
            onStateChange={this._onStateChange}
        />;
    };
}

BCWebView.propTypes = {
    param: PropTypes.object,
    onTradeResult: PropTypes.func,
    onStateChange: PropTypes.func,
    ...View.propTypes,
};

const NativeComponent = requireNativeComponent("BCWeb", BCWebView);

const {RNReactNativeMbaichuan} = NativeModules;

export async function initSDK(param) {
    let isvVersion = '4.0.0';
    let isvAppName = 'mbaichuan';
    if (param) {
        if (param.isvVersion && param.isvVersion !== '') {
            isvVersion = param.isvVersion;
        }
        if (param.isvVersion && param.isvAppName !== '') {
            isvAppName = param.isvAppName;
        }
    }
    if (Platform.OS === 'ios') {
        return await RNReactNativeMbaichuan.initSDK({
            isvVersion,
            isvAppName
        });
    } else {
        return await RNReactNativeMbaichuan.initSDK();
    }
}

export async function showLogin() {
    return await RNReactNativeMbaichuan.showLogin();
}

export async function getUserInfo() {
    return await RNReactNativeMbaichuan.getUserInfo();
}

export async function logout() {
    return await RNReactNativeMbaichuan.logout();
}

export async function show(params) {
    return await RNReactNativeMbaichuan.show(params);
}
