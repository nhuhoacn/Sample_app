import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import I18n from "i18n-js"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()
require("jquery")
require("bootstrap")

window.I18n = I18n

$(function(){
  $("#micropost_image").bind("change", function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert(I18n.t("js.maximum_size"));
    }
  });
});
