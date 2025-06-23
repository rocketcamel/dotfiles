import { GLib, Variable } from "astal";
import GTop from "gi://GTop";

type Snapshot = {
  total: number;
  user: number;
  sys: number;
  idle: number;
};

export function get_cpu_snapshot() {
  const cpu = new GTop.glibtop_cpu();
  GTop.glibtop_get_cpu(cpu);
  return {
    total: cpu.total,
    user: cpu.user + cpu.nice,
    sys: cpu.sys,
    idle: cpu.idle,
  };
}

export function calc_cpu_usage(a: Snapshot, b: Snapshot) {
  const total_diff = b.total - a.total;
  const active_diff = b.user + b.sys - (a.user + a.sys);
  return Math.round(total_diff > 0 ? (100 * active_diff) / total_diff : 0);
}

export function get_ram_info() {
  const mem = new GTop.glibtop_mem();
  GTop.glibtop_get_mem(mem);
  return {
    total: mem.total,
    used: mem.total - mem.free - mem.cached - mem.buffer,
    free: mem.free,
  };
}

export function get_disk_space() {
  const usage = new GTop.glibtop_fsusage();
  GTop.glibtop_get_fsusage(usage, "/");

  const free_bytes = usage.bavail * usage.block_size;
  const free_gib = free_bytes / 1024 ** 3;

  return free_gib.toFixed(2);
}
