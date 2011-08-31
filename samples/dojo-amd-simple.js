define('DocJS/Document', ['Object'], function() {
    otherFunctionCall('this is a test');

    /**
     * @class document class
     */
    dojo.declare('DocJS.Document', [Object], {
        /**
         * A null property
         */
        propertyNull: null,
        /**
         * A number property
         */
        propertyNumber: 1,
        /**
         * An array property
         */
        propertyArray: [1, 2, 3],
        /**
         * A string property
         */
        propertyString: 'a string',
        /**
         * A constructor.
         * @constructor
         * @param o
         */
        constructor: function(o)
        {

        },
        /**
         * A function.
         * @param a
         * @param b
         * @param c
         */
        methodA: function(a, b, c)
        {

        }
    });
});