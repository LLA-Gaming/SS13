var/going = 1.0 // ticker pregame countdown
var/master_mode = "traitor"//"extended"
var/secret_force_mode = "secret" // if this is anything but "secret", the secret rotation will forceably choose this mode

var/wavesecret = 0 // meteor mode, delays wave progression, terrible name
var/datum/station_state/start_state = null // Used to determine the state of the station
var/datum/station_state/end_state = null // also used to determine the state of the station