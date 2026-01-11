<script lang="ts">
  import { Button } from "bits-ui";

  function syncCreativeWorld() {
    console.log("Syncing creative world...");
  }

  function backupMainWorld() {
    console.log("Backing up main world...");
  }
</script>

<div class="flex gap-3 mb-6">
  <Button.Root
    onclick={syncCreativeWorld}
    class="bg-[#7aa2f7] hover:bg-[#7dcfff]"
  >
    Sync Creative World
  </Button.Root>
  <Button.Root
    onclick={backupMainWorld}
    class="bg-[#bb9af7] hover:bg-[#c0caf5]"
  >
    Backup Main World
  </Button.Root>
</div>
