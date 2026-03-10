#!/usr/bin/env bash
#
# Verifies whether a set of ports are open on a remote host, and if not, what process is using them.

ip=127.0.0.1
ports=(
  9080
  9080
  9090
)


ssh_host="$ip"          # adjust if you use user@host
ssh_user=""             # leave empty if default user works
ssh_target="${ssh_user:+$ssh_user@}$ssh_host"

# Quick reconnect?
control_path="/tmp/ssh-ctrl-$RANDOM.sock"
ssh_opts=(
  -o ControlMaster=auto
  -o ControlPath="$control_path"
  -o ControlPersist=60
  -o BatchMode=yes
  -o ConnectTimeout=2
)

# Master SSH session makes program faster
cleanup() {
    ssh -O exit "$ssh_target" 2>/dev/null || true
    rm -f "$control_path"
}
trap cleanup EXIT
ssh -MNf "${ssh_opts[@]}" "$ssh_target"


printf "%-10s | %-15s | %-30s | %s\n" "PORT" "STATUS" "REMOTE PROCESS" "NC RESULT"
printf "%-10s-+-%-15s-+-%-30s-+-%s\n" "----------" "---------------" "------------------------------" "-------------------------"


for port in "${ports[@]}"; do

  # Check if port is busy on remote host
  busy_info=$(ssh "${ssh_opts[@]}" "$ssh_target" "ss -tulnp | grep -w '\S*:$port' || true")

  # If port busy, extract futher info 
  if [ -n "$busy_info" ]; then
    proc_info=$(echo "$busy_info" | sed -n 's/.*users:(("\([^"]*\)",pid=\([0-9]*\).*/\1 (pid \2)/p')
    docker_info=$(ssh "$ssh_target" "docker ps --filter 'publish=$port' --format '{{.Image}} (docker)' | sed 's/:.* / /'")
    if [ -n "$docker_info" ]; then
      proc_info="$docker_info"
    fi

    # No listener to start if port busy
    listener_pid="" 
    remote_status="BUSY"

  # If port free, start nc listener there. Not super robust: if nc fails to start, we won't detect that
  else
    listener_pid=$(ssh "$ssh_target" "nohup nc -l -p $port >/dev/null 2>&1 </dev/null & echo \$!")
    proc_info="nc (pid:$listener_pid)"
    remote_status="LISTENING" 
  fi

  # Attempt to connect to the listening nc  we just lifted
  nc_out=$(nc -vz -w 1 "$ip" "$port" 2>&1 | tr '\n' ' ')
  if [[ $nc_out =~ "timed out" ]]; then
    remote_status="UNREACHABLE"
  fi

  printf "%-10s | %-15s | %-30s | %s\n" "$port" "$remote_status" "$proc_info" "$nc_out"

  # Clean up temporary listener if we started one 
  if [ -n "$listener_pid" ]; then
    ssh "$ssh_target" "kill $listener_pid 2>/dev/null || true"
  fi

done
