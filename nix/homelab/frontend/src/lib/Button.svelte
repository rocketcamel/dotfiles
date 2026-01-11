<script lang="ts">
  import { LoaderCircle } from "@lucide/svelte";
  import type { ButtonRootProps } from "bits-ui";
  import { Button } from "bits-ui";
  type Props = ButtonRootProps & {
    loading?: boolean;
    ["loading-overwrite"]?: boolean;
  };

  const {
    children,
    loading,
    disabled,
    "loading-overwrite": loadingOverwite = true,
    ...props
  }: Props = $props();
</script>

<Button.Root disabled={loading || disabled} {...props}>
  {#if loading}
    <span class="flex gap-2">
      {#if !loadingOverwite}
        {@render children?.()}
      {/if}
      <LoaderCircle class="animate-spin" />
    </span>
  {:else}
    {@render children?.()}
  {/if}
</Button.Root>
