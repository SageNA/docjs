/**
 * @namespace default namespace
 */
Ext.namespace('DocJS');

otherFunctionCall('this is a test');

/**
 * static function
 */
DocJS.Library = function()
{

};

/**
 * global function
 */
function anotherGlobalFunction()
{

}

/**
 * local function
 */
var assignedToLocal = function()
{

};

/**
 * @class document class
 */
DocJS.Document = Ext.extend(Object, {
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