pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root
  property string time

  Process {
    id: timeProcess

    command: ["date", "+%H:%M"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: root.time = this.text
    }
  }

  Timer {
    interval: 60000

    running: true
    repeat: true

    onTriggered: timeProcess.running = true
  }
}
