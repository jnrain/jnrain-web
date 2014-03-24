requirejs.config({
  paths: {
    'jquery': '../../../common-assets/js/jquery',
    'angular': '../../../common-assets/js/angular',
    'select2': '../../../common-assets/standalone/select2/select2'
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
    'angular-ui-select2': ['select2', 'angular'],
    'angular-smoothscroll': ['jquery', 'angular'],
    // Socket.IO.js is AMD-compatible
    'angular-socketio': ['socket.io', 'angular'],
    'angular-scrollevents': ['angular'],
    'stellar.directives': ['angular', 'jquery.stellar'],
    'ui.jq': ['jquery', 'angular'],

    // other libraries
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
