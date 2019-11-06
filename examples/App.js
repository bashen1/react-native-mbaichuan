import React, {Component} from 'react';
import {
    SafeAreaView,
    ScrollView,
    View,
    Text,
} from 'react-native';
import * as mBaichuan from 'react-native-mbaichuan';
import CommonCss from './CommonCss';
import ListItem from './ListItem';

class App extends Component {
    constructor(props) {
        super(props);
        this.state = {}
    }

    render(): React.ReactElement<any> | string | number | {} | React.ReactNodeArray | React.ReactPortal | boolean | null | undefined {
        let param = {
            mmpid: 'mm_23448739_15832573_60538822',
            isvcode: 'app',
            opentype: 'native',
            adzoneid: '60538822',
            tkkey: '23482513'
        };
        return (
            <SafeAreaView style={[CommonCss.wrap]}>
                <ScrollView>
                    <Text style={{
                        textAlign: 'center',
                        fontSize: 20,
                        fontWeight: '500',
                        color: '#000',
                        marginTop: 30
                    }}>阿里百川SDK（联盟）</Text>
                    <View style={[{marginTop: 30}]}>
                        <Text style={[CommonCss.lineBeforeNote]}>基础接口</Text>
                        <ListItem
                            title={'initSDK'}
                            action={async () => {
                                alert(JSON.stringify(await mBaichuan.initSDK()));
                            }}
                        />
                        <ListItem
                            title={'showLogin'}
                            action={async () => {
                                alert(JSON.stringify(await mBaichuan.showLogin()));
                            }}
                        />
                        <ListItem
                            title={'getUserInfo'}
                            action={async () => {
                                alert(JSON.stringify(await mBaichuan.getUserInfo()));
                            }}
                        />
                        <ListItem
                            title={'logout'}
                            action={async () => {
                                alert(JSON.stringify(await mBaichuan.logout()));
                            }}
                        />
                    </View>
                    <View style={[{marginTop: 30}]}>
                        <Text style={[CommonCss.lineBeforeNote]}>百川接口</Text>
                        <ListItem
                            title={'detail'}
                            action={async () => {
                                alert(JSON.stringify(await mBaichuan.show({
                                    type: 'detail',
                                    payload: Object.assign({}, param, {
                                        itemid: '600098537943'
                                    })
                                })));
                            }}
                        />
                        <ListItem
                            title={'url'}
                            action={async () => {
                                alert(JSON.stringify(await mBaichuan.show({
                                    type: 'url',
                                    payload: Object.assign({}, param, {
                                        url: 'https://detail.tmall.com/item.htm?id=600098537943'
                                    })
                                })));
                            }}
                        />
                        <ListItem
                            title={'url授权'}
                            action={async () => {
                                alert(JSON.stringify(await mBaichuan.show({
                                    type: 'url',
                                    payload: Object.assign({}, param, {
                                        url: 'https://oauth.taobao.com/authorize?response_type=code&client_id=25334456&redirect_uri=&view=wap',
                                        opentype: 'html5'
                                    })
                                })));
                            }}
                        />
                        <ListItem
                            title={'shop'}
                            action={async () => {
                                alert(JSON.stringify(await mBaichuan.show({
                                    type: 'shop',
                                    payload: Object.assign({}, param, {
                                        shopid: '471927947'
                                    })
                                })));
                            }}
                        />
                        <ListItem
                            title={'addCard【废除】'}
                            action={async () => {
                                alert(JSON.stringify(await mBaichuan.show({
                                    type: 'addCard',
                                    payload: Object.assign({}, param, {
                                        itemid: '579980429376'
                                    })
                                })));
                            }}
                        />
                        <ListItem
                            title={'orders【废除】'}
                            action={async () => {
                                alert(JSON.stringify(await mBaichuan.show({
                                    type: 'orders',
                                    payload: Object.assign({}, param, {
                                        orderStatus: '0',
                                        allOrder: 'YES'
                                    })
                                })));
                            }}
                        />
                        <ListItem
                            title={'mycard'}
                            action={async () => {
                                alert(JSON.stringify(await mBaichuan.show({
                                    type: 'mycard',
                                    payload: param
                                })));
                            }}
                        />
                    </View>

                    <View style={[{marginTop: 30}]}>

                        <ListItem
                            title={this.state.showWeb ? '关闭Webview' : '显示Webview'}
                            action={async () => {
                                this.setState({
                                    showWeb: !this.state.showWeb
                                })
                            }}
                        />
                        {this.state.showWeb ? (
                            <React.Fragment>
                                <mBaichuan.BCWebView
                                    style={{
                                        flex: 1,
                                        height: 300
                                    }}
                                    ref="BCWeb"
                                    param={{
                                        type: 'url',
                                        payload: Object.assign({}, param, {
                                            url: 'https://www.baidu.com'
                                        })
                                    }}
                                    onTradeResult={(tradeResult) => {
                                        alert(JSON.stringify(tradeResult));
                                    }}
                                    onStateChange={(state) => {
                                        alert(JSON.stringify(state));
                                    }}
                                />
                                <ListItem
                                    title={'goBack'}
                                    action={() => {
                                        this.refs['BCWeb'].goBack();
                                    }}
                                />
                                <ListItem
                                    title={'goForward'}
                                    action={async () => {
                                        this.refs['BCWeb'].goForward();
                                    }}
                                />
                                <ListItem
                                    title={'reload'}
                                    action={async () => {
                                        this.refs['BCWeb'].reload();
                                    }}
                                />
                            </React.Fragment>
                        ) : null}
                    </View>
                </ScrollView>
            </SafeAreaView>
        );
    }
}

export default App;
