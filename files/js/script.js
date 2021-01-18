/* globals apex */

var FOS = window.FOS || {};

FOS.timing = (function () {

    //used by addTimer and removeTimer
    var timers = {};

    /**
     * A dynamic action to declaratively control the firing of following actions or performing
     * repetetive actions using a timer
     *
     * @memberof FOS.timing
     * @param {object}   daContext                      Dynamic Action context as passed in by APEX
     * @param {object}   config                         Configuration object holding the configuration settings
     * @param {string}   config.actionType              The timing action type: debounce, delay, throttle, addTimer, removeTimer
     * @param {number}   [config.delay]                 The number of milliseconds to delay following actions this option applies to debounce, delay, throttle
     * @param {string}   [config.daId]                  A unique identifier for the delay/throttle actions
     * @param {boolean}  [config.fireImmediately]       true/false to fire the debounced actions immediately
     * @param {string}   [config.timerName]             A unique name to identify the timer
     * @param {number}   [config.interval]              The time (in milliseconds) the timer will fire the timeout tick event
     * @param {number}   [config.repetitions]           The number of repetitions before the timer is removed, if undefined it will be infinite
     */
    function action(daContext, config) {

        apex.debug.info('FOS - Timing Actions', config);

        // Replacing substituting strings and escaping the message
        if (['debounce', 'delay', 'throttle'].indexOf(config.actionType) > -1 && !daContext.resumeCallback) {
            // throw an error?
            apex.debug.error('FOS - Timing Actions - setting "Wait for result" must be toggled on for action "' + config.actionType + '"');
        }

        var resumeCallback = daContext.resumeCallback || function () { };

        switch (config.actionType) {
            case 'debounce':
                FOS.timing.debounce(daContext, config);
                break;
            case 'delay':
                FOS.timing.delay(daContext, config);
                break;
            case 'throttle':
                FOS.timing.throttle(daContext, config);
                break;
            case 'addTimer':
                FOS.timing.addTimer(config);
                resumeCallback();
                break;
            case 'removeTimer':
                FOS.timing.removeTimer();
                break;
        }
    }

    function delay(daContext, config) {
        // Call our delayed function
        setTimeout(function () {
            apex.da.resume(daContext.resumeCallback, false);
        }, config.delay);
    }

    function debounce(daContext, config) {
        var me = this;

        function debounceFn(callback, wait) {
            var _this = this;

            var timeout;
            return function () {
                for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
                    args[_key] = arguments[_key];
                }

                var context = _this;
                clearTimeout(timeout);
                timeout = setTimeout(function () {
                    return callback.apply(context, args);
                }, wait);
            };
        } // if we don't have a debounce handler


        if (typeof me[config.daId] != "function") {
            me[config.daId] = debounceFn(function (daContext) {
                // ensure debounce function is recreated to fire immediately again on next call
                if (config.fireImmediately) me[config.fnId] = undefined;
                apex.da.resume(daContext.resumeCallback, false);
            }, config.delay);

            if (config.fireImmediately) {
                apex.da.resume(daContext.resumeCallback, false);
            }
        } // Call our debounced function


        me[config.daId].call(me, daContext);
    }

    function throttle(daContext, config) {
        var me = this;

        var throttle = function (func, wait) {
            var inThrottle;
            return function () {
                var args = arguments;
                var context = this;

                if (!inThrottle) {
                    func.apply(context, args);
                    inThrottle = true;
                    setTimeout(function () {
                        return inThrottle = false;
                    }, wait);
                }
            };
        }; // if we don't have a throttle handler initialize one


        if (typeof me[config.daId] != "function") {
            me[config.daId] = throttle(function (daContext) {
                apex.da.resume(daContext.resumeCallback, false);
            }, config.delay);
        } // Call our throttled function


        me[config.daId].call(me, daContext);
    }

    function addTimer(config) {
        var name = config.timerName,
            interval = config.interval,
            maxRepetitions = config.repetitions,
            id;

        if (name && name in timers) {
            clearInterval(timers[name].id);
            apex.debug.trace('Timer "' + name + '" already exists - restarting it...');
        }

        id = setInterval(function () {
            var t = timers[name];

            t.repetitionCount++;
            apex.debug.trace('... timer tick: ' + t.repetitionCount);

            apex.jQuery('body').trigger('timer-tick', [{
                'name': name,
                'timerName': name,
                'timer': t
            }]);

            if (maxRepetitions && t.repetitionCount >= t.maxRepetitions) {
                apex.jQuery('body').trigger('timer-complete', [{
                    'name': name,
                    'timerName': name,
                    'timer': t
                }]);
                clearInterval(t.id);
                delete timers[name];
            }
        }, interval);

        timers[name] = {
            id: id,
            name: name,
            repetitionCount: 0,
            maxRepetitions: maxRepetitions
        };
    }

    function removeTimer(timerName) {
        if (timerName in timers) {
            clearInterval(timers[timerName].id);
            delete timers[timerName];
        } else {
            apex.debug.trace('Timer "' + timerName + '" does not exist (or has been removed already).');
        }
    }

    //public functions
    return {
        action: action,
        debounce: debounce,
        delay: delay,
        throttle: throttle,
        addTimer: addTimer,
        removeTimer: removeTimer
    };
})();


