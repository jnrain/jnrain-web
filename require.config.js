requirejs.config({
  paths: {
    'jquery': '../../bower_components/jquery/dist/jquery',
    'angular': '../../bower_components/angular/angular',
    'restangular': '../../bower_components/restangular/dist/restangular',
    'lodash': '../../bower_components/lodash/dist/lodash',
    'select2': '../../bower_components/select2/select2',
    'ui.select2': '../../bower_components/angular-ui-select2/src/select2',
    'angular-socket-io': '../../bower_components/angular-socket-io/socket.min',
    'socket.io-client': '../../bower_components/socket.io-client/dist/socket.io',
    'AngularJS-Toaster': '../../bower_components/AngularJS-Toaster/toaster',
    'ui-bootstrap': '../../bower_components/angular-bootstrap/ui-bootstrap-tpls',
    'angular-animate': '../../bower_components/angular-animate/angular-animate',
    'jsSHA': '../../bower_components/jsSHA/src/sha',
    'angular-local-storage': '../../bower_components/angular-local-storage/angular-local-storage',
    'flow': '../../bower_components/flow.js/dist/flow',  // known to be simply 'flow'
    'ng-flow': '../../bower_components/ng-flow/dist/ng-flow.js'
  },
  shim: {
    // jQuery plugins
    'jquery.ui': ['jquery'],
    'jquery.backstretch': ['jquery'],
    'jquery.fullscreen': ['jquery'],
    'jquery.knob': ['jquery'],
    'jquery.stellar': ['jquery'],
    'jquery.transit': ['jquery'],
    'garlic': ['jquery'],
    'parsley': ['jquery'],
    'supersized.core': ['jquery'],
    'select2': ['jquery'],
    'waypoints': ['jquery'],

    // AngularJS components
    'angular': {
      deps: ['jquery'],  // force use of real jQuery
      exports: 'angular'
    },
    'angular-resource': ['angular'],
    'angular-sanitize': ['angular'],
    'angular-dragdrop': {
      deps: ['jquery.ui', 'angular'],
      exports: 'jqyoui'
    },
    'ui.select2': ['select2', 'angular'],
    'angular-smoothscroll': ['jquery', 'angular'],
    'angular-scrollevents': ['angular'],
    'stellar.directives': ['angular', 'jquery.stellar'],
    'ui.jq': ['jquery', 'angular'],
    'restangular': ['angular', 'lodash'],
    // seems socket.io-client must be loaded in a separate <script>...
    'angular-socket-io': ['angular'],  // socket.io-client

    'ui-bootstrap': ['angular'],
    'AngularJS-Toaster': ['angular', 'angular-animate'],
    'angular-local-storage': ['angular'],

    // flow.js is AMD-compatible
    'ng-flow': ['angular', 'flow'],

    // other libraries
    'lodash': {
      deps: [],
      exports: '_'
    },

    'd3.v3': {
      deps: [],
      exports: 'd3'
    },
    'qrcode': {
      exports: 'QRCode'
    }
  }
});

// vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
