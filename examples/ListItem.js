import React, {PureComponent} from 'react';
import {
    Text,
    TouchableHighlight,
    View
} from 'react-native';
import CommonCss from './CommonCss';

class ListItem extends PureComponent {
    render = () => {
        let that = this;
        const {title, action} = that.props;
        return (
            <View style={[CommonCss.uiBorderBottom, CommonCss.lineItem]}>
                <TouchableHighlight
                    style={[CommonCss.lineAction]}
                    underlayColor={'#f2f2f2'}
                    onPress={action}
                >
                    <View style={[CommonCss.lineLeft]}>
                        <Text style={[CommonCss.lineText]}>{title}</Text>
                    </View>
                </TouchableHighlight>
            </View>
        )
    }
}

export default ListItem;
