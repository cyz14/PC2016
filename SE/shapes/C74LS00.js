// Generated Code for the Draw2D touch HTML5 lib
//                                                        
// http://www.draw2d.org                                  
//                                                        
// Go to the Designer http://www.draw2d.org               
// to design your own shape or download user generated    
//                                                        
var C74LS00 = draw2d.SetFigure.extend({

    NAME: "C74LS00",

    init: function(attr, setter, getter) {
        this._super($.extend({ stroke: 0, bgColor: null, width: 100, height: 173 }, attr), setter, getter);
        var port;
        // Port_Vcc
        port = this.addPort(new DecoratedInputPort(), new draw2d.layout.locator.XYRelPortLocator(101, 11.560693641618498));
        port.setConnectionDirection(1);
        port.setBackgroundColor("#37B1DE");
        port.setName("Port_Vcc");
        port.setMaxFanOut(20);
        // Port_4A
        port = this.addPort(new DecoratedInputPort(), new draw2d.layout.locator.XYRelPortLocator(101, 23.69942196531792));
        port.setConnectionDirection(1);
        port.setBackgroundColor("#37B1DE");
        port.setName("Port_4A");
        port.setMaxFanOut(20);
        // Port_4B
        port = this.addPort(new DecoratedInputPort(), new draw2d.layout.locator.XYRelPortLocator(101, 34.971098265895954));
        port.setConnectionDirection(1);
        port.setBackgroundColor("#37B1DE");
        port.setName("Port_4B");
        port.setMaxFanOut(20);
        // Port_4Y
        port = this.createPort("output", new draw2d.layout.locator.XYRelPortLocator(101, 46.820809248554916));
        port.setConnectionDirection(1);
        port.setBackgroundColor("#37B1DE");
        port.setName("Port_4Y");
        port.setMaxFanOut(20);
        // Port_3Y
        port = this.createPort("output", new draw2d.layout.locator.XYRelPortLocator(101, 58.95953757225434));
        port.setConnectionDirection(1);
        port.setBackgroundColor("#37B1DE");
        port.setName("Port_3Y");
        port.setMaxFanOut(20);
        // Port_3B
        port = this.addPort(new DecoratedInputPort(), new draw2d.layout.locator.XYRelPortLocator(101, 70.8092485549133));
        port.setConnectionDirection(1);
        port.setBackgroundColor("#37B1DE");
        port.setName("Port_3B");
        port.setMaxFanOut(20);
        // Port_3A
        port = this.addPort(new DecoratedInputPort(), new draw2d.layout.locator.XYRelPortLocator(101, 82.65895953757226));
        port.setConnectionDirection(1);
        port.setBackgroundColor("#37B1DE");
        port.setName("Port_3A");
        port.setMaxFanOut(20);
        // Port_1A
        port = this.addPort(new DecoratedInputPort(), new draw2d.layout.locator.XYRelPortLocator(-1, 11.560693641618498));
        port.setConnectionDirection(3);
        port.setBackgroundColor("#37B1DE");
        port.setName("Port_1A");
        port.setMaxFanOut(20);
        // Port_1B
        port = this.addPort(new DecoratedInputPort(), new draw2d.layout.locator.XYRelPortLocator(-1, 23.121387283236995));
        port.setConnectionDirection(3);
        port.setBackgroundColor("#37B1DE");
        port.setName("Port_1B");
        port.setMaxFanOut(20);
        // Port_1Y
        port = this.createPort("output", new draw2d.layout.locator.XYRelPortLocator(-1, 34.971098265895954));
        port.setConnectionDirection(3);
        port.setBackgroundColor("#37B1DE");
        port.setName("Port_1Y");
        port.setMaxFanOut(20);
        // Port_2Y
        port = this.createPort("output", new draw2d.layout.locator.XYRelPortLocator(-1, 46.53179190751445));
        port.setConnectionDirection(3);
        port.setBackgroundColor("#37B1DE");
        port.setName("Port_2Y");
        port.setMaxFanOut(20);
        // Port_2B
        port = this.addPort(new DecoratedInputPort(), new draw2d.layout.locator.XYRelPortLocator(-1, 58.67052023121388));
        port.setConnectionDirection(3);
        port.setBackgroundColor("#37B1DE");
        port.setName("Port_2B");
        port.setMaxFanOut(20);
        // Port_2A
        port = this.addPort(new DecoratedInputPort(), new draw2d.layout.locator.XYRelPortLocator(-1, 70.8092485549133));
        port.setConnectionDirection(3);
        port.setBackgroundColor("#37B1DE");
        port.setName("Port_2A");
        port.setMaxFanOut(20);
        // Port_GND
        port = this.addPort(new DecoratedInputPort(), new draw2d.layout.locator.XYRelPortLocator(-1, 82.65895953757226));
        port.setConnectionDirection(3);
        port.setBackgroundColor("#37B1DE");
        port.setName("Port_GND");
        port.setMaxFanOut(20);
        this.persistPorts = false;
    },

    createShapeElement: function() {
        var shape = this._super();
        this.originalWidth = 100;
        this.originalHeight = 173;
        return shape;
    },

    createSet: function() {
        this.canvas.paper.setStart();

        // BoundingBox
        shape = this.canvas.paper.path("M0,0 L100,0 L100,173 L0,173");
        shape.attr({ "stroke": "none", "stroke-width": 0, "fill": "none" });
        shape.data("name", "BoundingBox");

        // Rectangle
        shape = this.canvas.paper.path('M25.087488663525903 0L0 0L0 170L100 170L100 0L72.9125113364741 0L72.63538607229299 3.3035862876139532L71.55262289886178 7.518050213305088L69.78460969082653 11.472392638036808L67.38506663485549 15.04646286822748L64.42690263247692 18.131664588499575L61 20.63425550577L57.208483439816064 22.478195661389606L53.16755626400635 23.60745786680863L49 23.987730061349694L44.83244373599365 23.60745786680863L40.791516560183936 22.478195661389606L37 20.63425550577L33.573097367523076 18.131664588499575L30.61493336514451 15.046462868227493L28.215390309173472 11.472392638036808L26.447377101138215 7.518050213305088L25.364613927707012 3.3035862876139532L25.087488663525903 0Z');
        shape.attr({ "stroke": "#303030", "stroke-width": 1, "fill": "#FFFFFF", "dasharray": null, "opacity": 1 });
        shape.data("name", "Rectangle");

        // Label_Name
        shape = this.canvas.paper.text(0, 0, '74LS04');
        shape.attr({ "x": 22.421875, "y": 159.5, "text-anchor": "start", "text": "74LS04", "font-family": "\"Arial\"", "font-size": 16, "stroke": "none", "fill": "#080808", "stroke-scale": true, "font-weight": "normal", "stroke-width": 0, "opacity": 1 });
        shape.data("name", "Label_Name");

        // Label_4A
        shape = this.canvas.paper.text(0, 0, '4A');
        shape.attr({ "x": 75.78125, "y": 39.5, "text-anchor": "start", "text": "4A", "font-family": "\"Arial\"", "font-size": 8, "stroke": "none", "fill": "#080808", "stroke-scale": true, "font-weight": "normal", "stroke-width": 0, "opacity": 1 });
        shape.data("name", "Label_4A");

        // Label_4B
        shape = this.canvas.paper.text(0, 0, '4B');
        shape.attr({ "x": 76, "y": 59, "text-anchor": "start", "text": "4B", "font-family": "\"Arial\"", "font-size": 8, "stroke": "none", "fill": "#080808", "stroke-scale": true, "font-weight": "normal", "stroke-width": 0, "opacity": 1 });
        shape.data("name", "Label_4B");

        // Label_4Y
        shape = this.canvas.paper.text(0, 0, '4Y');
        shape.attr({ "x": 76, "y": 78.5, "text-anchor": "start", "text": "4Y", "font-family": "\"Arial\"", "font-size": 8, "stroke": "none", "fill": "#080808", "stroke-scale": true, "font-weight": "normal", "stroke-width": 0, "opacity": 1 });
        shape.data("name", "Label_4Y");

        // Label_3Y
        shape = this.canvas.paper.text(0, 0, '3Y');
        shape.attr({ "x": 75.78125, "y": 101.5, "text-anchor": "start", "text": "3Y", "font-family": "\"Arial\"", "font-size": 8, "stroke": "none", "fill": "#080808", "stroke-scale": true, "font-weight": "normal", "stroke-width": 0, "opacity": 1 });
        shape.data("name", "Label_3Y");

        // Label_3B
        shape = this.canvas.paper.text(0, 0, '3B');
        shape.attr({ "x": 75.78125, "y": 122.5, "text-anchor": "start", "text": "3B", "font-family": "\"Arial\"", "font-size": 8, "stroke": "none", "fill": "#080808", "stroke-scale": true, "font-weight": "normal", "stroke-width": 0, "opacity": 1 });
        shape.data("name", "Label_3B");

        // Label_3A
        shape = this.canvas.paper.text(0, 0, '3A');
        shape.attr({ "x": 75.78125, "y": 140.5, "text-anchor": "start", "text": "3A", "font-family": "\"Arial\"", "font-size": 8, "stroke": "none", "fill": "#080808", "stroke-scale": true, "font-weight": "normal", "stroke-width": 0, "opacity": 1 });
        shape.data("name", "Label_3A");

        // Label_1A
        shape = this.canvas.paper.text(0, 0, '1A');
        shape.attr({ "x": 9.9921875, "y": 20, "text-anchor": "start", "text": "1A", "font-family": "\"Arial\"", "font-size": 8, "stroke": "none", "fill": "#080808", "stroke-scale": true, "font-weight": "normal", "stroke-width": 0, "opacity": 1 });
        shape.data("name", "Label_1A");

        // Label_1B
        shape = this.canvas.paper.text(0, 0, '1B');
        shape.attr({ "x": 9.9921875, "y": 39.5, "text-anchor": "start", "text": "1B", "font-family": "\"Arial\"", "font-size": 8, "stroke": "none", "fill": "#080808", "stroke-scale": true, "font-weight": "normal", "stroke-width": 0, "opacity": 1 });
        shape.data("name", "Label_1B");

        // Label_1Y
        shape = this.canvas.paper.text(0, 0, '1Y');
        shape.attr({ "x": 9.9921875, "y": 60.5, "text-anchor": "start", "text": "1Y", "font-family": "\"Arial\"", "font-size": 8, "stroke": "none", "fill": "#080808", "stroke-scale": true, "font-weight": "normal", "stroke-width": 0, "opacity": 1 });
        shape.data("name", "Label_1Y");

        // Label_2Y
        shape = this.canvas.paper.text(0, 0, '2Y');
        shape.attr({ "x": 10.0078125, "y": 78.5, "text-anchor": "start", "text": "2Y", "font-family": "\"Arial\"", "font-size": 8, "stroke": "none", "fill": "#080808", "stroke-scale": true, "font-weight": "normal", "stroke-width": 0, "opacity": 1 });
        shape.data("name", "Label_2Y");

        // Label_2B
        shape = this.canvas.paper.text(0, 0, '2B');
        shape.attr({ "x": 9.9921875, "y": 101.5, "text-anchor": "start", "text": "2B", "font-family": "\"Arial\"", "font-size": 8, "stroke": "none", "fill": "#080808", "stroke-scale": true, "font-weight": "normal", "stroke-width": 0, "opacity": 1 });
        shape.data("name", "Label_2B");

        // Label_2A
        shape = this.canvas.paper.text(0, 0, '2A');
        shape.attr({ "x": 9.9921875, "y": 122.5, "text-anchor": "start", "text": "2A", "font-family": "\"Arial\"", "font-size": 8, "stroke": "none", "fill": "#080808", "stroke-scale": true, "font-weight": "normal", "stroke-width": 0, "opacity": 1 });
        shape.data("name", "Label_2A");

        // Label_GND
        shape = this.canvas.paper.text(0, 0, 'GND');
        shape.attr({ "x": 9.9921875, "y": 140.5, "text-anchor": "start", "text": "GND", "font-family": "\"Arial\"", "font-size": 7, "stroke": "none", "fill": "#080808", "stroke-scale": true, "font-weight": "normal", "stroke-width": 0, "opacity": 1 });
        shape.data("name", "Label_GND");

        // Label_Vcc
        shape = this.canvas.paper.text(0, 0, 'Vcc');
        shape.attr({ "x": 70.671875, "y": 20, "text-anchor": "start", "text": "Vcc", "font-family": "\"Arial\"", "font-size": 8, "stroke": "none", "fill": "#080808", "stroke-scale": true, "font-weight": "normal", "stroke-width": 0, "opacity": 1 });
        shape.data("name", "Label_Vcc");


        return this.canvas.paper.setFinish();
    },

    applyAlpha: function() {},

    layerGet: function(name, attributes) {
        if (this.svgNodes === null) return null;

        var result = null;
        this.svgNodes.some(function(shape) {
            if (shape.data("name") === name) {
                result = shape;
            }
            return result !== null;
        });

        return result;
    },

    layerAttr: function(name, attributes) {
        if (this.svgNodes === null) return;

        this.svgNodes.forEach(function(shape) {
            if (shape.data("name") === name) {
                shape.attr(attributes);
            }
        });
    },

    layerShow: function(name, flag, duration) {
        if (this.svgNodes === null) return;

        if (duration) {
            this.svgNodes.forEach(function(node) {
                if (node.data("name") === name) {
                    if (flag) {
                        node.attr({ opacity: 0 }).show().animate({ opacity: 1 }, duration);
                    } else {
                        node.animate({ opacity: 0 }, duration, function() { this.hide() });
                    }
                }
            });
        } else {
            this.svgNodes.forEach(function(node) {
                if (node.data("name") === name) {
                    if (flag) { node.show(); } else { node.hide(); }
                }
            });
        }
    },

    calculate: function() {},

    onStart: function() {},

    onStop: function() {},

    getParameterSettings: function() {
        return [];
    },

    /**
     * @method
     */
    addPort: function(port, locator) {
        this._super(port, locator);
        return port;
    },

    /**
     * @method
     * Return an objects with all important attributes for XML or JSON serialization
     *
     * @returns {Object}
     */
    getPersistentAttributes: function() {
        var memento = this._super();

        // add all decorations to the memento
        //
        memento.labels = [];
        this.children.each(function(i, e) {
            var labelJSON = e.figure.getPersistentAttributes();
            labelJSON.locator = e.locator.NAME;
            memento.labels.push(labelJSON);
        });

        return memento;
    },

    /**
     * @method
     * Read all attributes from the serialized properties and transfer them into the shape.
     *
     * @param {Object} memento
     * @returns
     */
    setPersistentAttributes: function(memento) {
        this._super(memento);

        // remove all decorations created in the constructor of this element
        //
        this.resetChildren();

        // and add all children of the JSON document.
        //
        $.each(memento.labels, $.proxy(function(i, json) {
            // create the figure stored in the JSON
            var figure = eval("new " + json.type + "()");

            // apply all attributes
            figure.attr(json);

            // instantiate the locator
            var locator = eval("new " + json.locator + "()");

            // add the new figure as child to this figure
            this.add(figure, locator);
        }, this));
    }
});

/**
 * by 'Draw2D Shape Designer'
 *
 * Custom JS code to tweak the standard behaviour of the generated
 * shape. add your custome code and event handler here.
 *
 *
 */
C74LS00 = C74LS00.extend({

    init: function(attr, setter, getter) {
        this._super(attr, setter, getter);

        // your special code here
    },

    /**
     *  Called by the simulator for every calculation
     *  loop
     *  @required
     **/
    calculate: function() {},


    /**
     *  Called if the simulation mode is starting
     *  @required
     **/
    onStart: function() {},

    /**
     *  Called if the simulation mode is stopping
     *  @required
     **/
    onStop: function() {}
});