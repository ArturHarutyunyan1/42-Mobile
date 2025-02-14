import { View, Text, StyleSheet, TouchableOpacity } from "react-native";
import { FontAwesomeIcon } from '@fortawesome/react-native-fontawesome';
import { faCalendarDay, faCalendarWeek, faCalendarCheck } from '@fortawesome/free-solid-svg-icons';

type footerProps = {
    onTabPress: (index: number) => void,
}

export default function BottomBar({onTabPress}: footerProps) {
    return (
        <View style={styles.wrapper}>
            <View style={styles.footer}>
                <View style={styles.row}>
                    <TouchableOpacity style={styles.rowItem} onPress={() => onTabPress(0)}>
                        <FontAwesomeIcon icon={faCalendarCheck} size={25} />
                        <Text style={styles.text}>Currently</Text>
                    </TouchableOpacity>
                    <TouchableOpacity style={styles.rowItem} onPress={() => onTabPress(1)}>
                        <FontAwesomeIcon icon={faCalendarDay} size={25} />
                        <Text style={styles.text}>Today</Text>
                    </TouchableOpacity>
                    <TouchableOpacity style={styles.rowItem} onPress={() => onTabPress(2)}>
                        <FontAwesomeIcon icon={faCalendarWeek} size={25} />
                        <Text style={styles.text}>Weekly</Text>
                    </TouchableOpacity>
                </View>
            </View>
        </View>
    );
}

const styles = StyleSheet.create({
    wrapper: {
        display: "flex",
        justifyContent: "center",
        alignItems: "center"
    },
    footer: {
        width: "90%",
        height: 100,
        position: "absolute",
        bottom: 30,
        backgroundColor: "#fff",
        borderRadius: 50
    },
    row: {
        flex: 1,
        flexDirection: "row",
    },
    rowItem: {
        flex: 1,
        justifyContent: "center",
        alignItems: "center",
    },
    text: {
        fontSize: 16,
        marginTop: 5,
    },
});
