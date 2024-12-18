// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import "@hotwired/turbo-rails";
import "controllers";
import "popper";
import "bootstrap";
import "@fortawesome/fontawesome-free";
//import "jquery";
import "jquery_ujs";
import "./jquery-ui.min";
import "./tinymce";

var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
var tooltipList = tooltipTriggerList.map(function(tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
})
$( document ).ready(function() {
    if (typeof tinyMCE != 'undefined') {
        tinyMCE.init({
            selector: "textarea.tinymce",
            toolbar: [
                "styleselect | bold italic | alignleft aligncenter alignright alignjustify",
                "bullist numlist outdent indent | link image | code | codesample"
            ],
            plugins: "image,link,code,codesample,autoresize,media,table,insertdatetime,charmap,preview,anchor,searchreplace,visualblocks,fullscreen"
        });
    } else {
        //setTimeout(arguments.callee, 50);
    }

    $('.toggle-sidebar-btn').click(function() {
       $('.autoium-body').toggleClass('toggle-sidebar');
    });
});