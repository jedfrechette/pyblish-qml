import QtQuick 2.3
import Pyblish 0.1


Item {
    id: overview

    property string __lastPlugin

    signal exploreInstance(int index)
    signal explorePlugin(int index)

    states: [
        State {
            name: "publishing"
        },

        State {
            name: "finished"
        },

        State {
            name: "initialising"
        },

        State {
            name: "stopping"
        }
    ]

    function setMessage(message) {
        footer.message.text = message
        footer.message.animation.restart()
        footer.message.animation.start()
    }

    TabBar {
        id: tabBar

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        tabs: [
            {
                text: "",
                icon: "logo-white"
            },
            "Terminal"
        ]
    }

    View {
        id: tabView

        anchors.top: tabBar.bottom
        anchors.bottom: footer.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: tabView.margins
        anchors.bottomMargin: 0

        width: parent.width - 10

        elevation: -1

        Row {
            visible: tabBar.currentIndex == 0

            anchors.fill: parent
            anchors.margins: parent.margins

            List {
                model: app.instanceProxy

                width: Math.floor(parent.width / 2.0)  // To keep checkbox border from collapsing
                height: parent.height

                section.property: "object.family"

                onActionTriggered: {
                    if (action.name == "repair")
                        app.repairInstance(index)
                    else if (action.name == "explore")
                        overview.exploreInstance(index)
                }

                onItemClicked: app.toggleInstance(index)
            }

            List {
                model: app.pluginProxy

                width: Math.floor(parent.width / 2.0)
                height: parent.height

                section.property: "object.type"

                onActionTriggered: {
                    if (action.name == "repair")
                        app.repairPlugin(index)
                    else if (action.name == "explore")
                        overview.explorePlugin(index)
                }

                onItemClicked: app.togglePlugin(index)
            }
        }

        Terminal {
            id: terminal

            anchors.fill: parent
            anchors.margins: 2
            
            visible: tabBar.currentIndex == 1
        }

        AwesomeIcon {
            name: "circle-o-notch-rotate"
            anchors.centerIn: parent
            opacity: tabBar.currentIndex == 0 && overview.state == "initialising" ? 1.0 : 0.0
            visible: opacity > 0 ? true : false
        }
    }


    Footer {
        id: footer

        mode: overview.state == "publishing" ? 1 : overview.state == "finished" ? 2 : 0

        width: parent.width
        anchors.bottom: parent.bottom

        onPublish: app.publish()
        onReset: app.reset()
        onStop: app.stop()
        onSave: app.save()
    }

    Connections {
        target: app

        onError: setMessage(message)
        onInfo: setMessage(message)
        // onSaved: setMessage("Saved")

        onStateChanged: {
            if (state == "ready") {
                overview.state = ""
                setMessage("Ready")
            }

            if (state == "initialising") {
                overview.state = "initialising"
                setMessage("Initialising..")
            }

            if (state == "publishing") {
                overview.state = "publishing"
                setMessage("Publishing..")
            }

            if (state == "finished") {
                overview.state = "finished"
                setMessage("Finished..")
            }

            if (state == "stopping") {
                setMessage("Stopping..")
            }

            if (state == "stopped") {
                overview.state = "finished"
                setMessage("Stopped")
            }

            if (state == "dirty") {
                setMessage("Dirty..")
            }
        }
    }
}