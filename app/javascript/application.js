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
import { createGraphFromJson } from "./jointjs-digram";

//In modern JavaScript with modules (ES6+), functions and variables inside a module are not automatically available globally. Instead, they are scoped to the module. This means that if you define a function inside a JavaScript file and import it somewhere, it won’t be accessible from inline scripts in .html.erb unless you explicitly expose it.

//By assigning the function to window.createGraphFromJson, we explicitly attach it to the global window object so it can be accessed from anywhere, including inline scripts in .html.erb:
window.createGraphFromJson = createGraphFromJson;

var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
})
$(document).on("click", "#case_screenshot", function () {
    showMarkerArea(this);
});

function showMarkerArea(target) {
    const markerArea = new markerjs2.MarkerArea(target);
    markerArea.settings.displayMode = 'popup';
    markerArea.addEventListener("render", function (event) {
        target.src = event.dataUrl;
        let env_suite_case = $(target).data("attr").split('-');
        fetch("/environments/"+env_suite_case[0]+"/test_suites/"+env_suite_case[1]+"/manual_test_cases/"+env_suite_case[2], {
            method: "PUT",
            headers: {
                "X-Requested-With": "XMLHttpRequest",// Important for Rails to detect XHR
                "Content-Type": "application/json",
                "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
            },
            body: JSON.stringify({manual_case: {file: event.dataUrl}}),
        })
        .then(response => response.json())
        .then(data => {
            console.log('Image saved successfully');
            //alert("Image saved successfully!");
        })
        .catch(error => console.error("Error saving image:", error));
    });
    markerArea.show();
}