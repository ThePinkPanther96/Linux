## Introduction
Audit configuration is managed in a single file, while rules are handled in a separate file. Although the default settings should be sufficient for most requirements, you can customize the system by using the following command.

## Requirements 
- Ubuntu 18.04 or higher
- At least 10BG Storage 
- Inbound port 22 (SSH).

## Configuration
1. Install auditd:
   ```
   apt-get install -y auditd 
   ```
2. Start and enable auditd service:
   ``` 
   systemctl start auditd
   systemctl enable auditd
   ```

## Edit the configuration file *(optional)*
The configuration of auditd is handled in a single file (where as rules are handled in a separate file). However, the default file should suffice for most needs.

- The location of the log file is configured in this entry ```log_file = /var/log/audit/audit.log```.
- The number of logs to be retained on the server is configured in this entry ```num_logs = 5```.
- Configure the maximum log file size (in MB) in this entry ```max_log_file = 8```.

### Let's break it down 
1. Enter the file:
   ```
   vi /etc/audit/auditd.conf
   ``` 
2. Configure the path for the log file:
   ```
   log_file = /var/log/audit/audit.log
   ```
3. The number of logs retained on the server:
   ```
   num_logs = 5
   ```
4. Set the maximum log file size: 
   *NOTE!* Maximum log file size is in **MB**.
   ```
   max_log_file = 8
   ```
   *NOTE!* If you make any changes to the configuration file, you will have to restart the service:
   ```
   systemctl restart auditd
   ```
## Creating autid rules
1. Use this command to check you already have rules that are confiured:
   ```
   auditctl -l
   ```
2. To Cconfigure audit rules enter ```audit.rules```:
   ```
   vi /etc/audit/rules.d/audit.rules
   ```
3. The rules are configured as such; The rule pattern will look like the following example:
   *NOTE* If a rule is set for a directory it will affect it's child items as well.
   ```
   -w /file/or/directory/path -p <permissions> -k <key name>
   ```
### Let's break the above lines:
- -w is the path to watch
- -p is the permissions to monitor
- -k is the key name for the rule

### The permissions will be configured like this:
- -r - read
- -w - write
- -x - execute
- -a - change in the file's attribute (either ownership or permissions)
  
## Viewing the auditd log file
   You can view every entry in the auditd log by using the following:
   ```
   less /var/log/audit/audit.log
   ```
   
   To view a log for a specific audit use the following command:
   
   ```
   ausearch -k passwd
   ```

I trust this guide equips you with the essential information to commence your project.
Should you have any inquiries or suggestions, please don't hesitate to reach out to me.
Many thanks! 😊