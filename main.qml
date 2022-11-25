import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.LocalStorage 2.12
import Qt.labs.qmlmodels 1.0
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.2


import "main.js" as MyJS

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Домашняя работа №7")
    property variant db: null
    Button {
        id: but
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 10
        text: "Добавить строку"
        onClicked: dialog.setFields();
    }
    ComboBox {
        anchors.top: parent.top
        anchors.left: but.right
        anchors.right: parent.right
        anchors.margins: 10
    }

    TableModel {
        id: tableModelFirst
        TableModelColumn { display: "id" }
        TableModelColumn { display: "first_name" }
        TableModelColumn { display: "last_name" }
        TableModelColumn { display: "email" }
        TableModelColumn { display: "phone" }
    }
    Item {
        anchors.top: but.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10


        TableView {
            anchors.fill: parent
            columnSpacing: 1
            rowSpacing: 1
            model: tableModelFirst
            delegate: Rectangle {
                implicitWidth: Math.max(100, 20 + innerText.width);
                implicitHeight: 50
                border.width: 1
                Text {
                    id: innerText
                    text: display
                    anchors.centerIn: parent
                }
                MouseArea {
                    anchors.fill:   parent
                    acceptedButtons: Qt.LeftButton
                    onDoubleClicked: dialog.setFields(model.row);
                }
            }

        }
    }
    Dialog {
        id: dialog
        title: but.text
        standardButtons: Dialog.Ok | Dialog.Cancel
        property int param: 0
        property string table: "persons";
        Column {
            anchors.fill: parent
            spacing: 5
            TextField {
                id: first_name
                placeholderText: "Имя"
            }
            TextField {
                id: last_name
                placeholderText: "Фамилия"
            }
            TextField {
                id: email
                placeholderText: "E-mail"
            }
            TextField {
                id: phone
                placeholderText: "Номер телефона"
            }
        }
        onAccepted: {
            var row = getFields();
            try {
                if(param === -1) {
                    db.transaction((tx) => {
                        var obj  = MyJS.addNote(tx, "persons", row);
                        if (obj.rowsAﬀected !== 0) {
                            row.id = obj.insertId
                            tableModelFirst.appendRow(row);
                        }
                    })
                }
                else {
                    db.transaction((tx) => {
                        MyJS.editNote(tx, "persons", param, row, tableModelFirst);
                    })
                }
            }
            catch (err) {
                console.log("Error...", err)
            }
        }
        function setFields(ind=-1) {
            param = ind
            if(ind ===  -1) {
                first_name.text = "";
                last_name.text = "";
                email.text = "";
                phone.text = "";
            }
            else {
                var p = tableModelFirst.rows[ind];
                first_name.text = p.first_name;
                last_name.text = p.last_name;
                email.text = p.email;
                phone.text = p.phone;
            }
            open();
        }
        function getFields() {
            return {
                "first_name": first_name.text,
                "last_name": last_name.text,
                "email": email.text,
                "phone": phone.text
            }
        }
    }
    Component.onCompleted: {
        db = LocalStorage.openDatabaseSync("MY_DB", "1.0", "Домашняя работа №7", 1000);
        try {
            var row = MyJS.createFirstTable();
            db.transaction((tx) => { MyJS.createTable(tx, "persons", row); });
            db.transaction((tx) => { MyJS.addIntoModel(tableModelFirst, MyJS.readNotes(tx, "persons", row)); })
        }
        catch(err) {
            console.log("Error... ", err);
        }
    }
}












