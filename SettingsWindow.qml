/*
* Copyright (C) 2016 - 2017 Adrian Verban <verbanady@gmail.com>
* Maintainers: Adrian Verban <verbanady@gmail.com>
* Derived from Typhoon by Archisman Panigrahi which is based on Stormcloud by Jono Cooper <jonocooper.com>
* Thanks to all the contributors.
* Using the Ubuntu Condensed font.
* This file is part of Cumulus.
#
* Cumulus is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
#
* Cumulus is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
#
* You should have received a copy of the GNU General Public License
* along with Cumulus.  If not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0

Item {
    id: root
    visible: false
    property alias searchLocationAlias: searchLocation
    property alias settingsFlickAlias: settingsFlick
    property alias trayVisible: traySwitch.checked
    property string backgroundColor: util.backgroundColor()
    property string textColor: util.textColor()
    property string speedUnit: util.getWindSpeedUnit()
    property string temperatureUnit: util.getTemperatureUnit()
    property string api: util.getWeatherApi()
    property int settingsItemHeight: 64
    signal locationChanged()
    signal showCredits()

    Rectangle {
        id: settingsOptionsView
        anchors.fill: parent
        color: root.backgroundColor.length > 7 ? "#" + root.backgroundColor.substring(3) : root.backgroundColor

        Flickable {
            id: settingsFlick
            contentHeight: settingsBody.childrenRect.height
            contentWidth: root.width
            width: root.width
            height: root.height

            Rectangle {
                id: settingsBody
                width: settingsFlick.width
                height: settingsFlick.height
                color: "transparent"

                //Search for location
                SettingsOptionItem {
                    id: locationSearchItem
                    optionText: "Location"
                    backgroundColor: "#ffffff"
                    anchors.top: settingsBody.top
                    height: root.settingsItemHeight
                    width: settingsBody.width
                    iconUrl: "icons/map.svg"
                    onClicked: {
                        if (searchLocation.visible == true)
                            searchLocation.visible = false
                        else
                            searchLocation.visible = true
                        searchLocation.focus = true
                    }
                }

                SearchLocation {
                    id: searchLocation
                    anchors.top: locationSearchItem.bottom
                    height: settingsBody.height - locationSearchItem.height
                    width: settingsBody.width
                    visible: false
                    backgroundColor: root.backgroundColor
                    textColor: root.textColor

                    Keys.onEscapePressed: {
                        searchLocation.visible = false
                    }
                    Keys.onBackPressed: {
                        searchLocation.visible = false
                    }
                    onVisibleChanged: {
                        if(searchLocation.visible == false) {
                            root.focus = true
                            tempUnitItem.anchors.top = locationSearchItem.bottom
                            locationSearchItem.bottomBorderVisibility = true
                        }
                        else {
                            tempUnitItem.anchors.top = searchLocation.bottom
                            locationSearchItem.bottomBorderVisibility = false
                        }
                    }
                    onLocationSelected: {
                        root.locationChanged()
                        searchLocation.visible = false
                    }
                }

                SettingsOptionItem {
                    id: tempUnitItem
                    optionText: "Temperature Unit"
                    backgroundColor: "#ffffff"
                    anchors.top: locationSearchItem.bottom
                    height: root.settingsItemHeight
                    width: settingsBody.width
                    iconUrl: "icons/temperature-icon.png"
                    onClicked: {
                        if (tempUnitSelect.visible == false) {
                            tempUnitSelect.currentIndex = tempUnitSelect.find(util.temperatureUnitSymbol().trim())
                            tempUnitSelect.visible = true
                        }
                        else {
                            tempUnitSelect.visible = false
                        }
                    }
                }

                ComboBox {
                    id: tempUnitSelect
                    anchors.top: tempUnitItem.bottom
                    anchors.topMargin: 5
                    width: tempUnitItem.width / 2
                    anchors.left: parent.left
                    anchors.leftMargin: width / 2
                    visible: false
                    model: [ "°F", "°C" ]
                    //                    model: [ "°F", "°C", "°K" ]
                    onVisibleChanged: {
                        if(tempUnitSelect.visible == false) {
                            speedUnitItem.anchors.top = tempUnitItem.bottom
                            speedUnitItem.anchors.topMargin = 0
                            tempUnitItem.bottomBorderVisibility = true
                        }
                        else {
                            speedUnitItem.anchors.top = tempUnitSelect.bottom
                            speedUnitItem.anchors.topMargin = 5
                            tempUnitItem.bottomBorderVisibility = false
                        }
                    }
                    onCurrentIndexChanged: {
                        if (visible == true) {
                            switch (currentIndex) {
                            case 0:
                                root.temperatureUnit = "f"
                                break;
                            case 1:
                                root.temperatureUnit = "c"
                                break;
                            default:
                                root.temperatureUnit = "k"
                                break;
                            }
                        }
                    }
                }

                SettingsOptionItem {
                    id: speedUnitItem
                    optionText: "Speed Unit"
                    backgroundColor: "#ffffff"
                    anchors.top: tempUnitItem.bottom
                    height: root.settingsItemHeight
                    width: settingsBody.width
                    iconUrl: "icons/speed-icon.png"
                    onClicked: {
                        if (speedUnitSelect.visible == false) {
                            speedUnitSelect.currentIndex = speedUnitSelect.find(util.speedUnitSymbol().trim())
                            speedUnitSelect.visible = true
                        }
                        else {
                            speedUnitSelect.visible = false
                        }
                    }
                }

                ComboBox {
                    id: speedUnitSelect
                    anchors.top: speedUnitItem.bottom
                    anchors.topMargin: 5
                    width: tempUnitItem.width / 2
                    anchors.left: parent.left
                    anchors.leftMargin: width / 2
                    visible: false
                    model: [ "MPH", "Km/h", "m/s" ]
                    onVisibleChanged: {
                        if(speedUnitSelect.visible == false) {
                            colorPalettesItem.anchors.top = speedUnitItem.bottom
                            colorPalettesItem.anchors.topMargin = 0
                            speedUnitItem.bottomBorderVisibility = true
                        }
                        else {
                            colorPalettesItem.anchors.top = speedUnitSelect.bottom
                            colorPalettesItem.anchors.topMargin = 5
                            speedUnitItem.bottomBorderVisibility = false
                        }
                    }
                    onCurrentIndexChanged: {
                        if (visible == true) {
                            switch (currentIndex) {
                            case 0:
                                root.speedUnit = "mph"
                                break;
                            case 1:
                                root.speedUnit = "kph"
                                break;
                            default:
                                root.speedUnit = "m/s"
                                break;
                            }
                        }
                    }
                }

                SettingsOptionItem {
                    id: colorPalettesItem
                    optionText: "Colors"
                    backgroundColor: "#ffffff"
                    anchors.top: speedUnitItem.bottom
                    height: root.settingsItemHeight
                    width: settingsBody.width
                    iconUrl: "icons/palette.png"
                    onClicked: {
                        if (colorButtonsLayout.visible == false) {
                            colorButtonsLayout.visible = true
                        }
                        else {
                            colorButtonsLayout.visible = false
                        }
                    }
                    bottomBorderVisibility: true
                }

                GridLayout {
                    id: colorButtonsLayout
                    columns: 2
                    anchors.top: colorPalettesItem.bottom
                    width: settingsBody.width * 80 / 100
                    anchors.left: parent.left
                    anchors.leftMargin: (settingsBody.width - width) / 2
                    visible: false
                    ColorPalleteButton {
                        id: bgColorButton
                        Layout.fillHeight: false
                        Layout.fillWidth: true
                        Layout.preferredHeight: 70
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                        text: "Background"
                        textColor: root.textColor
                        backgroundColor: root.backgroundColor
                        onClicked: {
                            colorDialog.purpose = "background"
                            colorDialog.showAlphaChannel = true
                            colorDialog.color = util.backgroundColor()
                            colorDialog.visible = true
                        }
                    }
                    ColorPalleteButton {
                        id: txtColorButton
                        Layout.fillHeight: false
                        Layout.fillWidth: true
                        Layout.preferredHeight: 70
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                        text: "Text"
                        textColor: root.textColor
                        backgroundColor: root.textColor
                        onClicked: {
                            colorDialog.purpose = "text"
                            colorDialog.color = util.textColor()
                            colorDialog.visible = true
                        }
                    }
                    onVisibleChanged: {
                        if(colorButtonsLayout.visible == false) {
                            apiSelectItem.anchors.top = colorPalettesItem.bottom
                            apiSelectItem.anchors.topMargin = 0
                            colorPalettesItem.bottomBorderVisibility = true
                        }
                        else {
                            apiSelectItem.anchors.top = colorButtonsLayout.bottom
                            apiSelectItem.anchors.topMargin = 5
                            colorPalettesItem.bottomBorderVisibility = false
                        }
                    }
                }

                SettingsOptionItem {
                    id: apiSelectItem
                    optionText: "API"
                    backgroundColor: "#ffffff"
                    anchors.top: colorPalettesItem.bottom
                    height: root.settingsItemHeight
                    width: settingsBody.width
                    iconUrl: "icons/api.png"
                    onClicked: {
                        if (apiSelect.visible == false) {
                            apiSelect.visible = true
                        }
                        else {
                            apiSelect.visible = false
                        }
                    }
                }

                ComboBox {
                    id: apiSelect
                    anchors.top: apiSelectItem.bottom
                    anchors.topMargin: 5
                    width: Math.round(apiSelectItem.width * 60 / 100)
                    anchors.left: parent.left
                    anchors.leftMargin: (parent.width - apiSelect.width) / 2
                    visible: false
                    model: ["Open Weather Map", "Yahoo! Weather"]
                    onCurrentIndexChanged: {
                        if (visible == true) {
                            switch (currentIndex) {
                            case 1:
                                root.api = "y"
                                break;
                            default:
                                root.api = "owm"
                                break;
                            }
                        }
                    }
                    onVisibleChanged: {
                        if(apiSelect.visible == false) {
                            creditsItem.anchors.top = apiSelectItem.bottom
                            creditsItem.anchors.topMargin = 0
                            apiSelectItem.bottomBorderVisibility = true
                        }
                        else {
                            creditsItem.anchors.top = apiSelect.bottom
                            creditsItem.anchors.topMargin = 5
                            apiSelectItem.bottomBorderVisibility = false
                        }
                    }
                }
                Component.onCompleted: {
                    if (util.getWeatherApi() == "y") {
                        apiSelect.currentIndex = 1
                    }
                    else {
                        apiSelect.currentIndex = 0
                    }
                }

                SettingsOptionItem {
                    id: creditsItem
                    optionText: "Credits"
                    backgroundColor: "#ffffff"
                    anchors.top: apiSelectItem.bottom
                    height: root.settingsItemHeight
                    width: settingsBody.width
                    iconUrl: "icons/credits.png"
                    bottomBorderVisibility: false
                    onClicked: root.showCredits()
                }

                RowLayout {
                    id: traySwitchLayout
                    anchors.top: creditsItem.bottom
                    width: settingsBody.width * 80 / 100
                    height: 50
                    anchors.left: parent.left
                    anchors.leftMargin: (settingsBody.width - traySwitchLayout.width) / 2
                    visible: util.osType() === "android" ? false : true
                    Text {
                        text: "Enable Tray"
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        Layout.alignment: Qt.AlignCenter
                        visible: util.osType() === "android" ? false : true
                    }
                    Switch {
                        id: traySwitch
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignCenter
                        checked: util.trayVisibility()
                        visible: util.osType() === "android" ? false : true
                    }
                }
            }
        }
    }
    ColorDialog {
        id: colorDialog
        title: "Please choose a color"
        showAlphaChannel: true
        modality: Qt.ApplicationModal
        property string purpose
        onVisibleChanged: visible == false ? root.focus = true : root.focus = false
        onAccepted: {
            if (purpose == "background") {
                root.backgroundColor = currentColor
            }
            else {
                root.textColor = currentColor
            }
        }
    }
}

