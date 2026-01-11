<script lang="ts">
  import {
    createQuery,
    QueryClient,
    QueryClientProvider,
  } from "@tanstack/svelte-query";
  import Actions from "./lib/minecraft/Actions.svelte";
  import Stats from "./lib/minecraft/Stats.svelte";
  import { SvelteQueryDevtools } from "@tanstack/svelte-query-devtools";

  const queryClient = new QueryClient();
</script>

<QueryClientProvider client={queryClient}>
  <main class="flex justify-center mt-8">
    <div class="w-full max-w-2xl px-4">
      <div class="flex justify-center">
        <h1 class="text-2xl font-semibold mb-8">Management</h1>
      </div>

      <!-- Minecraft Section -->
      <section class="bg-zinc-800 rounded-lg p-6">
        <h2 class="text-xl mb-4">Minecraft</h2>
        <Actions />
        <Stats />
      </section>
    </div>
  </main>
  <SvelteQueryDevtools />
</QueryClientProvider>
