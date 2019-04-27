/**
 * 📝 What is all this? See https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/ExtensionScenarios.html#//apple_ref/doc/uid/TP40014214-CH21-SW1
 */

var ActionClass = function () {};

ActionClass.prototype = {
  run: function(params) {
    /**
     * Pass data to our extension when the script is run on the page.
     *
     * Here, we'll pass:
     *   - the URL of the current page,
     *   - the page title
     */
    params.completionFunction({
      URL: document.URL, title: document.title
    });
  },

  /**
   * Handle anything passed back from an extension when it's runtime completes
   */
  finalize: function(params) {
    eval(params.customJavaScript);
  }
};

var ExtensionPreprocessingJS = new ActionClass;
