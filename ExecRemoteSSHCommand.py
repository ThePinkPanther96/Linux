
import logging
import paramiko
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__) 


host = "IPAddres"
username = "Username"
command =  "Command"

def ssh_run_remote(host,username,command):

 port = 22

 ssh = paramiko.SSHClient()
 ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
 ssh.connect(host,port, username,key_filename = 'frp.pem')
 ssh.get_transport()

 stdin, stdout, stderr = ssh.exec_command(command) 
 out = stdout.read().decode().strip()
 print(out) 
 error = stderr.read().decode().strip()
 print(error)
 ssh.close()
 
 return out,error 


output = ssh_run_remote(host=host,username = username,command = command)
print (output)


