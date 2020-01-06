<script>
  import { onMount } from 'svelte';
  import Search from './Search.svelte';
  import SearchResults from './SearchResults.svelte';
  import LoadingIndicator from './LoadingIndicator.svelte';
  import Top10TagsResults from './Top10TagsResults.svelte';

  let searchQuery = '';
  let searchTerm = null;
  let totalPages = null;
  let searchResults = [];
  let nextPage = 1;
  let isLoading = false;
  let top10 = false;

  let observer;
  let target;

  const options = {
    rootMargin: '0px 0px 300px',
    threshold: 0,
  };


  const loadMoreResults = entries => {
    entries.forEach(entry => {
      // If new search or if ongoing search
      if (nextPage === 1 || isLoading) return;

      if (entry.isIntersecting) {
        searchUnsplash();
      }
    });
  };

  onMount(() => {
    observer = new IntersectionObserver(loadMoreResults, options);
    target = document.querySelector('.loading-indicator');
    // searchQuery = 'carbcap';
    // top10tags();
  });


  function handleSubmit() {
    // alert(searchQuery);
    searchTerm = searchQuery.trim();
    searchResults = [];
    totalPages = null;
    nextPage = 1;

    if (!searchTerm) return;

    observer.observe(target);
    searchUnsplash();
  }

  function searchUnsplash() {
    isLoading = true;
    top10 = false;

    const endpoint =
        `http://thomasthomas.tk/enqueue?tag=${searchTerm}&page=${nextPage}`;

    fetch(endpoint)
      .then(response => {
        if (!response.ok) {
          throw Error(response.statusText);
        }
        return response.json();
      })
      .then(data => {
        if (data.total === 0) {
          alert("No products were found. Try another hashtag.")
          return;
        }
        searchResults = [...searchResults, ...data.results];
        totalPages = data.total_pages;
        
        if (nextPage < totalPages) {
          nextPage += 1;
        }
      })
      .catch(() => alert("An error occured!"))
      .finally(() => {
        isLoading = false;

        if (nextPage >= Number(totalPages)) {
          observer.unobserve(target);
        }
      });
  }

  function top10tags() {
    searchTerm = 'top10tags';
    isLoading = true;
    searchResults = [];
    nextPage = 1;
    top10 = true;

    const endpoint =
        `http://thomasthomas.tk/enqueue?tag=${searchTerm}&page=${nextPage}`;

    fetch(endpoint)
      .then(response => {
        if (!response.ok) {
          throw Error(response.statusText);
        }
        return response.json();
      })
      .then(data => {
        if (data.total === 0) {
          alert("An error happened loading top10tags")
          return;
        }
        searchResults = [...searchResults, ...data.results];
        totalPages = data.total_pages;
        if (nextPage < totalPages) {
          nextPage += 1;
        }
      })
      .catch(() => alert("An error occured!"))
      .finally(() => {
        isLoading = false;

        if (nextPage >= Number(totalPages)) {
          observer.unobserve(target);
        }
      });
  }

</script>

<style>
  .App {
    width: 100%;
    max-width: 1500px;
    padding: 20px;
    margin: 0 auto 50px;
    text-align: center;
  }

  h1 {
    font-size: 50px;
    margin-top: 30px;
    margin-bottom: 30px;
  }
</style>

<main class="App">

  <h1>ecsta.tk about stuff.</h1>
  <Search bind:query={searchQuery} handleSubmit={handleSubmit} />  
  {#if top10}
    <Top10TagsResults results={searchResults} />

  {:else}
    <SearchResults results={searchResults} />

  {/if}

  <!-- top10searchresults -->
    <!-- {top10 = false} -->

      <!-- Show detailed status moving through pipeline -->

  <div class="loading-indicator">
    {#if isLoading}
      <LoadingIndicator isLoading={isLoading} />
    {/if}
  </div>

</main>
