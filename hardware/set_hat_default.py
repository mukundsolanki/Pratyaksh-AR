import paramiko

# Define your Raspberry Pi's hostname or IP address, username, and password
raspi_host = "raspberrypi"
raspi_username = "pi"
raspi_password = "raspberry"

# Define the command to set the audio output to the HAT
audio_command = "sudo raspi-config nonint do_audio 0"

# Create an SSH client instance
ssh_client = paramiko.SSHClient()
ssh_client.load_system_host_keys()
ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

try:
    # Connect to the Raspberry Pi
    ssh_client.connect(hostname=raspi_host, username=raspi_username, password=raspi_password)

    # Run the audio configuration command
    stdin, stdout, stderr = ssh_client.exec_command(audio_command)
    
    # Wait for the command to finish
    stdout.channel.recv_exit_status()

    # Reboot the Raspberry Pi to apply the changes
    reboot_command = "sudo reboot"
    ssh_client.exec_command(reboot_command)

    print("Audio configuration set to HAT. Raspberry Pi will reboot to apply the changes.")
except Exception as e:
    print(f"Error: {e}")
finally:
    ssh_client.close()

