<script>
  export let photo;
</script>

<style>
  .photo-card {
    animation: show 0.5s forwards ease-in-out;
  }

  .photo {
    width: 100%;
    object-fit: cover;
    height: 300px;
    background-color: #ccc;
    margin-bottom: 10px;
  }

  .photographer {
    display: inline-block;
  }

  .photographer a {
    color: #333;
    text-decoration: none;
  }

  .photographer a:hover {
    text-decoration: underline;
  }

  @keyframes show {
    0% {
      opacity: 0;
      transform: translateY(100px);
    }

    100% {
      opacity: 1;
      transform: translateY(0);
    }
  }
</style>

<li class="photo-card">
  <a href={photo.link || "not  found error"} rel="noopener noreferrer" target="_blank">
    <img class="photo" src={photo.imgUrl} alt={photo.link || ""}>
  </a>
  <!-- <span class="photographer">
    <a href={photo.link} rel="noopener noreferrer"
      target="_blank">{photo.link}</a>
  </span> -->
</li>