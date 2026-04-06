[.result[] | {
  mac: .mac,
  comment: .comment,
  host: .hostname,
  ip: .ip,
  ipv4: [.host.l3connectivities[] | select(.af == "ipv4") | .addr] | join(";"),
  ipv6: [.host.l3connectivities[] | select(.af == "ipv6") | .addr] | join(";"),
  active:    .host.active,
  persist:   .host.persistent,
  vendor:    .host.vendor_name,
  host_typ:  .host.host_type,
  interface: .host.interface
}
]
