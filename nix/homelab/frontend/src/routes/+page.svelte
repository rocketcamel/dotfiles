<script lang="ts">
  import { QueryClient, QueryClientProvider } from "@tanstack/svelte-query";
  import Actions from "$lib/minecraft/Actions.svelte";
  import Stats from "$lib/minecraft/Stats.svelte";
  import { SvelteQueryDevtools } from "@tanstack/svelte-query-devtools";

  const queryClient = new QueryClient();
</script>

<QueryClientProvider client={queryClient}>
  <main class="mt-8 flex justify-center">
    <div class="w-full max-w-2xl px-4">
      <div class="flex justify-center">
        <h1 class="mb-8 text-2xl font-semibold">Management</h1>
      </div>

      <!-- Minecraft Section -->
      <section class="rounded-lg bg-zinc-800 p-6">
        <h2 class="mb-4 text-xl">Minecraft</h2>
        <Actions />
        <Stats />
      </section>
    </div>
  </main>
  <SvelteQueryDevtools />
</QueryClientProvider>
