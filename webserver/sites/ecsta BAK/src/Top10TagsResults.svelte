<script>
  // outer
  import PhotoCardTop10 from './PhotoCardTop10tags.svelte';
  export let results;
</script>

<style>
  .search-results {
    list-style: none;
    display: grid;
    gap: 40px 20px;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  }
</style>
<!-- ^ inner -->

<ul class="search-results">
  {#each results as result (result.id)}
    <PhotoCardTop10 photo={result}/>
  {/each}

</ul>
