var make = function make(elm) {
    elm.Native = elm.Native || {};
    elm.Native.AsIs = elm.Native.AsIs || {};

    if (elm.Native.AsIs.values) return elm.Native.AsIs.values;

    return elm.Native.AsIs.values = {
        'asIs' : function(a) { return a; }
    };
};

Elm.Native.AsIs = {};
Elm.Native.AsIs.make = make;
