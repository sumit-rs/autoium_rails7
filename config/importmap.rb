# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "popper", to: 'popper.js', preload: true
pin "bootstrap", to: 'bootstrap.min.js', preload: true
pin "@fortawesome/fontawesome-free", to: "https://ga.jspm.io/npm:@fortawesome/fontawesome-free@6.1.1/js/all.js"

#pin "jquery", to: "https://code.jquery.com/jquery-3.6.0.min.js", preload: true
pin "jquery_ujs", to: "jquery_ujs.js", preload: true
pin "jquery_ui", to: "jquery-ui.min.js", preload: true
#pin "tinymce-rails", to: "tinymce.js", preload: true

pin_all_from "app/javascript/controllers", under: "controllers"

#pin "apexcharts", to: "apexcharts/apexcharts.min.js", preload: truepin "@markerjs/mjs-diagram", to: "@markerjs--mjs-diagram.js" # @1.3.2
pin "@joint/core", to: "@joint--core.js" # @4.1.2
