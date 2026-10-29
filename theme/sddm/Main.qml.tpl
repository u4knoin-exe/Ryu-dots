import QtQuick 2.15

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#{{bg}}"
    property string uiFont: (config.font && config.font !== "") ? config.font : "{{font}}"

    Image {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
    }
    Rectangle { anchors.fill: parent; color: "#{{bg}}"; opacity: 0.6 }

    Text {
        id: clock
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height * 0.22
        font.family: root.uiFont
        font.pixelSize: Math.round(parent.height * 0.16)
        font.weight: Font.ExtraBold
        color: "#{{fg}}"
        text: Qt.formatTime(new Date(), "hh:mm")
    }
    Text {
        id: dateText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: clock.bottom
        font.family: root.uiFont
        font.pixelSize: 16
        font.letterSpacing: 4
        color: "#{{muted}}"
        text: Qt.formatDate(new Date(), "dddd  dd.MM.yyyy").toUpperCase()
    }
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            clock.text = Qt.formatTime(new Date(), "hh:mm")
            dateText.text = Qt.formatDate(new Date(), "dddd  dd.MM.yyyy").toUpperCase()
        }
    }

    Column {
        id: form
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height * 0.6
        spacing: 14

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: root.uiFont
            font.pixelSize: 14
            color: "#{{muted}}"
            text: userModel.lastUser
        }
        Rectangle {
            id: box
            width: 320
            height: 40
            color: "transparent"
            border.width: 1
            border.color: "#{{muted}}"
            TextInput {
                id: pw
                anchors.fill: parent
                anchors.margins: 10
                echoMode: TextInput.Password
                passwordCharacter: "*"
                color: "#{{fg}}"
                font.family: root.uiFont
                font.pixelSize: 16
                verticalAlignment: TextInput.AlignVCenter
                focus: true
                Keys.onReturnPressed: root.doLogin()
                Keys.onEnterPressed: root.doLogin()
            }
        }
        Text {
            id: msg
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: root.uiFont
            font.pixelSize: 13
            color: "#{{red}}"
            text: ""
        }
    }

    function doLogin() {
        msg.text = ""
        sddm.login(userModel.lastUser, pw.text, sessionModel.lastIndex)
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            msg.text = "wrong password"
            pw.text = ""
            box.border.color = "#{{red}}"
        }
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 32
        spacing: 36
        Repeater {
            model: ["suspend", "reboot", "shutdown"]
            Text {
                font.family: root.uiFont
                font.pixelSize: 13
                color: area.containsMouse ? "#{{fg}}" : "#{{muted}}"
                text: modelData
                MouseArea {
                    id: area
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (modelData === "suspend") sddm.suspend()
                        else if (modelData === "reboot") sddm.reboot()
                        else sddm.powerOff()
                    }
                }
            }
        }
    }

    Component.onCompleted: pw.forceActiveFocus()
}
