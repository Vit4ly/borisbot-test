import { createApp } from "vue";
import App from "./App.vue";
import "../src/assets/style/reset.scss";

const app = createApp(App);
app.config.devtools = true;
app.mount("#app");
