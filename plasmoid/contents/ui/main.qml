import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0

Item{
	//Plasmoid.preferredRepresentation : Plasmoid.fullRepresentation
    id: root
    property var script_path: "/usr/local/bin/ideapad5_14are05_energy_mgmt.sh"

Plasmoid.fullRepresentation: RowLayout {
	id : fullRep

	GroupBox
	{
		title: "Charging"
		ColumnLayout {
			PlasmaComponents.CheckBox {
				id: battConserv
				text: i18n("Battery conservation")
				checked: false
				onClicked: executor.exec('sudo '+root.script_path+' batt_conserv ' + (checked ? "on" : "off"));
			}
			PlasmaComponents.CheckBox {
				id: rapidCharge
				text: i18n("Rapid charge")
				checked: false
				onClicked: executor.exec('sudo '+root.script_path+' rapid_charge ' + (checked ? "on" : "off"));
			}
		}
	}
	GroupBox
	{
		title: "Performance Mode"
		ColumnLayout {
			ExclusiveGroup { id: perfModeGroup }
			PlasmaComponents.RadioButton {
				id: intel
				text: i18n("Intelligent cooling")
				checked: true
				exclusiveGroup: perfModeGroup
				onClicked: 
				{
					if (checked) executor.exec('sudo '+root.script_path+' perf_mode intel');
				}
			}
			PlasmaComponents.RadioButton {
				id: perf
				text: i18n("Extreme Performance")
				exclusiveGroup: perfModeGroup
				onClicked: 
				{
					if (checked) executor.exec('sudo '+root.script_path+' perf_mode perf');
				}
			}
			PlasmaComponents.RadioButton {
				id: save
				text: i18n("Battery Saving")
				exclusiveGroup: perfModeGroup
				onClicked: 
				{
					if (checked) executor.exec('sudo '+root.script_path+' perf_mode save');
				}
			}
		}
	}

	function updatePerfMode()
	{
	    executor.exec('sudo '+root.script_path+' perf_mode', function(md){
		    md = md.trim();
		    if (md == "intel") 
			    perfModeGroup.current = intel;
		    else if (md == "perf") 
			    perfModeGroup.current = perf;
		    else if (md == "save") 
			    perfModeGroup.current = save;
	    });
	}

	function updateRapidCharge()
	{
	    executor.exec('sudo '+root.script_path+' rapid_charge', function(md){
		    md = md.trim();
		    rapidCharge.checked = md == "on";
	    });
	}

	function updateBattConserv()
	{
	    executor.exec('sudo '+root.script_path+' batt_conserv', function(md){
		    md = md.trim();
		    battConserv.checked = md == "on";
	    });
	}

    function updateStates()
    {
	    updatePerfMode();
	    updateRapidCharge();
	    updateBattConserv();
    }

    PlasmaCore.DataSource {
	    id: executor
	    engine: "executable"
	    connectedSources: []
	    property var callbacks: ({})
	    property var queue: ([])

	    onNewData: {
		    var stdout = data["stdout"]

		    if (callbacks[sourceName] !== undefined) {
			    callbacks[sourceName](stdout);
		    }

		    exited(sourceName, stdout)
		    disconnectSource(sourceName) // cmd finished

		    queue.shift();
		    exec_next();
	    }

	    function exec(cmd, onNewDataCallback) {
		    queue.push({cmd: cmd, cb :onNewDataCallback});
		    if (queue.length == 1)
			    exec_next();
	    }

	    function exec_next() {
		    if (queue.length == 0)
			    return;

		    var item = queue[0];
		    if (item.cb !== undefined){
			    callbacks[item.cmd] = item.cb
		    }
		    connectSource(item.cmd)
	    }

	    signal exited(string sourceName, string stdout)

    }

    Timer {
        interval: 800
        running: plasmoid.expanded
        repeat: true
        onTriggered: updateStates()
    }
}
}
