# Works on pi (Checked)

# Step 1: chmod +x set_audio_hat.py
# Step 2: sudo ./set_audio_hat.py


import subprocess

# Check if the script is run with superuser privileges
if not subprocess.call(["sudo", "true"]):
    # Use raspi-config non-interactively to set the audio output to the HAT
    command = "sudo raspi-config nonint do_audio 0"
    subprocess.call(command, shell=True)

    # Reboot to apply the changes
    print("Rebooting the Raspberry Pi to apply audio settings...")
    subprocess.call("sudo reboot", shell=True)
else:
    print("Please run this script with superuser privileges (sudo).")