<script lang="ts">
  import { createQuery } from "@tanstack/svelte-query";
  import { fetchStats } from "./stats";
  import { LoaderCircle } from "@lucide/svelte";

  const query = createQuery(() => ({
    queryKey: ["minecraft-server-stats"],
    queryFn: () => fetchStats(),
    refetchInterval: 10000,
    staleTime: 5000,
  }));
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
      <span class="text-sm text-red-500"
        >an error occured fetching server stats</span
      >
    {:else if query.isPending}
      <LoaderCircle class="ml-1 w-4 h-4 inline-block animate-spin" />
    {/if}
  </h3>
  <div class="grid grid-cols-2 gap-4 text-zinc-400">
    {@render statItem("Players Online", query.data?.players_online ?? "--")}
    {@render statItem("Server Status", query.data?.status ?? "--")}
    {@render statItem("Uptime", query.data?.uptime ?? "--")}
    {@render statItem("World Size", query.data?.world_size ?? "--")}
  </div>
</div>
