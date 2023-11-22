#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <num_logs> <log_size> <log_file_path>"
    exit 1
fi

num_logs="$1"
log_size="$2"
log_file_path="$3"

# updater server
sudo apt-get -y update 

# Install auditd service
apt-get install -y auditd

# Enable service
systemctl start auditd
systemctl enable auditd

# Update the configuration file with the new values
sed -i "s/^num_logs = .*/num_logs = $num_logs/" /etc/audit/auditd.conf
sed -i "s/^max_log_file = .*/max_log_file = $log_size/" /etc/audit/auditd.conf
sed -i "s|^log_file = .*|log_file = $log_file_path|" /etc/audit/auditd.conf

# Reset the audit service
systemctl restart auditd
echo "Audit service was restarted"

# Show results
echo -e "\e[92mThe following values where configured: \e[0m"
echo -e "\e[94mnum_logs: $num_logs \e[0m"
echo -e "\e[94mlog_size: $log_size \e[0m"
echo -e "\e[94mlog_file_path: $log_file_path \e[0m"

# Show rules (if any)
echo ""
echo -e "\e[92mThe following rules are active: \e[0m"
audit_result=$(auditctl -l)
echo -e "\e[94mAudit rules:\n$audit_result\e[0m"

echo -e "\e[91mFollow the instructions for creating audit rules: \e[0m"

echo "1. Navigate to:"
echo "   /etc/audit/rules.d/audit.rules"
echo ""
echo "2. Build your rules according to this pattern:"
echo "   -w /file/or/directory/path -p <permissions> -k <key name>"
echo "   • -w is the path to watch"
echo "   • -p is the permissions to monitor"
echo "   • -k is the key name for the rule"
echo ""
echo "3. The permissions will be configured as follows:"
echo "   • -r - read"
echo "   • -w - write"
echo "   • -x - execute"
echo "   • -a - change in the file's attribute (either ownership or permissions)"
echo ""
echo "4. Viewing the auditd log file:"
echo "   less /var/log/audit/audit.log"
echo ""
echo "5. To view a log for a specific audit, use the following command:"
echo "   ausearch -k passwd"
echo ""
echo "For more information, refer to:"
echo "https://github.com/ThePinkPanther96/Linux/blob/main/Server%20Tools/File%20Auditing/README.md"
