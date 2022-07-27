<template>
  <div class="header">
    <div class="container">
        <nav>
        <nuxt-link  to="/" >
            <div class="navigation__title">Where in the world?</div>
        </nuxt-link>
        <div class="navigation__theme">
            <div v-if="theme === 'darkMode'" @click="changeTheme('lightMode')">
                <fa :icon="['fas', 'sun']" />
                <span>Light mode</span>
            </div>
            <div v-else @click="changeTheme('darkMode')" >
                <fa :icon="['fas', 'moon']" />
                <span>Dark mode</span>
            </div>
        </div>
        </nav> 
    </div>
  </div>
</template>
 
<script>
  
export default {
  name: "Header",
  created() {},
  data() {
    return {
      theme: false,
    };
  },
  mounted() {
    this.changeTheme(localStorage.getItem('theme') || 'lightMode', true);
  },
  props: {},
  methods: {
    changeTheme (theme, init) {
      this.theme = theme;
      document.body.removeAttribute('class')
      document.body.classList.add(theme);
      if (!init) localStorage.setItem('theme', theme);
    },
  },
  components:{
  }
  };
</script>
 
<style scoped>
.header {
  background-color: #fff;
}

nav {
  display: flex;
 
  align-items: center;
 
  justify-content: space-between;

  padding: 1rem 0;
}
 
.navigation__title {
  font-weight: 800;
}
.navigation__theme {
    font-size: 90%;
    cursor: pointer;
}
a{
  text-decoration:none;
  color: #000;
}
</style>