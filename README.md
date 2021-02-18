# Dockerfile-Prometheus_Normal_Exporter
Make Prometheus node exporter, blackbox exporter, and SNMP exporter as an image

## Description
An container image for running Prometheus node exporter, blackbox exporter, and SNMP exporter and let you can run there three services in one container or more. So that you can manage your exporter more easily.

## Run
### Docker
You can run the image by using `docker` command. To use `-p` option to expose the service.

`docker run -p 9100:9100/tcp -p 9100:9100/tcp -p 9100:9100/tcp chouhongming/prometheus-normal-exporter`

Also, you must use `-v` option to mount the configure file if you have your own blackbox exporter and SNMP exporter settings.

`docker run -p 9100:9100/tcp -p 9100:9100/tcp -p 9100:9100/tcp -v ./blackbox_exporter.yml:/etc/blackbox_exporter/blackbox_exporter.yml -v ./snmp_exporter.yml:/etc/snmp_exporter/snmp_exporter.yml chouhongming/prometheus-normal-exporter`

### Docker Compose
You can use the `docker-compose.yml` file to run the service easily. Due to the different directory structure, you may need to change your working directory to example directory or use `-f` option to start the service.

`docker-compose -f example/docker-compose.yml up -d`

The command for stopping the service, if you use `-f` option to start the service.

`docker-compose -f example/docker-compose.yml down`

And you can use exec action to login to the container to run the command that you want.

`docker-compose -f example/docker-compose.yml exec server bash`

If you want to rebuild the image, you can replace `image: chouhongming/prometheus-normal-exporter` with `build: ..` and run the `docker-compose` with `--build` option, for example:

```
version: "3.7"
services:
  core:
    build: ..
    ports:
      - "9100:9100/tcp"
      - "9115:9115/tcp"
      - "9116:9116/tcp"
```

`docker-compose -f example/docker-compose.yml up -d --build`

### Kubernetes
You can copy the `k8s-resource.yml` file and replace the word `[YOUR_K8S_NAMESPACE]` with the namespace that you want to apply the service.

After your done the `k8s-resource.yml` file, you can apply to the Kubernetes cluster.

`kubectl apply -f k8s-resource.yml`

## Volume
- /etc/blackbox_exporter/blackbox_exporter.yml

    To import your own blackbox exporter settings. You can edit the example for the specific service and mount it again.

- /etc/snmp_exporter/snmp_exporter.yml

    To import your own SNMP exporter settings. You can edit the example for the specific SNMP device and mount it again.

## Environment
- NODE_EXPORTER=true

    Set `ture` to enable node exporter.

- BLACKBOX_EXPORTER=true

    Set `ture` to enable blackbox exporter. If you don't provide the blackbox exporter settings or you mount it in the wrong path, it may set to `false` automatically or run with default settings.

- SNMP_EXPORTER=true

    Set `ture` to enable SNMP exporter. If you don't provide the SNMP exporter settings or you mount it in the wrong path, it may set to `false` automatically or run with default settings.

- TIMEZONE=UTC

    Set the timezone in the container.

- NODE_EXPORTER_OPT=

    Provide more option/parameter when the node exporter startup.
    There is the option that the node exporter can use:

    ```
    usage: node_exporter [<flags>]

    Flags:
    -h, --help                    Show context-sensitive help (also try --help-long and --help-man).
        --collector.cpu.info      Enables metric cpu_info
        --collector.diskstats.ignored-devices="^(ram|loop|fd|(h|s|v|xv)d[a-z]|nvme\\d+n\\d+p)\\d+$"  
                                    Regexp of devices to ignore for diskstats.
        --collector.filesystem.ignored-mount-points="^/(dev|proc|sys|var/lib/docker/.+)($|/)"  
                                    Regexp of mount points to ignore for filesystem collector.
        --collector.filesystem.ignored-fs-types="^(autofs|binfmt_misc|bpf|cgroup2?|configfs|debugfs|devpts|devtmpfs|fusectl|hugetlbfs|iso9660|mqueue|nsfs|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|selinuxfs|squashfs|sysfs|tracefs)$"  
                                    Regexp of filesystem types to ignore for filesystem collector.
        --collector.netclass.ignored-devices="^$"  
                                    Regexp of net devices to ignore for netclass collector.
        --collector.netdev.device-blacklist=COLLECTOR.NETDEV.DEVICE-BLACKLIST  
                                    Regexp of net devices to blacklist (mutually exclusive to device-whitelist).
        --collector.netdev.device-whitelist=COLLECTOR.NETDEV.DEVICE-WHITELIST  
                                    Regexp of net devices to whitelist (mutually exclusive to device-blacklist).
        --collector.netstat.fields="^(.*_(InErrors|InErrs)|Ip_Forwarding|Ip(6|Ext)_(InOctets|OutOctets)|Icmp6?_(InMsgs|OutMsgs)|TcpExt_(Listen.*|Syncookies.*|TCPSynRetrans)|Tcp_(ActiveOpens|InSegs|OutSegs|PassiveOpens|RetransSegs|CurrEstab)|Udp6?_(
    InDatagrams|OutDatagrams|NoPorts|RcvbufErrors|SndbufErrors))$"  
                                    Regexp of fields to return for netstat collector.
        --collector.ntp.server="127.0.0.1"  
                                    NTP server to use for ntp collector
        --collector.ntp.protocol-version=4  
                                    NTP protocol version
        --collector.ntp.server-is-local  
                                    Certify that collector.ntp.server address is not a public ntp server
        --collector.ntp.ip-ttl=1  IP TTL to use while sending NTP query
        --collector.ntp.max-distance=3.46608s  
                                    Max accumulated distance to the root
        --collector.ntp.local-offset-tolerance=1ms  
                                    Offset between local clock and local ntpd time to tolerate
        --path.procfs="/proc"     procfs mountpoint.
        --path.sysfs="/sys"       sysfs mountpoint.
        --path.rootfs="/"         rootfs mountpoint.
        --collector.perf.cpus=""  List of CPUs from which perf metrics should be collected
        --collector.perf.tracepoint=COLLECTOR.PERF.TRACEPOINT ...  
                                    perf tracepoint that should be collected
        --collector.powersupply.ignored-supplies="^$"  
                                    Regexp of power supplies to ignore for powersupplyclass collector.
                                    test fixtures to use for qdisc collector end-to-end testing
        --collector.runit.servicedir="/etc/service"  
                                    Path to runit service directory.
        --collector.supervisord.url="http://localhost:9001/RPC2"  
                                    XML RPC endpoint.
        --collector.systemd.unit-whitelist=".+"  
                                    Regexp of systemd units to whitelist. Units must both match whitelist and not match blacklist to be included.
        --collector.systemd.unit-blacklist=".+\\.(automount|device|mount|scope|slice)"  
                                    Regexp of systemd units to blacklist. Units must both match whitelist and not match blacklist to be included.
        --collector.systemd.enable-task-metrics  
                                    Enables service unit tasks metrics unit_tasks_current and unit_tasks_max
        --collector.systemd.enable-restarts-metrics  
                                    Enables service unit metric service_restart_total
        --collector.systemd.enable-start-time-metrics  
                                    Enables service unit metric unit_start_time_seconds
        --collector.textfile.directory=""  
                                    Directory to read text files with metrics from.
        --collector.vmstat.fields="^(oom_kill|pgpg|pswp|pg.*fault).*"  
                                    Regexp of fields to return for vmstat collector.
        --collector.wifi.fixtures=""  
                                    test fixtures to use for wifi collector metrics
        --collector.arp           Enable the arp collector (default: enabled).
        --collector.bcache        Enable the bcache collector (default: enabled).
        --collector.bonding       Enable the bonding collector (default: enabled).
        --collector.btrfs         Enable the btrfs collector (default: enabled).
        --collector.buddyinfo     Enable the buddyinfo collector (default: disabled).
        --collector.conntrack     Enable the conntrack collector (default: enabled).
        --collector.cpu           Enable the cpu collector (default: enabled).
        --collector.cpufreq       Enable the cpufreq collector (default: enabled).
        --collector.diskstats     Enable the diskstats collector (default: enabled).
        --collector.drbd          Enable the drbd collector (default: disabled).
        --collector.edac          Enable the edac collector (default: enabled).
        --collector.entropy       Enable the entropy collector (default: enabled).
        --collector.filefd        Enable the filefd collector (default: enabled).
        --collector.filesystem    Enable the filesystem collector (default: enabled).
        --collector.hwmon         Enable the hwmon collector (default: enabled).
        --collector.infiniband    Enable the infiniband collector (default: enabled).
        --collector.interrupts    Enable the interrupts collector (default: disabled).
        --collector.ipvs          Enable the ipvs collector (default: enabled).
        --collector.ksmd          Enable the ksmd collector (default: disabled).
        --collector.loadavg       Enable the loadavg collector (default: enabled).
        --collector.logind        Enable the logind collector (default: disabled).
        --collector.mdadm         Enable the mdadm collector (default: enabled).
        --collector.meminfo       Enable the meminfo collector (default: enabled).
        --collector.meminfo_numa  Enable the meminfo_numa collector (default: disabled).
        --collector.mountstats    Enable the mountstats collector (default: disabled).
        --collector.netclass      Enable the netclass collector (default: enabled).
        --collector.netdev        Enable the netdev collector (default: enabled).
        --collector.netstat       Enable the netstat collector (default: enabled).
        --collector.nfs           Enable the nfs collector (default: enabled).
        --collector.nfsd          Enable the nfsd collector (default: enabled).
        --collector.ntp           Enable the ntp collector (default: disabled).
        --collector.perf          Enable the perf collector (default: disabled).
        --collector.powersupplyclass  
                                    Enable the powersupplyclass collector (default: enabled).
        --collector.pressure      Enable the pressure collector (default: enabled).
        --collector.processes     Enable the processes collector (default: disabled).
        --collector.qdisc         Enable the qdisc collector (default: disabled).
        --collector.rapl          Enable the rapl collector (default: enabled).
        --collector.runit         Enable the runit collector (default: disabled).
        --collector.schedstat     Enable the schedstat collector (default: enabled).
        --collector.sockstat      Enable the sockstat collector (default: enabled).
        --collector.softnet       Enable the softnet collector (default: enabled).
        --collector.stat          Enable the stat collector (default: enabled).
        --collector.supervisord   Enable the supervisord collector (default: disabled).
        --collector.systemd       Enable the systemd collector (default: disabled).
        --collector.tcpstat       Enable the tcpstat collector (default: disabled).
        --collector.textfile      Enable the textfile collector (default: enabled).
        --collector.thermal_zone  Enable the thermal_zone collector (default: enabled).
        --collector.time          Enable the time collector (default: enabled).
        --collector.timex         Enable the timex collector (default: enabled).
        --collector.udp_queues    Enable the udp_queues collector (default: enabled).
        --collector.uname         Enable the uname collector (default: enabled).
        --collector.vmstat        Enable the vmstat collector (default: enabled).
        --collector.wifi          Enable the wifi collector (default: disabled).
        --collector.xfs           Enable the xfs collector (default: enabled).
        --collector.zfs           Enable the zfs collector (default: enabled).
        --web.listen-address=":9100"  
                                    Address on which to expose metrics and web interface.
        --web.telemetry-path="/metrics"  
                                    Path under which to expose metrics.
        --web.disable-exporter-metrics  
                                    Exclude metrics about the exporter itself (promhttp_*, process_*, go_*).
        --web.max-requests=40     Maximum number of parallel scrape requests. Use 0 to disable.
        --collector.disable-defaults  
                                    Set all collectors to disabled by default.
        --web.config=""           [EXPERIMENTAL] Path to config yaml file that can enable TLS or authentication.
        --log.level=info          Only log messages with the given severity or above. One of: [debug, info, warn, error]
        --log.format=logfmt       Output format of log messages. One of: [logfmt, json]
        --version                 Show application version.
    ```

- BLACKBOX_EXPORTER_OPT=

    Provide more option/parameter when the blackbox exporter startup.
    There is the option that the blackbox exporter can use:

    ```
    usage: blackbox_exporter [<flags>]

    Flags:
    -h, --help                     Show context-sensitive help (also try --help-long and --help-man).
        --config.file="blackbox.yml"  
                                    Blackbox exporter configuration file.
        --web.listen-address=":9115"  
                                    The address to listen on for HTTP requests.
        --timeout-offset=0.5       Offset to subtract from timeout in seconds.
        --config.check             If true validate the config file and then exit.
        --history.limit=100        The maximum amount of items to keep in the history.
        --web.external-url=<url>   The URL under which Blackbox exporter is externally reachable (for example, if Blackbox exporter is served via a reverse proxy). Used for generating relative and absolute links back to Blackbox exporter itself. If
                                    the URL has a path portion, it will be used to prefix all HTTP endpoints served by Blackbox exporter. If omitted, relevant URL components will be derived automatically.
        --web.route-prefix=<path>  Prefix for the internal routes of web endpoints. Defaults to path of --web.external-url.
        --log.level=info           Only log messages with the given severity or above. One of: [debug, info, warn, error]
        --log.format=logfmt        Output format of log messages. One of: [logfmt, json]
        --version                  Show application version.
    ```

- SNMP_EXPORTER_OPT=

    Provide more option/parameter when the SNMP exporter startup.
    There is the option that the SNMP exporter can use:

    ```
    usage: snmp_exporter [<flags>]
    
    Flags:
    -h, --help                    Show context-sensitive help (also try --help-long and --help-man).
        --snmp.wrap-large-counters  
                                    Wrap 64-bit counters to avoid floating point rounding.
        --config.file="snmp.yml"  Path to configuration file.
        --web.listen-address=":9116"  
                                    Address to listen on for web interface and telemetry.
        --dry-run                 Only verify configuration is valid and exit.
        --log.level=info          Only log messages with the given severity or above. One of: [debug, info, warn, error]
        --log.format=logfmt       Output format of log messages. One of: [logfmt, json]
    ```

