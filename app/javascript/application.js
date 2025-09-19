// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "./facility_maps"
import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()