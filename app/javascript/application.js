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

});