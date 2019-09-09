/**
 * Created by iori on 2017/6/15.
 */
import {
    StyleSheet,
    Dimensions,
    Platform
} from 'react-native';

const {height, width} = Dimensions.get('window');

const themeConfig = {
    wrapColor: '#f2f2f2',
    bgColor: '#ffffff',
    borderColorConfig: '#eeeeee',
    themeColor: '#ff6600',
    touchOverColor: '#eeeeee'
};

export default CommonCss = StyleSheet.create({
    themeColor: {
        backgroundColor: themeConfig.themeColor
    },
    iconfont: {
        fontFamily: 'iconfont',
        fontSize: 16
    },
    wrap: {
        backgroundColor: themeConfig.wrapColor,
        height: '100%'
    },
    winWidth: {
        width: width,
    },
    winHeight: {
        height: height
    },
    //边框
    uiBorder: {
        borderColor: themeConfig.borderColorConfig,
        borderWidth: StyleSheet.hairlineWidth
    },
    uiBorderTop: {
        borderTopColor: themeConfig.borderColorConfig,
        borderTopWidth: StyleSheet.hairlineWidth
    },
    uiBorderRight: {
        borderRightColor: themeConfig.borderColorConfig,
        borderRightWidth: StyleSheet.hairlineWidth
    },
    uiBorderBottom: {
        borderBottomColor: themeConfig.borderColorConfig,
        borderBottomWidth: StyleSheet.hairlineWidth
    },
    uiBorderLeft: {
        borderLeftColor: themeConfig.borderColorConfig,
        borderLeftWidth: StyleSheet.hairlineWidth
    },
    //flex布局
    flexColumn: {
        flexDirection: 'column'
    },

    flexRow: {
        flexDirection: 'row'
    },

    flexItemsMiddle: {
        alignItems: 'center'
    },

    flexItemsTop: {
        alignItems: 'flex-start'
    },

    flexItemsBottom: {
        alignItems: 'flex-end'
    },

    flexItemsLeft: {
        justifyContent: 'flex-start'
    },

    flexItemsCenter: {
        justifyContent: 'center'
    },

    flexItemsRight: {
        justifyContent: 'flex-end'
    },

    flexSelfTop: {
        alignSelf: 'flex-start'
    },

    flexSelfMiddle: {
        alignSelf: 'center'
    },

    flexSelfBottom: {
        alignSelf: 'flex-end'
    },

    flexItemsAround: {
        justifyContent: 'space-around'
    },

    flexItemsBetween: {
        justifyContent: 'space-between'
    },

    listItemGroup: {
        marginTop: 10
    },
    flexNoWrap: {
        flexWrap: 'nowrap'
    },
    flexWrap: {
        flexWrap: 'wrap'
    },
    bgWhite: {
        backgroundColor: themeConfig.bgColor
    },
    naviLeftBox: {
        marginLeft: 10
    },
    naviRightBox: {
        marginRight: 10
    },
    lineItem: {
        backgroundColor: '#ffffff',
    },
    lineAction: {
        paddingHorizontal: 12,
        paddingVertical: 10,
        height: 48
    },
    lineLeft: {
        flex: 1
    },
    lineIconBox: {
        width: 20,
        height: 20,
        borderRadius: 3,
        alignItems: 'center',
        justifyContent: 'center'
    },
    lineIcon: {
        color: '#ffffff',
        fontSize: 14
    },
    lineText: {
        fontSize: 15,
        color: '#333333',
        marginLeft: 5,
        lineHeight: 26
    },
    lineRight: {},
    lineArr: {
        color: '#aaaaaa',
        lineHeight: 24,
        fontSize: 14
    },
    lineBeforeNote: {
        color: '#999999',
        fontSize: 14,
        paddingVertical: 10,
        paddingHorizontal: 15
    }
});