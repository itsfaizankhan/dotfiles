#!/bin/bash

# Taken from bash script: https://gist.github.com/sanskar10100/fa2eb78bcf431cec28dde509dd797288
bt_device_name=$(pactl list cards | grep -B 20 "device.form_factor = \"headset\"" | grep "Name" | awk '{print $2}')

bt_active_profile=$(pactl list cards | grep -A 40 "Name: $bt_device_name" | grep "Active Profile" | cut -d ' ' -f3)

if [ "$bt_active_profile" == "a2dp-sink" ]; then
	pactl set-card-profile "$bt_device_name" headset-head-unit-msbc
else
	pactl set-card-profile "$bt_device_name" a2dp-sink
fi
