window.FOS = window.FOS || {};

FOS.timing = (function () {

    //used by addTimer and removeTimer
    var timers = {};

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
            default:
                break;
        }
    }

    function debounce(daContext, config) {
        let me = this;

        function debounceFn(callback, wait) {
            let timeout;
            return (...args) => {
                const context = this;
                clearTimeout(timeout);
                timeout = setTimeout(() => callback.apply(context, args), wait);
            }
        }
        // if we don't have a debounce handler
        if (typeof me[config.daId] != "function") {
            me[config.daId] = debounceFn((daContext) => {
                // ensure debounce function is recreated to fire immediately again on next call
                if (config.fireImmediately) this[config.fnId] = undefined;
                apex.da.resume(daContext.resumeCallback, false);
            }, config.delay);
            if (config.fireImmediately) {
                apex.da.resume(daContext.resumeCallback, false);
            }
        }
        // Call our debounced function
        me[config.daId].call(me, daContext);

    }

    function delay(daContext, config) {
        let me = this;

        // Call our delayed function
        setTimeout(() => { apex.da.resume(daContext.resumeCallback, false); }, config.delay);

    }

    function throttle(daContext, config) {
        let me = this;

        const throttle = (func, wait) => {
            let inThrottle
            return function () {
                const args = arguments
                const context = this
                if (!inThrottle) {
                    func.apply(context, args)
                    inThrottle = true
                    setTimeout(() => inThrottle = false, wait)
                }
            }
        }
        // if we don't have a throttle handler initialize one
        if (typeof me[config.daId] != "function") {
            me[config.daId] = throttle((daContext) => {
                apex.da.resume(daContext.resumeCallback, false);
            }, config.delay);
        }
        // Call our throttled function
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

            console.log('increased it');
            t.repetitionCount++;

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

