
# 关闭防火墙
systemctl stop firewalld && systemctl disable firewalld && iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X && ufw disable
