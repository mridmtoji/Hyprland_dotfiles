pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
    readonly property string time: {
        Qt.formatDateTime(clock.date, "HH:mm | ddd, MMM d")
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
