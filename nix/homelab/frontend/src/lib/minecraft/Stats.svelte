<script lang="ts">
  import { createQuery } from "@tanstack/svelte-query";
  import { fetchStats } from "./stats";
  import { LoaderCircle } from "@lucide/svelte";
  import {
    formatDistance,
    formatDistanceToNow,
    formatDuration,
    intervalToDuration,
  } from "date-fns";

  const query = createQuery(() => ({
    queryKey: ["minecraft-server-stats"],
    queryFn: () => fetchStats(),
    refetchInterval: 10000,
    staleTime: 5000,
  }));

  const formatUptime = () => {
    if (!query.data) {
      return "--";
    }
    const started_at = query.data.uptime.started_at;
    const duration = intervalToDuration({ start: started_at, end: new Date() });
    $inspect(duration);
    if (!duration.days && (duration.hours ?? 0) < 1) {
      return formatDistanceToNow(new Date(query.data.uptime.started_at));
    }
    return formatDuration(duration, {
      format: ["days", "hours", "minutes"],
    });
  };
</script>

{#snippet statItem(label: string, value?: string | number)}
  <div class="bg-zinc-700 rounded p-3">
    <div class="text-sm">{label}</div>
    <div class="text-xl text-white">{value}</div>
  </div>
{/snippet}

<div class="border border-zinc-600 rounded-lg p-4">
  <h3 class="text-lg font-medium mb-3">
    Server Stats {#if query.isError}
      <span class="ml-1 text-sm text-red-500"
        >an error occured fetching server stats</span
      >
    {:else if query.isPending}
      <LoaderCircle class="ml-1 w-4 h-4 inline-block animate-spin" />
    {/if}
  </h3>
  <div class="grid grid-cols-2 gap-4 text-zinc-400">
    {@render statItem("Players Online", query.data?.players_online ?? "--")}
    {@render statItem("Server Status", query.data?.status ?? "--")}
    {@render statItem("Uptime", formatUptime())}
    {@render statItem("World Size", query.data?.world_size ?? "--")}
  </div>
</div>
