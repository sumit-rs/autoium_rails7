// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "popper"
import "bootstrap"
import "@fortawesome/fontawesome-free";
import "jquery"
import "jquery_ujs"
import "./jquery-ui.min"

$(document).ready(function() {
    $("#datepicker").datepicker();
    $( "#draggable" ).draggable();
});

