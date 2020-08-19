# Switch SELinux to Permissive Mode if in Enforcing Mode:

(
  selinux=`getenforce`
  if [ "$selinux" == "Enforcing" ]; then
    setenforce 0 2>/dev/null
  fi
)&
