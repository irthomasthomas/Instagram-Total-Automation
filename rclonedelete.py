import subprocess
command = 'rclone delete googledrive:rclone'
process = subprocess.Popen(command.split(), stdout=subprocess.PIPE)
output, error = process.communicate()
print output