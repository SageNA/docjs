/**
 * module comment
 */
DocJS.Module = (function() {
    /**
     * privateMethodA comment
     */
    var privateMethodA = function() {};

    return {
        /**
         * methodA comment
         */
        methodA: privateMethodA,
        options: {
            one: 'one',
            two: 'two'
        }
    };
})();