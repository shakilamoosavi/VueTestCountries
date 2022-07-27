<template>
  <div>
    <Header />
    <div id="detail-page" class="container my-5">


      <!-- back btn box start -->
      <b-row class="back-btn-box">
        <b-col>
          <NuxtLink to="/" class="btn">
            <fa :icon="['fa', 'arrow-left-long']" />
            Back
          </NuxtLink>
        </b-col>
      </b-row>
      <!-- back btn box end -->


      <!-- loading start -->
      <div v-if="loading" class="text-center">
        <div class="spinner-grow m-auto d-block" role="status">
          <span class="sr-only">Loading...</span>
        </div>
      </div>
      <!-- loading end -->


      <!-- detail info start -->
      <b-row v-else>
        <b-col cols="12" xl="6" class="mb-4">
          <img class="country-flag-detail" :src="detail?.flags?.png" />
        </b-col>
        <b-col cols="12" xl="6" class="mb-5">
          <b-row>
            <b-col cols="12" class="my-3 main-title">
              {{ countryName }}
            </b-col>
            <b-col cols="12" xl="6" class="mb-5">
              <div class="mb-1">
                <span class="info-title"> Native Name: </span>
                <span class="info-value"> {{ detail?.name?.common }} </span>
              </div>
              <div class="mb-1">
                <span class="info-title"> Population: </span>
                <span class="info-value"> {{ detail?.population }} </span>
              </div>
              <div class="mb-1">
                <span class="info-title"> Region: </span>
                <span class="info-value"> {{ detail?.region }} </span>
              </div>
              <div class="mb-1">
                <span class="info-title"> Sub Region: </span>
                <span class="info-value"> {{ detail?.subregion }} </span>
              </div>
              <div class="mb-1">
                <span class="info-title"> Capital: </span>
                <span class="info-value" v-for="(capital, indexC) in detail?.capital"> {{ (indexC > 0 ? ', ' : '') +
                    capital
                }} </span>
              </div>
            </b-col>
            <b-col cols="12" xl="6" class="mb-5">
              <div class="mb-1">
                <span class="info-title"> Top Level Domain: </span>
                <span class="info-value" v-for="(domain, indexT) in detail?.tld"> {{ (indexT > 0 ? ', ' : '') + domain }}
                </span>
              </div>
              <div class="mb-1">
                <span class="info-title"> Currencies: </span>
                <span class="info-value" v-for="(curr, indexC) in detail?.currencies"> {{ (indexC > 0 ? ', ' : '') +
                    curr?.name
                }} </span>
              </div>
              <div class="mb-1">
                <span class="info-title"> Language: </span>
                <span class="info-value" v-for="(lang, indexL) in detail?.languages"> {{ (indexL > 0 ? ', ' : '') + lang
                }} </span>
              </div>
            </b-col>
            <!-- <b-col cols="12" class="border-countries-box">
              <span class="info-title"> Border Countries: </span>
              <NuxtLink v-for="(country, indexC) in borders" :to="'/detail/' + country.name?.toLowerCase()"
                class="btn mr-1">
                {{ country.name }}
              </NuxtLink>
            </b-col> -->
          </b-row>
        </b-col>
      </b-row>
      <!-- detail info end -->

    </div>
  </div>

</template>

<script>
import Header from '@/components/Header.vue'
export default {
  name: 'Detail',
  async asyncData({ $axios, route, }) {
    let detail = null;
    let borders = null;
    let res = await $axios.get('v3.1/name/' + route?.params?.name + '?fullText=true');
    if (res?.data?.length > 0) {
      detail = res?.data[0];
      if (detail?.borders?.length > 0) borders = await $axios.get('v2/alpha?codes=' + detail?.borders?.toString());
    }
    return {
      detail,
      borders
    }
  },
  data() {
    return {
      loading: false,
      countryName: '',
      detail: null,
      borders: []
    }
  },
  created() {
    this.countryName = this.$route?.params?.name;
  },
  methods: {
  },
  components: {
    Header
  }
}
</script>