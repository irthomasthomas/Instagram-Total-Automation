<script>
  // inner
  export let photo;

  function sayHello() {
    // alert(photo.rootTag)
  }

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
{photo.rootTag}
  <img class="photo" src={photo.imgUrl} alt={photo.rootTag || ""} on:click={sayHello} />
  <!-- <a href="#">{photo.rootTag}</a> -->
  
  <!-- <p>{photo.rootTag}</p> -->

  <!-- <a href="#" rel="noopener noreferrer" target="_blank" on:click={photoClick}>
    <img class="photo" src={photo.imgUrl} alt={photo.link || ""} on:click={photoClick} >
  </a> -->
  <!-- <span class="photographer" on:click={photoClick}>
    <a href="">{photo.rootTag}</a>
    <button onClick="action();"><img class ="photo" src={photo.imgUrl} id="ImageButton1" alt="button"></button>
    <br>
  </span> -->
</li>