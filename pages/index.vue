<template>
  <div>
    <Header />
    <div id="home-page" class="container my-5">

      <!-- filter & sort box start -->
      <b-row class="mb-4">
        <b-col cols="12" xl="4" class="mb-3">
          <div class="search-input">
            <fa :icon="['fas', 'search']" />
            <b-form-input v-model="searchParams.countryName" @input="gitCountriesByName()"
              placeholder="Search for a country"></b-form-input>
          </div>
        </b-col>
        <b-col cols="12" xl="4" class="mb-3">
          <div class="d-flex">
            <div class="sort-item" @click="sortList('population')">
              <span v-if="sort.name === 'population'">
                <fa v-if="sort.type === 'asc'" :icon="['fas', 'fa-arrow-down-1-9']" />
                <fa v-else :icon="['fas', 'fa-arrow-down-9-1']" />
              </span>
              Population
            </div>
            <div class="sort-item" @click="sortList('name.common')">
              <span v-if="sort.name === 'name.common'">
                <fa v-if="sort.type === 'asc'" :icon="['fas', 'fa-arrow-down-a-z']" />
                <fa v-else :icon="['fas', 'fa-arrow-down-z-a']" />
              </span>
              
              Country name
            </div>
          </div>
        </b-col>
        <b-col cols="8" xl="2" class="mb-3 region-box">
          <b-form-select v-model="searchParams.region" :options="regionList" @change="getCountriesByRegion()">
          </b-form-select>
        </b-col>
      </b-row>
      <!-- filter & sort box end -->


      <div>


        <div>

          <!-- no data msg start -->
          <div v-if="!list?.length" class="text-center">
            <fa :icon="['fas', 'ban']" />
            No match data !
          </div>
          <!-- no data msg end -->


          <!-- country list start -->
          <b-row v-else>
            <b-col v-for="(item, index) in list" cols="12" xl="3" class="mb-5">
              <NuxtLink :to="'/detail/' + item.name?.common?.toLowerCase()">
                <b-card>
                  <div class="img-container">
                    <img :data-src="item.flags?.png" v-lazy-load />
                  </div>
                  <div class="p-4">
                    <b class="d-block mb-3">{{ item.name?.common }}</b>
                    <div class="mb-1">
                      <span class="info-title">Population:</span>
                      <span class="info-value"> {{ item.population }} </span>
                    </div>
                    <div class="mb-1">
                      <span class="info-title">Region:</span>
                      <span class="info-value"> {{ item.region }} </span>
                    </div>
                    <div class="mb-1">
                      <span class="info-title"> Capital: </span>
                      <span class="info-value" v-for="(capital, indexC) in item.capital"> {{ (indexC > 0 ? ', ' : '') +
                          capital
                      }} </span>
                    </div>
                  </div>
                </b-card>
              </NuxtLink>
            </b-col>
          </b-row>
          <!-- country list end -->


        </div>

      </div>
    </div>
  </div>

</template>

<script>
import Header from '@/components/Header.vue'
import Detail from './detail.vue'

export default {
  name: 'IndexPage',
  async asyncData({ $axios, route, $lodash }) {
    let list = null;
    if (route.query.region) {
      try {
        list = await $axios.get('v3.1/region/' + route.query.region).then(
          (response) => {
            return response.data;
          },
          (error) => {
            console.log(error);
          }
        );
      } catch (error) {
        console.log(error);
      }
    } else if (route.query.name) {
      try {
        list = await $axios.get('v3.1/name/' + route.query.name).then(
          (response) => {
            return response.data;
          },
          (error) => {
            console.log(error);
          }
        );
      } catch (error) {
        console.log(error);
      }
    } else {
      try {
        list = await $axios.get('v3.1/all').then(
          (response) => {
            return response.data;
          },
          (error) => {
            console.log(error);
          }
        );
      } catch (error) {
        console.log(error);
      }
    }
    if (route.query) {
      list = $lodash.orderBy(list, [route.query.sort], [route.query.type]);
    }
    return {
      list
    }
  },
  data() {
    return {
      loading: false,
      regionList: ['africa', 'americas', 'asia', 'europe', 'oceania'],
      list: [],
      sort: {
        type: 'asc',
        name: 'countryName'
      },
      searchParams: {
        region: null,
        countryName: null
      }
    }
  },
  created() {
    this.checkParams();
  },
  methods: {
    checkParams() {
      this.loading = true;
      let query = this.$route?.query;
      if (query.sort && query.type) {
        this.sort.name = query.sort;
        this.sort.type = query.type;
      }
      if (query.name) this.searchParams.countryName = query.name;
      else if (query.region) this.searchParams.region = query.region;
      this.loading = false;
    },
    updatePathParams($router, newParams) {
      const currentParams = $router.currentRoute.query;
      const mergedParams = { ...currentParams, ...newParams };
      $router.push({ query: mergedParams });
    },
    removeQueryParams(item) {
      let query = Object.assign({}, this.$route.query);
      delete query[item];
      this.$router.replace({ query });
    },
    sortList(field) {
      this.sort.type = (this.sort.type === 'asc' ? 'desc' : 'asc');
      this.sort.name = field;
      this.updatePathParams(this.$router, { sort: this.sort.name, type: this.sort.type })
      this.list = this.$lodash.orderBy(this.list, [this.sort.name], [this.sort.type]);
    },
    getList() {
      this.$axios.get('v3.1/all').then(
        (response) => {
          this.list = response.data;
          this.loading = false;

        },
        (error) => {
          console.log(error);
          this.loading = false;
        }
      );
    },
    getCountriesByRegion() {
      this.loading = true;
      this.updatePathParams(this.$router, { region: this.searchParams.region });
      if (this.searchParams.countryName) { // clear value because of calling api 
        this.searchParams.countryName = null;
        this.removeQueryParams('name');
      }
      this.list = [];
      this.$axios.get('v3.1/region/' + this.searchParams.region).then(
        (response) => {
          this.list = response.data;
          this.loading = false;
        },
        (error) => {
          console.log(error);
          this.loading = false;
        }
      );
    },
    gitCountriesByName() {
      this.loading = true;
      this.updatePathParams(this.$router, { name: this.searchParams.countryName });
      if (this.searchParams.region) { // clear value because of calling api
        this.searchParams.region = null;
        this.removeQueryParams('region');
      }
      this.list = [];
      if (this.searchParams.countryName !== '') {
        this.$axios.get('v3.1/name/' + this.searchParams.countryName).then(
          (response) => {
            this.list = response.data;
            this.loading = false;
          },
          (error) => {
            console.log(error);
            this.loading = false;
          }
        );
      } else this.getList();
    }
  },
  components: {
    Header,
    Detail,
  }
}
</script>