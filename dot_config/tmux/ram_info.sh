#!/usr/bin/env bash
export LC_ALL=en_US.UTF-8

get_ratio()
{
  case $(uname -s) in
    Linux)
      usage="$(free -h | awk 'NR==2 {print $3}')"
      total="$(free -h | awk 'NR==2 {print $2}')"
      formated="${usage}/${total}"
      echo "${formated//i/B}"
      ;;

    Darwin)
      # Get used memory blocks with vm_stat, multiply by page size to get size in bytes, then convert to MiB
      used_mem=$(vm_stat | grep ' active\|wired\|compressor\|speculative' | sed 's/[^0-9]//g' | paste -sd ' ' - | awk -v pagesize=$(pagesize) '{printf "%d\n", ($1+$2+$3+$5) * pagesize / 1048576}')
      total_mem=$(sysctl -n hw.memsize | awk '{print $0/1024/1024/1024 " GB"}')
      if ((used_mem < 1024 )); then
        echo "${used_mem}MB/$total_mem"
      else
        memory=$((used_mem/1024))
        echo "${memory}GB/$total_mem"
      fi
      ;;
  esac
}

echo "RAM $(get_ratio)"
